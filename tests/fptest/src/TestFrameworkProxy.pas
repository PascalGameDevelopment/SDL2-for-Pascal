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

   The Original Code is DUnit.

   The Initial Developers of the Original Code are Kent Beck, Erich Gamma,
   and Juancarlo Añez.
   Portions created The Initial Developers are Copyright (C) 1999-2000.
   Portions created by The DUnit Group are Copyright (C) 2000-2007.
   All rights reserved.

   Contributor(s):
   Kent Beck <kentbeck@csi.com>
   Erich Gamma <Erich_Gamma@oti.com>
   Juanco Añez <juanco@users.sourceforge.net>
   Chris Morris <chrismo@users.sourceforge.net>
   Jeff Moore <JeffMoore@users.sourceforge.net>
   Uberto Barbini <uberto@usa.net>
   Brett Shearer <BrettShearer@users.sourceforge.net>
   Kris Golko <neuromancer@users.sourceforge.net>
   The DUnit group at SourceForge <http://dunit.sourceforge.net>
   Peter McNab <mcnabp@gmail.com>
   Graeme Geldenhuys <graemeg@gmail.com>
}

{ Description:
  This unit sits between the adapted GUITestRunner and TestFramework.
  It provides an interface to look and behave like the original TestFramework.
  When tests FPTest code has reached a mature stage a new GUITestRunner will be
  introduced to interface directly with a new TestRunner TestFramework.
  This "Proxy" unit re-creates the Tests structure currently accessed by
  the treeview. }
unit TestFrameworkProxy;

{$IFDEF FPC}
  {$mode delphi}{$H+}
  {$UNDEF FASTMM}
{$ELSE}
  {$WARN UNIT_PLATFORM OFF}
{$ENDIF}

{$BOOLEVAL OFF}

interface
uses
  TestFrameworkProxyIfaces,
  TestFrameworkIfaces,
  Classes;

function  RegisteredTests(const TestSuite: ITestCase): ITestSuiteProxy; overload;
function  RegisteredTests: ITestSuiteProxy; overload;
function  RegisteredTests(const TestsTitle: string): ITestSuiteProxy; overload;
function  IsTestMethod(ATest: ITestProxy): Boolean;
function  GetDUnitRegistryKey: string;
procedure ClearRegistry;
function  GetTestResult: ITestResult;
function  RunTest(Suite: ITestProxy; const Listeners: array of ITestListener): ITestResult; overload;
function  PointerToLocationInfo(Addrs: PtrType): string;


implementation

uses
  TestFramework,
  TestListenerIface,
  ProjectsManagerIface,
  SysUtils,
  TimeManager;

