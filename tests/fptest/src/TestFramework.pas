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

unit TestFramework;

{$IFDEF FPC}
  {$mode delphi}{$H+}
{$ELSE}
  // If Delphi 7, turn off UNSAFE_* Warnings
  {$IFNDEF VER130}
    {$IFNDEF VER140}
      {$WARN UNSAFE_CODE OFF}
      {$WARN UNSAFE_CAST OFF}
    {$ENDIF}
  {$ENDIF}
{$ENDIF}

// Comment out this define to remove FPCUnit test interface support
{$define fpcunit}

interface

uses
  TestFrameworkIfaces,
  Classes,
  SysUtils,
  IniFiles;

{ This lets us use a single include file for both the Interface and
  Implementation sections. }
{$define read_interface}
{$undef read_implementation}

{ TODO -cregistry : Remove Registry support - we want clean INI support only }

{$IFNDEF FPC}
const
  LineEnding          = #13#10;
  AllFilesMask        = '*.*';
{$ENDIF}

type
  ETestFailure = class(EAbort)
     constructor Create;                          overload;
     constructor Create(const ErrorMsg :string);  overload;
  end;


  EDUnitException = class(Exception);
  ETestError = class(EDUnitException);


  TReadOnlyIterator = class(TInterfacedObject, IReadOnlyIterator)
  private
    idx: Integer;
    FCurrentTest: ITest;
    function  Count: Integer;
  protected
    FIList: IInterfaceList;
    procedure Reset;
    function  FindFirstTest: ITest;
    function  FindNextTest: ITest;
    function  PriorTest: ITest;
    function  FindNextEnabledProc: ITest;
    function  CurrentTest: ITest;
  public
    constructor Create; virtual;
    destructor Destroy; override;
  end;


  TTestIterator = class(TReadOnlyIterator, ITestIterator)
  protected
    //Adds entry and resets idx to 1st entry
    procedure AddTest(const ATest: ITest);
  end;


  {$M+}
  TTestProc = class(TInterfacedObject, ITest, ITestMethod, ITestCheck)
  private
    FUniqueID: Cardinal;
    FProjectID: Integer;
    FEnabled: boolean;
    FExcluded: boolean;
    FTestSetUpData: ITestSetUpData;
    FMethodName: string;
    FParent: Pointer; // Weak reference to ITestCase;
    FIsTestMethod: boolean;
    FSupportedIface: TSupportedIface;
    FMethod: TTestMethod;
    FExecStatus: TExecutionStatus;
    FDepth: Integer;
    FCheckCalled: boolean;
    FElapsedTime: Extended;
    FStartTime: Extended;
    FStopTime:  Extended;
    FExceptionIs: ExceptClass;
    FExpectedExcept: ExceptClass;
    FErrorAddress: PtrType;
    FErrorMessage: string;
    FFailsOnNoChecksExecuted: boolean;
    FStatusMsgs: TStrings;
    FProxy: Pointer; // Weak reference to IInterface;
    FParentPath: string;
    FInhibitSummaryLevelChecks: Boolean;
    FEarlyExit: Boolean;
    FLeakAllowed: Boolean;
    FAllowedLeakList: TAllowedLeakArray;
    FAllowedLeakListIndex: Word;
    FFailsOnMemoryLeak: boolean;
    FIgnoresMemoryLeakInSetUpTearDown: boolean;
    function  CheckMethodCalledCheck(const ATest: ITest): TExecutionStatus;
    function  ElapsedTestTime: Extended;
    function  MethodCode(const MethodsName: string): TTestMethod;
    procedure CheckMethodIsNotEmpty(const AMethod: TTestMethod);
    procedure InitializeRunState; virtual;
    function  Run(const CurrentTestCase: ITestCase;
                  const AMethodName: string;
                  const ExecControl: ITestExecControl): TExecutionStatus;
    function  IsValidTestMethod(const AProc: TTestMethod): boolean;
  protected
    FDisplayedName: string;
    FExecControl: ITestExecControl;
    function  UniqueID: Cardinal;
    function  get_ProjectID: Integer;
    procedure set_ProjectID(const ID: Integer);
    function  MethodsName: string;
    procedure RunTest; virtual;
    function  get_ParentTestCase: ITestCase;
    procedure set_ParentTestCase(const TestCase: ITestCase);
    procedure InstallExecutionControl(const Value: ITestExecControl);
    function  get_ExceptionClass: ExceptClass;
    procedure set_ExceptionClass(const Value: ExceptClass);
    function  get_DisplayedName: string; virtual;
    procedure set_DisplayedName(const AName: string); virtual;
    function  GetName: string; virtual;
    function  CurrentTest: ITest; virtual;
    function  get_ParentPath: string;
    procedure set_ParentPath(const AName: string); virtual;
    function  get_Enabled: boolean;
    procedure set_Enabled(const Value: boolean);
    function  get_Excluded: boolean;
    procedure set_Excluded(const Value: boolean);
    function  Count: Integer; virtual;
    function  get_Depth: Integer;
    procedure set_Depth(const Value: Integer);
    function  get_CheckCalled: boolean;
    procedure set_CheckCalled(const Value: boolean);
    procedure SaveConfiguration(const iniFile: TCustomIniFile;
                                const Section: string); virtual;
    procedure LoadConfiguration(const iniFile :TCustomIniFile;
                                const Section :string); virtual;
    function  IsTestMethod: boolean;
    function  SupportedIfaceType: TSupportedIface;
    function  InterfaceSupports(const Value: TSupportedIface): Boolean;
    function  get_ElapsedTime: Extended;
    procedure set_ElapsedTime(const Value: Extended);
    function  get_TestSetUpData: ITestSetUpData;
    procedure set_TestSetUpData(const IsTestSetUpData: ITestSetUpData);
    function  get_FailsOnNoChecksExecuted: boolean;
    procedure set_FailsOnNoChecksExecuted(const Value: boolean);
    function  get_InhibitSummaryLevelChecks: boolean;
    procedure set_InhibitSummaryLevelChecks(const Value: boolean);
    function  get_EarlyExit: boolean;
    function  get_LeakAllowed: boolean;
    procedure set_LeakAllowed(const Value: boolean);
    property  LeakAllowed: boolean read get_LeakAllowed;
    function  get_FailsOnMemoryLeak: boolean;
    procedure set_FailsOnMemoryLeak(const Value: boolean);
    function  GetAllowedLeak: Integer;
    procedure SetAllowedLeakArray(const AllowedList: array of Integer);
    function  get_AllowedLeaksIterator: TListIterator;
    function  get_AllowedMemoryLeakSize: Integer;
    procedure set_AllowedMemoryLeakSize(const NewSize: Integer);
    function  get_IgnoresMemoryLeakInSetUpTearDown: boolean;
    procedure set_IgnoresMemoryLeakInSetUpTearDown(const Value: boolean);
    function  get_ExpectedException: ExceptClass;
    procedure StartExpectingException(e: ExceptClass);
    procedure StopExpectingException(const ErrorMsg :string = '');
    procedure BeginRun; virtual;
    function  get_ExecStatus: TExecutionStatus;
    procedure set_ExecStatus(const Value: TExecutionStatus);
    function  get_ErrorMessage: string;
    procedure set_ErrorMessage(const Value: string);
    function  get_ErrorAddress: PtrType;
    procedure set_ErrorAddress(const Value: PtrType);
    procedure Warn(const ErrorMsg: string;
                   const ErrorAddress: Pointer = nil); overload;
    function  UpdateOnFail(const ATest: ITest;
                           const NewStatus: TExecutionStatus;
                           const Excpt: Exception;
                           const Addrs: PtrType): TExecutionStatus;
    function  UpdateOnError(const ATest: ITest;
                            const NewStatus: TExecutionStatus;
                            const ExceptnMsg: string;
                            const Excpt: Exception;
                            const Addrs: PtrType): TExecutionStatus;
    function  GetStatus: string;
    procedure Status(const Value: string);
    function  get_Proxy: IInterface;
    procedure set_Proxy(const AProxy: IInterface);
    procedure PostFail(const ErrorMsg: string;
                       const ErrorAddress: Pointer = nil); overload;
    function  PtrToStr(const P: Pointer): string;
    procedure Invoke(AMethod: TExceptTestMethod);
    // related to Check(Not)EqualsMem, pointer based
    function  GetMemDiffStr(const expected, actual: pointer;
                            const size: longword; const ErrorMsg: string): string;

    function  EqualsErrorMessage(const expected, actual :UnicodeString;
                                 const ErrorMsg: string): UnicodeString; virtual;
    function  NotEqualsErrorMessage(const expected, actual :UnicodeString;
                                    const ErrorMsg: string): UnicodeString; virtual;
  public
    procedure Fail(const ErrorMsg: string;
                   const ErrorAddress: Pointer = nil);
    procedure FailEquals(const expected, actual: UnicodeString;
                         const ErrorMsg: string = ''; ErrorAddrs: Pointer = nil); //virtual;
    procedure FailNotEquals(const expected, actual: UnicodeString;
                            const ErrorMsg: string = ''; ErrorAddrs: Pointer = nil); //virtual;
    procedure FailNotSame(const expected, actual: UnicodeString;
                          const ErrorMsg: string = ''; ErrorAddrs: Pointer = nil); //virtual;
    procedure OnCheckCalled;

    { The following are the calls users make in test procedures . }
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
    {$IFDEF fpcunit}
      {$I FPCUnitCompatibleInterface.inc}
    {$ENDIF}
  public
    constructor Create; overload; virtual;
    constructor Create(const AName: string); overload; virtual;
    constructor Create(const OwnerProc: TTestMethod;
                       const ParentPath: string;
                       const AMethod: TTestMethod;
                       const AMethodName: string); overload;
    destructor Destroy; override;
  published
    property  ProjectID: Integer read get_ProjectID write set_ProjectID;
    property  DisplayedName: string read get_DisplayedName
                                    write set_DisplayedName;
    property  ParentPath: string read get_ParentPath write set_ParentPath;
    property  ParentTestCase: ITestCase read get_ParentTestCase write set_ParentTestCase;
    property  Enabled: boolean read get_Enabled write set_Enabled;
    property  Excluded: boolean read get_Excluded write set_Excluded;
    property  Depth: Integer read get_Depth write set_Depth;
    property  ElapsedTime: Extended read get_ElapsedTime write set_ElapsedTime;
    property  TestSetUpData: ITestSetUpData read get_TestSetUpData
                                            write set_TestSetUpData;
    property  FailsOnNoChecksExecuted: boolean read get_FailsOnNoChecksExecuted
                                               write set_FailsOnNoChecksExecuted;
    property  ExecStatus: TExecutionStatus read get_ExecStatus write set_ExecStatus;
    property  ExceptionClass: ExceptClass read get_ExceptionClass
                                          write set_ExceptionClass;
    property  ErrorMessage: string read get_ErrorMessage write set_ErrorMessage;
    property  ErrorAddress: PtrType read get_ErrorAddress write set_ErrorAddress;
    property  ExpectedException :ExceptClass read  get_ExpectedException
                                             write StartExpectingException;
    property  InhibitSummaryLevelChecks: boolean read get_InhibitSummaryLevelChecks
                                         write set_InhibitSummaryLevelChecks;
    property  EarlyExit: boolean read get_EarlyExit;
    property  FailsOnMemoryLeak: boolean read get_FailsOnMemoryLeak write set_FailsOnMemoryLeak;
    property  FailsOnMemLeakDetection: boolean read get_FailsOnMemoryLeak write set_FailsOnMemoryLeak;
    property  IgnoresMemoryLeakInSetUpTearDown: boolean read get_IgnoresMemoryLeakInSetUpTearDown write set_IgnoresMemoryLeakInSetUpTearDown;
    property  Proxy: IInterface read get_Proxy write set_Proxy;
  end;
  {$M-}

  // Provided for partial backwards compatibility
  TAbstractTest = TTestProc;

  TTestCase = class(TTestProc, ITestCase)
  private
    FReportErrorOnce: boolean;
    FProgressSummary: IInterface;
    FReEntering: Boolean;
    procedure EnumerateMethods;
  protected
    FTestIterator: ITestIterator;
    procedure set_DisplayedName(const AName: string); override;
    procedure set_ParentPath(const AName: string); override;
    function  GetName: string; override;
    procedure SetUpOnce; virtual;
    procedure SetUp; virtual;
    function  Run(const ExecControl: ITestExecControl): TExecutionStatus; virtual;
    procedure TearDown; virtual;
    procedure TearDownOnce; virtual;
    function  Count: Integer; override;
    function  CountTestCases: Integer; virtual;
    procedure Reset; virtual; //Resets to 1st entry
    procedure BeginRun; override;
    function  PriorTest: ITest; virtual;
    function  FindNextEnabledProc: ITest; virtual;
    function  CurrentTest: ITest; override;
    procedure Status(const Value: string);
    function  GetStatus: string;
    function  get_ReEntering: Boolean;
    procedure set_ReEntering(const Value: Boolean);
    function  get_ProgressSummary: IInterface;
    procedure SaveConfiguration(const iniFile: TCustomIniFile;
                                const Section: string); override;
    procedure LoadConfiguration(const iniFile :TCustomIniFile;
                                const Section :string); override;
    function  get_ReportErrorOnce: boolean;
    procedure set_ReportErrorOnce(const Value: boolean);
    property  ReportErrorOnce: Boolean read get_ReportErrorOnce
                                       write set_ReportErrorOnce;
    procedure ReleaseProxys; virtual;
    procedure StopTests(const ErrorMsg: string = '');
    procedure InhibitStackTrace; overload;
    procedure InhibitStackTrace(const Value: boolean); overload;

    { The following are the calls users make in test procedures . }
  public
    procedure AddSuite(const ATest: ITest); virtual;
    procedure AddTest(const ATest: ITest);
    constructor Create; overload; override;
    constructor Create(const AProcName: string); override;
    destructor Destroy; override;
    class function Suite: ITestCase; virtual;
  published
    property  AllowedMemoryLeakSize: Integer read get_AllowedMemoryLeakSize write set_AllowedMemoryLeakSize;
    property  AllowedLeaksIterator: TListIterator read get_AllowedLeaksIterator;
    property  ProgressSummary: IInterface read get_ProgressSummary;
    property  ReEntering: Boolean read get_ReEntering write set_ReEntering;
  end;


  TTestSuite = class(TTestCase, ITestSuite)
  protected
    procedure Reset; override; //Resets all subordinate iterators to 1st entry
    function  PriorTest: ITest; override;
    function  FindNextEnabledProc: ITest; override;
    function  TestIterator: IReadOnlyIterator;
  public
    procedure AddTest(const SuiteTitle: string; const ASuite: ITestCase); reintroduce; overload;
    procedure AddTest(const SuiteTitle: string; const Suites: array of ITestCase); reintroduce; overload;
    constructor Create(const ASuiteName: string); overload; override;
    class function Suite(const ASuiteName: string): ITestSuite; reintroduce; overload;
    class function Suite(const ASuiteName: string; const ATestCase: ITestCase): ITestSuite; reintroduce; overload;
    class function Suite(const ASuiteName: string; const TestCases: array of ITestCase): ITestSuite; reintroduce; overload;
  end;


  TTestDecorator = class(TTestSuite, ITestDecorator)
  protected
    function  Run(const ExecControl: ITestExecControl): TExecutionStatus; reintroduce; override;
  public
    // Provides a decoratorated TestCase.
    class function Suite(const DecoratedTestCase: ITestCase): ITestSuite; reintroduce; overload;
    // Provides a decoratorated TestSuite.
    class function Suite(const DecoratorName: string;
                         const DecoratedTestCase: ITestCase): ITestSuite; reintroduce; overload;
    // Provides an array of decorated TestSuites/TestCases
    class function Suite(const DecoratorName: string;
                         const DecoratedTestCases: array of ITestCase): ITestSuite; reintroduce; overload;
  end;


  TRepeatedTest = class(TTestSuite, IRepeatedTest)
  private
    FRepeatCount: Integer;
    FHaltOnError: Boolean;
    function  GetHaltOnError: Boolean;
    procedure SetHaltOnError(const Value: Boolean);
  protected
    function  Run(const ExecControl: ITestExecControl): TExecutionStatus; override;
    procedure set_RepeatCount(const Value: Integer);
    function  Count: Integer; override;
  published
    property  RepeatCount: Integer write set_RepeatCount;
    property  HaltOnError: Boolean read GetHaltOnError write SetHaltOnError;
  public
    class function Suite(const CountedTestCase: ITestCase;
                         const Iterations: Cardinal): IRepeatedTest; reintroduce; overload;
  end;


  TTestProject = class(TTestSuite, ITestProject, IReadOnlyIterator)
  private
    FAllTestsList: IInterfaceList; // ITests stored in reverse order
    FSuiteList: IInterfaceList; // Holds a list of retreivable TestSuites
    FTestIdx: Integer;
    FManager: IInterface; //Points to ProjectManager.
    FEnabledTestsCounted: boolean;
    FProjectName: string;
    FExecStatusUpdater: TExecStatusUpdater;
    FStatusMsgUpdater: TStatusMsgUpdater;
    FTestingBegins: boolean;
    FListener: IInterface;
    FCount: Integer;
    FExecControl: ITestExecControl;
    procedure CreateFields;
    function  IsTestSelected(const ATest: ITest):Boolean;
    procedure ExecStatusUpdater(const ATest: ITest);
    procedure StatusMessageUpdater(const ATest: ITest; const AStatusMsg: string);
    procedure AddNamedSuite(const SuiteTitle: string; const ATest: ITestCase);
  protected
    function  CountEnabledTests: Integer;
    function  get_ProjectName: string;
    procedure set_ProjectName(const AName: string);
    procedure Reset; override;
    function  SuiteByTitle(const SuiteTitle: string): ITestSuite;
    function  FindFirstTest: ITest; virtual;
    function  FindNextTest: ITest; virtual;
    function  FindNextEnabledProc: ITest; override;
    function  Count: Integer; override; // Count of enabled procedures
    procedure AddTest(const ATest: ITest); reintroduce; overload;
    procedure RegisterTest(const ATest: ITest);
    function  get_Manager: IInterface;
    procedure set_Manager(const AManager: IInterface);
    function  ExecutionControl: ITestExecControl; virtual;
    function  Run(const ExecControl: ITestExecControl): TExecutionStatus; override;
    procedure set_Listener(const Value: IInterface);
  public
    constructor Create; overload; override;
    constructor Create(const ASuiteName: string); overload; override;
    destructor Destroy; override;
  published
    property  Manager: IInterface read get_Manager write set_Manager;
    property  ProjectName: string read get_ProjectName write set_ProjectName;
    property  Listener: IInterface write set_Listener;
  end;


