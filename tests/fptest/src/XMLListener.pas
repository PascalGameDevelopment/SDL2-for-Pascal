{
   DUnit: An XTreme testing framework for Delphi and Free Pascal programs.

   The contents of this file are subject to the Mozilla Public
   License Version 1.1 (the "License"); you may not use this file
   except in compliance with the License. You may obtain a copy of
   the License at http://www.mozilla.org/MPL/

   Software distributed under the License is distributed on an "AS
   IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
   implied. See the License for the specific language governing
   rights and limitations under the License.

   All rights reserved.

   Contributor(s):
   Peter McNab <mcnabp@gmail.com>
   Graeme Geldenhuys <graemeg@gmail.com>
}

unit XMLListener;

{$IFDEF FPC}
  {$mode delphi}{$H+}
{$ENDIF}

{$ifdef selftest}
  {$define ShowClass}
{$endif}

interface

uses
  Contnrs,
  {$IFDEF FPC}
  dom, XMLWrite,
  {$ELSE}
  // Chosen because it does not drag in any other units e.g. TComponent
  xdom,
  {$ENDIF}
  TestFrameworkProxyIfaces;

type

  IXMLStack = interface
  ['{CC96971E-E712-475D-A8AB-1BE7EB96092D}']
    function  Pop: TDomElement;
    procedure Push(const ANode: TDomElement);
    function  Empty: boolean;
    function  Top: TDomElement;
  end;


  TXMLListener = class(TInterfacedObject, ITestListener, ITestListenerX)
  private
    FAppPath: string;
    FAppName: string;
    FDocName: string;
    FStack:   IXMLStack;
    FXMLDoc: TdomDocument;
    procedure AppendComment(const AComment: string);
    procedure AppendElement(const AnElement: string);
    function  CurrentElement: TDomElement;
    procedure MakeElementCurrent(const AnElement: TDomElement);
    function  PreviousElement: TDomElement;
    procedure AddResult(const ATitle, AValue: string);
    procedure AppendLF;
    procedure AddNamedValue(const AnAttrib: TDomElement; const AName: string; AValue: string);
    procedure AddNamedText(const ANode: TDomElement; const AName: string; const AMessage: string);
    procedure AddFault(const AnError: TTestFailure; const AFault: string);
  protected
    function  UnEscapeUnknownText(const UnKnownText: string): string; virtual;
    procedure AddSuccess(Test: ITestProxy); virtual;
    procedure AddError(AnError: TTestFailure); virtual;
    procedure AddFailure(AnError: TTestFailure); virtual;
    procedure AddWarning(AnError: TTestFailure); virtual;
    procedure TestingStarts; virtual;
    procedure StartSuite(Suite: ITestProxy); virtual;
    procedure StartTest(Test: ITestProxy); virtual;
    procedure EndTest(Test: ITestProxy); virtual;
    procedure EndSuite(Suite: ITestProxy); virtual;
    procedure TestingEnds(TestResult: ITestResult); virtual;
    function  ShouldRunTest(const ATest :ITestProxy):Boolean; virtual;
    procedure Status(const ATest: ITestProxy; AMessage: string); virtual;
  public
    constructor Create(const ExePathFileName: string); overload;
    constructor Create(const ExePathFileName: string; const PIContent: string); overload;
    destructor Destroy; override;
  end;


implementation
uses
  TestFrameworkIfaces,
  Classes,
  SysUtils,
  TimeManager;

const
  milliSecsToDays       = 1/86400000;
  cxmlExt               = '.xml';
  cxmlStylesheet        = 'xml-stylesheet';
  cElapsedTime          = 'ElapsedTime';
  cNumberOfErrors       = 'NumberOfErrors';
  cNumberOfFailures     = 'NumberOfFailures';
  cNumberOfRunTests     = 'NumberOfRunTests';
  cNumberOfWarnings     = 'NumberOfWarnings';
  cNumberOfExcludedTests = 'NumberOfExcludedTests';
  cNumberOfChecksCalled = 'NumberOfChecksCalled';
  cTotalElapsedTime     = 'TotalElapsedTime';
  cDateTimeRan          = 'DateTimeRan';
  cyyyymmddhhmmss       = 'yyyy-mm-dd hh:mm:ss';
  chhnnsszz             = 'hh:nn:ss.zzz';
  cTestResults          = 'TestResults';
  cTestListing          = 'TestListing';
  cName                 = 'Name';
  cExceptionClass       = 'ExceptionClass';
  cExceptionMessage     = 'ExceptionMessage';
  cMessage              = 'Message';
  cTest                 = 'Test';
  cResult               = 'Result';
  cError                = 'Error';
  cFailed               = 'Failed';
  cWarning              = 'Warning';
  cOK                   = 'OK';
  cTitle                = 'Title';
  cTitleText            = 'FPTest XML test report';
  cGeneratedBy          = 'Generated using FPTest on ';
  cEncoding             = 'UTF-8';
  cTestSuite            = 'TestSuite';
  cTestCase             = {$ifdef ShowClass} 'TestCase' {$else} cTestSuite {$endif};
  cTestDecorator        = {$ifdef ShowClass} 'TestDecorator' {$else} cTestSuite {$endif};
  cTestProject          = {$ifdef ShowClass} 'TestProject' {$else} cTestSuite {$endif};