type
  TTestListenerProxy = class(TInterfacedObject, ITestListenerProxy)
  private
    FTestResult: ITestResult;
    FTestListeners: IInterfaceList;
    FRunningStartTime: Extended;
    FRunningStopTime: Extended;
    procedure UpdateTestResult;
    function  EndTestExec(const ATest: ITest):ITestProxy;
  protected
    function  ShouldRunTest(const ATest :ITest):Boolean;
    procedure AddListener(const Listener: ITestListener); overload;
    procedure TestingStarts;
    procedure StartSuite(ASuite: ITest);
    procedure StartTest(Test: ITest);
    procedure EndTest(ATest: ITest);
    procedure EndSuite(ASuite: ITest);
    procedure TestingEnds;
    procedure ReleaseListeners;
    procedure Status(const ATest: ITest; const AMessage: string);
  public
    constructor Create(const Value: ITestResult);
    destructor Destroy; override;
  end;


  {$M+}
  TTestProxy = class(TInterfacedObject, ITestProxy)
  private
    FITest: ITest;
    FGUIObject: TObject;
    FTestName: string;
    FExecutionStatus : TExecutionStatus;
    FIsOverridden: boolean;
    FIsWarning: boolean;
    FFailsOnMemoryRecovery: boolean;
    FAllowedLeakList: TAllowedLeakArray;
    FITestList: IInterfaceList;
    FErrors: Integer;
    FFailures: Integer;
    FTestExecuted: Integer;
    FWarnings: Integer;
    procedure SetGUIObject(const GUIObject: TObject);
    function  GetGUIObject: TObject;
    function  GetEnabled: Boolean;
    procedure SetEnabled(Value: Boolean);
    function  GetExcluded: Boolean;
    procedure SetExcluded(Value: Boolean);
    function  GetName: string;
    function  ParentPath: string;
    function  GetStatus :string;
    function  get_IsTestMethod: boolean;
    function  SupportedIfaceType: TSupportedIface;
    function  get_ExecutedStatus: TExecutionStatus;
    procedure set_ExecutedStatus(const Value: TExecutionStatus);
    function  get_IsOverridden: boolean;
    procedure set_IsOverridden(const Value: boolean);
    function  get_IsWarning: boolean;
    procedure set_IsWarning(const Value: boolean);
    function  get_Errors: Integer;
    procedure set_Errors(const Value: Integer);
    function  get_Failures: Integer;
    procedure set_Failures(const Value: Integer);
    function  get_Warnings: Integer;
    procedure set_Warnings(const Value: Integer);
    function  get_TestsExecuted: Integer;
    procedure set_TestsExecuted(const Value: Integer);
    function  Updated: boolean;
    procedure SetFailsOnNoChecksExecuted(const Value: Boolean);
    function  GetFailsOnNoChecksExecuted: Boolean;
    function  get_InhibitSummaryLevelChecks: boolean;
    procedure set_InhibitSummaryLevelChecks(const Value: boolean);
    function  EarlyExit: boolean;

    function  get_LeakAllowed: boolean;
    function  GetFailsOnMemoryLeak: Boolean;
    procedure SetFailsOnMemoryLeak(const Value: Boolean);
    function  GetIgnoreSetUpTearDownLeaks: Boolean;
    procedure SetIgnoreSetUpTearDownLeaks(const Value: Boolean);
    function  GetAllowedMemoryLeakSize: Integer;
    procedure SetAllowedMemoryLeakSize(const NewSize: Integer);
    function  GetFailsOnMemoryRecovery: Boolean;

    procedure SaveConfiguration(const FileName: string; const useRegistry, useMemIni: Boolean);
    procedure LoadConfiguration(const FileName: string; const useRegistry, useMemIni: Boolean); virtual;
    function  CountEnabledTestCases: Integer;
    function  ElapsedTestTime: Extended;
    function  Tests: IInterfaceList;
    procedure Run(const TestResult: ITestResult); overload;
    function  Run(const Listeners: array of ITestListener): ITestResult; overload;
    function  Run(const AListener: ITestListener): ITestResult; overload;
    procedure HaltTesting;
    procedure ReleaseTests; virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;
  end;
  {$M-}


  TTestSuiteProxy = class(TTestProxy, ITestSuiteProxy)
  protected
    FIsTestMethod: Boolean;
    FIsNotTestMethod: Boolean;
  public
    constructor Create(const ATestProject: ITestProject); reintroduce; overload;
    constructor Create(const ATestProject: ITestProject;
                       const CurrentTest: ITest;
                       out   LTest: ITest); reintroduce; overload;
    function Tests: IInterfaceList;
    procedure TestSuiteTitle(const ATitle: string);
  end;


  TITestFailure = class(TInterfacedObject, TTestFailure)
  private
    FFailedTest: ITestProxy;
    FStackTrace: string;
    FThrownExceptionAddress: PtrType;
    FThrownExceptionMessage: string;
    FThrownExceptionClassName: string;
    function ThrownExceptionAddress: PtrType; virtual;
    procedure CaptureStackTrace;
  public
    constructor Create(const FailedTest: ITestProxy;
                       const ThrownExceptionClass: ExceptClass;
                       const AMsg: string;
                       const Addrs: PtrType;
                       const ShowStack: boolean); overload;
    function FailedTest: ITestProxy;         virtual;
    function ThrownExceptionName: string;    virtual;
    function ThrownExceptionMessage: string; virtual;
    function LocationInfo: string;           virtual;
    function AddressInfo:  string;           virtual;
    function StackTrace:   string;           virtual;
  end;


  { This interfaced object replicates the reporting and control of the original
    TTestResult object but unwinds some of the deeper convoluted involvement in
    test execution. }
  {$M+}
  TITestResult = class(TInterfacedObject, ITestResult)
  private
    FOverrides: Integer;
    FBreakOnFailures: boolean;
    FFailsIfNoChecksExecuted: boolean;
    FFailsIfMemoryLeaked: boolean;
    FIgnoresMemoryLeakInSetUpTearDown: boolean;
    FErrorCount: Integer;
    FWarningCount: Integer;
    FFailureCount: Integer;
    FFailures: IInterfaceList;
    FErrors: IInterfaceList;
    FWarnings: IInterfaceList;
    FRunTests: Integer;
    FChecksCalledCount: Integer;
    FStop: Boolean;
    FWasStopped: Boolean;
    FTestListenerProxy: ITestListenerProxy;
    FTotalTime: Extended;
    FExcludedCount: Integer;
    FInhibitSummaryLevelChecks: Boolean;
    function  GetFailure(idx: Integer): TTestFailure;
    procedure SetFailure(idx: Integer; AFailure: TTestFailure);
    function  GetError(idx: Integer): TTestFailure;
    procedure SetError(idx: Integer; AnError: TTestFailure);
    function  GetWarning(idx :Integer) :TTestFailure;
    procedure SetWarning(idx: Integer; AFailure: TTestFailure);
  protected
    function  get_TotalTime: Extended;
    procedure set_TotalTime(const Value: Extended);
    function  get_WarningCount: Integer;
    procedure set_WarningCount(const Value: Integer);
    function  get_ExcludedCount: Integer;
    procedure set_ExcludedCount(const Value: integer);
    function  get_Overrides: Integer;
    procedure set_Overrides(const Value: Integer);
    function  get_ChecksCalledCount: Integer;
    procedure set_ChecksCalledCount(const Value: Integer);
    function  get_BreakOnFailures: boolean;
    procedure set_BreakOnFailures(const Value: boolean);
    function  get_FailsIfNoChecksExecuted: boolean;
    procedure set_FailsIfNoChecksExecuted(const Value: boolean);
    function  get_FailsIfMemoryLeaked: boolean;
    procedure set_FailsIfMemoryLeaked(const Value: boolean);
    function  get_IgnoresMemoryLeakInSetUpTearDown: boolean;
    procedure set_IgnoresMemoryLeakInSetUpTearDown(const Value: boolean);
    function  get_InhibitSummaryLevelChecks: boolean;
    procedure set_InhibitSummaryLevelChecks(const Value: boolean);
    procedure ReleaseListeners;
    function  get_ErrorCount: Integer;   virtual;
    procedure set_ErrorCount(const Value: Integer);
    function  get_RunCount: Integer;
    procedure set_RunCount(const Value: Integer);
    function  get_FailureCount: Integer; virtual;
    procedure set_FailureCount(const Value: Integer); virtual;
    procedure Stop; virtual;
    procedure AddListener(const Listener: ITestListener); virtual;
    procedure RemoveListener(const Listener: ITestListener); virtual;
    function  WasSuccessful: Boolean; virtual;
    function  get_WasStopped :Boolean;
    procedure set_WasStopped(const Value: Boolean);

  public
    constructor Create;
    destructor Destroy; override;
  published
    property  ErrorCount: Integer read get_ErrorCount write set_ErrorCount;
    property  FailureCount: Integer read get_FailureCount write set_FailureCount;
    property  WasStopped:Boolean read get_WasStopped write set_WasStopped;
  end;
  {$M-}