function  TestExecControl: ITestExecControl;
function  Projects: ITestProject; overload;
function  TestProject: ITestProject; overload;
function  TestProject(const idx: Integer): ITestProject; overload;
{$IFDEF FASTMM}
function  MemLeakMonitor: IDUnitMemLeakMonitor;
{$ENDIF}
// creating suites
procedure ProjectRegisterTest(const ProjectName: string;
                              const ATest: ITestCase); overload;
procedure ProjectRegisterTest(const ProjectName: string;
                              const SuiteTitle: string;
                              const ATest: ITestCase); overload;
procedure ProjectRegisterTests(const ProjectName: string;
                               const Tests: array of ITestCase); overload;
procedure ProjectRegisterTests(const ProjectName: string;
                               const SuiteTitle: string;
                               const Tests: array of ITestCase); overload;
procedure RegisterTest(const ATest: ITestCase); overload;
procedure RegisterTest(const SuiteTitle: string;
                       const ATest: ITestCase); overload;
procedure RegisterTests(const Tests: array of ITestCase); overload;
procedure RegisterTests(const SuiteTitle: string;
                        const Tests: array of ITestCase); overload;
function  RegisteredTests: ITestSuite;
function  RegisterProject(const AProject: ITestProject): Integer; overload;
function  RegisterProject(const AName: string;
                          const AProject: ITestProject): Integer; overload;
procedure UnRegisterProjectManager;
function  CallerAddr: Pointer; {$IFNDEF FPC}assembler;{$ENDIF}

{$BOOLEVAL OFF}

implementation
uses
//  StrUtils,
  TypInfo,
  Math,
  {$IFDEF FPC}
  fpchelper,
  {$ENDIF}
  ProjectsManagerIface,
  ProjectsManager,
  TestListenerIface,
  TimeManager;

{$STACKFRAMES ON} // Required to retrieve caller's address

{ This lets us use a single include file for both the Interface and
  Implementation sections. }
{$undef read_interface}
{$define read_implementation}


const
  csExcluded = 'Excluded_';

var  // This holds the singleton ProjectManager
  ProjectManager: IProjectManager = nil;

type

{$M+}
  TTestExecControl = class(TInterfacedObject, ITestExecControl)
  private
    FTestSetUpData: ITestSetUpData;
    FHaltTesting: boolean;
    FBreakOnFailures: Boolean;
    FTestCanRun: boolean;
    FStatusUpdater: TExecStatusUpdater;
    FStatusMsgUpdater: TStatusMsgUpdater;
    FIndividuallyEnabledTest: TIsTestSelected;
    FEnabledCount: Cardinal;
    FExecutionCount: Cardinal;
    FFailsOnNoChecksExecuted: boolean;
    FErrorCount: Integer;
    FFailureCount: Integer;
    FWarningCount: Integer;
    FExcludedCount: Integer;
    FCurrentTest: ITest;
    FCheckCalledCount: Integer;
    FInhibitStackTrace: boolean;
    FInhibitSummaryLevelChecks: Boolean;
    FFailsOnMemoryLeak: boolean;
    FIgnoresMemoryLeakInSetUpTearDown: boolean;
    function  get_TestSetUpData: ITestSetUpData;
    procedure set_TestSetUpData(const Value: ITestSetUpData);
    function  get_HaltExecution: boolean;
    procedure set_HaltExecution(const Value: boolean);
    function  get_BreakOnFailures: boolean;
    procedure set_BreakOnFailures(const Value: boolean);
    procedure ClearCounts;
    function  get_TestCanRun: boolean;
    procedure set_TestCanRun(const Value: boolean);
    function  get_CurrentTest: ITest;
    procedure set_CurrentTest(const Value: ITest);
    function  get_ExecStatusUpdater: TExecStatusUpdater;
    procedure set_ExecStatusUpdater(const Value: TExecStatusUpdater);
    function  get_StatusMsgUpdater: TStatusMsgUpdater;
    procedure set_StatusMsgUpdater(const Value: TStatusMsgUpdater);
    function  get_EnabledCount: Cardinal;
    procedure set_EnabledCount(const Value: Cardinal);
    function  get_ExecutionCount: Cardinal;
    procedure set_ExecutionCount(const Value: Cardinal);
    function  get_FailsOnNoChecksExecuted: boolean;
    procedure set_FailsOnNoChecksExecuted(const Value: boolean);
    function  get_FailureCount: Integer;
    procedure set_FailureCount(const Value: Integer);
    function  get_ErrorCount: Integer;
    procedure set_ErrorCount(const Value: Integer);
    function  get_WarningCount: Integer;
    procedure set_WarningCount(const Value: Integer);
    function  get_ExcludedCount: Integer;
    procedure set_ExcludedCount(const Value: Integer);
    function  get_CheckCalledCount: Integer;
    procedure set_CheckCalledCount(const Value: Integer);
    function  get_IndividuallyEnabledTest: TIsTestSelected;
    procedure set_IndividuallyEnabledTest(const Value: TIsTestSelected);
    procedure IssueStatusMsg(const ATest: ITestMethod; const StatusMsg: string);
    function  get_InhibitStackTrace: boolean;
    procedure set_InhibitStackTrace(const Value: boolean);
    function  get_InhibitSummaryLevelChecks: boolean;
    procedure set_InhibitSummaryLevelChecks(const Value: boolean);
    function  get_FailsOnMemoryLeak: boolean;
    procedure set_FailsOnMemoryLeak(const Value: boolean);
    function  get_IgnoresMemoryLeakInSetUpTearDown: boolean;
    procedure set_IgnoresMemoryLeakInSetUpTearDown(const Value: boolean);
  public
    constructor Create; overload;
    constructor Create(const MExecStatusCallback: TExecStatusUpdater;
                       const MStatusMsgUpdater: TStatusMsgUpdater;
                       const MTestCanRun: TIsTestSelected); overload;
    destructor Destroy; override;
  end;
  {$M-}

  {$M+}
  TProgressSummary = class(TInterfacedObject, IProgressSummary)
  private
    FErrors: Integer;
    FFailures: Integer;
    FWarnings: Integer;
    FTestsExecuted: Cardinal;
    FTestsExcluded: Integer;
    FUpdated: Boolean;
  protected
    function  get_Errors: Integer;
    function  get_Failures: Integer;
    function  get_Warnings: Integer;
    function  get_TestsExecuted: Cardinal;
    function  get_TestsExcluded: Integer;
    function  Updated: boolean;
    procedure UpdateSummary(const ExecControl: ITestExecControl);
  public
    constructor Create(const ExecControl: ITestExecControl);
  end;
{$M-}

function TestExecControl: ITestExecControl;
begin
  Result := TTestExecControl.Create;
end;

function  RegisteredTests: ITestSuite;
begin
  Result := TestProject;
end;

function  RegisterProject(const AProject: ITestProject): Integer;
begin
  Result := -1;
  if not Assigned(AProject) then
    Exit;

  if not Assigned(ProjectManager) then
    ProjectManager := TProjectManager.Create;
  Result := ProjectManager.AddProject(AProject);
end;

function  RegisterProject(const AName: string;
                          const AProject: ITestProject): Integer; overload;
begin
  if AName <> '' then
    AProject.DisplayedName := AName;

  Result := RegisterProject(AProject);
end;

procedure UnRegisterProjectManager;
begin
  if Assigned(ProjectManager) then
    ProjectManager.ReleaseProjects;
  ProjectManager := nil;
end;

const
  sExpectedButWasFmt = 'Expected:'+LineEnding+'  "%s"'+LineEnding+'But was:'+LineEnding+'  "%s"';
  sExpectedButWasAndMessageFmt = '      "%s"'+LineEnding + sExpectedButWasFmt;
  sActualEqualsExpFmt = 'Expected '+LineEnding+'< %s > '+LineEnding+'equals actual '+LineEnding+'< %s >';
  sMsgActualEqualsExpFmt = '%s'+LineEnding+sActualEqualsExpFmt;