{ TXMLStack }

type
  TXMLStack = class(TInterfacedObject, IXMLStack)
  private
    FStack: TFPObjectList;
  protected
    function  Pop: TDomElement;
    procedure Push(const ANode: TDomElement);
    function  Empty: boolean;
    function  Top: TDomElement;
  public
    constructor Create;
    destructor Destroy; override;
  end;

constructor TXMLStack.Create;
begin
  inherited Create;
  FStack := TFPObjectList.Create(False);
end;

destructor TXMLStack.Destroy;
begin
  FStack.Destroy;
  inherited Destroy;
end;

function TXMLStack.Empty: boolean;
begin
  Result := FStack.Count = 0;
end;

function TXMLStack.Pop: TDomElement;
var
  idx: integer;
begin
  if Empty then
    Result := nil
  else
  begin
    idx := FStack.Count-1;
    Result := FStack.Items[idx] as TDomElement;
    FStack.Delete(idx);
  end;
end;

procedure TXMLStack.Push(const ANode: TDomElement);
begin
  FStack.Add(ANode);
end;

function TXMLStack.Top: TDomElement;
begin
  if Empty then
    Result := nil
  else
    Result := FStack.Items[FStack.Count-1] as TDomElement;
end;


{ TXMLListener }

constructor TXMLListener.Create(const ExePathFileName: string);
begin
  Create(ExePathFileName, '');
end;

constructor TXMLListener.Create(const ExePathFileName: string; const PIContent: string);
var
  LDomElement: TDomElement;
begin
  inherited Create;
  FStack := TXMLStack.Create;
  FAppPath := ExtractFilePath(ExePathFileName);
  FAppName := ExtractFileName(ExePathFileName);
  FDocName := ChangeFileExt(FAppName, cxmlExt);
  FXMLDoc := TDOMDocument.Create{$IFNDEF FPC}(nil){$ENDIF};
  {$IFNDEF FPC}
  { TODO -cFPC : XMLDoc needs an Encoding parameter. }
  FXMLDoc.Encoding := cEncoding;
  {$ENDIF}
  if PIContent <> '' then
    FXMLDoc.AppendChild(FXMLDoc.CreateProcessingInstruction(cxmlStylesheet, PIContent));
  LDomElement := FXMLDoc.CreateElement(cTestResults);
  FXMLDoc.AppendChild(LDomElement);
  MakeElementCurrent(LDomElement);
  AppendLF;
  AppendComment(cGeneratedBy + FormatDateTime(cyyyymmddhhmmss, Now));
end;

destructor TXMLListener.Destroy;
var
  Stream: TFileStream;
  S: string;
  sl: TStringList;
begin
  {$IFDEF FPC}
  WriteXML(FXMLDoc, FAppPath + FDocName);
//  S := FXMLDoc.TextContent;
  {$ELSE}
  Stream := TFileStream.Create(FAppPath + FDocName, fmCreate or fmOpenWrite);
  try
    S := FXMLDoc.code;
    Stream.Write(S[1], Length(S));
  finally
    FreeAndNil(Stream);
  end;
  {$ENDIF}
  FStack := nil;
  FreeAndNil(FXMLDoc);
  inherited Destroy;
end;

{------------------- Functions that operate on the stack ----------------------}

function TXMLListener.CurrentElement: TDomElement;
begin
  Result := FStack.Top;
end;

procedure TXMLListener.MakeElementCurrent(const AnElement: TDomElement);
begin
  FStack.Push(AnElement);
end;

function TXMLListener.PreviousElement: TDomElement;
begin
  Result := FStack.Pop;