var
  DUnitRegistryKey: string = '';


function GetTestResult: ITestResult;
begin
  Result := TITestResult.Create;
end;

function RunTest(Suite: ITestProxy; const Listeners: array of ITestListener): ITestResult; overload;
var
  i: Integer;
begin
  Result := GetTestResult;
  if Supports(Suite, ITestSuiteProxy) then
  begin
    Result.FailsIfNoChecksExecuted := Suite.FailsOnNoChecksExecuted;
    Result.InhibitSummaryLevelChecks := Suite.InhibitSummaryLevelChecks;
    {$IFDEF FASTMM}
    Result.FailsIfMemoryLeaked := Suite.FailsOnMemoryLeak;
    Result.IgnoresMemoryLeakInSetUpTearDown := Suite.IgnoreSetUpTearDownLeaks;
    {$ENDIF}
  end;
  for i := low(Listeners) to high(Listeners) do
      result.addListener(Listeners[i]);
  if Suite <> nil then
  try
    Suite.Run(result);
  finally
    TestFrameWork.RegisteredTests.ReleaseProxys;
  end;
end;

function  RegisteredTests(const TestSuite: ITestCase): ITestSuiteProxy; overload;
begin
  if TestSuite = nil then
  begin
    Result := nil;
    Exit;
  end;

  if TestSuite.SupportedIfaceType = _isTestProject then
    Result := TTestSuiteProxy.Create(TestSuite as ITestProject)
  else
    Result := TTestSuiteProxy.Create(Projects)
end;

function  RegisteredTests(const TestsTitle: string): ITestSuiteProxy; overload;
var
  LProject: ITestProject;
begin
  Result := nil;
  LProject := Projects;
  if LProject = nil then
    Exit;

  if TestsTitle <> '' then
    LProject.DisplayedName := TestsTitle;
  Result := TTestSuiteProxy.Create(LProject);
end;

function  RegisteredTests: ITestSuiteProxy; overload;
begin
  Result := RegisteredTests('');
end;

function IsTestMethod(aTest: ITestProxy): Boolean;
begin
  Result := ATest.IsTestMethod;
end;

function GetDUnitRegistryKey: string;
begin
  Result := DUnitRegistryKey;
end;

function TestToProxy(const ATest: ITest): ITestProxy;
begin
  if Assigned(ATest) then
    Result := (ATest.Proxy as ITestProxy)
  else
    Result := nil;
end;

{ TTestResult }

procedure TITestResult.AddListener(const Listener: ITestListener);
begin
  if Listener = nil then
    Exit;

  if not Assigned(FTestListenerProxy) then
    FTestListenerProxy := TTestListenerProxy.Create(Self);
   FTestListenerProxy.AddListener(Listener);
  (TestProject.Manager as IProjectManager).AddListener(FTestListenerProxy);
end;

procedure TITestResult.RemoveListener(const Listener: ITestListener);
begin
  if Listener = nil then
    Exit;

  if Assigned(FTestListenerProxy) then
  begin
    (TestProject.Manager as IProjectManager).RemoveListener(FTestListenerProxy);
     FTestListenerProxy.ReleaseListeners;
  end;
end;

procedure TITestResult.SetError(idx: Integer; AnError: TTestFailure);
begin
  if Assigned(AnError) then
    FErrors.Add(AnError);
end;

procedure TITestResult.SetFailure(idx: Integer; AFailure: TTestFailure);
begin
  if Assigned(AFailure) then
    FFailures.Add(AFailure);
end;

procedure TITestResult.SetWarning(idx: Integer; AFailure: TTestFailure);
begin
  if Assigned(AFailure) then
    FWarnings.Add(AFailure);
end;

constructor TITestResult.Create;
begin
  inherited Create;
  FFailures := TInterfaceList.Create;
  FErrors := TInterfaceList.Create;
  FWarnings := TInterfaceList.Create;
  FStop := false;
  FRunTests := 0;
end;

destructor TITestResult.Destroy;
begin
  FTestListenerProxy := nil;
  FWarnings := nil;
  FErrors := nil;
  FFailures := nil;
  inherited;
end;

procedure TITestResult.ReleaseListeners;
begin
  try
    if Assigned(FTestListenerProxy) then
      FTestListenerProxy.ReleaseListeners;
  finally
    FTestListenerProxy := nil;
  end;