type
  EStopTestsFailure = class(ETestFailure);
  EPostTestFailure  = class(ETestFailure);
  EPostTestWarning  = class(ETestFailure);
  ETestFailOverride = class(ETestFailure);
  ECheckExit        = class(ETestFailure);
  EBreakingTestFailure = class(EDUnitException);

  TMemoryLeakMonitor = class(TInterfacedObject, IMemLeakMonitor)
  private
    {$IFDEF FASTMM}
      FMS1: TMemoryManagerState;
      FMS2: TMemoryManagerState;
    {$ENDIF}
  protected
    function MemLeakDetected(out LeakSize: Integer): boolean;
  public
    constructor Create;
  end;

  {$M+}
  TDUnitMemLeakMonitor = class(TMemoryLeakMonitor, IDUnitMemLeakMonitor)
  public
    procedure MarkMemInUse;
    function MemLeakDetected(const AllowedLeakSize: Integer;
                             const FailOnMemoryRecovery: boolean;
                             out   LeakSize: Integer): boolean; overload;
    function MemLeakDetected(const AllowedValuesGetter: TListIterator;
                             const FailOnMemoryRecovery: boolean;
                             out   LeakIndex: Integer;
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
  end;

  TBaseMemUseComparator = class(TInterfacedObject, IMemUseComparator)
  private
    FTestOwner: ITestCase;
    FExecCtrl: ITestExecControl;
  protected
    procedure RunSetup(const UsersSetUp: TThreadMethod); virtual;
    procedure RunTearDown(const UsersTearDown: TThreadMethod); virtual;
    function  AlertOnMemoryLoss(const CurrentStatus: TExecutionStatus): TExecutionStatus; virtual;
  public
    constructor Create(const ATestOwner: ITestCase;
                       const AExecControl: ITestExecControl); virtual;
  end;

  TMemUseComparator = class(TBaseMemUseComparator)
  private
    FTest: ITest;
    FEntryWarnCount: Integer;
    FTestCaseMemLeakMonitor : IDUnitMemLeakMonitor;
    FTestMemLeakMonitor     : IDUnitMemLeakMonitor;
    FTestCaseMemDiff : Integer;
    FTestProcMemDiff : Integer;
    FSetUpMemDiff    : Integer;
    FTearDownMemDiff : Integer;
  {$IFDEF FASTMM}
    function BumpWarningCount(const ALeakSize: Integer): TExecutionStatus;
  {$ENDIF}
  protected
    procedure BeginTestMethod;
    procedure RunSetup(const UsersSetUp: TThreadMethod); override;
    procedure RunTearDown(const UsersTearDown: TThreadMethod); override;
    function  AlertOnMemoryLoss(const CurrentStatus: TExecutionStatus): TExecutionStatus; override;
  public
    constructor Create(const ATestOwner: ITestCase;
                       const AExecControl: ITestExecControl); override;
  end;

{ TMethodEnumerator }

type
  TMethodEnumerator = class
  private
    FMethodNameList: array of string;
  protected
    function GetNameOfMethod(idx: Integer):  string;
    function GetMethodCount: Integer;
  public
    constructor Create(AClass: TClass);
    property MethodCount: Integer read GetMethodCount;
    property NameOfMethod[idx:  Integer]: string read GetNameOfMethod;
  end;
{$M-}

  { TMemLeakMonitor }

constructor TMemoryLeakMonitor.Create;
begin
  inherited;
  {$IFDEF FASTMM}
  GetMemoryManagerState(FMS1);
  {$ENDIF}
end;

{$IFNDEF FASTMM}
function TMemoryLeakMonitor.MemLeakDetected(out LeakSize: Integer): Boolean;
begin
  LeakSize := 0;
  Result := False;
end;
{$ELSE}

function  MemLeakMonitor: IDUnitMemLeakMonitor;
begin
  Result := TDUnitMemLeakMonitor.Create
end;

function TMemoryLeakMonitor.MemLeakDetected(out LeakSize: Integer): boolean;
var
  i: Integer;
  LSMBSize1,
  LSMBSize2: Int64;

begin
  LeakSize := 0;
  LSMBSize1 := 0;
  LSMBSize2 := 0;
  GetMemoryManagerState(FMS2);

  for i := 0 to NumSmallBlockTypes - 1 do // Iterate through the blocks
  begin
    Inc(LSMBSize1, (FMS1.SmallBlockTypeStates[i].InternalBlockSize *
                    FMS1.SmallBlockTypeStates[i].AllocatedBlockCount));
    Inc(LSMBSize2, (FMS2.SmallBlockTypeStates[i].InternalBlockSize *
                    FMS2.SmallBlockTypeStates[i].AllocatedBlockCount));
  end;

  LeakSize := (LSMBSize2 - LSMBSize1);

  LeakSize := LeakSize +
    (Int64(FMS2.TotalAllocatedMediumBlockSize) - Int64(FMS1.TotalAllocatedMediumBlockSize)) +
    (Int64(FMS2.TotalAllocatedLargeBlockSize) - Int64(FMS1.TotalAllocatedLargeBlockSize));

  Result := LeakSize <> 0;
end;
{$ENDIF}

// May be called after detecting memory use change at Test Procedure level
function TDUnitMemLeakMonitor.GetMemoryUseMsg(const FailOnMemoryRecovery: boolean;
                                              const TestProcChangedMem: Integer;
                                              out   ErrorMsg: string): boolean;
begin
  ErrorMsg := '';

  if (TestProcChangedMem > 0) then
    ErrorMsg := IntToStr(TestProcChangedMem) +
      ' Bytes Memory Leak in Test Procedure'
  else
  if (TestProcChangedMem  < 0) and (FailOnMemoryRecovery) then
    ErrorMsg := IntToStr(Abs(TestProcChangedMem)) +
     ' Bytes Memory Recovered in Test Procedure';

  Result := (Length(ErrorMsg) = 0);
end;

function TDUnitMemLeakMonitor.MemLeakDetected(const AllowedLeakSize: Integer;
                                              const FailOnMemoryRecovery: boolean;
                                              out   LeakSize: Integer): boolean;
begin
  LeakSize := 0;
  inherited MemLeakDetected(LeakSize);
  Result := ((LeakSize > 0) and (LeakSize <> AllowedLeakSize)) or
    ((LeakSize < 0) and (FailOnMemoryRecovery) and (LeakSize <> AllowedLeakSize));
end;

procedure TDUnitMemLeakMonitor.MarkMemInUse;
begin
  {$IFDEF FASTMM}
    GetMemoryManagerState(FMS1);
  {$ENDIF}
end;

function TDUnitMemLeakMonitor.MemLeakDetected(const AllowedValuesGetter: TListIterator;
                                              const FailOnMemoryRecovery: boolean;
                                              out   LeakIndex: Integer;
                                              out   LeakSize: Integer): boolean;
var
  AllowedLeakSize: Integer;
begin
  LeakIndex := 0;
  LeakSize  := 0;
  Result := False;
  inherited MemLeakDetected(LeakSize);
  if (LeakSize = 0) then
    exit;

  // Next line access value stored via SetAllowedLeakSize, if any
  if LeakSize = AllowedValuesGetter then
    Exit;

  repeat // loop over values stored via SetAllowedLeakArray
    inc(LeakIndex);
    AllowedLeakSize := AllowedValuesGetter;
    if (LeakSize = AllowedLeakSize) then
      Exit;
  until (AllowedLeakSize = 0);
  Result := (LeakSize > 0) or ((LeakSize < 0) and FailOnMemoryRecovery);
end;

// Expanded message generation for detected leak isolation
// Use additional knowledge of when Setup and or TearDown have nor run.

function TDUnitMemLeakMonitor.GetMemoryUseMsg(const FailOnMemoryRecovery: boolean;
                                              const TestSetupChangedMem: Integer;
                                              const TestProcChangedMem: Integer;
                                              const TestTearDownChangedMem: Integer;
                                              const TestCaseChangedMem: Integer;
                                              out   ErrorMsg: string): boolean;
var
  Location: string;
begin
  Result := False;
  ErrorMsg := '';

  if (TestSetupChangedMem = 0) and (TestProcChangedMem = 0) and
     (TestTearDownChangedMem = 0) and (TestCaseChangedMem <> 0) then
  begin
    ErrorMsg :=
      'Error in TestFrameWork. No leaks in Setup, TestProc or Teardown but '+
      IntToStr(TestCaseChangedMem) +
      ' Bytes Memory Leak reported across TestCase';
    Exit;
  end;

  if (TestSetupChangedMem + TestProcChangedMem + TestTearDownChangedMem) <>
    TestCaseChangedMem then
  begin
    ErrorMsg :=
      'Error in TestFrameWork. Sum of Setup, TestProc and Teardown leaks <> '+
      IntToStr(TestCaseChangedMem) +
      ' Bytes Memory Leak reported across TestCase';
    Exit;
  end;

  Result := True;
  if TestCaseChangedMem = 0 then
    Exit;  // Dont waste further time here

  if (TestCaseChangedMem < 0) and not FailOnMemoryRecovery then
    Exit;     // Dont waste further time here


// We get to here because there is a memory use imbalance to report.
  if (TestCaseChangedMem > 0) then
    ErrorMsg := IntToStr(TestCaseChangedMem) + ' Bytes memory leak  ('
  else
    ErrorMsg := IntToStr(TestCaseChangedMem) + ' Bytes memory recovered  (';

  Location := '';

  if (TestSetupChangedMem <> 0) then
    Location := 'Setup= ' + IntToStr(TestSetupChangedMem) + '  ';
  if (TestProcChangedMem <> 0) then
    Location := Location + 'TestProc= ' + IntToStr(TestProcChangedMem) + '  ';
  if (TestTearDownChangedMem <> 0) then
    Location := Location + 'TearDown= ' + IntToStr(TestTearDownChangedMem) + '  ';

  ErrorMsg := ErrorMsg + Location + ')';
  Result := (Length(ErrorMsg) = 0);
end;

{ TBaseMemUseComparator }

constructor TBaseMemUseComparator.Create(const ATestOwner: ITestCase;
                                         const AExecControl: ITestExecControl);
begin
  inherited Create;
  FTestOwner := ATestOwner;
  FExecCtrl := AExecControl;
end;

procedure TBaseMemUseComparator.RunSetup(const UsersSetUp: TThreadMethod);
begin
  UsersSetUp;
end;

procedure TBaseMemUseComparator.RunTearDown(const UsersTearDown: TThreadMethod);
begin
  UsersTearDown;
end;

function TBaseMemUseComparator.AlertOnMemoryLoss(const CurrentStatus: TExecutionStatus): TExecutionStatus;
begin
  Result := CurrentStatus;
end;

{ TMemUseComparitor }

constructor TMemUseComparator.Create(const ATestOwner: ITestCase;
                                     const AExecControl: ITestExecControl);
begin
  inherited Create(ATestOwner, AExecControl);
  FTestMemLeakMonitor := TDUnitMemLeakMonitor.Create;
  FTestCaseMemLeakMonitor := TDUnitMemLeakMonitor.Create;
end;

{$IFDEF FASTMM}
function TMemUseComparator.BumpWarningCount(const ALeakSize: Integer): TExecutionStatus;
begin
  Result := _Warning;
  if FEntryWarnCount = FExecCtrl.WarningCount then // we can bump count
  begin
    FExecCtrl.WarningCount := FExecCtrl.WarningCount + 1;
    case ALeakSize of
      -1: begin
            if FTest.ErrorMessage = '' then
              FTest.ErrorMessage := 'Allowed leak size of ' + IntToStr(FTestCaseMemDiff) + ' Bytes';
            FTest.ExceptionClass := ExceptClass(ETestFailOverride);
          end;
       0: begin
            if FTest.ErrorMessage = '' then
              FTest.ErrorMessage := 'Leak Allowed in SetUp/Teardown. Size = ' + IntToStr(FTestCaseMemDiff) + ' Bytes';
            FTest.ExceptionClass := ExceptClass(ETestFailOverride);
          end;
      else
      begin
       if FTest.ErrorMessage = '' then
         FTest.ErrorMessage := 'Possible memory leak of ' + IntToStr(FTestCaseMemDiff) + ' Bytes';
       FTest.ExceptionClass := ExceptClass(EPostTestWarning);
      end;
    end;  {case}
  end;
end;
{$ENDIF}

procedure TMemUseComparator.BeginTestMethod;
begin
  FTest := FTestOwner.CurrentTest;
  FEntryWarnCount := FExecCtrl.WarningCount;
  {$IFDEF FASTMM}
    FTestOwner.AllowedMemoryLeakSize := 0;
    FTestOwner.SetAllowedLeakArray([]);
    //Set run-time options in owning TTestcase prior to executing user's SetUp proc.
    FTestOwner.FailsOnMemoryLeak := FExecCtrl.FailsOnMemoryLeak;
    FTestOwner.IgnoresMemoryLeakInSetUpTearDown := FExecCtrl.IgnoresMemoryLeakInSetUpTearDown;
  {$ENDIF}
end;

procedure TMemUseComparator.RunSetup(const UsersSetUp: TThreadMethod);
begin
  BeginTestMethod;
  FTestCaseMemLeakMonitor.MarkMemInUse;
  FTestMemLeakMonitor.MarkMemInUse;
  UsersSetUp;
  (FTestMemLeakMonitor as IMemLeakMonitor).MemLeakDetected(FSetUpMemDiff);
  FTestMemLeakMonitor.MarkMemInUse;
end;

procedure TMemUseComparator.RunTearDown(const UsersTearDown: TThreadMethod);
begin
  (FTestMemLeakMonitor as IMemLeakMonitor).MemLeakDetected(FTestProcMemDiff);
  FTestMemLeakMonitor.MarkMemInUse;
  UsersTearDown;
 (FTestMemLeakMonitor as IMemLeakMonitor).MemLeakDetected(FTearDownMemDiff);
 (FTestCaseMemLeakMonitor as IMemLeakMonitor).MemLeakDetected(FTestCaseMemDiff);

  // Test ran in context of owning TTestcase so copy any changed settings into TestMethod instance
  {$IFDEF FASTMM}
    FTest.FailsOnMemoryLeak := FTestOwner.FailsOnMemoryLeak;
    FTest.IgnoresMemoryLeakInSetUpTearDown := FTestOwner.IgnoresMemoryLeakInSetUpTearDown;
  {$ENDIF}
end;

function TMemUseComparator.AlertOnMemoryLoss(const CurrentStatus: TExecutionStatus): TExecutionStatus;
{$IFDEF FASTMM}
var
  LMemoryLeakIgnoredInSetupOrTearDown: Boolean;
  LMemoryImbalance : boolean;
  LLeakIndex       : Integer;
  LMemErrorMessage : string;
  LExcept: Exception;
{$ENDIF}
begin
  Result := CurrentStatus;
  {$IFDEF FASTMM}
    if not (Result = _Passed) then
      Exit;

    LExcept := nil;
    LMemoryImbalance :=
      FTestCaseMemLeakMonitor.MemLeakDetected(FTestOwner.AllowedLeaksIterator,
                                              False {was FailsOnMemoryRecovery},
                                              LLeakIndex,
                                              FTestCaseMemDiff);

    LMemoryLeakIgnoredInSetupOrTearDown :=
      (FExecCtrl.IgnoresMemoryLeakInSetUpTearDown or
       FTestOwner.IgnoresMemoryLeakInSetUpTearDown) and
      (FTestProcMemDiff = 0) and LMemoryImbalance;

    if (FTestCaseMemDiff > 0) { or (FailsOnMemoryRecovery and (LTestCaseMemDiff < 0)) } then
    begin
      // A leak has been detected so see if it matches an allowed leak size,
      FTest.LeakAllowed := not LMemoryImbalance;
      if FTest.LeakAllowed then
      begin
        // The leak matched an allowed size so save it and let the test pass
        FTest.AllowedMemoryLeakSize := FTestCaseMemDiff;
        Result := BumpWarningCount(-1);
      end
      else
      begin
        if not FTestOwner.FailsOnMemoryLeak or LMemoryLeakIgnoredInSetupOrTearDown then
          Result := BumpWarningCount(0)
        else
        begin // Construct possible leak location message
           FTestCaseMemLeakMonitor.GetMemoryUseMsg(False, //was FailsOnMemoryRecovery (now depricated)
                                                  FSetUpMemDiff,
                                                  FTestProcMemDiff,
                                                  FTearDownMemDiff,
                                                  FTestCaseMemDiff,
                                                  LMemErrorMessage);
          try
            LExcept := EPostTestFailure.Create(LMemErrorMessage);
            Result := FTestOwner.UpdateOnFail(FTest, _Failed, LExcept, IntPtr(FTest.ErrorAddress));
          finally
            FreeAndNil(LExcept);
          end
        end;
      end;
    end
    else
    if (FTestCaseMemDiff > 0) then
    begin
      if not LMemoryImbalance then
        Result := BumpWarningCount(-1)
      else
        Result := BumpWarningCount(FTestCaseMemDiff);
    end;
  {$ENDIF}
end;

{ ETestFailure }

constructor ETestFailure.Create;
begin
  inherited Create('')
end;

constructor ETestFailure.Create(const ErrorMsg: string);
begin
  inherited Create(ErrorMsg)
end;

constructor TMethodEnumerator.Create(AClass: TClass);
{$IFDEF FPC}
var
  ml: TStringList;
  i: integer;
  LName: string;
begin
  inherited Create;
  ml := TStringList.Create;
  try
    GetMethodList(AClass, ml);
    if ml.Count > 0 then
      SetLength(FMethodNameList, ml.Count);
    for i := 0 to ml.Count-1 do
      FMethodNameList[i] := ml[i];
  finally
    ml.Free;
  end;
{$ELSE}
{ TODO -cRefactoring : Move this out into a DelphiHelper unit. }
type
  TMethodTable = packed record
    Count: SmallInt;
  end;

var
  table: ^TMethodTable;
  AName:  ^ShortString;
  i, J:  Integer;
  LClass: TClass;
begin
  inherited Create;
  table := nil;
  LClass := AClass;
  while LClass <> nil do
  begin
    asm
      mov  EAX, [LClass]
      mov  EAX,[EAX].vmtMethodTable { fetch pointer to method table }
      mov  [table], EAX
    end;
    if table <> nil then
    begin
      AName  := Pointer(PAnsiChar(table) + 8);
      for i := 1 to table.count do
      begin
        // check if we've seen the method name
        J := Low(FMethodNameList);
        while (J <= High(FMethodNameList)) and (string(AName^) <> FMethodNameList[J]) do
          inc(J);
        // if we've seen the name, then the method has probably been overridden
        if J > High(FMethodNameList) then
        begin
          SetLength(FMethodNameList,length(FMethodNameList)+1);
          FMethodNameList[J] := string(AName^);
        end;
        AName := Pointer(PAnsiChar(AName) + length(AName^) + 7)
      end;
    end;
    LClass := LClass.ClassParent;
  end;
{$ENDIF}
end;

function TMethodEnumerator.GetMethodCount: Integer;
begin
  Result := Length(FMethodNameList);
end;

function TMethodEnumerator.GetNameOFMethod(idx: Integer): string;
begin
  Result := FMethodNameList[idx];
end;


{ TTestReadOnlyIterator }

constructor TReadOnlyIterator.Create;
begin
  inherited Create;
  idx := 0;
  FIList := TInterfaceList.Create;
end;

function TReadOnlyIterator.CurrentTest: ITest;
begin
  Result := FCurrentTest;
end;

destructor TReadOnlyIterator.Destroy;
begin
  FIList := nil; // So we can see the destructors run
  inherited;
end;

function TReadOnlyIterator.Count: Integer;
begin
  Result := FIList.Count;
end;

function TReadOnlyIterator.FindFirstTest: ITest;
begin
  idx := 0;
  if Count > 0  then
    Result := (FIList[idx] as ITest)
  else
    Result := nil;
  FCurrentTest := Result;
end;

function TReadOnlyIterator.FindNextTest: ITest;
begin
  Result := nil;
  if idx < Count  then
  begin
    Result := (FIList.Items[idx] as ITest);
    inc(idx); // idx will eventually = count
  end;
  FCurrentTest := Result;
end;

function TReadOnlyIterator.PriorTest: ITest;
begin
  Result := nil;
  if idx > 0 then
  begin
    Dec(idx);
    Result := (FIList.Items[idx] as ITest);
  end;
  FCurrentTest := Result;
end;

procedure TReadOnlyIterator.Reset;
begin
  idx := 0;
  FCurrentTest := nil;
end;

function TReadOnlyIterator.FindNextEnabledProc: ITest;
begin
  repeat
    Result := FindNextTest;
  until (Result = nil) or Result.Enabled;
end;

{ TTestIterator }

procedure TTestIterator.AddTest(const ATest: ITest);
begin
  if (ATest <> nil) then
    FIList.Add(ATest);
end;

{ TTestExectionControl }

constructor TTestExecControl.Create;
begin
  inherited;
  FTestCanRun := True; //True by default
end;

constructor TTestExecControl.Create(const MExecStatusCallback: TExecStatusUpdater;
                                    const MStatusMsgUpdater: TStatusMsgUpdater;
                                    const MTestCanRun: TIsTestSelected);
begin
  Create;
  FStatusUpdater := MExecStatusCallback;
  FStatusMsgUpdater := MStatusMsgUpdater;
  FIndividuallyEnabledTest := MTestCanRun;
end;

destructor TTestExecControl.Destroy;
begin
  FTestCanRun := False;
  FStatusUpdater := nil;
  inherited;
end;

procedure TTestExecControl.ClearCounts;
begin
  FEnabledCount := 0;
  FExecutionCount := 0;
  FErrorCount := 0;
  FFailureCount := 0;
  FWarningCount := 0;
  FCheckCalledCount := 0;
end;

function TTestExecControl.get_BreakOnFailures: boolean;
begin
  Result := FBreakOnFailures;
end;

procedure TTestExecControl.set_BreakOnFailures(const Value: boolean);
begin
  FBreakOnFailures := Value;
end;

function TTestExecControl.get_CheckCalledCount: Integer;
begin
  Result := FCheckCalledCount;
end;

procedure TTestExecControl.set_CheckCalledCount(const Value: Integer);
begin
  if Value = 0 then
    FCheckCalledCount := 0
  else
    Inc(FCheckCalledCount);
end;

function TTestExecControl.get_CurrentTest: ITest;
begin
  Result := FCurrentTest;
end;

procedure TTestExecControl.set_CurrentTest(const Value: ITest);
begin
  FCurrentTest := Value;
end;

function TTestExecControl.get_EnabledCount: Cardinal;
begin
  Result := FEnabledCount;
end;

procedure TTestExecControl.set_EnabledCount(const Value: Cardinal);
begin
  FEnabledCount := Value;
end;

function TTestExecControl.get_ErrorCount: Integer;
begin
  Result := FErrorCount;
end;

procedure TTestExecControl.set_ErrorCount(const Value: Integer);
begin
  FErrorCount := Value;
end;

function TTestExecControl.get_ExecutionCount: Cardinal;
begin
  Result := FExecutionCount;
end;

procedure TTestExecControl.set_ExecutionCount(const Value: Cardinal);
begin
  FExecutionCount := Value;
end;

function TTestExecControl.get_FailsOnNoChecksExecuted: boolean;
begin
  Result := FFailsOnNoChecksExecuted;
end;

procedure TTestExecControl.set_FailsOnNoChecksExecuted(const Value: boolean);
begin
  FFailsOnNoChecksExecuted := Value;
end;

function TTestExecControl.get_FailureCount: Integer;
begin
  Result := FFailureCount;
end;

function TTestExecControl.get_HaltExecution: boolean;
begin
  Result := FHaltTesting;
end;

procedure TTestExecControl.set_HaltExecution(const Value: boolean);
begin
  FHaltTesting := Value;
end;

procedure TTestExecControl.set_FailureCount(const Value: Integer);
begin
  FFailureCount := Value;
end;

function TTestExecControl.get_IndividuallyEnabledTest: TIsTestSelected;
begin
  Result := FIndividuallyEnabledTest;
end;

function TTestExecControl.get_InhibitSummaryLevelChecks: boolean;
begin
  Result := FInhibitSummaryLevelChecks;
end;

procedure TTestExecControl.set_InhibitSummaryLevelChecks(const Value: boolean);
begin
  FInhibitSummaryLevelChecks := Value;
end;

function TTestExecControl.get_InhibitStackTrace: boolean;
begin
  Result := FInhibitStackTrace;
end;

procedure TTestExecControl.set_InhibitStackTrace(const Value: boolean);
begin
  FInhibitStackTrace := Value;
end;

procedure TTestExecControl.set_IndividuallyEnabledTest(const Value: TIsTestSelected);
begin
  FIndividuallyEnabledTest := Value;
end;

function TTestExecControl.get_StatusMsgUpdater: TStatusMsgUpdater;
begin
  Result := FStatusMsgUpdater;
end;

procedure TTestExecControl.set_StatusMsgUpdater(const Value: TStatusMsgUpdater);
begin
  FStatusMsgUpdater := Value;
end;

function TTestExecControl.get_ExecStatusUpdater: TExecStatusUpdater;
begin
  Result := FStatusUpdater;
end;

procedure TTestExecControl.set_ExecStatusUpdater(const Value: TExecStatusUpdater);
begin
  FStatusUpdater := Value;
end;

function TTestExecControl.get_TestCanRun: boolean;
begin
  Result := FTestCanRun;
end;

function TTestExecControl.get_TestSetUpData: ITestSetUpData;
begin
  Result := FTestSetUpData;
end;

procedure TTestExecControl.set_TestCanRun(const Value: boolean);
begin
  FTestCanRun := Value;
end;

procedure TTestExecControl.set_TestSetUpData(const Value: ITestSetUpData);
begin
  FTestSetUpData := Value;
end;

function TTestExecControl.get_WarningCount: Integer;
begin
  Result := FWarningCount;
end;

procedure TTestExecControl.set_WarningCount(const Value: Integer);
begin
  FWarningCount := Value;
end;

function TTestExecControl.get_ExcludedCount: Integer;
begin
  Result := FExcludedCount;
end;

procedure TTestExecControl.set_ExcludedCount(const Value: Integer);
begin
  FExcludedCount := Value;
end;

procedure TTestExecControl.IssueStatusMsg(const ATest: ITestMethod;
                                          const StatusMsg: string);
begin
  Assert(False, 'procedure IssueStatusMsg not implenented');
end;

function TTestExecControl.get_FailsOnMemoryLeak: boolean;
begin
  Result := FFailsOnMemoryLeak;
end;

procedure TTestExecControl.set_FailsOnMemoryLeak(const Value: boolean);
begin
  FFailsOnMemoryLeak := Value;
end;

function TTestExecControl.get_IgnoresMemoryLeakInSetUpTearDown: boolean;
begin
  Result := FIgnoresMemoryLeakInSetUpTearDown;
end;

procedure TTestExecControl.set_IgnoresMemoryLeakInSetUpTearDown(const Value: boolean);
begin
  FIgnoresMemoryLeakInSetUpTearDown := Value;
end;

{ TProgressSummary }

constructor TProgressSummary.Create(const ExecControl: ITestExecControl);
begin
  inherited Create;
  if ExecControl = nil then
    Exit;

  FErrors := ExecControl.ErrorCount;
  FFailures := ExecControl.FailureCount;
  FWarnings := ExecControl.WarningCount;
  FTestsExecuted := ExecControl.ExecutionCount;
  FTestsExcluded := ExecControl.ExcludedCount;
end;

function TProgressSummary.get_Errors: Integer;
begin
  Result := FErrors;
end;

function TProgressSummary.get_Failures: Integer;
begin
  Result := FFailures;
end;

function TProgressSummary.get_TestsExcluded: Integer;
begin
  Result := FTestsExcluded;
end;

function TProgressSummary.get_TestsExecuted: Cardinal;
begin
  Result := FTestsExecuted;
end;

function TProgressSummary.get_Warnings: Integer;
begin
  Result := FWarnings;
end;

function TProgressSummary.Updated: boolean;
begin
  Result := FUpdated;
end;

procedure TProgressSummary.UpdateSummary(const ExecControl: ITestExecControl);
begin
  FErrors := ExecControl.ErrorCount - FErrors;
  FFailures := ExecControl.FailureCount - FFailures;
  FWarnings := ExecControl.WarningCount - FWarnings;
  FTestsExecuted := ExecControl.ExecutionCount - FTestsExecuted;
  FTestsExcluded := ExecControl.ExcludedCount - FTestsExcluded;
  FUpdated := True;
end;


{ TTestProc }
var
  CUniqueID: Cardinal = 0;

constructor TTestProc.Create;
begin
  inherited;
  Inc(CUniqueID);
  FUniqueID := CUniqueID;
  FDisplayedName := Self.ClassName;
  FEnabled := True;

  FSupportedIface := _Other;
  if Supports(Self, ITestProject) then
    FSupportedIface := _isTestProject
  else
  if Supports(Self, ITestDecorator) then
    FSupportedIface := _isTestDecorator
  else
  if Supports(Self, ITestSuite) then
    FSupportedIface := _isTestSuite
  else
  if Supports(Self, ITestCase) then
    FSupportedIface := _isTestCase
  else
  if Supports(Self, ITestMethod) then
    FSupportedIface := _isTestMethod
end;

constructor TTestProc.Create(const AName: string);
begin
  Create;
  if AName <> '' then
    FDisplayedName := AName;
end;

constructor TTestProc.Create(const OwnerProc: TTestMethod;
                             const ParentPath: string;
                             const AMethod: TTestMethod;
                             const AMethodName: string);
begin
  Create;
  FMethod := AMethod;
  {$IFNDEF CLR}
    FErrorAddress := PtrType(@FMethod);
    if Assigned(AMethod) then
  {$ENDIF}
    FMethodName := AMethodName;
  FDisplayedName := FMethodName;
  FIsTestMethod := IsValidTestMethod(OwnerProc);
  FParentPath := ParentPath;
end;

function TTestProc.CurrentTest: ITest;
begin
  Result := Self;
end;

destructor TTestProc.Destroy;
begin
  FreeAndNil(FStatusMsgs);
  FDisplayedName := '';
  FMethodName := '';
  FMethod := nil;
  inherited;
end;

{ DUnit compatibility interface }
{$IFDEF fpcunit}
  {$I FPCUnitCompatibleInterface.inc}
{$ENDIF}

function TTestProc.get_Depth: Integer;
begin
  Result := FDepth;
end;

procedure TTestProc.set_Depth(const Value: Integer);
begin
  FDepth := Value;
end;

function TTestProc.get_DisplayedName: string;
begin
  Result := FDisplayedName;
end;

procedure TTestProc.set_DisplayedName(const AName: string);
begin
  FDisplayedName := AName;
end;

// returns TestTime in seconds.millisecs
function TTestProc.ElapsedTestTime: Extended;
var
  LTime: Extended;
begin
  if FStopTime > 0 then
    LTime := FStopTime
  else if FStartTime > 0 then
    LTime := gTimer.Elapsed
  else
    LTime := 0;
  Result := LTime - FStartTime;
end;

function TTestProc.get_Enabled: boolean;
begin
  Result := FEnabled;
end;

procedure TTestProc.set_Enabled(const Value: boolean);
begin
  FEnabled := Value;
end;

function TTestProc.get_Excluded: boolean;
begin
  Result := FExcluded;
end;

procedure TTestProc.set_Excluded(const Value: boolean);
begin
  FExcluded := Value;
end;

function TTestProc.get_ErrorAddress: PtrType;
begin
  Result := FErrorAddress;
end;

function TTestProc.get_ErrorMessage: string;
begin
  Result := FErrorMessage;
end;

procedure TTestProc.set_ErrorMessage(const Value: string);
begin
  FErrorMessage := Value;
end;

procedure TTestProc.InstallExecutionControl(const Value: ITestExecControl);
begin
  FExecControl := Value;
end;

function TTestProc.UniqueID: Cardinal;
begin
  Result := FUniqueID;
end;

function TTestProc.get_ExceptionClass: ExceptClass;
begin
  Result := FExceptionIs;
end;

function TTestProc.get_ExpectedException: ExceptClass;
begin
  Result := FExpectedExcept;
end;

function TTestProc.get_CheckCalled: boolean;
begin
  Result := FCheckCalled;
end;

procedure TTestProc.set_CheckCalled(const Value: boolean);
begin
  FCheckCalled := Value;
end;

function TTestProc.get_InhibitSummaryLevelChecks: boolean;
begin
  Result := FInhibitSummaryLevelChecks;
end;

procedure TTestProc.set_InhibitSummaryLevelChecks(const Value: boolean);
begin
  FInhibitSummaryLevelChecks := Value;
end;

function TTestProc.get_EarlyExit: boolean;
begin
  Result := FEarlyExit;
end;

function TTestProc.get_AllowedMemoryLeakSize: Integer;
// Array[0] reserved for property AllowedLeakSize and remainder for
// values entered by SetAllowedLeakArray
var
  i: Integer;
begin
  Result := FAllowedLeakList[0];
  if (result = 0) then
  begin   // The user may have set the values using SetAllowedLeakArray
    for i := 0 to Length(FAllowedLeakList) - 1 do    // Iterate
    begin
      if FAllowedLeakList[0] <> 0 then
      begin
        result := FAllowedLeakList[i];
        break;
      end;
    end;    // for
  end;
end;

procedure TTestProc.set_AllowedMemoryLeakSize(const NewSize: Integer);
begin
  FAllowedLeakList[0] := NewSize;
end;

function TTestProc.get_FailsOnMemoryLeak: boolean;
begin
  Result := FFailsOnMemoryLeak;
end;

procedure TTestProc.set_FailsOnMemoryLeak(const Value: boolean);
begin
  FFailsOnMemoryLeak := Value;
end;

function TTestProc.GetAllowedLeak: Integer;
begin // Auto Iterator
  if FAllowedLeakListIndex >= Length(FAllowedLeakList) then
    Result := 0
  else
  begin
    Result := FAllowedLeakList[FAllowedLeakListIndex];
    Inc(FAllowedLeakListIndex);
  end;
end;

function TTestProc.get_AllowedLeaksIterator: TListIterator;
begin
  FAllowedLeakListIndex := 0;
  Result := GetAllowedLeak;
end;

function TTestProc.get_IgnoresMemoryLeakInSetUpTearDown: boolean;
begin
  Result := FIgnoresMemoryLeakInSetUpTearDown;
end;

function TTestProc.get_LeakAllowed: boolean;
begin
  Result := FLeakAllowed;
end;

procedure TTestProc.set_IgnoresMemoryLeakInSetUpTearDown(const Value: boolean);
begin
  FIgnoresMemoryLeakInSetUpTearDown := Value;
end;

procedure TTestProc.set_LeakAllowed(const Value: boolean);
begin
  FLeakAllowed := Value;
end;

procedure TTestProc.SetAllowedLeakArray(const AllowedList: array of Integer);
var
  i: Integer;
  LLen: Integer;
begin // Note the 0th element is reserved for old code value.
  LLen := Length(AllowedList);
  if LLen >= Length(FAllowedLeakList) then
    Fail('Too many values in AllowedLeakArray. Limit = ' +
      IntToStr(Length(FAllowedLeakList) - 1));
  
  for i := 1 to Length(FAllowedLeakList) - 1 do
  begin
    if i <= LLen then
      FAllowedLeakList[i] := AllowedList[i-1]
    else
      FAllowedLeakList[i] := 0;
  end;
end;

function TTestProc.get_FailsOnNoChecksExecuted: boolean;
begin
  Result := FFailsOnNoChecksExecuted;
end;

function TTestProc.get_ParentPath: string;
begin
  Result := FParentPath;
end;

function TTestProc.get_ParentTestCase: ITestCase;
begin
  Result := ITestCase(FParent);
end;

procedure TTestProc.set_ParentTestCase(const TestCase: ITestCase);
begin
  FParent := Pointer(TestCase);
end;

procedure TTestProc.set_ParentPath(const AName: string);
begin
  FParentPath := AName;
end;

function TTestProc.get_ProjectID: Integer;
begin
  Result := FProjectID;
end;

procedure TTestProc.set_ProjectID(const ID: Integer);
begin
  FProjectID := ID;
end;

function TTestProc.get_Proxy: IInterface;
begin
  Result := IInterface(FProxy);
end;

procedure TTestProc.set_Proxy(const AProxy: IInterface);
begin
  FProxy := Pointer(AProxy);
end;

function TTestProc.GetName: string;
begin
  Result := FDisplayedName;
end;

function TTestProc.GetStatus: string;
begin
  Result := '';
  if Assigned(FStatusMsgs) then
    Result := FStatusMsgs.Text;
end;

procedure TTestProc.Status(const Value: string);
begin
  if FStatusMsgs = nil then
    FStatusMsgs := TStringList.Create;
  FStatusMsgs.Add(Value);
  if Assigned(FExecControl.StatusMsgUpdater) then
    FExecControl.StatusMsgUpdater(Self, Value);
end;

function TTestProc.get_TestSetUpData: ITestSetUpData;
begin
  Result := FTestSetUpData;
end;

procedure TTestProc.set_ElapsedTime(const Value: Extended);
begin
  FElapsedTime := Value;
end;

procedure TTestProc.SaveConfiguration(const iniFile: TCustomIniFile;
                                      const Section: string);

  procedure DeleteIfEmpty(ASection: string);
  var
    LKeys: TStringList;
  begin
    LKeys := TStringList.Create;
    try
      iniFile.deleteKey(ASection, DisplayedName);
      iniFile.ReadSection(ASection, LKeys);
      if LKeys.Count = 0 then
        iniFile.EraseSection(ASection);
    finally
      FreeAndNil(LKeys);
    end;
  end;
  
begin
  if Section = '' then
    Exit;
  if Enabled then
    DeleteIfEmpty(Section)
  else
    iniFile.writeBool(Section, DisplayedName, False);

  if Excluded then
    iniFile.writeBool(csExcluded + Section, DisplayedName, False)
  else
    DeleteIfEmpty(csExcluded + Section);
end;

procedure TTestProc.LoadConfiguration(const iniFile: TCustomIniFile;
                                      const Section: string);
begin
  self.set_Enabled(iniFile.readBool(Section, self.DisplayedName, True));
  self.set_Excluded(not iniFile.readBool(csExcluded + Section, self.DisplayedName, True));
end;

procedure TTestProc.set_ErrorAddress(const Value: PtrType);
begin
  FErrorAddress := Value;
end;

procedure TTestProc.set_ExceptionClass(const Value: ExceptClass);
begin
  FExceptionIs := Value;
end;

procedure TTestProc.set_FailsOnNoChecksExecuted(const Value: boolean);
begin
  FFailsOnNoChecksExecuted := Value;
end;

procedure TTestCase.Status(const Value: string);
begin
  if Assigned(FExecControl.CurrentTest) then
    FExecControl.CurrentTest.Status(Value);
end;

function TTestCase.GetStatus: string;
begin
  Result := '';
  if Assigned(FExecControl.CurrentTest) then
    Result := FExecControl.CurrentTest.GetStatus;
end;

procedure TTestProc.set_TestSetUpData(const IsTestSetUpData: ITestSetUpData);
begin
  FTestSetUpData := IsTestSetUpData;
end;

{$IFNDEF FPC}
function IsBadPointer(const P: Pointer):boolean; register;
begin
  try
    Result := (P = nil) or
              ((Pointer(P^) <> P) and (Pointer(P^) = P));
  except
    Result := true;
  end
end;

{$WARN SYMBOL_PLATFORM OFF}
function RtlCaptureStackBackTrace(FramesToSkip: ULONG; FramesToCapture: ULONG;
  out BackTrace: Pointer; BackTraceHash: PULONG): USHORT; stdcall;
  external 'kernel32.dll' name 'RtlCaptureStackBackTrace' delayed;
{$WARN SYMBOL_PLATFORM ON}

// 32-bit and 64-bit compatible
// Source: http://stackoverflow.com/questions/12022862/what-does-dunit2s-calleraddr-function-do-and-how-do-i-convert-it-to-64-bits
function CallerAddr: Pointer;
begin
  // Skip 2 Frames, one for the return of CallerAddr and one for the
  // return of RtlCaptureStackBackTrace
  if RtlCaptureStackBackTrace(2, 1, Result, nil) > 0 then
  begin
    if not IsBadPointer(Result) then
      Result := Pointer(NativeInt(Result) - 5)
    else
      Result := nil;
  end
  else
  begin
    Result := nil;
  end;
end;
{$ELSE}
// FPC has a cross-platform implementation for this.
function CallerAddr: Pointer;
var
  bp: Pointer;
begin
  bp := get_caller_frame(get_frame);
  if bp <> nil then
    Result := get_caller_addr(bp)
  else
    Result := nil;
end;

{$ENDIF}

function TTestProc.get_ExecStatus: TExecutionStatus;
begin
  Result := FExecStatus;
end;

procedure TTestProc.set_ExecStatus(const Value: TExecutionStatus);
begin
  if (Ord(Value) > Ord(FExecStatus)) or (Value = _Ready) then
  begin
    FExecStatus := Value;
    if Assigned(FExecControl) and Assigned(FExecControl.ExecStatusUpdater) then
      FExecControl.ExecStatusUpdater(Self);
    if (Value = _Ready) then // We are starting a new exection run
      FreeAndNil(FStatusMsgs);
  end;
end;

procedure TTestProc.StartExpectingException(e: ExceptClass);
begin
  StopExpectingException;
  FExpectedExcept := e;
end;

procedure TTestProc.StopExpectingException(const ErrorMsg: string);
begin
  if FExpectedExcept <> nil then
  try
    Fail(Format('Expected exception "%s" but there was none. %s',
      [FExpectedExcept.ClassName, ErrorMsg]), CallerAddr);
  finally
    FExpectedExcept := nil;
  end;
end;

function TTestProc.SupportedIfaceType: TSupportedIface;
begin
  Result := FSupportedIface;
end;

function TTestProc.InterfaceSupports(const Value: TSupportedIface): Boolean;
begin
  Result := (Ord(SupportedIfaceType) >= Ord(Value)); 
end;

function TTestProc.IsValidTestMethod(const AProc: TTestMethod): boolean;
begin
  Result := (FMethodName <> '') and
            (TMethod(FMethod).Code <> nil) and
            (TMethod(FMethod).Data = TMethod(AProc).Data);
end;

function TTestProc.MethodsName: string;
begin
  Result := FMethodName;
end;

function TTestProc.MethodCode(const MethodsName: string): TTestMethod;
var
  LMethod: TMethod;
begin
  LMethod.Code := MethodAddress(MethodsName);
  LMethod.Data := self;
  Result := TTestMethod(LMethod);
end;

function TTestProc.get_ElapsedTime: Extended;
begin
  Result := FElapsedTime;
end;

procedure TTestProc.InitializeRunState;
begin
  FEarlyExit      := False;
  FCheckCalled    := False;
  FElapsedTime    := 0;
  FStartTime      := 0;
  FStopTime       := 0;
  FErrorMessage   := '';
  FExceptionIs    := nil;
  FExpectedExcept := nil;
end;

function TTestProc.IsTestMethod: boolean;
begin
  Result := FIsTestMethod;
end;

procedure TTestProc.BeginRun;
begin
  ExecStatus := _Ready;
end;

// The users test method is called from this function.
function  TTestProc.Run(const CurrentTestCase: ITestCase;
                        const AMethodName: string;
                        const ExecControl: ITestExecControl): TExecutionStatus;
var
  LMsg: string;
  {$IFDEF USE_JEDI_JCL}
  LTrackingStack: boolean;
  {$ENDIF}
begin
  InitializeRunState;
  FExecControl := ExecControl;
  ExecStatus := _Running; //Issue _Running state to listeners if not already set
  try
    ExecControl.ExecutionCount := ExecControl.ExecutionCount + 1;
    CheckMethodIsNotEmpty(FMethod);
    {$IFNDEF USE_JEDI_JCL}
    try
    {$ELSE}
      LTrackingStack := JclExceptionTrackingActive;
      try
      {$IFNDEF CLR}
        if (ExecControl.InhibitStackTrace or ExecControl.FailsOnMemoryLeak) then
          JclStopExceptionTracking   //Does nothing if already stopped
        else
          JclStartExceptionTracking;  // Does nothing if already started.
       {$ENDIF}
    {$ENDIF}
      // Clear here so state cannot be contrived by user in Setup
     (CurrentTestCase as ITestCase).CheckCalled := False;
      // Note. Processing in FMethod/RunTest occurs in context of
      // Parent TTestCase, not in context of this ITest instance.
      if IsTestMethod then
      begin
        FStartTime := gTimer.Elapsed;
        FMethod;
      end
      else
      begin
        FStartTime := gTimer.Elapsed;
        RunTest;
      end;
    finally
      FStopTime := gTimer.Elapsed;
      FElapsedTime := ElapsedTestTime;
    end;

    // Arrive here when there are no unhandled exceptions in Method's code.
    // If exception was expected but no exception occurred then fail the testproc.
    FExpectedExcept := CurrentTestCase.ExpectedException;
    StopExpectingException;

    // Get CheckCalled from Parent because method runs in context of TTestCase
    if IsTestMethod then
    begin
      FCheckCalled := CurrentTestCase.CheckCalled;
      ErrorMessage := CurrentTestCase.ErrorMessage;
    end
    else
      CurrentTestCase.CheckCalled := FCheckCalled;
    FailsOnNoChecksExecuted := CurrentTestCase.FailsOnNoChecksExecuted;
    // Pass back the state after the method executed
    Result := CheckMethodCalledCheck(ITestCase(FParent));
    if (Result = _Warning) then
      ExecControl.WarningCount := ExecControl.WarningCount + 1
    else
    if ErrorMessage <> '' then
    begin
      Result := _Failed; // CheckExit failed and passed through
      ExecStatus := Result;
    end;

  except // Handle execution exceptions here
    on e: ECheckExit do
    begin
      FEarlyExit := True;
      Result := _Passed;
    end;

    on e: EStopTestsFailure do
    begin
      ExecStatus := UpdateOnFail(Self, _Stopped, e, PtrType(ExceptAddr));
      Result := ExecStatus;
    end;

    on e: ETestFailure do
    begin
      ExecStatus := UpdateOnFail(Self, _Failed, e, PtrType(ExceptAddr));
      Result := ExecStatus;
    end;

    on e: EBreakingTestFailure do
    begin
      ExecStatus := UpdateOnFail(Self, _Break, e, PtrType(ExceptAddr));
      Result := ExecStatus;
    end;

    on e: Exception do
    begin
      //See if it was an expected exception, in which case the test does not fail
      FExceptionIs := (CurrentTestCase as ITestCase).ExpectedException;
      if E.ClassType.InheritsFrom(FExceptionIs) and
        (FExceptionIs.ClassName = E.ClassName) then
        begin
          Result := _Passed; // Was the expected exception
          FExpectedExcept := nil;
          FExceptionIs := nil;
          LMsg := '';
        end
      else
      begin
        FExceptionIs := ExceptClass(e.ClassType);
        LMsg := e.Message;    // Unexpected exception
        ExecStatus := UpdateOnError(Self, _Error, LMsg, e, PtrType(ExceptAddr));
        Result := ExecStatus;
      end;
    end;
  end;
end;

procedure TTestProc.RunTest;
begin
// Legacy dunit compatibility.
// Methodless TestProcs call this procedure which can invoke Fail();
end;

function TTestProc.UpdateOnError(const ATest: ITest;
                                 const NewStatus: TExecutionStatus;
                                 const ExceptnMsg: string;
                                 const Excpt: Exception;
                                 const Addrs: PtrType): TExecutionStatus;
begin
  ATest.ErrorMessage := ExceptnMsg;
  ATest.ErrorAddress := Addrs;
  ATest.ExceptionClass := ExceptClass(Excpt.ClassType);
  FExecControl.ErrorCount := FExecControl.ErrorCount + 1;
  Result := NewStatus; // This just passes through
end;

function TTestProc.UpdateOnFail(const ATest: ITest;
                                const NewStatus: TExecutionStatus;
                                const Excpt: Exception;
                                const Addrs: PtrType): TExecutionStatus;
begin
  ATest.ErrorMessage := Excpt.Message;
  ATest.ErrorAddress := Addrs;
  ATest.ExceptionClass := ExceptClass(Excpt.ClassType);
  if (NewStatus = _Stopped) or
     (NewStatus = _Failed) or
     (NewStatus = _Break) then
    FExecControl.FailureCount := FExecControl.FailureCount + 1;
  Result := NewStatus; // This just passes through
end;

procedure TTestProc.Warn(const ErrorMsg: string; const ErrorAddress: Pointer);
begin
  if ErrorAddress = nil then
    raise EPostTestFailure.Create(ErrorMsg) at CallerAddr
  else
    raise EPostTestFailure.Create(ErrorMsg) at ErrorAddress;
end;

procedure TTestProc.CheckMethodIsNotEmpty(const AMethod: TTestMethod);
const
  AssemblerRet = $C3;
begin
{$IFNDEF CLR}
  if (not Assigned(AMethod)) then
    Exit;
  if byte(TMethod(AMethod).Code^) = AssemblerRet then
    Fail('Empty test', TMethod(AMethod).Code);
{$ENDIF}
end;

function TTestProc.Count: Integer;
begin
  Result := 1
end;

function TTestProc.CheckMethodCalledCheck(const ATest: ITest): TExecutionStatus;
begin
  Result := _Passed;
  if FCheckCalled then
    Exit;

  if FailsOnNoChecksExecuted then
  begin
    PostFail('No checks executed in TestCase', TMethod(FMethod).Code);
  end
  else
  begin
    ErrorMessage := ATest.ErrorMessage;
    if ErrorMessage = '' then
      ErrorMessage := 'No checks executed in TestCase';
    ExceptionClass := ExceptClass(EPostTestWarning);
  end;

  Result := _Warning;  // Pass back warning to show check not called overridden
end;

procedure TTestCase.EnumerateMethods;
var
  i: Integer;
  LNameOfMethod: string;
  LMethod: TTestMethod;
  LMethodEnumerator:  TMethodEnumerator;
  LTest: ITest;
  LParentStr: string;
begin
  LMethod := nil;
  LMethodEnumerator := TMethodEnumerator.Create(Self.ClassType);
  try
    if LMethodEnumerator.MethodCount > 0 then
    begin
      for i := 0 to LMethodEnumerator.MethodCount-1 do
      begin
        LNameOfMethod := LMethodEnumerator.NameOfMethod[i];
        LMethod := MethodCode(LNameOfMethod);
        Assert(Assigned(LMethod), 'Bad method address');
        LParentStr := '';
        if (FParentPath <> '') then
          LParentStr := FParentPath + '.';
        LTest := TTestProc.Create(EnumerateMethods, LParentStr +
            FDisplayedName, LMethod, LNameOfMethod);
        Assert(LTest.IsTestMethod, 'Invalid test method');
        FTestIterator.AddTest(LTest);
      end;
    end;
  finally
    LMethodEnumerator.free;
  end;
end;

constructor TTestCase.Create;
begin
  inherited Create;
  FTestIterator := TTestIterator.Create;
  EnumerateMethods;
end;

constructor TTestCase.Create(const AProcName: string);
var
  LTest: ITest;
begin
  Create;
  repeat
    LTest := FTestIterator.FindNextTest;
    if Assigned(LTest) then
      LTest.Enabled := (LTest.DisplayedName = AProcName) or (AProcName = '');
  until (LTest = nil);
end;

function TTestCase.CurrentTest: ITest;
begin
  Result := FTestIterator.CurrentTest;
  if result = nil then
    Exit;

  // Recurse into lower levels
  if not Result.IsTestMethod then
    Result := Result.CurrentTest;
  if Result = nil then
    Result := self;
end;

procedure TTestProc.Invoke(AMethod: TExceptTestMethod);
begin
  AMethod;
end;

function TTestCase.Count: Integer;
var
  LTest: ITest;
begin
  Result := 0;
  FTestIterator.Reset;
  repeat
    LTest := FTestIterator.FindNextEnabledProc;
    if (LTest <> nil) then
    begin
      LTest.Depth := Depth + 1;
      if not LTest.Excluded then
        Result := Result + LTest.Count;
    end;
  until (LTest = nil);
end;

// Deprecated, backwards compatibility use only
function TTestCase.CountTestCases: Integer;
begin
  Result := Count;
end;

procedure TTestCase.AddTest(const ATest: ITest);
begin
  if Assigned(ATest) then
  begin
    ATest.Depth := Self.Depth + 1;
    FTestIterator.AddTest(ATest);
    if ParentPath <> '' then
      ATest.ParentPath := ParentPath + '.' + DisplayedName
    else
      ATest.ParentPath :=  DisplayedName;
    // Reset required because setting parentpath screws with the iterator index
    Reset;
  end;
end;

procedure TTestCase.AddSuite(const ATest: ITest);
begin
  AddTest(ATest);
end;

class function TTestCase.Suite: ITestCase;
begin
  Result := Self.Create;
end;

destructor TTestCase.Destroy;
begin
  FTestIterator := nil;
  FMethod := nil;
  inherited;
end;

procedure TTestCase.set_ParentPath(const AName: string);
var
  LTest: ITest;
begin
  if FParentPath <> AName then
  begin
    FParentPath := AName;
  // Now propogate addition to ParentPath to subordinate test methods.
    FTestIterator.Reset;
    LTest := FTestIterator.FindNextTest;
    while Assigned(LTest) do
    begin
      if FParentPath = '' then
        LTest.ParentPath := DisplayedName
      else
        LTest.ParentPath := FParentPath + '.' + DisplayedName;
      LTest := FTestIterator.FindNextTest;
    end;
  end;
end;

function TTestCase.get_ProgressSummary: IInterface;
begin
  Result := FProgressSummary;
end;

procedure TTestCase.set_DisplayedName(const AName: string);
var
  LTest: ITest;
begin
  if FDisplayedName <> AName then
  begin
    FDisplayedName := AName;
    FTestIterator.Reset;
    LTest := FTestIterator.FindNextTest;
    while Assigned(LTest) do
    begin
      if ParentPath = '' then
        LTest.ParentPath := AName
      else
        LTest.ParentPath := FParentPath + '.' + FDisplayedName;
      LTest := FTestIterator.FindNextTest;
    end;
  end;
end;

procedure TTestCase.Reset;
begin
  FTestIterator.Reset;
end;

function TTestCase.PriorTest: ITest;
begin
  Result := FTestIterator.PriorTest;
end;

function TTestProc.PtrToStr(const P: Pointer): string;
begin
  Result := Format('%p', [P])
end;

procedure TTestCase.BeginRun;
var
  LTest: ITest;
begin
  inherited;
  LTest := FTestIterator.FindFirstTest;
  while Assigned(LTest) do
  begin
    if LTest.Enabled then
      LTest.BeginRun;
    LTest := FTestIterator.FindNextTest;
  end;
end;

procedure TTestCase.ReleaseProxys;
var
  LTest: ITest;
begin
  Proxy := nil;
  LTest := FTestIterator.FindFirstTest;
  while Assigned(LTest) do
  begin
    if LTest.IsTestMethod then
      LTest.Proxy := nil
    else
      (LTest as ITestCase).ReleaseProxys;
    LTest := FTestIterator.FindNextTest;
  end;
end;

function TTestCase.get_ReEntering: Boolean;
begin
  Result := FReEntering;
  FReEntering := False;
end;

procedure TTestCase.set_ReEntering(const Value: Boolean);
begin
  FReEntering := Value;
end;

function TTestCase.get_ReportErrorOnce: boolean;
begin
  Result := FReportErrorOnce;
  FReportErrorOnce := False;
end;

procedure TTestCase.InhibitStackTrace(const Value: boolean);
begin
  FExecControl.InhibitStackTrace := Value;
end;

procedure TTestCase.InhibitStackTrace;
begin
  FExecControl.InhibitStackTrace := True;
end;

procedure TTestCase.set_ReportErrorOnce(const Value: boolean);
begin
  FReportErrorOnce := Value;
end;

// Called once before executing all test procedures in class
procedure TTestCase.SetUpOnce;
begin
// Empty but required in case called via inheritance
end;

// Called once before executing each test procedures in class
procedure TTestCase.Setup;
begin
// Empty but required in case called via inheritance
end;

function  TTestCase.Run(const ExecControl: ITestExecControl): TExecutionStatus;
var
  LStartTime: Extended;
  LMemUseComparitor: IMemUseComparator;

  function ExecuteTestMethod(const ATest: ITest): TExecutionStatus;
  var
    LErrors          : Integer;
  begin
    Result := ExecStatus;
    LErrors := ExecControl.ErrorCount;  // Hold count so we only bump it once
    FErrorMessage := '';
    ATest.ParentTestCase := self;

    try
      TestSetUpData := ExecControl.TestSetUpData;
      ATest.ExecStatus := _Running;
      FailsOnNoChecksExecuted := ExecControl.FailsOnNoChecksExecuted;

      try
        LMemUseComparitor.RunSetup(SetUp);
        // Now run the test method
        Result := (ATest as ITestMethod).Run(Self, ATest.MethodsName, ExecControl);
        try
          LMemUseComparitor.RunTearDown(TearDown);
        except
          on E:Exception do
            Result := UpdateOnError(ATest, _Error, 'TearDown failed: ' + E.Message, E, PtrType(ExceptAddr));
        end;
      except
        on E:Exception do
          Result := UpdateOnError(ATest, _Error, 'SetUp failed: ' + E.Message, E, PtrType(ExceptAddr));
      end;
    finally
    if ExecControl.ErrorCount > LErrors then
      ExecControl.ErrorCount := LErrors + 1
    else
      Result := LMemUseComparitor.AlertOnMemoryLoss(Result);
    end;

    ATest.ExecStatus := Result;
    ATest.ErrorMessage := '';
    FExpectedExcept := nil;
    ExecControl.CurrentTest := nil;
    FTestSetUpData := nil;
    ATest.ParentTestCase := nil;
  end;

  function RunAsTestCase(const ATest: ITestCase): TExecutionStatus;
  var
    LExecStatus: TExecutionStatus;
  begin
    FStartTime := gTimer.Elapsed;
    Result := ATest.ExecStatus;

    try
      SetUp;
      ATest.ReEntering := True;
      Result := ATest.Run(ExecControl);  // Run the testcase
      try
        TearDown;
      except
        on E:Exception do
        begin
          (ATest as ITestCase).ReportErrorOnce := True;
          LExecStatus := UpdateOnError(ATest, _Error, 'TearDown failed: ' +
              E.Message, E, PtrType(ExceptAddr));
          Result := TExecutionStatus(Max(ord(LExecStatus), Ord(Result)));
        end;
      end;
    except
      on E:Exception do
      begin
        ATest.ExecStatus := _Running;
        (ATest as ITestCase).ReportErrorOnce := True;
        LExecStatus := UpdateOnError(ATest, _Error, 'SetUp failed: ' +
            E.Message, E, PtrType(ExceptAddr));
        Result := TExecutionStatus(Max(ord(LExecStatus), Ord(Result)));
      end;
    end;

    FStopTime := gTimer.Elapsed;
    ATest.ElapsedTime := ElapsedTestTime;
    ATest.ExecStatus := Result;
  end;

var
  LLExecStatus: TExecutionStatus;
  LTest: ITest;
begin  {TTestCase.Run(const ExecControl: ITestExecControl): TExecutionStatus;}
  FExecControl := ExecControl;
  FTestSetUpData := ExecControl.TestSetUpData;
  FProgressSummary := TProgressSummary.Create(ExecControl);
  {$IFDEF FASTMM}
    LMemUseComparitor := TMemUseComparator.Create(Self, ExecControl);
  {$ELSE}
    LMemUseComparitor := TBaseMemUseComparator.Create(Self, ExecControl);
  {$ENDIF}

  LStartTime := gTimer.Elapsed;
  FTestIterator.Reset;
  InitializeRunState;
  if not ReEntering then
    FExecStatus := _Ready; // Pre-set status
  ExecStatus := _Running;  // Notify listeners
  Result := ExecStatus;
  LLExecStatus := ExecStatus; // Holds status until it needs to be propogated
  try
    SetUpOnce;
    repeat
      if (not ExecControl.TestCanRun or ExecControl.HaltExecution) then
        Result := TExecutionStatus(Max(ord(_HaltTest), Ord(Result)))
      else
      begin
        LTest := FTestIterator.FindNextEnabledProc;
        ExecControl.CurrentTest := LTest;
        if (LTest <> nil) then
        begin
          if LTest.Excluded then
            ExecControl.ExcludedCount := ExecControl.ExcludedCount + 1;
          if (not Assigned(ExecControl.IndividuallyEnabledTest) or
             ExecControl.IndividuallyEnabledTest(LTest)) then
          begin
            LTest.InstallExecutionControl(ExecControl);
            if LTest.SupportedIfaceType = _isTestMethod then
              LLExecStatus := ExecuteTestMethod(LTest)
            else
              LLExecStatus := RunAsTestCase(LTest as ITestCase);
          end;
          Result := TExecutionStatus(Max(ord(LLExecStatus), Ord(Result)));
        end;
      end;
    until ((LTest = nil) or
           (ExecControl.BreakOnFailures and ((Result = _Error) or (Result = _Failed)) or
           (Result = _HaltTest) or
           (Result = _Stopped) or
           (Result = _Break) or
            ExecControl.HaltExecution));

    try
      TearDownOnce;
    except // Catch exception in TearDownOnce and report
      on E:Exception do
      begin
        FReportErrorOnce := True;
        LLExecStatus := UpdateOnError(Self, _Error, 'TearDownOnce failed: '+
            E.Message, E, PtrType(ExceptAddr));
        Result := TExecutionStatus(Max(ord(LLExecStatus), Ord(Result)));
      end;
    end;

  except // Catch exception in SetUpOnce and report
    on E:Exception do
    begin
      ReportErrorOnce := True;
      LLExecStatus := UpdateOnError(Self, _Error, 'SetUpOnce failed: ' +
          E.Message, E, PtrType(ExceptAddr));
      Result := TExecutionStatus(Max(ord(LLExecStatus), Ord(Result)));
    end;
  end;

  FStartTime := LStartTime;
  FStopTime := gTimer.Elapsed;
  ElapsedTime := ElapsedTestTime;

  (FProgressSummary as IProgressSummary).UpdateSummary(ExecControl);
  ExecStatus := Result; // Report status to listeners

  // Let the world know we are finished with these
  LMemUseComparitor := nil;
  FTestSetUpData := nil;
  FProgressSummary := nil;
end;

// Called after executing each test method in class
procedure TTestCase.TearDown;
begin
// Empty but required in case called via inheritance
end;

// Called once after executing all tests procedures in class.
procedure TTestCase.TearDownOnce;
begin
// Empty but required in case called via inheritance
end;

function ByteAt(P: pointer; const Offset: Integer): byte;
begin
  Result:=pByte(PtrUInt(P)+Offset)^;
end;

function FirstByteDiff(p1, p2: pointer; size: longword; out b1, b2: byte): Integer;
// Returns offset of first byte pair (left to right, incrementing address) that is unequal
// Returns -1 if no difference found, or if size=0
var
  i: Integer;
begin
  Result := -1;
  if size > 0 then
  for i := 0 to size-1 do // Subject to optimisation for sure:
    if ByteAt(p1,i)<>ByteAt(p2,i) then
    begin
      Result := i;
      b1 :=ByteAt(p1,i);
      b2 :=ByteAt(p2,i);
      break;
    end;
end;

function TTestProc.GetMemDiffStr(const expected, actual: pointer; const size: longword;
                                 const ErrorMsg: string): string;
var
  Ldb1, Ldb2: byte;
  LOffset: Integer;
begin
  LOffset := FirstByteDiff(expected, actual, size, Ldb1, Ldb2);
  Result := NotEqualsErrorMessage(IntToHex(Ldb1,2),IntToHex(Ldb2,2), ErrorMsg);
  Result := Result + ' at offset = ' + IntToHex(LOffset,4) + 'h';
end;

function TTestCase.GetName: string;
var
  LTest: ITest;
begin
  Result := FDisplayedName;
  LTest := CurrentTest;
  if not Assigned(LTest) or (LTest.UniqueID = Self.UniqueID) then
    Exit;

  Result := LTest.GetName
end;

function TTestCase.FindNextEnabledProc: ITest;
begin
  Result := FTestIterator.FindNextEnabledProc;
end;

procedure TTestCase.SaveConfiguration(const iniFile: TCustomIniFile;
                                      const Section: string);
var
  LTestSection: string;
  LTest: ITest;
begin
  inherited SaveConfiguration(iniFile, Section);
  FTestIterator.Reset;
  LTestSection := Section + '.' + Self.DisplayedName;
  repeat
   LTest := FTestIterator.FindNextTest;
    if (LTest <> nil) then
      LTest.SaveConfiguration(iniFile, LTestSection);
  until (LTest = nil);
end;

procedure TTestCase.LoadConfiguration(const iniFile: TCustomIniFile;
                                      const Section: string);
var
  LTest: ITest;
  LTestSection: string;
begin
  inherited LoadConfiguration(iniFile, Section);
  FTestIterator.Reset;
  LTestSection := Section + '.' + Self.DisplayedName;
  LTest := FTestIterator.FindNextTest;
  while LTest <> nil do
  begin
    LTest.LoadConfiguration(iniFile, LTestSection);
    LTest := FTestIterator.FindNextTest;
  end;
end;

{---------- helper functions ------------}
function TTestProc.EqualsErrorMessage(const expected, actual: UnicodeString;
                                      const ErrorMsg: string): UnicodeString;
begin
  if (ErrorMsg <> '') then
    Result := Format(sMsgActualEqualsExpFmt, [ErrorMsg + ', ', expected, actual])
  else
    Result := Format(sActualEqualsExpFmt, [expected, actual])
end;

function TTestProc.NotEqualsErrorMessage(const expected, actual: UnicodeString;
                                         const ErrorMsg: string): UnicodeString;
begin
  if (ErrorMsg <> '') then
    Result := Format(sExpectedButWasAndMessageFmt, [ErrorMsg, expected, actual])
  else
    Result := Format(sExpectedButWasFmt, [expected, actual]);
end;

{--------- Fail exception generation ---------}
procedure TTestProc.Fail(const ErrorMsg: string; const ErrorAddress: Pointer);
begin
//  raise ETestFailure.Create(ErrorMsg);
  if ErrorAddress = nil then
    raise ETestFailure.Create(ErrorMsg) at CallerAddr
  else
    raise ETestFailure.Create(ErrorMsg) at ErrorAddress;
end;

procedure TTestProc.PostFail(const ErrorMsg: string; const ErrorAddress: Pointer);
begin
  if ErrorAddress = nil then
    raise EPostTestFailure.Create(ErrorMsg) at CallerAddr
  else
    raise EPostTestFailure.Create(ErrorMsg) at ErrorAddress;
end;

procedure TTestProc.FailEquals(const expected, actual: UnicodeString;
                               const ErrorMsg: string;
                                     ErrorAddrs: Pointer);
begin
  Fail(EqualsErrorMessage(expected, actual, ErrorMsg), ErrorAddrs);
end;

procedure TTestProc.FailNotEquals(const expected, actual: UnicodeString;
                                  const ErrorMsg: string;
                                        ErrorAddrs: Pointer);
begin
  Fail(NotEqualsErrorMessage(expected, actual, ErrorMsg), ErrorAddrs);
end;

procedure TTestProc.FailNotSame(const expected, actual: UnicodeString;
                                const ErrorMsg: string;
                                      ErrorAddrs: Pointer);
begin
  Fail(NotEqualsErrorMessage(expected, actual, ErrorMsg), ErrorAddrs);
end;

procedure TTestProc.OnCheckCalled;
begin
  FCheckCalled := True;
  if Assigned(FExecControl) then
    FExecControl.CheckCalledCount := 1;
end;

{-------------Checks---------------}
function IntToBin(const Value, digits: longword): string;
const
  ALL_32_BIT_0 = '00000000000000000000000000000000';
var
  LCounter: Integer;
  Lpow:     Integer;
begin
  Result := ALL_32_BIT_0;
  SetLength(Result, digits);
  Lpow := 1 shl (digits - 1);
  if Value <> 0 then
  for LCounter := 0 to digits - 1 do
  begin
    if (Value and (Lpow shr LCounter)) <> 0 then
      Result[LCounter+1] := '1';
  end;
end;

procedure TTestProc.Check(const condition: boolean; const ErrorMsg: string);
begin
  OnCheckCalled;
  if (not condition) then
    Fail(ErrorMsg, CallerAddr);
end;

procedure TTestProc.CheckTrue(const condition: boolean; const ErrorMsg: string);
begin
  OnCheckCalled;
  if (not condition) then
      FailNotEquals(BoolToStr(true, true), BoolToStr(false, true), ErrorMsg, CallerAddr);
end;

procedure TTestProc.CheckFalse(const condition: boolean; const ErrorMsg: string);
begin
  OnCheckCalled;
  if (condition) then
      FailNotEquals(BoolToStr(false, true), BoolToStr(true, true), ErrorMsg, CallerAddr);
end;

procedure TTestProc.CheckEquals(const expected, actual: int64;
    const ErrorMsg: string);
begin
  OnCheckCalled;
  if (expected <> actual) then
    FailNotEquals(IntToStr(expected), IntToStr(actual), ErrorMsg, CallerAddr);
end;

procedure TTestProc.CheckNotEquals(const expected, actual: int64;
    const ErrorMsg: string);
begin
  OnCheckCalled;
  if (expected = actual) then
    FailEquals(IntToStr(expected), IntToStr(actual), ErrorMsg, CallerAddr);
end;

procedure TTestProc.CheckEquals(const expected, actual: extended;
    const ErrorMsg: string);
begin
  CheckEquals(expected, actual, 0, ErrorMsg);
end;

procedure TTestProc.CheckEquals(const expected, actual: extended;
    const delta: extended; const ErrorMsg: string);
begin
  OnCheckCalled;
  if (abs(expected-actual) > delta) then
      FailNotEquals(FloatToStr(expected), FloatToStr(actual), ErrorMsg, CallerAddr);
end;

procedure TTestProc.CheckEquals(const expected, actual: string;
    const ErrorMsg: string);
begin
  OnCheckCalled;
  if expected <> actual then
    FailNotEquals(expected, actual, ErrorMsg, CallerAddr);
end;

procedure TTestProc.CheckEqualsString(const expected, actual: string;
    const ErrorMsg: string);
begin
  OnCheckCalled;
  if expected <> actual then
    FailNotEquals(expected, actual, ErrorMsg, CallerAddr);
end;

{$IFNDEF UNICODE}
procedure TTestProc.CheckEquals(const expected, actual: UnicodeString;
    const ErrorMsg: string);
begin
  OnCheckCalled;
  if expected <> actual then
    FailNotEquals(expected, actual, ErrorMsg, CallerAddr);
end;

procedure TTestProc.CheckEqualsMem(const expected, actual: pointer;
    const size: longword; const ErrorMsg: string);
begin
  OnCheckCalled;
  if not CompareMem(expected, actual, size) then
    Fail(GetMemDiffStr(expected, actual, size, ErrorMsg), CallerAddr);
end;

procedure TTestProc.CheckNotEquals(const expected, actual: UnicodeString;
    const ErrorMsg: string);
begin
  OnCheckCalled;
  if expected = actual then
    FailEquals(expected, actual, ErrorMsg, CallerAddr);
end;

procedure TTestProc.CheckNotEqualsMem(const expected, actual: pointer;
    const size: longword; const ErrorMsg: string);
begin
  OnCheckCalled;
  if CompareMem(expected, actual, size) then
  begin
    if (ErrorMsg <> '') then
      Fail(ErrorMsg + ', ' + 'Memory content was identical', CallerAddr)
    else
      Fail(ErrorMsg + 'Memory content was identical', CallerAddr)
  end;
end;
{$ENDIF}

procedure TTestProc.CheckEqualsUnicodeString(const expected, actual: UnicodeString;
    const ErrorMsg: string);
begin
  OnCheckCalled;
  if expected <> actual then
    FailNotEquals(expected, actual, ErrorMsg, CallerAddr);
end;

procedure TTestProc.CheckNotEqualsUnicodeString(const expected, actual: UnicodeString;
    const ErrorMsg: string);
begin
  OnCheckCalled;
  if expected = actual then
    FailEquals(expected, actual, ErrorMsg, CallerAddr);
end;

procedure TTestProc.CheckEquals(const expected, actual: boolean;
    const ErrorMsg: string);
begin
  OnCheckCalled;
  if (expected <> actual) then
    FailNotEquals(BoolToStr(expected, true), BoolToStr(actual, true), ErrorMsg, CallerAddr);
end;

procedure TTestProc.CheckEqualsBin(const expected, actual: longword;
                                   const ErrorMsg: string;
                                   const digits: Integer);
begin
  OnCheckCalled;
  if expected <> actual then
    FailNotEquals(IntToBin(expected, digits), IntToBin(actual, digits), ErrorMsg, CallerAddr);
end;

procedure TTestProc.CheckEqualsHex(const expected, actual: longword;
                                   const ErrorMsg: string;
                                   const digits: Integer);
begin
  OnCheckCalled;
  if expected <> actual then
    FailNotEquals(IntToHex(expected, digits), IntToHex(actual, digits), ErrorMsg, CallerAddr);
end;

procedure TTestProc.CheckNotEquals(const expected, actual: extended;
                                   const delta: extended;
                                   const ErrorMsg: string);
begin
  OnCheckCalled;
    if (abs(expected-actual) <= delta) then
      FailEquals(FloatToStr(expected), FloatToStr(actual), ErrorMsg, CallerAddr);
end;

{$IFNDEF VER130}
procedure TTestProc.CheckNotEquals(const expected, actual: string;
                                   const ErrorMsg: string);
begin
  OnCheckCalled;
  if expected = actual then
    FailEquals(expected, actual, ErrorMsg, CallerAddr);
end;
{$ENDIF}

procedure TTestProc.CheckNotEqualsString(const expected, actual: string;
                                         const ErrorMsg: string);
begin
  OnCheckCalled;
  if expected = actual then
    FailEquals(expected, actual, ErrorMsg, CallerAddr);
end;

procedure TTestProc.CheckNotEquals(const expected, actual: boolean;
                                   const ErrorMsg: string);
begin
  OnCheckCalled;
  if (expected = actual) then
    FailEquals(BoolToStr(expected, true), BoolToStr(actual, true), ErrorMsg, CallerAddr);
end;

procedure TTestProc.CheckEquals(const expected, actual: integer;
                                const ErrorMsg: string);
begin
  OnCheckCalled;
  if (expected <> actual) then
    FailNotEquals(IntToStr(expected), IntToStr(actual), ErrorMsg, CallerAddr);
end;

procedure TTestProc.CheckNotEquals(const expected, actual: integer;
                                   const ErrorMsg: string);
begin
  OnCheckCalled;
  if (expected = actual) then
    FailEquals(IntToStr(expected), IntToStr(actual), ErrorMsg, CallerAddr);
end;

procedure TTestProc.CheckNotEqualsBin(const expected, actual: longword;
                                      const ErrorMsg: string;
                                      const digits: Integer);
begin
  OnCheckCalled;
  if (expected = actual) then
    FailEquals(IntToBin(expected, digits), IntToBin(actual, digits), ErrorMsg, CallerAddr);
end;

procedure TTestProc.CheckNotEqualsHex(const expected, actual: longword;
                                      const ErrorMsg: string;
                                      const digits: Integer);
begin
  OnCheckCalled;
  if (expected = actual) then
    FailEquals(IntToHex(expected, digits), IntToHex(actual, digits), ErrorMsg, CallerAddr);
end;

procedure TTestProc.CheckNotNull(const obj: IInterface; const ErrorMsg: string);
begin
  OnCheckCalled;
  if obj = nil then
    Fail(ErrorMsg, CallerAddr);
end;

procedure TTestProc.CheckNull(const obj: IInterface; const ErrorMsg: string);
begin
  OnCheckCalled;
  if obj <>  nil then
    Fail(ErrorMsg, CallerAddr);
end;

procedure TTestProc.CheckSame(const expected, actual: IInterface;
                              const ErrorMsg: string);
begin
  OnCheckCalled;
  if (expected <> actual) then
    FailNotEquals(PtrToStr(Pointer(expected)), PtrToStr(Pointer(actual)), ErrorMsg, CallerAddr);
end;

procedure TTestProc.CheckNotSame(const expected, actual: IInterface;
                                 const ErrorMsg: string);
begin
  OnCheckCalled;
  if (expected = actual) then
    FailEquals(PtrToStr(Pointer(expected)), PtrToStr(Pointer(actual)), ErrorMsg, CallerAddr);
end;

procedure TTestProc.CheckSame(const expected, actual: TObject;
                              const ErrorMsg: string);
begin
  OnCheckCalled;
  if (expected <> actual) then
    FailNotEquals(PtrToStr(Pointer(expected)), PtrToStr(Pointer(actual)), ErrorMsg, CallerAddr);
end;

procedure TTestProc.CheckNotSame(const expected, actual: TObject;
                                 const ErrorMsg: string);
begin
  OnCheckCalled;
  if (expected = actual) then
    FailEquals(PtrToStr(Pointer(expected)), PtrToStr(Pointer(actual)), ErrorMsg, CallerAddr);
end;

procedure TTestProc.CheckNotNull(const obj: TObject; const ErrorMsg: string);
begin
  OnCheckCalled;
  if obj = nil then
    FailNotEquals('object', PtrToStr(Pointer(obj)), ErrorMsg, CallerAddr);
end;

procedure TTestProc.CheckNull(const obj: TObject; const ErrorMsg: string);
begin
  OnCheckCalled;
  if obj <> nil then
    FailEquals('nil', PtrToStr(Pointer(obj)), ErrorMsg, CallerAddr);
end;

procedure TTestProc.CheckNotNull(const obj: Pointer; const ErrorMsg: string);
begin
  OnCheckCalled;
  if obj = nil then
    FailNotEquals('pointer', PtrToStr(obj), ErrorMsg, CallerAddr);
end;

procedure TTestProc.CheckNull(const obj: Pointer; const ErrorMsg: string);
begin
  OnCheckCalled;
  if obj <> nil then
    FailEquals('nil', PtrToStr(obj), ErrorMsg, CallerAddr);
end;

procedure TTestProc.CheckException(const AMethod: TExceptTestMethod;
                                   const AExceptionClass: TClass;
                                   const ErrorMsg: string);
var
  LExceptionClass: TClass;
begin
  LExceptionClass := AExceptionClass;
  try
    Invoke(AMethod);
  except
    on E:Exception do
    begin
      OnCheckCalled;
      if not Assigned(LExceptionClass) then
        raise
      else if not e.ClassType.InheritsFrom(LExceptionClass) then
        FailNotEquals(AExceptionClass.ClassName, e.ClassName, ErrorMsg, CallerAddr)
      else
        LExceptionClass := nil;
    end;
  end;
  if Assigned(LExceptionClass) then
    FailNotEquals(AExceptionClass.ClassName, 'nothing', ErrorMsg, CallerAddr)
end;

procedure TTestProc.EarlyExitCheck(const condition: boolean; const ErrorMsg: string);
begin
  if FExecControl.InhibitSummaryLevelChecks then
  begin
    Check(condition, ErrorMsg);
    Exit;
  end;

  FExecControl.CheckCalledCount := FExecControl.CheckCalledCount + 1;
  if condition then
    raise ECheckExit.Create('');

  // Note we fall through to here if the test failed.
  if ErrorMessage = '' then
    ErrorMessage := ErrorMsg
  else
    ErrorMessage := ErrorMessage + '.' + ErrorMsg
end;

procedure TTestProc.CheckEquals(const expected, actual: TClass;
                                const ErrorMsg: string);
begin
  OnCheckCalled;
  if expected <> actual then
  begin
    if expected = nil then
      FailNotEquals('nil', actual.ClassName, ErrorMsg, CallerAddr)
    else if actual = nil then
      FailNotEquals(expected.ClassName, 'nil', ErrorMsg, CallerAddr)
    else
      FailNotEquals(expected.ClassName, actual.ClassName, ErrorMsg, CallerAddr)
  end;
end;

procedure TTestProc.CheckNotEquals(const expected, actual: TClass;
                                   const ErrorMsg: string);
begin
  OnCheckCalled;
  if expected = nil then
    FailNotEquals('nil', '', ErrorMsg, CallerAddr)
  else if actual = nil then
    FailNotEquals('', 'nil', ErrorMsg, CallerAddr)
  else
  if expected = actual then
    FailNotEquals(expected.ClassName, actual.ClassName, ErrorMsg, CallerAddr)
end;

procedure TTestProc.CheckNotEquals(const expected, actual: extended;
                                   const ErrorMsg: string);
begin
  // TODO: This is not going to report correct calling error address
  CheckNotEquals(expected, actual, 0, ErrorMsg);
end;

procedure TTestProc.CheckInherits(const expected, actual: TClass;
                                  const ErrorMsg: string);
begin
  OnCheckCalled;
  if expected = nil then
    FailNotEquals('nil', actual.ClassName, ErrorMsg, CallerAddr)
  else if actual = nil then
    FailNotEquals(expected.ClassName, 'nil', ErrorMsg, CallerAddr)
  else if not actual.InheritsFrom(expected) then
    FailNotEquals(expected.ClassName, actual.ClassName, ErrorMsg, CallerAddr)
end;

procedure TTestProc.CheckIs(const AObject: TObject;
                            const AClass: TClass;
                            const ErrorMsg: string);
begin
  OnCheckCalled;
  if AClass= nil then
    FailNotEquals(Self.ClassName, 'nil', ErrorMsg, CallerAddr);
  if AObject = nil then
    FailNotEquals(AClass.ClassName, 'nil', ErrorMsg, CallerAddr)
  else if not AObject.ClassType.InheritsFrom(AClass) then
    FailNotEquals(AClass.ClassName, AObject.ClassName, ErrorMsg, CallerAddr)
end;

procedure TTestCase.StopTests(const ErrorMsg: string);
begin
  OnCheckCalled; // This line is questionable.
  raise EStopTestsFailure.Create('Testing Stopped: ' + ErrorMsg);
end;


{ TTestSuite }

constructor TTestSuite.Create(const ASuiteName: string);
begin
  Create;
  if ASuiteName <> '' then
    FDisplayedName := ASuiteName;
end;

class function TTestSuite.Suite(const ASuiteName: string): ITestSuite;
begin
  Result := Self.Create;
  if ASuiteName <> '' then
    Result.DisplayedName := ASuiteName;
end;

class function TTestSuite.Suite(const ASuiteName: string;
                                const ATestCase: ITestCase): ITestSuite;
begin
  Result := Self.Create(ASuiteName);
  Result.AddTest('', ATestCase);
end;

class function TTestSuite.Suite(const ASuiteName: string;
                                const TestCases: array of ITestCase): ITestSuite;
begin
  Result := Self.Create(ASuiteName);
  Result.AddTest('', TestCases);
end;

procedure TTestSuite.AddTest(const SuiteTitle: string;
                             const ASuite: ITestCase);
begin
  if Assigned(ASuite) then
  begin
    if SuiteTitle <> '' then
      ASuite.DisplayedName := SuiteTitle;
    inherited AddTest(ASuite);
  end;
end;

procedure TTestSuite.AddTest(const SuiteTitle: string;
                             const Suites: array of ITestCase);
var
  idx: Integer;
begin
  if SuiteTitle <> '' then
    DisplayedName := SuiteTitle;
  for idx := 0 to Length(Suites) - 1 do
  begin
    AddTest(Suites[idx]);
  end;
end;

function TTestSuite.FindNextEnabledProc: ITest;
var
  LTest: ITest;
begin
  Result := nil;
  repeat
    LTest := FTestIterator.FindNextEnabledProc;
    if Assigned(LTest) then
    begin
      if (LTest.SupportedIfaceType = _isTestMethod) then
      Result := LTest
      else
      begin
        Result := (LTest as ITestCase).FindNextEnabledProc;
        if Assigned(Result) then
          FTestIterator.PriorTest;
      end;
    end;
  until (Assigned(Result) or (LTest = nil));
end;

function TTestSuite.TestIterator: IReadOnlyIterator;
begin
  Result := FTestIterator;
end;

function TTestSuite.PriorTest: ITest;
var
  LTest : ITest;
begin
  Result := FTestIterator.PriorTest;
  if Assigned(Result) then
  begin
    if Result.InterfaceSupports(_isTestCase) then
    begin
      LTest := (Result as ITestCase).PriorTest;
      if Assigned(LTest) then
      begin // Hold current entry while tests are valid
        FTestIterator.FindNextTest;
        Result := LTest;
      end;
    end;
  end;
end;

procedure TTestSuite.Reset;
var
  LTest: ITest;
begin
  LTest := FTestIterator.FindFirstTest;
  while Assigned(LTest) do
  begin
    LTest := FTestIterator.FindNextTest;
    if Assigned(LTest) and LTest.InterfaceSupports(_isTestCase) then
      (LTest as ITestCase).Reset;
  end;
  FTestIterator.Reset;
end;

{ TTestDecorator }

class function TTestDecorator.Suite(const DecoratorName: string;
                                    const DecoratedTestCase: ITestCase): ITestSuite;
begin
  Result := Self.Create;
  Result.AddTest(DecoratorName, DecoratedTestCase);
end;

class function TTestDecorator.Suite(const DecoratedTestCase: ITestCase): ITestSuite;
begin
  Result := Suite('', DecoratedTestCase);
end;

class function TTestDecorator.Suite(const DecoratorName: string;
                                    const DecoratedTestCases: array of ITestCase): ITestSuite;
var
  idx: Integer;
  LSuite : ITestSuite;
begin
  Result := Self.Create;
  if DecoratorName = '' then
    for idx := 0 to Length(DecoratedTestCases) - 1 do
      Result.AddTest(DecoratorName, DecoratedTestCases[idx])
  else
  begin
    LSuite := TTestSuite.Create(DecoratorName);
    for idx := 0 to Length(DecoratedTestCases) - 1 do
      LSuite.AddTest(DecoratedTestCases[idx]);
    Result.AddTest(LSuite);
  end;
end;

function TTestDecorator.Run(const ExecControl: ITestExecControl): TExecutionStatus;
var
  LTest: ITestCase;
  LWhichOne: string;
begin
  try
    ExecStatus := _Running;
    LWhichOne := 'Once';
    SetUpOnce;
    LWhichOne := '';
    SetUp;
    FTestIterator.Reset;
    LTest := FTestIterator.FindNextTest as ITestCase;
    while LTest <> nil do
    begin
      ExecStatus := LTest.Run(ExecControl);
      LTest := FTestIterator.FindNextTest as ITestCase;
    end;

    try
      TearDown;
      LWhichOne := 'Once';
      TearDownOnce;
    except
      on E:Exception do
      begin
        FReportErrorOnce := True;
        ExecStatus := UpdateOnError(Self,
                                    _Error,
                                    'TearDown ' + LWhichOne + ' failed: ' + E.Message,
                                    E,
                                    PtrType(ExceptAddr));
      end;
    end;
  except
    on E:Exception do
    begin
      FReportErrorOnce := True;
      ExecStatus := UpdateOnError(Self,
                                  _Error,
                                  'SetUp ' + LWhichOne + ' failed: ' + E.Message,
                                  E,
                                  PtrType(ExceptAddr));
    end;
  end;

  LWhichOne := '';
  Result := ExecStatus;
end;

{ TRepeatedTest }

class function TRepeatedTest.Suite(const CountedTestCase: ITestCase;
                                   const Iterations: Cardinal): IRepeatedTest;
begin
  Result := Self.Create;
  (Result as IRepeatedTest).RepeatCount := Iterations;
  Result.DisplayedName := Self.ClassName;
  CountedTestCase.DisplayedName := IntToStr(Iterations) + ' * ' + CountedTestCase.DisplayedName;
  Result.AddTest(CountedTestCase);
end;

function TRepeatedTest.Count: Integer;
begin
  Result := inherited Count * FRepeatCount;
end;

function TRepeatedTest.GetHaltOnError: Boolean;
begin
  Result := FHaltOnError;
end;

procedure TRepeatedTest.SetHaltOnError(const Value: Boolean);
begin
  FHaltOnError := Value;
end;

procedure TRepeatedTest.set_RepeatCount(const Value: Integer);
begin
  FRepeatCount := Value;
end;

function  TRepeatedTest.Run(const ExecControl: ITestExecControl): TExecutionStatus;
var
  LCount: Integer;
  LErrorCount: Integer;
  LFailureCount: Integer;
  LHalt: boolean;
begin
  Result := ExecStatus;
  LHalt := False;
  LCount := FRepeatCount;

  while (LCount > 0) and (not LHalt) do
  begin
    LErrorCount := ExecControl.ErrorCount;
    LFailureCount := ExecControl.FailureCount;
    Result := inherited Run(ExecControl);
    LHalt := FHaltOnError and
      ((ExecControl.ErrorCount > LErrorCount) or
       (ExecControl.FailureCount > LFailureCount));
    Dec(LCount);
  end;
end;

{------------------------------------------------------------------------------}
{ TTestProject }

function  TestProject: ITestProject;
begin
  Result := nil;
  if Assigned(ProjectManager) then
    Result := ProjectManager.Project[0];
end;

function TestProject(const idx: Integer): ITestProject;
begin
  Result := nil;
  if Assigned(ProjectManager) and
    ((idx >= 0) and (idx < ProjectManager.Count)) then
      Result := ProjectManager.Project[idx];
end;

function  Projects: ITestProject; overload;
begin
  Result := nil;
  if Assigned(ProjectManager) then
  begin
    Result := ProjectManager.Projects;
    if not Assigned(Result) then
      Result := TestProject;
  end;
end;

constructor TTestProject.Create;
begin
  inherited Create;
  CreateFields;
end;

constructor TTestProject.Create(const ASuiteName: string);
begin
  Create;
  if (ASuiteName <> '') then
    FDisplayedName := ASuiteName
  else
    FDisplayedName := DefaultProject;
end;

procedure TTestProject.CreateFields;
begin
  FAllTestsList := TInterfaceList.Create;
  FSuiteList := TInterfaceList.Create;
  // Install procedures that direct callbacks
  FExecStatusUpdater := ExecStatusUpdater;
  FStatusMsgUpdater := StatusMessageUpdater;
end;

destructor TTestProject.Destroy;
begin
  FExecStatusUpdater := nil;
  FListener := nil;
  FSuiteList := nil;
  FAllTestsList := nil;
  inherited;
end;

procedure TTestProject.ExecStatusUpdater(const ATest: ITest);
begin
  if (ATest = nil) or (FListener = nil) then
    Exit;
  case (ATest as ITest).ExecStatus of
    _Ready: FTestingBegins := False;

    _Running:
      begin
        FTestingBegins := True;
        if not ATest.IsTestMethod then
        begin
          if (ATest.Depth = 0) and (ATest.ProjectID = 0) then
            (FListener as ITestListenerProxy).TestingStarts;
          (FListener as ITestListenerProxy).StartSuite(ATest);
        end;
        (FListener as ITestListenerProxy).StartTest(ATest);
      end;

    else // All other conditions
    begin
      (FListener as ITestListenerProxy).EndTest(ATest);
      if not (ATest.SupportedIfaceType = _isTestMethod) then
      begin
        (FListener as ITestListenerProxy).EndSuite(ATest);
          if (ATest.Depth = 0) and (ATest.ProjectID = 0) then
         (FListener as ITestListenerProxy).TestingEnds;
      end;
    end;
  end; {case}
end;

procedure TTestProject.StatusMessageUpdater(const ATest: ITest; const AStatusMsg: string);
begin
  if (ATest = nil) or (FListener = nil) then
    Exit;

  (FListener as ITestListenerProxy).Status(ATest, AStatusMsg);
end;

function TTestProject.ExecutionControl: ITestExecControl;
begin
  if not Assigned(FExecControl) then
  begin
    FExecControl := TTestExecControl.Create(ExecStatusUpdater,
                                            StatusMessageUpdater,
                                            IsTestSelected);
  end;
  Result := FExecControl;
end;

function TTestProject.get_Manager: IInterface;
begin
  Result := ProjectManager as IInterface;
end;

function TTestProject.get_ProjectName: string;
begin
  Result := FProjectName;
end;

procedure TTestProject.RegisterTest(const ATest: ITest);
begin
  if Assigned(ATest) and (FAllTestsList.IndexOf(ATest) < 0) then
    FAllTestsList.Add(ATest)
end;

procedure TTestProject.Reset;
begin
  inherited Reset;
  FTestIdx := FAllTestsList.Count-1;
  FEnabledTestsCounted := False;
end;

// Note. The calling code can do the testing starts and end function just as
// well as this code and then there is no need for callbacks.
function TTestProject.Run(const ExecControl: ITestExecControl): TExecutionStatus;
var
  i: Integer;
  LCount: Cardinal;
begin
  LCount := CountEnabledTests;
  if Assigned(ExecControl) and (Depth = 0) then
  begin // This is the top level project
    ExecControl.CheckCalledCount := 0;
    ExecControl.EnabledCount := LCount;
  end;

  for i := FAllTestsList.Count - 1 downto 0 do
    (FAllTestsList.Items[i] as ITest).ExecStatus := _Ready;

  ExecStatus := inherited Run(ExecControl);
  ExecControl.TestSetUpData := nil;  //Prevent data leakage outside of project
  Result := ExecStatus;
end;

procedure TTestProject.set_Listener(const Value: IInterface);
begin
  FListener := Value;
end;

procedure TTestProject.set_Manager(const AManager: IInterface);
begin
  FManager := AManager;
end;

procedure TTestProject.set_ProjectName(const AName: string);
begin
  FProjectName := Trim(AName);
  DisplayedName := FProjectName;
end;

function TTestProject.IsTestSelected(const ATest: ITest): Boolean;
begin
  Result := False;
  if (ATest = nil) then
    Exit;

  if (FListener = nil) then
    Result := True
  else
    Result := (FListener as ITestListenerProxy).ShouldRunTest(ATest);
end;

function TTestProject.SuiteByTitle(const SuiteTitle: string): ITestSuite;
var
  i: Integer;
  LSuite: ITest;
begin
  Result := nil;
  if SuiteTitle = DisplayedName then
  begin
    Result := Self;
    Exit;
  end;

  for i := 0 to FSuiteList.Count - 1 do
  begin
    LSuite := (FSuiteList.Items[i] as ITest);
    if LSuite.InterfaceSupports(_isTestSuite) and
      ((LSuite as ITestSuite).DisplayedName = SuiteTitle) then
    begin
      Result := (LSuite as ITestSuite);
      Break;
    end;
  end;
end;

// Visit the low level instances recursively
function TTestProject.FindNextEnabledProc: ITest;
begin
  if not FEnabledTestsCounted then
    FindFirstTest;
  Result := inherited FindNextEnabledProc;
end;

// Pull an instance out of the linear list or registered tests
function TTestProject.FindFirstTest: ITest;
begin
  CountEnabledTests;
  if FAllTestsList.Count <= 0 then
    Result := nil
  else
    Result := (FAllTestsList.Items[FAllTestsList.Count-1] as ITest);
end;

function TTestProject.FindNextTest: ITest;
begin
  if not FEnabledTestsCounted then
    Result := FindFirstTest
  else
  begin
    Result := nil;
    if FTestIdx > 0 then
    begin
      Dec(FTestIdx);
      Result := (FAllTestsList.Items[FTestIdx] as ITest);
    end;
  end;
end;

function TTestProject.CountEnabledTests: Integer;
var
  LTest: ITest;
  LHeldTest: ITest;
begin
  Result := 0;
  LHeldTest := nil;
  FCount := inherited Count;
  if Assigned(FAllTestsList) then
  begin
    FAllTestsList.Clear;       // Clean out any/all old entries
    FEnabledTestsCounted := False;

    LTest := FTestIterator.PriorTest;
    repeat  // Now build the reversed linear list of all entities.
      LHeldTest := LTest;
      if Assigned(LTest) and LTest.InterfaceSupports(_isTestCase) then
      begin
        LTest := (LTest as ITestCase).PriorTest;
        if Assigned(LTest) then
        begin
          LTest.ProjectID := Self.ProjectID;
          FTestIterator.FindNextTest; // Hold current entry while tests are valid
        end;
      end;

      begin
        if LTest <> nil then
          RegisterTest(LTest)
        else
        if Assigned(LHeldTest) then
          RegisterTest(LHeldTest);
      end;

      LTest := FTestIterator.PriorTest;
    until LTest = nil;
    Reset;
    FEnabledTestsCounted := True;
    Result := FCount;
  end;
end;

procedure TTestProject.AddTest(const ATest: ITest);
begin
  if ATest = nil then
    Exit;

  if ParentPath = '' then
    ATest.ParentPath := DisplayedName
  else
    ATest.ParentPath := ParentPath + '.' + DisplayedName;

  if ATest.InterfaceSupports(_isTestSuite) then
    FSuiteList.Add(ATest);

  ATest.ProjectID := FSuiteList.Count;
  inherited AddTest(ATest);
end;

procedure TTestProject.AddNamedSuite(const SuiteTitle: string;
                                     const ATest: ITestCase);
var
  LTestSuite: ITestSuite;
begin
  LTestSuite := SuiteByTitle(SuiteTitle);
  if Assigned(LTestSuite) then
    LTestSuite.AddTest(ATest)
  else
  begin
    LTestSuite := TTestSuite.Create;
    LTestSuite.DisplayedName := SuiteTitle;
    LTestSuite.AddTest(ATest);
    AddTest(LTestSuite);
  end;
end;

function TTestProject.Count: Integer;
begin
  if FEnabledTestsCounted then
    Result := FCount
  else
    Result := CountEnabledTests;
end;

{------------------------------------------------------------------------------}
{ Register tests }

procedure RegisterTest(const ATest: ITestCase);
begin
  ProjectRegisterTest('', ATest);
end;

procedure RegisterTest(const SuiteTitle: string; const ATest: ITestCase);
begin
  ProjectRegisterTest('', SuiteTitle, ATest);
end;

procedure RegisterTests(const Tests: array of ITestCase);
begin
  ProjectRegisterTests('', Tests);
end;

procedure RegisterTests(const SuiteTitle: string;
                        const Tests: array of ITestCase);
begin
  ProjectRegisterTests('', SuiteTitle, Tests);
end;


procedure ProjectRegisterTest(const ProjectName: string;
                              const ATest: ITestCase);
var
  LProjectID: Integer;
  LProject: ITestProject;
begin  //procedure ProjectRegisterTest
  if (ATest = nil) then
    Exit;

  if not Assigned(ProjectManager) then
    ProjectManager := TProjectManager.Create;

  LProjectID := ProjectManager.FindProjectID(ProjectName);

  if (LProjectID < 0) then  // project has not been registered before
  begin
    LProject := TTestProject.Create(ProjectName);
    ProjectManager.AddProject(LProject);
    LProject.AddTest(ATest);
  end
  else
  begin
    LProject := ProjectManager.Project[LProjectID];
    LProject.AddTest(ATest);
  end;
end;

procedure ProjectRegisterTests(const ProjectName: string;
                               const Tests: array of ITestCase); overload;
var
  idx: Integer;
begin
  if Length(Tests) = 0   then
    Exit;

  for idx := 0 to Length(Tests)-1 do
  begin
    if Assigned(Tests[idx]) then
      ProjectRegisterTest(ProjectName, Tests[idx]);
  end;
end;

procedure ProjectRegisterTest(const ProjectName: string;
                              const SuiteTitle: string;
                              const ATest: ITestCase); overload;
var
  LProject: ITestProject;
  LProjectID: Integer;
begin
  if (ATest = nil) then
    Exit;

  if SuiteTitle = '' then
  begin
    ProjectRegisterTest(ProjectName, ATest);
    Exit;
  end;

  if not Assigned(ProjectManager) then
    ProjectManager := TProjectManager.Create;
  LProjectID := ProjectManager.FindProjectID(ProjectName);
  if (LProjectID < 0) then  // project has not been registered before
  begin
    LProject := TTestProject.Create(ProjectName);
    LProject.AddNamedSuite(SuiteTitle, ATest);
    LProjectID := ProjectManager.AddProject(LProject);
  end
  else
  begin
    LProject := ProjectManager.Project[LProjectID];
    LProject.AddNamedSuite(SuiteTitle, ATest);
  end;

  ATest.ProjectID := LProjectID;
end;

procedure ProjectRegisterTests(const ProjectName: string;
                               const SuiteTitle: string;
                               const Tests: array of ITestCase);
var
  idx: Integer;
begin
  if Length(Tests) = 0   then
    Exit;

  if SuiteTitle = '' then
  begin
    for idx := 0 to Length(Tests)-1 do
      ProjectRegisterTest(ProjectName, Tests[idx]);
  end
  else
  for idx := 0 to Length(Tests)-1 do
  begin
    ProjectRegisterTest(ProjectName, SuiteTitle, Tests[idx]);
  end;
end;

initialization
  gTimer.Clear;
  gTimer.Start;

finalization
  UnRegisterProjectManager;
end.