end;

{------------------- Functions that collect associated actions ----------------}

procedure TXMLListener.AppendLF;
begin
  CurrentElement.appendChild(FXMLDoc.createTextNode(#10));
end;

procedure TXMLListener.AppendElement(const AnElement: string);
var
  LDomElement: TDomElement;
begin
  LDomElement := FXMLDoc.createElement(AnElement);
  CurrentElement.appendChild(LDomElement);
  AppendLF;
  MakeElementCurrent(LDomElement);
end;

procedure TXMLListener.AppendComment(const AComment: string);
begin
  CurrentElement.appendChild(FXMLDoc.CreateComment(AComment));
  AppendLF;
end;

procedure TXMLListener.AddResult(const ATitle: string; const AValue: string);
var
  LElement: TDomElement;
  E: Exception;
begin
  LElement := FXMLDoc.createElement(ATitle);
  LElement.appendChild(FXMLDoc.createTextNode(UnEscapeUnknownText(AValue)));
  if (CurrentElement <> nil) then
  begin
    CurrentElement.appendChild(LElement);
    AppendLF;
  end
  else
  begin
    E := Exception.Create('XMLListener: No corresponding opening tag for ' +
      ATitle + '  Final value = ' + AValue);
    raise E;
  end;
end;

procedure TXMLListener.AddNamedValue(const AnAttrib: TDomElement; const AName: string; AValue: string);
var
  LAttrib: TdomAttr;
begin
  LAttrib := FXMLDoc.createAttribute(AName);
  LAttrib.value := AValue;
  AnAttrib.setAttributeNode(LAttrib);
end;

procedure TXMLListener.AddNamedText(const ANode: TDomElement; const AName: string; const AMessage: string);
var
  LDomElement: TDomElement;
begin
  LDomElement := FXMLDoc.createElement(AName);
  LDomElement.appendChild(FXMLDoc.createTextNode(UnEscapeUnknownText(AMessage)));
  ANode.appendChild(LDomElement);
  AppendLF;
end;

{--------------------- These are ITestListener functions ----------------------}

function TXMLListener.ShouldRunTest(const ATest: ITestProxy): Boolean;
begin
  Result := True;
end;

procedure TXMLListener.StartSuite(Suite: ITestProxy);
begin
// Nothing required here but the procedure must be includes to match the interface.
end;

procedure TXMLListener.Status(const ATest: ITestProxy; AMessage: string);
begin
// Nothing required here but the procedure must be includes to match the interface.
end;

procedure TXMLListener.EndSuite(Suite: ITestProxy);
begin
// Nothing required here but the procedure must be includes to match the interface.
end;

{--------------------- Active ITestListener functions -------------------------}

procedure TXMLListener.TestingStarts;
begin
  AppendElement(cTestListing);
end;

function TXMLListener.UnEscapeUnknownText(const UnKnownText: string): string;
begin
  Result := UnKnownText;
end;

procedure TXMLListener.StartTest(Test: ITestProxy);
var
  LTestElement: TDomElement;

  procedure AddClassName(const AClassName: string);
  begin
    LTestElement := FXMLDoc.createElement(AClassName);
    AddNamedValue(LTestElement, cName, UnEscapeUnknownText(Test.Name));
    CurrentElement.appendChild(LTestElement);
    MakeElementCurrent(LTestElement);
    AppendLF;
  end;


begin  {TXMLListener.StartTest(Test: ITestProxy);}
  if not Assigned(Test) or (CurrentElement = nil) then
    Exit;

  if not Test.IsTestMethod then
  begin
    case Test.SupportedIfaceType of
      _isTestCase:      AddClassName(cTestCase);
      _isTestSuite:     AddClassName(cTestSuite);
      _isTestDecorator: AddClassName(cTestDecorator);
      _isTestProject:   AddClassName(cTestProject);
    end;
  end;
end;

procedure TXMLListener.EndTest(Test: ITestProxy);
begin
  if not Assigned(Test) then
    Exit;

  if Ord(Test.ExecutionStatus) > Ord(_Running)  then
  begin
    if (CurrentElement = nil) then
      Exit;

    case Test.SupportedIfaceType of
      _isTestCase,
      _isTestSuite,
     _isTestProject,
     _isTestDecorator:
      begin
        AddNamedValue(CurrentElement, cElapsedTime, ElapsedDHMS(Test.ElapsedTestTime));
        if Test.Updated then
        begin
          AddNamedValue(CurrentElement, cNumberOfErrors,   IntToStr(Test.Errors));
          AddNamedValue(CurrentElement, cNumberOfFailures, IntToStr(Test.Failures));
          AddNamedValue(CurrentElement, cNumberOfWarnings, IntToStr(Test.Warnings));
          AddNamedValue(CurrentElement, cNumberOfRunTests, IntToStr(Test.TestsExecuted));
         end;
        PreviousElement;
      end;
    end;  {case}
  end;
end;

procedure TXMLListener.TestingEnds(TestResult: ITestResult);
begin
  if not Assigned(TestResult) or (CurrentElement = nil) then
    Exit;

  AddNamedValue(CurrentElement, cElapsedTime,       ElapsedDHMS(TestResult.TotalTime));
  AddNamedValue(CurrentElement, cNumberOfErrors,    IntToStr(TestResult.ErrorCount));
  AddNamedValue(CurrentElement, cNumberOfFailures,  IntToStr(TestResult.FailureCount));
  AddNamedValue(CurrentElement, cNumberOfRunTests,  IntToStr(TestResult.RunCount));
  AddNamedValue(CurrentElement, cNumberOfWarnings,  IntToStr(TestResult.WarningCount));
  AddNamedValue(CurrentElement, cNumberOfChecksCalled, IntToStr(TestResult.ChecksCalledCount));

  while (CurrentElement <> nil) and (CurrentElement.tagName <> cTestResults) do
    PreviousElement;

  AddResult(cTitle, cTitleText);
  AddResult(cNumberOfRunTests, IntToStr(TestResult.RunCount));
  AddResult(cNumberOfErrors,   IntToStr(TestResult.ErrorCount));
  AddResult(cNumberOfFailures, IntToStr(TestResult.FailureCount));
  AddResult(cNumberOfWarnings, IntToStr(TestResult.WarningCount));
  AddResult(cNumberOfExcludedTests, IntToStr(TestResult.ExcludedCount));
  AddResult(cNumberOfChecksCalled, IntToStr(TestResult.ChecksCalledCount));
  AddResult(cTotalElapsedTime, ElapsedDHMS(TestResult.TotalTime));
  AddResult(cDateTimeRan,      FormatDateTime(cyyyymmddhhmmss, Now));
end;

procedure TXMLListener.AddSuccess(Test: ITestProxy);
var
  LOKTest: TDomElement;
begin
  if not Assigned(Test) or (CurrentElement = nil) then
    Exit;

  if Test.IsTestMethod then
  begin
    LOKTest := FXMLDoc.createElement(cTest);
    AddNamedValue(LOKTest, cName, UnEscapeUnknownText(Test.Name));
    AddNamedValue(LOKTest, cResult, cOK);
    AddNamedValue(LOKTest, cElapsedTime, ElapsedDHMS(Test.ElapsedTestTime));
    CurrentElement.appendChild(LOKTest);
    AppendLF;
  end;
end;

procedure TXMLListener.AddFault(const AnError: TTestFailure;
                                const AFault: string);
var
  LBadTest: TDomElement;
begin
  if not Assigned(AnError) or (CurrentElement = nil) then
    Exit;
  LBadTest := FXMLDoc.createElement(cTest);
  AddNamedValue(LBadTest, cName, UnEscapeUnknownText(AnError.FailedTest.Name));
  AddNamedValue(LBadTest, cResult, AFault);
  AddNamedValue(LBadTest, cElapsedTime, ElapsedDHMS(AnError.FailedTest.ElapsedTestTime));
  AppendLF;

  AddNamedText(LBadTest, cMessage, AnError.FailedTest.ParentPath + '.' +
    AnError.FailedTest.Name + ': ' + AnError.ThrownExceptionMessage);
  AddNamedText(LBadTest, cExceptionClass, AnError.ThrownExceptionName);
  AddNamedText(LBadTest, cExceptionMessage, AnError.ThrownExceptionMessage);
  CurrentElement.appendChild(LBadTest);
  AppendLF;
end;

procedure TXMLListener.AddWarning(AnError: TTestFailure);
begin
  AddFault(AnError, cWarning);
end;

procedure TXMLListener.AddError(AnError: TTestFailure);
begin
  AddFault(AnError, cError);
end;

procedure TXMLListener.AddFailure(AnError: TTestFailure);
begin
  AddFault(AnError, cFailed);
end;


end.