end;

function TITestResult.get_ErrorCount: Integer;
begin
  Result := FErrorCount;
end;

function TITestResult.get_ExcludedCount: integer;
begin
  Result := FExcludedCount;
end;

procedure TITestResult.set_ExcludedCount(const Value: integer);
begin
  FExcludedCount := Value;
end;

function TITestResult.get_FailureCount: Integer;
begin
  Result := FFailureCount;
end;

function TITestResult.GetError(idx: Integer): TTestFailure;
begin
  Result := nil;
  if (idx >= 0) and (idx < FErrors.Count) then
    Result := (FErrors[idx]) as TTestFailure;
end;

function TITestResult.GetFailure(idx: Integer): TTestFailure;
begin
  Result := nil;
  if (idx >= 0) and (idx < FFailures.Count) then
    Result := FFailures[idx] as TTestFailure;
end;

function TITestResult.GetWarning(idx: Integer): TTestFailure;
begin
  Result := nil;
  if (idx >= 0) and (idx < FWarnings.Count) then
    Result := (FWarnings[idx]) as TTestFailure;
end;

function TITestResult.get_BreakOnFailures: boolean;
begin
  Result := FBreakOnFailures;
end;

function TITestResult.get_ChecksCalledCount: Integer;
begin
  Result := FChecksCalledCount;
end;

procedure TITestResult.set_ChecksCalledCount(const Value: Integer);
begin
  FChecksCalledCount := Value;
end;

function TITestResult.get_FailsIfMemoryLeaked: boolean;
begin
  Result := FFailsIfMemoryLeaked;
end;

function TITestResult.get_FailsIfNoChecksExecuted: boolean;
begin
  Result := FFailsIfNoChecksExecuted;
end;

function TITestResult.get_IgnoresMemoryLeakInSetUpTearDown: boolean;
begin
  Result := FIgnoresMemoryLeakInSetUpTearDown;
end;

function TITestResult.get_Overrides: Integer;
begin
  Result := FOverrides;
end;

function TITestResult.get_TotalTime: Extended;
begin
  Result := FTotalTime;
end;

function TITestResult.get_WarningCount: Integer;
begin
  Result := FWarningCount;
end;

function TITestResult.get_WasStopped: Boolean;
begin
  Result := FWasStopped;
end;

function TITestResult.get_RunCount: Integer;
begin
  Result := FRunTests;
end;

procedure TITestResult.Stop;
begin
  FStop := true;
end;

function TITestResult.WasSuccessful: Boolean;
begin
  Result := (FailureCount = 0) and (ErrorCount = 0) and not WasStopped;
end;

procedure TITestResult.set_BreakOnFailures(const Value: boolean);
begin
  FBreakOnFailures := Value;
end;

procedure TITestResult.set_ErrorCount(const Value: Integer);
begin
  FErrorCount := Value;
end;

procedure TITestResult.set_FailsIfMemoryLeaked(const Value: boolean);
begin
  FFailsIfMemoryLeaked := Value;
end;

procedure TITestResult.set_FailsIfNoChecksExecuted(const Value: boolean);
begin
  FFailsIfNoChecksExecuted := Value;
end;

procedure TITestResult.set_FailureCount(const Value: Integer);
begin
  FFailureCount := Value;
end;

procedure TITestResult.set_IgnoresMemoryLeakInSetUpTearDown(const Value: boolean);
begin
  FIgnoresMemoryLeakInSetUpTearDown := Value;
end;

procedure TITestResult.set_Overrides(const Value: Integer);
begin
  FOverrides := Value;
end;

procedure TITestResult.set_RunCount(const Value: Integer);
begin
  FRunTests := Value;
end;

procedure TITestResult.set_TotalTime(const Value: Extended);
begin
  FTotalTime := Value;
end;

procedure TITestResult.set_WarningCount(const Value: Integer);
begin
  FWarningCount := Value;
end;

procedure TITestResult.set_WasStopped(const Value: Boolean);
begin
  FWasStopped := Value;
end;

function PtrToStr(P: PtrType): string;
begin
  // 2009-07-15   graemeg
  // I guess we can cast to Pointer here, even though the compiler complains.
  Result := Format('%p', [Pointer(P)])
end;

function AddrsToStr(Addrs: PtrType): string;
begin
  if Addrs > 0 then
    Result := '$'+PtrToStr(Addrs)
  else
    Result := 'n/a';
end;

function PointerToLocationInfo(Addrs: PtrType): string;
var
  _line: Integer;
  _file: string;
begin
  // TODO: Extract file and line info from backtrace
//  if _file <> '' then
//    Result := Format('%s:%d', [_file, _line]);
  Result := BackTraceStrFunc(Pointer(Addrs));
//  else
//    Result := string(_module);
  if Trim(Result) = '' then
    Result := AddrsToStr(Addrs) + '  <no map file>';
end;

function PointerToAddressInfo(Addrs: PtrType): string;
begin
  Result := AddrsToStr(Addrs);
end;

{ TITestFailure }

function TITestFailure.AddressInfo: string;
begin
  Result := PointerToAddressInfo(ThrownExceptionAddress);
end;

procedure TITestFailure.CaptureStackTrace;
var
  LTrace: TStrings;
