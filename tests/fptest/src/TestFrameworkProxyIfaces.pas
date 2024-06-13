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

unit TestFrameworkProxyIfaces;
{ This unit sits between a modified GUITestRunner and the new FPTest
  TestFramework. It provides an interface to make the new TestFrameWork
  look and appear to behave like the old TestFramework. Once tests are
  running GUITestRunner will be gradually modified to interface more closely
  with the new TestFramework. This "Proxy" unit re-creates the Tests
  structure currently accessed by the treeview.  }

{$IFDEF FPC}
  {$mode delphi}{$H+}
{$ENDIF}

interface

uses
  Classes,
  TestFrameworkIfaces;

type
  // forward declarations
  ITestResult = interface;
  ITestListener = interface;

  ITestProxy = interface
  ['{D09EA9F7-3C0D-4A51-9A07-30BF202AF87C}']
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
    function  get_Failures: integer;
    procedure set_Failures(const Value: integer);
    function  get_Warnings: integer;
    procedure set_Warnings(const Value: integer);
    function  get_TestsExecuted: Integer;
    procedure set_TestsExecuted(const Value: Integer);
    function  Updated: boolean;
    procedure SetFailsOnNoChecksExecuted(const Value: Boolean);
    function  GetFailsOnNoChecksExecuted: Boolean;
    function  get_InhibitSummaryLevelChecks: boolean;
    procedure set_InhibitSummaryLevelChecks(const Value: boolean);
    property  InhibitSummaryLevelChecks: boolean read get_InhibitSummaryLevelChecks
                                                 write set_InhibitSummaryLevelChecks;
    function  EarlyExit: boolean;

    function  get_LeakAllowed: boolean;
    property  LeakAllowed: boolean read get_LeakAllowed;
    function  GetFailsOnMemoryLeak: Boolean;
    procedure SetFailsOnMemoryLeak(const Value: Boolean);
    function  GetIgnoreSetUpTearDownLeaks: Boolean;
    procedure SetIgnoreSetUpTearDownLeaks(const Value: Boolean);
    function  GetAllowedMemoryLeakSize: Integer;
    procedure SetAllowedMemoryLeakSize(const NewSize: Integer);
    function  GetFailsOnMemoryRecovery: Boolean;

    procedure SaveConfiguration(const FileName: string; const useRegistry, useMemIni: Boolean);
    procedure LoadConfiguration(const FileName: string; const useRegistry, useMemIni: Boolean);
    function  CountEnabledTestCases: integer;
    function  ElapsedTestTime: Extended;
    function  Tests: IInterfaceList;
    procedure Run(const TestResult: ITestResult); overload;
    function  Run(const Listeners: array of ITestListener): ITestResult; overload;
    function  Run(const AListener: ITestListener): ITestResult; overload;
    procedure HaltTesting;
    procedure ReleaseTests;

    property  GUIObject: TObject read GetGUIObject write SetGUIObject;
    property  Enabled: Boolean read GetEnabled write SetEnabled;
    property  Excluded: Boolean read GetExcluded write SetExcluded;
    property  Name: string read GetName;
    property  Status: string read GetStatus;
    property  IsTestMethod: boolean read get_IsTestMethod;
    property  ExecutionStatus: TExecutionStatus read get_ExecutedStatus
                                               write set_ExecutedStatus;
    property  IsOverridden: boolean read get_IsOverridden write set_IsOverridden;
    property  IsWarning: boolean read get_IsWarning write set_IsWarning;
    property  Errors: integer read get_Errors write set_Errors;
    property  Failures: integer read get_Failures write set_Failures;
    property  Warnings: integer read get_Warnings write set_Warnings;
    property  TestsExecuted: integer read get_TestsExecuted write set_TestsExecuted;
    property  FailsOnNoChecksExecuted: Boolean
                read GetFailsOnNoChecksExecuted
                write SetFailsOnNoChecksExecuted;
    property  FailsOnMemoryLeak: Boolean read GetFailsOnMemoryLeak
                                         write SetFailsOnMemoryLeak;
    property  FailsOnMemLeakDetection: boolean read GetFailsOnMemoryLeak
                                               write SetFailsOnMemoryLeak;
    property  IgnoreSetUpTearDownLeaks: Boolean read GetIgnoreSetUpTearDownLeaks
                                                write SetIgnoreSetUpTearDownLeaks;
    property  AllowedMemoryLeakSize: Integer read GetAllowedMemoryLeakSize
                                             write SetAllowedMemoryLeakSize;
  end;


  ITestSuiteProxy = interface(ITestProxy)
  ['{7CFE1779-1207-4D55-A0DD-BA71240F96E0}']
    procedure TestSuiteTitle(const ATitle: string);
  end;


  TTestFailure = interface
  ['{C652E195-29DC-409D-B4EF-65B1EF1223F0}']
    function ThrownExceptionAddress: PtrType;
    function FailedTest: ITestProxy;
    function ThrownExceptionName:    string;
    function ThrownExceptionMessage: string;
    function LocationInfo:           string;
    function AddressInfo:            string;
    function StackTrace:             string;
  end;


  { IStatusListeners are notified of test status messages }
  IStatusListener = interface
  ['{8681DC88-033C-4A42-84F4-4C52EF9ABAC0}']
    procedure Status(const ATest: ITestProxy; AMessage: string);
  end;


  { ITestListeners get notified of testing events.
    See ITestResult.AddListener()  }
  ITestListener = interface(IStatusListener)
  ['{114185BC-B36B-4C68-BDAB-273DBD450F72}']
    procedure AddSuccess(Test: ITestProxy);
    procedure AddError(Error: TTestFailure);
    procedure AddFailure(Failure: TTestFailure);
    procedure AddWarning(AWarning: TTestFailure);
    procedure TestingStarts;
    procedure StartTest(Test: ITestProxy);
    procedure EndTest(Test: ITestProxy);
    procedure TestingEnds(TestResult: ITestResult);
    function  ShouldRunTest(const ATest :ITestProxy):Boolean;
  end;


  ITestListenerX = interface(ITestListener)
  ['{5C28B1BE-38B5-4D6F-AA96-A04E9302C317}']
    procedure StartSuite(Suite: ITestProxy);
    procedure EndSuite(Suite: ITestProxy);
  end;


  ITestResult = interface
    procedure ReleaseListeners;
    function  GetFailure(idx :Integer) :TTestFailure;
    procedure SetFailure(idx: Integer; AFailure: TTestFailure);
    function  GetError(idx :Integer) :TTestFailure;
    procedure SetError(idx: Integer; AnError: TTestFailure);
    function  GetWarning(idx :Integer) :TTestFailure;
    procedure SetWarning(idx: Integer; AFailure: TTestFailure);
    function  get_ErrorCount: integer;
    procedure set_ErrorCount(const Value: integer);
    property  ErrorCount: integer read get_ErrorCount write set_ErrorCount;
    function  get_RunCount: integer;
    procedure set_RunCount(const Value: integer);
    property  RunCount: integer read get_RunCount write set_RunCount;
    function  get_FailureCount: integer;
    procedure set_FailureCount(const Value: integer);
    property  FailureCount: integer read get_FailureCount write set_FailureCount;
    function  get_ChecksCalledCount: integer;
    procedure set_ChecksCalledCount(const Value: integer);
    property  ChecksCalledCount: integer read get_ChecksCalledCount write set_ChecksCalledCount;
    procedure Stop;
    procedure AddListener(const Listener: ITestListener);
    procedure RemoveListener(const Listener: ITestListener);
    property  Failures[i :Integer] :TTestFailure read GetFailure write SetFailure;
    property  Errors[i :Integer] :TTestFailure read GetError write SetError;
    property  Warnings[i :Integer] :TTestFailure read GetWarning write SetWarning;
    function  WasSuccessful: Boolean;
    function  get_WasStopped :Boolean;
    procedure set_WasStopped(const Value: Boolean);
    property  WasStopped:Boolean read get_WasStopped write set_WasStopped;
    function  get_WarningCount: integer;
    procedure set_WarningCount(const Value: integer);
    property  WarningCount: integer read get_WarningCount write set_WarningCount;
    function  get_ExcludedCount: Integer;
    procedure set_ExcludedCount(const Value: integer);
    property  ExcludedCount: integer read get_ExcludedCount write set_ExcludedCount;
    function  get_Overrides: integer;
    procedure set_Overrides(const Value: integer);
    property  Overrides: integer read get_Overrides write set_Overrides;
    function  get_TotalTime: Extended;
    procedure set_TotalTime(const Value: Extended);
    property  TotalTime: Extended read get_TotalTime write set_TotalTime;

    function  get_BreakOnFailures: boolean;
    procedure set_BreakOnFailures(const Value: boolean);
    property  BreakOnFailures :Boolean read get_BreakOnFailures write set_BreakOnFailures;

    function  get_FailsIfNoChecksExecuted: boolean;
    procedure set_FailsIfNoChecksExecuted(const Value: boolean);
    property  FailsIfNoChecksExecuted :Boolean read get_FailsIfNoChecksExecuted
                                              write set_FailsIfNoChecksExecuted;
    function  get_InhibitSummaryLevelChecks: boolean;
    procedure set_InhibitSummaryLevelChecks(const Value: boolean);
    property  InhibitSummaryLevelChecks: boolean read get_InhibitSummaryLevelChecks
                                                 write set_InhibitSummaryLevelChecks;

    function  get_FailsIfMemoryLeaked: boolean;
    procedure set_FailsIfMemoryLeaked(const Value: boolean);
    property  FailsIfMemoryLeaked :Boolean read get_FailsIfMemoryLeaked
                                          write set_FailsIfMemoryLeaked;
    function  get_IgnoresMemoryLeakInSetUpTearDown: boolean;
    procedure set_IgnoresMemoryLeakInSetUpTearDown(const Value: boolean);
    property  IgnoresMemoryLeakInSetUpTearDown: Boolean
                read get_IgnoresMemoryLeakInSetUpTearDown
                write set_IgnoresMemoryLeakInSetUpTearDown;
  end;


implementation

end.
