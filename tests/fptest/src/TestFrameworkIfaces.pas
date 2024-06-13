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

unit TestFrameworkIfaces;

{$IFDEF FPC}
  {$mode delphi}{$H+}
{$ENDIF}

interface

uses
  Classes,
  IniFiles,
  SysUtils;

type
  PtrType = PtrUInt;
  TExceptTestMethod = procedure of object;

  TTestMethod = procedure of object;
  ITest = interface;
  TIsTestSelected = function(const ATest: ITest): boolean of object;
  TExecStatusUpdater = procedure(const ATest: ITest) of object;
  TStatusMsgUpdater = procedure(const ATest: ITest;
                                const AStatusMsg: string) of object;
{$M+}
  // The order is determined such that higher values always override lower
  // values when reporting status. So a failed testmethod will override a passed
  // test method at the testcase level and so on.
  TExecutionStatus = (_Ready, _Running, _HaltTest, _Passed,
                      _Warning, _Stopped, _Failed, _Break, _Error);

  TSupportedIface = (_isTestMethod, _isTestCase, _isTestSuite, _isTestProject,
                     _isTestDecorator, _Other);
  
{$M-}

  TAllowedLeakArray = array[0..3] of integer;
  TListIterator = function: integer of object;


  IMemLeakMonitor = interface(IUnknown)
  ['{041368CC-5B04-4111-9E2E-05A5908B3A58}']

    function MemLeakDetected(out LeakSize: Integer): boolean;
  end;


  IDUnitMemLeakMonitor = interface(IMemLeakMonitor)
  ['{45466FCA-1ADC-4457-A41C-88FA3F8D23F7}']

    function MemLeakDetected(const AllowedLeakSize: Integer;
                             const FailOnMemoryRecovery: boolean;
                             out   LeakSize: Integer): boolean; overload;
    function MemLeakDetected(const AllowedValuesGetter: TListIterator;
                             const FailOnMemoryRecovery: boolean;
                             out   LeakIndex: integer;
                             out   LeakSize: Integer): boolean; overload;
    function GetMemoryUseMsg(const FailOnMemoryRecovery: boolean;
                             const TestProcChangedMem: Integer;
                             out   ErrorMsg: string): boolean; overload;
    function GetMemoryUseMsg(const FailOnMemoryRecovery: boolean;
                             const TestSetupChangedMem: Integer;
                             const TestProcChangedMem: Integer;
                             const TestTearDownChangedMem: Integer;
                             const TestCaseChangedMem: Integer;
                             out   ErrorMsg: string): boolean; overload;
    procedure MarkMemInUse;
  end;


  // forward declaration
  ITestMethod = interface;


  ITestSetUpData = interface
  ['{46F62E93-A9C4-45D9-9AF1-C914E75481C0}']
  // derive from this interface when adding getters, setters and properties
  end;


  ITestExecControl = interface
  ['{F2E51368-2D72-49B3-A91F-E202C4466EB7}']

    function  get_TestSetUpData: ITestSetUpData;
    procedure set_TestSetUpData(const Value: ITestSetUpData);
    property  TestSetUpData: ITestSetUpData read Get_TestSetUpData write Set_TestSetUpData;

    function  get_HaltExecution: boolean;
    procedure set_HaltExecution(const Value: boolean);
    property  HaltExecution: boolean read get_HaltExecution write set_HaltExecution;

    function  get_BreakOnFailures: boolean;
    procedure set_BreakOnFailures(const Value: boolean);
    property  BreakOnFailures: boolean read get_BreakOnFailures write set_BreakOnFailures;

    procedure ClearCounts;
    function  get_TestCanRun: boolean;
    procedure set_TestCanRun(const Value: boolean);
    property  TestCanRun: boolean read get_TestCanRun write set_TestCanRun;

    function  get_CurrentTest: ITest;
    procedure set_CurrentTest(const Value: ITest);
    property  CurrentTest: ITest read get_CurrentTest write set_CurrentTest;

    function  get_ExecStatusUpdater: TExecStatusUpdater;
    procedure set_ExecStatusUpdater(const Value: TExecStatusUpdater);
    property  ExecStatusUpdater: TExecStatusUpdater read get_ExecStatusUpdater
                                                    write set_ExecStatusUpdater;
    function  get_StatusMsgUpdater: TStatusMsgUpdater;
    procedure set_StatusMsgUpdater(const Value: TStatusMsgUpdater);
    property  StatusMsgUpdater: TStatusMsgUpdater read get_StatusMsgUpdater
                                                  write set_StatusMsgUpdater;
    function  get_EnabledCount: Cardinal;
    procedure set_EnabledCount(const Value: Cardinal);
    property  EnabledCount: Cardinal read get_EnabledCount
                                     write set_EnabledCount;
    function  get_ExecutionCount: Cardinal;
    procedure set_ExecutionCount(const Value: Cardinal);
    property  ExecutionCount: Cardinal read get_ExecutionCount
                                       write set_ExecutionCount;
    function  get_FailsOnNoChecksExecuted: boolean;
    procedure set_FailsOnNoChecksExecuted(const Value: boolean);
    property  FailsOnNoChecksExecuted: boolean read get_FailsOnNoChecksExecuted
                                               write set_FailsOnNoChecksExecuted;
    function  get_FailureCount: Integer;
    procedure set_FailureCount(const Value: Integer);
    property  FailureCount: Integer read get_FailureCount
                                    write set_FailureCount;
    function  get_ErrorCount: Integer;
    procedure set_ErrorCount(const Value: Integer);
    property  ErrorCount: Integer read get_ErrorCount
                                  write set_ErrorCount;
    function  get_WarningCount: Integer;
    procedure set_WarningCount(const Value: Integer);
    property  WarningCount: Integer read get_WarningCount
                                    write set_WarningCount;
    function  get_ExcludedCount: Integer;
    procedure set_ExcludedCount(const Value: Integer);
    property  ExcludedCount: Integer read get_ExcludedCount
                                    write set_ExcludedCount;
    procedure IssueStatusMsg(const ATest: ITestMethod; const StatusMsg: string);
    function  get_CheckCalledCount: integer;
    procedure set_CheckCalledCount(const Value: Integer);
    property  CheckCalledCount: integer read get_CheckCalledCount
                                        write set_CheckCalledCount;
    function  get_IndividuallyEnabledTest: TIsTestSelected;
    procedure set_IndividuallyEnabledTest(const Value: TIsTestSelected);
    property  IndividuallyEnabledTest: TIsTestSelected read get_IndividuallyEnabledTest
                                                       write set_IndividuallyEnabledTest;
    function  get_InhibitStackTrace: boolean;
    procedure set_InhibitStackTrace(const Value: boolean);
    property  InhibitStackTrace: boolean read get_InhibitStackTrace
                                         write set_InhibitStackTrace;
    function  get_InhibitSummaryLevelChecks: boolean;
    procedure set_InhibitSummaryLevelChecks(const Value: boolean);
    property  InhibitSummaryLevelChecks: boolean read get_InhibitSummaryLevelChecks
                                                 write set_InhibitSummaryLevelChecks;
    function  get_FailsOnMemoryLeak: boolean;
    procedure set_FailsOnMemoryLeak(const Value: boolean);
    property  FailsOnMemoryLeak: boolean read get_FailsOnMemoryLeak
                                         write set_FailsOnMemoryLeak;
    property  FailsOnMemLeakDetection: boolean read get_FailsOnMemoryLeak
                                               write set_FailsOnMemoryLeak;
    function  get_IgnoresMemoryLeakInSetUpTearDown: boolean;
    procedure set_IgnoresMemoryLeakInSetUpTearDown(const Value: boolean);
    property  IgnoresMemoryLeakInSetUpTearDown: boolean
                read get_IgnoresMemoryLeakInSetUpTearDown
                write set_IgnoresMemoryLeakInSetUpTearDown;
  end;


  // forward declaration
  ITestCase = interface;


  ITest = interface
  ['{E465B9E7-5D7E-4A82-A5E7-9F4F86B465AD}']
    function  UniqueID: Cardinal;
    function  get_Proxy: IInterface;
    procedure set_Proxy(const AProxy: IInterface);
    property  Proxy: IInterface read get_Proxy write set_Proxy;
    function  get_ProjectID: integer;
    procedure set_ProjectID(const ID: integer);
    property  ProjectID: integer read get_ProjectID write set_ProjectID;
    function  MethodsName: string;
    // Legacy dunit partial compatability
    procedure RunTest;
    function  get_ParentTestCase: ITestCase;
    procedure set_ParentTestCase(const TestCase: ITestCase);
    property  ParentTestCase: ITestCase read get_ParentTestCase write set_ParentTestCase;
    procedure InstallExecutionControl(const Value: ITestExecControl);
    function  get_DisplayedName: string;
    procedure set_DisplayedName(const AName: string);
    function  GetName: string;
    function  CurrentTest: ITest;
    property  DisplayedName: string read get_DisplayedName write set_DisplayedName;
    function  get_ParentPath: string;
    procedure set_ParentPath(const AName: string);
    property  ParentPath: string read get_ParentPath write set_ParentPath;
    procedure set_Enabled(const Value: boolean);
    function  get_Enabled: boolean;
    property  Enabled : boolean read get_Enabled write set_Enabled;
    function  get_Excluded: boolean;
    procedure set_Excluded(const Value: boolean);
    property  Excluded: boolean read get_Excluded write set_Excluded;
    function  Count: integer;
    function  get_Depth: integer;
    procedure set_Depth(const Value: integer);
    property  Depth: integer read get_Depth write set_Depth;
    function  get_TestSetUpData: ITestSetUpData;
    procedure set_TestSetUpData(const Value: ITestSetUpData);
    property  TestSetUpData : ITestSetUpData read get_TestSetUpData write set_TestSetUpData;
    function  IsTestMethod: boolean;
    function  SupportedIfaceType: TSupportedIface;
    function  InterfaceSupports(const Value: TSupportedIface): Boolean;
    function  get_ElapsedTime: Extended;
    procedure set_ElapsedTime(const Value: Extended);
    property  ElapsedTime: Extended read get_ElapsedTime write set_ElapsedTime;
    procedure SaveConfiguration(const iniFile: TCustomIniFile; const Section: string);
    procedure LoadConfiguration(const iniFile :TCustomIniFile; const Section :string);
    procedure BeginRun;
    function  get_ExecStatus: TExecutionStatus;
    procedure set_ExecStatus(const Value: TExecutionStatus);
    property  ExecStatus: TExecutionStatus read get_ExecStatus write set_ExecStatus;
    procedure Status(const Value: string);
    function  GetStatus: string;
    function  UpdateOnFail(const ATest: ITest;
                           const NewStatus: TExecutionStatus;
                           const Excpt: Exception;
                           const Addrs: PtrType): TExecutionStatus;
    function  get_CheckCalled: boolean;
    procedure set_CheckCalled(const Value: boolean);
    property  CheckCalled: boolean read get_CheckCalled write set_CheckCalled;
    function  get_ErrorMessage: string;
    procedure set_ErrorMessage(const Value: string);
    property  ErrorMessage: string read get_ErrorMessage write set_ErrorMessage;
    function  get_ErrorAddress: PtrType;
    procedure set_ErrorAddress(const Value: PtrType);
    property  ErrorAddress: PtrType read get_ErrorAddress write set_ErrorAddress;
    function  get_ExceptionClass: ExceptClass;
    procedure set_ExceptionClass(const Value: ExceptClass);
    property  ExceptionClass: ExceptClass read get_ExceptionClass
                                          write set_ExceptionClass;
    function  get_FailsOnNoChecksExecuted: boolean;
    procedure set_FailsOnNoChecksExecuted(const Value: boolean);
    property  FailsOnNoChecksExecuted: boolean read get_FailsOnNoChecksExecuted
                                               write set_FailsOnNoChecksExecuted;
    function  get_InhibitSummaryLevelChecks: boolean;
    procedure set_InhibitSummaryLevelChecks(const Value: boolean);
    property  InhibitSummaryLevelChecks: boolean read get_InhibitSummaryLevelChecks
                                                 write set_InhibitSummaryLevelChecks;
    function  get_EarlyExit: Boolean;
    property  EarlyExit: boolean read get_EarlyExit;
    function  get_LeakAllowed: boolean;
    procedure set_LeakAllowed(const Value: boolean);
    property  LeakAllowed: boolean read get_LeakAllowed write set_LeakAllowed;
    function  get_FailsOnMemoryLeak: boolean;
    procedure set_FailsOnMemoryLeak(const Value: boolean);
    property  FailsOnMemoryLeak: boolean read get_FailsOnMemoryLeak
                                         write set_FailsOnMemoryLeak;
    function  get_AllowedMemoryLeakSize: Integer;
    procedure set_AllowedMemoryLeakSize(const NewSize: Integer);
    property  AllowedMemoryLeakSize: Integer read get_AllowedMemoryLeakSize
                                           write set_AllowedMemoryLeakSize;
    procedure SetAllowedLeakArray(const AllowedList: array of Integer);
    function  get_AllowedLeaksIterator: TListIterator;
    property  AllowedLeaksIterator: TListIterator read get_AllowedLeaksIterator;
    function  get_IgnoresMemoryLeakInSetUpTearDown: boolean;
    procedure set_IgnoresMemoryLeakInSetUpTearDown(const Value: boolean);
    property  IgnoresMemoryLeakInSetUpTearDown: boolean
                read get_IgnoresMemoryLeakInSetUpTearDown
                write set_IgnoresMemoryLeakInSetUpTearDown;
  end;


  ITestMethod = interface(ITest)
  ['{9B2501B0-F692-48A5-BE95-4DB6DD3FD382}']
    function  Run(const Parent: ITestCase;
                  const AMethodName: string;
                  const ExecControl: ITestExecControl): TExecutionStatus;
    procedure Warn(const ErrorMsg: string;
                   const ErrorAddress: Pointer = nil);
    procedure Fail(const ErrorMsg: string;
                   const ErrorAddress: Pointer = nil);
    procedure FailEquals(const expected, actual: UnicodeString;
                         const ErrorMsg: string = ''; ErrorAddrs: Pointer = nil);
    procedure FailNotEquals(const expected, actual: UnicodeString;
                            const ErrorMsg: string = ''; ErrorAddrs: Pointer = nil);
    procedure FailNotSame(const expected, actual: UnicodeString;
                          const ErrorMsg: string = ''; ErrorAddrs: Pointer = nil);
    //function  get_ExceptionClass: ExceptClass;
    //procedure set_ExceptionClass(const Value: ExceptClass);
    //property  ExceptionClass: ExceptClass read get_ExceptionClass
    //                                      write set_ExceptionClass;
  end;


   ITestCheck = interface
   ['{D6CFEE09-44AE-499A-AE8E-EFE23848AEED}']
    procedure OnCheckCalled;
    { The following are the calls users make in test procedures}
    procedure EarlyExitCheck(const condition: boolean; const ErrorMsg: string = '');
    procedure CheckFalse(const condition: boolean; const ErrorMsg: string = '');
    procedure CheckNotEquals(const expected, actual: boolean;
                             const ErrorMsg: string = ''); overload;
    procedure CheckEquals(const expected, actual: integer;
                          const ErrorMsg: string = ''); overload;
    procedure CheckNotEquals(const expected, actual: integer;
                             const ErrorMsg: string = ''); overload;
    procedure CheckEquals(const expected, actual: int64;
                          const ErrorMsg: string= ''); overload;
    procedure CheckNotEquals(const expected, actual: int64;
                             const ErrorMsg: string= ''); overload;
    procedure CheckNotEquals(const expected, actual: extended;
                             const ErrorMsg: string= ''); overload;
    procedure CheckNotEquals(const expected, actual: extended;
                             const delta: extended;
                             const ErrorMsg: string= ''); overload;
    procedure CheckEquals(const expected, actual: string;
                          const ErrorMsg: string= ''); overload;
    procedure CheckNotEquals(const expected, actual: string;
                             const ErrorMsg: string = ''); overload;
    procedure CheckEqualsString(const expected, actual: string;
                                const ErrorMsg: string = '');
    procedure CheckNotEqualsString(const expected, actual: string;
                                   const ErrorMsg: string = '');
  {$IFNDEF UNICODE}
    procedure CheckEquals(const expected, actual: UnicodeString;
                          const ErrorMsg: string= ''); overload;
    procedure CheckNotEquals(const expected, actual: UnicodeString;
                             const ErrorMsg: string = ''); overload;
    procedure CheckEqualsMem(const expected, actual: pointer;
                             const size:longword;
                             const ErrorMsg: string= '');
    procedure CheckNotEqualsMem(const expected, actual: pointer;
                                const size:longword;
                                const ErrorMsg:string='');
  {$ENDIF}
    procedure CheckEqualsUnicodeString(const expected, actual: UnicodeString;
                                    const ErrorMsg: string= '');
    procedure CheckNotEqualsUnicodeString(const expected, actual: UnicodeString;
                                       const ErrorMsg: string = '');
    procedure CheckEqualsBin(const expected, actual: longword;
                             const ErrorMsg: string = '';
                             const digits: Integer=32);
    procedure CheckNotEqualsBin(const expected, actual: longword;
                                const ErrorMsg: string = '';
                                const digits: Integer=32);
    procedure CheckEqualsHex(const expected, actual: longword;
                             const ErrorMsg: string = '';
                             const digits: Integer=8);
    procedure CheckNotEqualsHex(const expected, actual: longword;
                                const ErrorMsg: string = '';
                                const digits: Integer=8);

    procedure CheckNotNull(const obj :IInterface;
                           const ErrorMsg :string = ''); overload;
    procedure CheckNull(const obj: IInterface;
                        const ErrorMsg: string = ''); overload;
    procedure CheckNotNull(const obj: TObject;
                           const ErrorMsg: string = ''); overload;
    procedure CheckNull(const obj: TObject;
                        const ErrorMsg: string = ''); overload;
    procedure CheckNotNull(const obj :Pointer;
                           const ErrorMsg :string = ''); overload;
    procedure CheckNull(const obj: Pointer;
                        const ErrorMsg: string = ''); overload;
    procedure CheckNotSame(const expected, actual: IInterface;
                           const ErrorMsg: string = ''); overload;
    procedure CheckSame(const expected, actual: TObject;
                        const ErrorMsg: string = ''); overload;
    procedure CheckNotSame(const expected, actual: TObject;
                           const ErrorMsg: string = ''); overload;
    procedure CheckException(const AMethod: TExceptTestMethod;
                             const AExceptionClass: TClass;
                             const ErrorMsg :string = '');
    procedure CheckEquals(const expected, actual: TClass;
                          const ErrorMsg: string = ''); overload;
    procedure CheckNotEquals(const expected, actual: TClass;
                             const ErrorMsg: string = ''); overload;
    procedure CheckInherits(const expected, actual: TClass;
                            const ErrorMsg: string = '');
    procedure Check(const condition: boolean; const ErrorMsg: string= ''); overload;
    procedure CheckEquals(const expected, actual: extended;
                          const ErrorMsg: string= ''); overload;
    procedure CheckTrue(const condition: boolean; const ErrorMsg: string = '');
    procedure CheckEquals(const expected, actual: boolean;
                          const ErrorMsg: string = ''); overload;
    procedure CheckSame(const expected, actual: IInterface;
                        const ErrorMsg: string = ''); overload;
    procedure CheckIs(const AObject :TObject;
                      const AClass: TClass;
                      const ErrorMsg: string = '');
    procedure CheckEquals(const expected, actual: extended;
                          const delta: extended;
                          const ErrorMsg: string= ''); overload;
  end;


  ITestCase = interface(ITest)
  ['{230CEE88-79CD-4D01-9CE3-DF8018327C05}']
    procedure SetUp;
    procedure TearDown;
    function  Run(const ExecControl: ITestExecControl): TExecutionStatus;
    procedure AddTest(const ATest: ITest);
    //function  Count: integer;
    function  CountTestCases: Integer;
    procedure AddSuite(const ATest: ITest);
    procedure Reset; //Resets to 1st entry
    function  PriorTest: ITest;
    function  FindNextEnabledProc: ITest;
    function  get_ProgressSummary: IInterface;
    property  ProgressSummary: IInterface read get_ProgressSummary;
    function  get_ExpectedException: ExceptClass;
    procedure StartExpectingException(e: ExceptClass);
    property  ExpectedException :ExceptClass read  get_ExpectedException
                                             write StartExpectingException;
    //procedure InstallExecutionControl(const Value: ITestExecControl);
    function  get_ReEntering: Boolean;
    procedure set_ReEntering(const Value: Boolean);
    property  ReEntering: Boolean read get_ReEntering write set_ReEntering;
    function  get_ReportErrorOnce: boolean;
    procedure set_ReportErrorOnce(const Value: boolean);
    property  ReportErrorOnce: Boolean read get_ReportErrorOnce
                                       write set_ReportErrorOnce;
    procedure ReleaseProxys;
    procedure StopTests(const ErrorMsg: string = '');
    procedure InhibitStackTrace; overload;
    procedure InhibitStackTrace(const Value: boolean); overload;
  end;


  IReadOnlyIterator = interface
  ['{F76E5F49-B2EC-4F6C-ACB9-E8E03B1F230B}']
    procedure Reset; //Resets to 1st entry
    function  FindFirstTest: ITest;
    function  FindNextTest: ITest;
    function  PriorTest: ITest;
    function  FindNextEnabledProc: ITest;
    function  CurrentTest: ITest;
  end;


  ITestIterator = interface(IReadOnlyIterator)
  ['{A408E082-8F55-4E37-AA66-E41629E2DE26}']
    procedure AddTest(const ATest: ITest);
  end;


  ITestSuite = interface(ITestCase)
  ['{DD917A7D-B457-43A9-9828-250C890DFE58}']
    procedure AddTest(const SuiteTitle: string;
                      const ASuite: ITestCase); overload;
    procedure AddTest(const SuiteTitle: string;
                      const Suites: array of ITestCase); overload;
  end;


  {: General interface for test decorators}
  ITestDecorator = interface(ITestSuite)
  ['{962956B6-0633-4296-A5E7-AC6250450793}']
  end;


  IRepeatedTest = interface(ITestSuite)
  ['{DF3B52FF-2645-42C2-958A-174FF87A19B8}']
    procedure set_RepeatCount(const Value: Integer);
    property  RepeatCount: Integer write set_RepeatCount;
    function  GetHaltOnError: Boolean;
    procedure SetHaltOnError(const Value: Boolean);
    property  HaltOnError: Boolean read GetHaltOnError write SetHaltOnError;
  end;


  ITestProject = interface(ITestSuite)
  ['{83481224-7BC4-4C9F-83B3-56DD17BD73AA}']
    function  get_Manager: IInterface;
    procedure set_Manager(const AManager: IInterface);
    property  Manager: IInterface read Get_Manager write Set_Manager;
    function  CountEnabledTests: integer;
    function  SuiteByTitle(const SuiteTitle: string): ITestSuite;
    //procedure AddTest(const SuiteTitle: string;
    //                  const ASuite: ITestCase); overload;
    //procedure AddTest(const SuiteTitle: string;
    //                  const Suites: array of ITestCase); overload;
    procedure AddNamedSuite(const SuiteTitle: string; const ATest: ITestCase);
    function  FindFirstTest: ITest;
    function  FindNextTest: ITest;
    procedure RegisterTest(const ATest: ITest);
    function  ExecutionControl: ITestExecControl;
    procedure set_Listener(const Value: IInterface);
    property  Listener: IInterface write set_Listener;
  end;


  IMemUseComparator = interface
  ['{1D015AE6-6555-426D-987D-64B482AFBB94}']
    procedure RunSetup(const UsersSetUp: TThreadMethod);
    procedure RunTearDown(const UsersTearDown: TThreadMethod);
    function  AlertOnMemoryLoss(const CurrentStatus: TExecutionStatus): TExecutionStatus;
  end;


implementation

end.