begin
  LTrace := TStringList.Create;
  try
    { TODO -cStackTrace : See DumpStack for details }
    {$IFDEF USE_JEDI_JCL}
      JclDebug.JclLastExceptStackListToStrings(LTrace, true);
    {$ENDIF}
    FStackTrace := LTrace.Text;
  finally
    LTrace.Free;
  end;
end;

constructor TITestFailure.Create(const FailedTest: ITestProxy;
                                 const ThrownExceptionClass: ExceptClass;
                                 const AMsg: string;
                                 const Addrs: PtrType;
                                 const ShowStack: boolean);
begin
  inherited Create;
  FFailedTest := FailedTest;
  if (ThrownExceptionClass = nil) then
    FThrownExceptionClassName := 'ETestFailure'
  else
    FThrownExceptionClassName := ThrownExceptionClass.ClassName;
  FThrownExceptionMessage := AMsg;
  FThrownExceptionAddress := Addrs;
  if ShowStack then
    CaptureStackTrace
  else
    FStackTrace := '';
end;

function TITestFailure.FailedTest: ITestProxy;
begin
  Result := FFailedTest;
end;

function TITestFailure.LocationInfo: string;
begin
  Result := PointerToLocationInfo(ThrownExceptionAddress);
end;

function TITestFailure.StackTrace: string;
begin
  Result := FStackTrace;
end;

function TITestFailure.ThrownExceptionAddress: PtrType;
begin
  Result := FThrownExceptionAddress;
end;

function TITestFailure.ThrownExceptionMessage: string;
begin
  Result := FThrownExceptionMessage;
end;

function TITestFailure.ThrownExceptionName: string;
begin
  Result := FThrownExceptionClassName
end;

{ TTestProxy }

function TTestProxy.CountEnabledTestCases: Integer;
begin
  Projects.Reset;
  Result := Projects.Count;
end;

constructor TTestProxy.Create;
begin
  inherited Create;
  FITestList := TInterfaceList.Create;
end;

destructor TTestProxy.Destroy;
begin                // Delibarately release refs so tests go down early
  FITest := nil;     // Release ref to this proxy's ITest.
  FITestList := nil; // Release the list of contained proxys
  FTestName := '';   // Releasing string early helps isolate other leaks
  inherited;
end;

function TTestProxy.ElapsedTestTime: Extended;
begin
  Result := FITest.ElapsedTime;
end;

function TTestProxy.GetEnabled: Boolean;
begin
  Result := FITest.Enabled;
end;

function TTestProxy.GetFailsOnNoChecksExecuted: Boolean;
begin
  Result := FITest.FailsOnNoChecksExecuted;
end;

function TTestProxy.GetExcluded: Boolean;
begin
  Result := FITest.Excluded;
end;

procedure TTestProxy.SetExcluded(Value: Boolean);
begin
  FITest.Excluded := Value;
end;

function TTestProxy.GetAllowedMemoryLeakSize: Integer;
begin
  Result := 0;
  if FITest.IsTestMethod then
    Result := FITest.AllowedMemoryLeakSize
end;

function TTestProxy.GetFailsOnMemoryLeak: Boolean;
begin
  Result := FITest.FailsOnMemoryLeak;
end;

function TTestProxy.GetFailsOnMemoryRecovery: Boolean;
begin
  Result := FFailsOnMemoryRecovery;
end;

procedure TTestProxy.SetFailsOnMemoryLeak(const Value: Boolean);
begin
  FITest.FailsOnMemoryLeak := Value;
end;

function TTestProxy.GetIgnoreSetUpTearDownLeaks: Boolean;
begin
  Result := FITest.IgnoresMemoryLeakInSetUpTearDown;
end;

procedure TTestProxy.SetIgnoreSetUpTearDownLeaks(const Value: Boolean);
begin
  FITest.IgnoresMemoryLeakInSetUpTearDown := Value;
end;

procedure TTestProxy.SetAllowedMemoryLeakSize(const NewSize: Integer);
begin
  FAllowedLeakList[0] := NewSize;
end;

procedure TTestProxy.SetFailsOnNoChecksExecuted(const Value: Boolean);
begin
  FITest.FailsOnNoChecksExecuted := Value;
end;

function TTestProxy.GetGUIObject: TObject;
begin
  Result := FGUIObject;
end;

function TTestProxy.GetName: string;
var
  LTest: ITest;
begin
  Result := '';
  if FITest = nil then
    Exit;

  if FITest.ParentTestCase <> nil then
  begin
    Result := FITest.ParentTestCase.GetName;
    Exit;
  end;

  LTest := FITest.CurrentTest;
  if Assigned(LTest) then
    Result := LTest.GetName
  else
    Result := FITest.DisplayedName;
end;

function TTestProxy.GetStatus: string;
begin
  Result := FITest.GetStatus;
end;

function TTestProxy.get_IsTestMethod: boolean;
begin
  Result := FITest.IsTestMethod;
end;

function TTestProxy.ParentPath: string;
begin
  Result := FITest.ParentPath;
end;

procedure TTestProxy.LoadConfiguration(const FileName: string;
                                       const useRegistry, useMemIni: Boolean);
begin
  (TestProject.Manager as IProjectManager).LoadConfiguration(FileName, useRegistry, useMemIni);
end;

procedure TTestProxy.SaveConfiguration(const FileName: string;
                                       const useRegistry, useMemIni: Boolean);
begin
  (TestProject.Manager as IProjectManager).SaveConfiguration(FileName, useRegistry, useMemIni);
end;

procedure TTestProxy.ReleaseTests;
var
  i: Integer;
begin
  for i := FITestList.Count - 1 downto 0 do
  begin
    (FITestList.Items[i] as ITestProxy).ReleaseTests;
  end;
  if Assigned(FITest) then
  begin
    FITest.Proxy := nil;
    FITest.ParentTestCase := nil;
  end;
  FITest := nil;
end;

procedure TTestProxy.Run(const TestResult: ITestResult);
var
  LExecControl: ITestExecControl;
begin
  TestResult.FailsIfNoChecksExecuted := Projects.FailsOnNoChecksExecuted;
  TestResult.InhibitSummaryLevelChecks := Projects.InhibitSummaryLevelChecks;
  {$IFDEF FASTMM}
    TestResult.FailsIfMemoryLeaked := Projects.FailsOnMemoryLeak;
    TestResult.IgnoresMemoryLeakInSetUpTearDown := Projects.IgnoresMemoryLeakInSetUpTearDown;
  {$ENDIF}

  LExecControl := Projects.ExecutionControl;
  LExecControl.HaltExecution := False;
  LExecControl.BreakOnFailures := TestResult.BreakOnFailures;
  LExecControl.ClearCounts;
  LExecControl.FailsOnNoChecksExecuted := Projects.FailsOnNoChecksExecuted;
  LExecControl.InhibitSummaryLevelChecks := Projects.InhibitSummaryLevelChecks;
  {$IFDEF FASTMM}
    LExecControl.FailsOnMemoryLeak := Projects.FailsOnMemoryLeak;
    LExecControl.IgnoresMemoryLeakInSetUpTearDown := Projects.IgnoresMemoryLeakInSetUpTearDown;
  {$ENDIF}
  Projects.Run(LExecControl);
  TestResult.WasStopped := (Self.FITest.ExecStatus = _Break) or
    (Self.FITest.ExecStatus = _HaltTest);
end;

function TTestProxy.Run(const Listeners: array of ITestListener): ITestResult;
var
  idx: Integer;
  LTestResult: ITestResult;
begin
  Result := nil;
  LTestResult := GetTestResult;
  if Length(Listeners) = 0 then
    Exit;

  for idx := 0 to Length(Listeners) - 1 do
    if Assigned(Listeners[idx]) then
      LTestResult.addListener(Listeners[idx]);

  Run(LTestResult);
  Result := LTestResult;
end;

function TTestProxy.Run(const AListener: ITestListener): ITestResult;
begin
  Result := Run([AListener]);
end;

procedure TTestProxy.HaltTesting;
var
  LExecControl: ITestExecControl;
begin
  // Projects.ExecutionControl returns a reference to the project's ExecControl instance.
  LExecControl := Projects.ExecutionControl;
  LExecControl.HaltExecution := True;
  LExecControl := nil;
end;

procedure TTestProxy.SetEnabled(Value: Boolean);
begin
  FITest.Enabled := Value;
end;

procedure TTestProxy.SetGUIObject(const GUIObject: TObject);
begin
  FGUIObject := GUIObject;
end;

function TTestProxy.Tests: IInterfaceList;
begin
  Result := FITestList;
end;

function TTestProxy.Updated: boolean;
var
  LSummaryData: IProgressSummary;
begin
  Result := False;
  if FITest.IsTestMethod then
    Exit;

  LSummaryData := ((FITest as ITestCase).ProgressSummary as IProgressSummary);
  if LSummaryData = nil then
    Exit;

  Result := LSummaryData.Updated;
  FErrors := LSummaryData.Errors;
  FFailures := LSummaryData.Failures;
  FTestExecuted := LSummaryData.TestsExecuted;
  FWarnings := LSummaryData.Warnings;
end;

procedure ClearRegistry;
begin
  UnRegisterProjectManager;
end;

function TTestProxy.get_ExecutedStatus: TExecutionStatus;
begin
  Result := FExecutionStatus;
end;

procedure TTestProxy.set_ExecutedStatus(const Value: TExecutionStatus);
begin
  FExecutionStatus := Value;
end;

function TTestProxy.get_Errors: Integer;
begin
  Result := FErrors;
end;

procedure TTestProxy.set_Errors(const Value: Integer);
begin
  FErrors := Value;
end;

function TTestProxy.get_Failures: Integer;
begin
  Result := FFailures;
end;

procedure TTestProxy.set_Failures(const Value: Integer);
begin
  FFailures := Value;
end;

function TTestProxy.get_IsWarning: boolean;
begin
  Result := FIsWarning;
end;

function TTestProxy.get_LeakAllowed: boolean;
begin
  Result := FITest.LeakAllowed;
end;

function TTestProxy.get_TestsExecuted: Integer;
begin
  Result := FTestExecuted;
end;

procedure TTestProxy.set_TestsExecuted(const Value: Integer);
begin
  FTestExecuted := Value;
end;

function TTestProxy.get_Warnings: Integer;
begin
  Result := FWarnings;
end;

procedure TTestProxy.set_Warnings(const Value: Integer);
begin
  FWarnings := Value;
end;

procedure TTestProxy.set_IsWarning(const Value: boolean);
begin
  FIsWarning := Value;
end;

function TTestProxy.SupportedIfaceType: TSupportedIface;
begin
  if Assigned(FITest) then
    Result := FITest.SupportedIfaceType
  else
    Result := _Other;  
end;

function TTestProxy.get_IsOverridden: boolean;
begin
  Result := FIsOverridden;
end;

procedure TTestProxy.set_IsOverridden(const Value: boolean);
begin
  FIsOverridden := Value;
end;

function TTestProxy.EarlyExit: boolean;
begin
  Result := FITest.EarlyExit;
end;

function TTestProxy.get_InhibitSummaryLevelChecks: boolean;
begin
  Result := FITest.InhibitSummaryLevelChecks;
end;

procedure TTestProxy.set_InhibitSummaryLevelChecks(const Value: boolean);
begin
  FITest.InhibitSummaryLevelChecks := Value;
end;

{ TTestSuiteProxy }

constructor TTestSuiteProxy.Create(const ATestProject: ITestProject);
var
  LTest: ITest;
  LNext: ITest;
  LTestProxy: ITestProxy;
begin
  if ATestProject = nil then
    Exit;

  inherited Create;
  FTestName := ATestProject.DisplayedName;
  ATestProject.Proxy := Self as IInterface;
  FITest := ATestProject;

  LNext := nil;
  LTest := ATestProject.FindFirstTest;
  while Assigned(LTest) do
  begin
    LTestProxy := TTestSuiteProxy.Create(ATestProject, LTest, LNext);
    if Assigned(LTestProxy) then
      FITestList.Add(LTestProxy);
    LTest := LNext;
  end;
end;

constructor TTestSuiteProxy.Create(const ATestProject: ITestProject;
    const CurrentTest: ITest; out LTest: ITest);
var
  LNext: ITest;
  LTestProxy: ITestProxy;
begin
  LTest := nil;
  if not Assigned(CurrentTest) then
    Exit;

  inherited Create;
  FTestName := CurrentTest.DisplayedName;
  CurrentTest.Proxy := Self as IInterface;
  FITest := CurrentTest;

  LTest := ATestProject.FindNextTest;
  while Assigned(LTest) do
  begin
    if (LTest.Depth <= CurrentTest.Depth) then
    begin
      FIsNotTestMethod := True;
      Break;
    end;

    if (LTest.Depth = CurrentTest.Depth) then
      FIsTestMethod := True
    else
    begin
      LTestProxy := TTestSuiteProxy.Create(ATestProject, LTest, LNext);
      if Assigned(LTestProxy) then
        FITestList.Add(LTestProxy);
      LTest := LNext;
    end;
  end;
end;

function TTestSuiteProxy.Tests: IInterfaceList;
begin
  Result := FITestList;
end;

procedure TTestSuiteProxy.TestSuiteTitle(const ATitle: string);
begin
  if ATitle <> '' then
    FTestName := ATitle;
end;

{ TTestListenerProxy }

constructor TTestListenerProxy.Create(const Value: ITestResult);
begin
  inherited Create;
  FTestResult := Value;
  FTestListeners := TInterfaceList.Create;
end;

destructor TTestListenerProxy.Destroy;
begin
  FTestListeners := nil;
  FTestResult := nil;
  inherited;
end;

function TTestListenerProxy.ShouldRunTest(const ATest: ITest): Boolean;
var
  i: Integer;
begin
  Result := False;
  if ATest = nil then
    Exit;

  for i := 0 to FTestListeners.Count - 1 do
  begin
    Result := (FTestListeners.Items[i] as ITestListener).ShouldRunTest(TestToProxy(ATest));
    if not Result then
      Break;
  end;
end;

procedure TTestListenerProxy.AddListener(const Listener: ITestListener);
begin
  if Assigned(Listener) then
    FTestListeners.Add(Listener);
end;

procedure TTestListenerProxy.UpdateTestResult;
var
  LExecControl: ITestExecControl;
begin
  LExecControl := Projects.ExecutionControl;
  FTestResult.RunCount          := LExecControl.ExecutionCount;
  FTestResult.FailureCount      := LExecControl.FailureCount;
  FTestResult.ErrorCount        := LExecControl.ErrorCount;
  FTestResult.WarningCount      := LExecControl.WarningCount;
  FTestResult.ChecksCalledCount := LExecControl.CheckCalledCount;
  FTestResult.ExcludedCount     := LExecControl.ExcludedCount;
  FRunningStopTime := gTimer.Elapsed;
  FTestResult.TotalTime := FRunningStopTime-FRunningStartTime;
  LExecControl := nil;
end;

procedure TTestListenerProxy.StartSuite(ASuite: ITest);
var
  i: Integer;
begin
  if ASuite = nil then
    Exit;

  for i := 0 to FTestListeners.Count - 1 do
    if Supports(FTestListeners.Items[i], ITestListenerX) then
      (FTestListeners.Items[i] as ITestListenerX).StartSuite(TestToProxy(ASuite))
    else
      (FTestListeners.Items[i] as ITestListener).StartTest(TestToProxy(ASuite));
end;

procedure TTestListenerProxy.StartTest(Test: ITest);
var
  i: Integer;
begin
  if Test = nil then
    Exit;

  for i := 0 to FTestListeners.Count - 1 do
    (FTestListeners.Items[i] as ITestListener).StartTest(TestToProxy(Test));
end;

procedure TTestListenerProxy.TestingStarts;
var
  idx: Integer;
begin
  for idx := 0 to FTestListeners.Count -1 do
    (FTestListeners.Items[idx] as ITestListener).TestingStarts;

  FRunningStopTime := 0.0;
  FRunningStartTime := gTimer.Elapsed;
end;

procedure TTestListenerProxy.TestingEnds;
var
  idx: Integer;
begin
  UpdateTestResult;
  for idx := 0 to FTestListeners.Count -1 do
    (FTestListeners.Items[idx] as ITestListener).TestingEnds(FTestResult);
end;

function TTestListenerProxy.EndTestExec(const ATest: ITest):ITestProxy;
begin
  Result := ATest.Proxy as ITestProxy;
  Result.ExecutionStatus := ATest.ExecStatus;
  Result.IsWarning := ATest.ExecStatus = _Warning;
  UpdateTestResult;
end;

procedure TTestListenerProxy.EndSuite(ASuite: ITest);
var
  idx: Integer;
  LProxy: ITestProxy;
  LProgressSummary: IProgressSummary;

begin
  if ASuite = nil then
    Exit;

  LProxy := EndTestExec(ASuite);
  if not ASuite.IsTestMethod then
    LProgressSummary := ((ASuite as ITestCase).ProgressSummary as IProgressSummary);
    if (LProgressSummary <> nil) and LProgressSummary.Updated then
    begin
      LProxy.Errors := LProgressSummary.Errors;
      LProxy.Failures := LProgressSummary.Failures;
      LProxy.TestsExecuted := LProgressSummary.TestsExecuted;
      LProxy.Warnings:= LProgressSummary.Warnings;
    end;

  for idx := 0 to FTestListeners.Count - 1 do
  begin
    if Supports(FTestListeners.Items[idx], ITestListenerX) then
      (FTestListeners.Items[idx] as ITestListenerX).EndSuite(LProxy)
    else
      (FTestListeners.Items[idx] as ITestListener).EndTest(LProxy);
  end;
end;

procedure TTestListenerProxy.EndTest(ATest: ITest);
var
  idx: Integer;
  LProxy: ITestProxy;
  LErrorLevelRaised: boolean;
  LTestFailure: TTestFailure;
  LListener: ITestListener;
begin
  if ATest = nil then
    Exit;

  LProxy := EndTestExec(ATest);

  LErrorLevelRaised := (ATest.ExecStatus = _Error) and
    (not ATest.IsTestMethod) and (ATest as ITestCase).ReportErrorOnce;

  case ATest.ExecStatus of
    _Passed:
    begin
      for idx := 0 to FTestListeners.Count - 1 do
      begin
        LListener := (FTestListeners.Items[idx] as ITestListener);
        LListener.AddSuccess(LProxy);
      end;
    end;

    _Warning:
    if (ATest.SupportedIfaceType = _isTestMethod) then
    begin
      LTestFailure := TITestFailure.Create(LProxy,
                                          ATest.ExceptionClass,
                                          ATest.ErrorMessage,
                                          ATest.ErrorAddress,
                                          False);
      FTestResult.Warnings[0] := LTestFailure;
      for idx := 0 to FTestListeners.Count - 1 do
      begin
        LListener := (FTestListeners.Items[idx] as ITestListener);
        LListener.AddWarning(LTestFailure);
      end;
    end;

    _Failed:
    if (ATest.SupportedIfaceType = _isTestMethod) then
    begin
      LTestFailure := TITestFailure.Create(LProxy,
                                          ATest.ExceptionClass,
                                          ATest.ErrorMessage,
                                          ATest.ErrorAddress,
                                          False);
      FTestResult.Failures[0] := LTestFailure;
      for idx := 0 to FTestListeners.Count - 1 do
      begin
        LListener := (FTestListeners.Items[idx] as ITestListener);
        LListener.AddFailure(LTestFailure);
      end;
    end;

    _Error:
    if (ATest.IsTestMethod) or LErrorLevelRaised then
    begin
      LTestFailure := TITestFailure.Create(LProxy,
                                          ATest.ExceptionClass,
                                          ATest.ErrorMessage,
                                          ATest.ErrorAddress,
                                          True);
      FTestResult.Errors[0] := LTestFailure;
      for idx := 0 to FTestListeners.Count - 1 do
      begin
        LListener := (FTestListeners.Items[idx] as ITestListener);
        LListener.AddError(LTestFailure);
      end;
    end;
  end;

  for idx := 0 to FTestListeners.Count - 1 do
  begin
    LListener := (FTestListeners.Items[idx] as ITestListener);
    LListener.EndTest(LProxy);
  end;
end;

procedure TTestListenerProxy.ReleaseListeners;
begin
  FTestResult := nil;
  FTestListeners.Clear;
end;

procedure TTestListenerProxy.Status(const ATest: ITest; const AMessage: string);
var
  i: Integer;
begin
  if ATest = nil then
    Exit;

  for i := 0 to FTestListeners.Count - 1 do
    (FTestListeners.Items[i] as ITestListener).Status(TestToProxy(ATest), AMessage);
end;

function TITestResult.get_InhibitSummaryLevelChecks: boolean;
begin
  Result := FInhibitSummaryLevelChecks;
end;

procedure TITestResult.set_InhibitSummaryLevelChecks(const Value: boolean);
begin
  FInhibitSummaryLevelChecks := Value;
end;

end.
