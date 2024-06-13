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

unit ProjectsManager;

{$IFDEF FPC}
  {$mode delphi}{$H+}
{$ENDIF}

interface
uses
  Classes,
  ProjectsManagerIface,
  TestFrameworkIfaces,
  TestListenerIface,
  IniFiles
  {$IFNDEF UNIX}
  ,Registry
  {$ENDIF}
  ;

{ TODO : Remove Registry support - we want clean INI support only }

type
  {$M+}
  TProjectManager = class(TInterfacedObject, IProjectManager)
  private
    FMultiProjectSuite: ITestProject;
    FProjectList: IInterfaceList;
    FExeName: string;
    function SectionName(const AProject: ITestProject): string;
  protected
    function  get_Project(const idx: Integer): ITestProject;
    procedure set_Project(const idx: Integer; const AProject: ITestProject);
    function  get_Projects: ITestProject;
    procedure set_Projects(const Value: ITestProject);
    function  get_Count: Integer;
    function  FindProjectID(const AName: string): Integer;
    procedure SaveConfiguration(const FileName: string; const useRegistry, useMemIni: Boolean); virtual;
    procedure LoadConfiguration(const FileName: string; const useRegistry, useMemIni: Boolean); virtual;
    procedure AddListener(const Listener: ITestListenerProxy); overload;
    procedure AddListener(const ProjectID: Integer; const Listener: ITestListenerProxy); overload;
    procedure RemoveListener(const Listener: ITestListenerProxy); overload;
    procedure RemoveListener(const ProjectID: Integer; const Listener: ITestListenerProxy); overload;
    procedure ReleaseProject(const AProject: ITestProject);
    procedure ReleaseProjects;
    function  AddProject(const AProject: ITestProject): Integer;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    property  Project[const index: Integer]: ITestProject read get_Project write set_Project;
  published
    property  Projects: ITestProject read get_Projects write set_Projects;
    property  Count: Integer read get_Count;
  end;
  {$M-}

implementation

uses
  SysUtils,
  TestFramework;

{$IFNDEF UNIX}
var
  // SubKey of HKEY_CURRENT_USER for storing configurations in the registry (end with \)
  DUnitRegistryKey: string = ''; // How about 'Software\DUnitTests\';
{$ENDIF}

type
  TMemIniFileTrimmed = class(TMemIniFile)
  public
    // Override the read string method to trim the string for compatibility with TIniFile
    function ReadString(const Section, Ident, DefaultStr: string): string; override;
  end;

function TMemIniFileTrimmed.ReadString(const Section, Ident,
  DefaultStr: string): string;
begin
  // Trim the result for compatibility with TIniFile
  Result := Trim(inherited ReadString(Section, Ident, DefaultStr));
end;


type
  IProjectIterator = interface(ITestIterator)
  ['{E1D98B08-C97B-42D0-8952-E74CA7F8C73B}']
    function Exists(const AProject: ITestProject): boolean;
  end;


  TProjectIterator = class(TTestIterator, IProjectIterator)
  protected
    function Exists(const AProject: ITestProject): boolean;
  end;


  TMultiProjectSuite = class(TTestProject)
  private
    FForceFindFirstTest: boolean;
  protected
    function  FindFirstTest: ITest; override;
    function  FindNextTest: ITest; override;
    function  ExecutionControl: ITestExecControl; override;
    procedure SaveConfiguration(const FileName: string; const useRegistry, useMemIni: Boolean); reintroduce; overload;
    procedure LoadConfiguration(const FileName: string; const useRegistry, useMemIni: Boolean); reintroduce; overload;
  end;



function TProjectIterator.Exists(const AProject: ITestProject): boolean;
begin
  Result := FIList.IndexOf(AProject) >= 0;
end;


{ TProjectManager }

constructor TProjectManager.Create;
begin
  inherited Create;
  FExeName := ExtractFileName(ParamStr(0));
  FProjectList := TInterfaceList.Create;
end;

destructor TProjectManager.Destroy;
begin
  ReleaseProjects;
  FProjectList := nil;
  inherited;
end;

procedure TProjectManager.ReleaseProject(const AProject: ITestProject);
var
  LEntry: Integer;
begin
  if AProject = nil then
    Exit;

  if FProjectList.Count > 0 then
  begin
    LEntry := FProjectList.IndexOf(AProject);
    if LEntry >= 0 then
      FProjectList.Items[LEntry] := nil;
  end;
end;

procedure TProjectManager.ReleaseProjects;
begin
  if Assigned(FProjectList) then
  // Prevent crash during shutdown if interfaced object instances in DLLs
  // have already been unloaded.
  // Note. I'm not convinced this was the real cause, yet!  
  try
    FProjectList.Clear;
  except
  end;
  FProjectList := nil;
  FMultiProjectSuite := nil;
end;

function TProjectManager.get_Count: Integer;
begin
  Result := FProjectList.Count;
end;

function TProjectManager.get_Project(const idx: Integer): ITestProject;
begin
  Result := nil;

  if (idx >= 0) and (idx < Count) and
    Assigned(FProjectList.Items[idx]) then
      Result := (FProjectList.Items[idx] as ITestProject);
end;

procedure TProjectManager.set_Project(const idx: Integer; const AProject: ITestProject);
begin
  if Assigned(AProject) then
  begin
    if (idx >= 0) then
    begin
      AProject.Manager := Self as IInterface;
      if (idx < Count) then
      begin
        AProject.ProjectID := idx;
        FProjectList.Items[idx] := AProject as IInterface;
      end
      else
      begin
        FProjectList.Add(AProject);
        AProject.ProjectID := FProjectList.Count;
      end;
    end;
  end;
end;

function TProjectManager.FindProjectID(const AName: string): Integer;
var
  LName: string;
  LCount: Integer;
begin
  Result := -1;
  LName := Trim(AName);
  Assert(Pos(',', LName) = 0, 'Project names must not contain a delimiter');

  for LCount := 0 to FProjectList.Count-1 do
  begin
    if (FProjectList.Items[LCount] as ITestProject).DisplayedName = LName then
    begin
      Result := LCount;
      Exit;
    end
  end;

  if ((Result = -1) and (LName = '')) then
  begin
    Result := FindProjectID(DefaultProject);
    if (Result = -1) then
      Result := FindProjectID(FExeName);
  end;
end;

// FMultiProjectSuite is nil if there is only one project registered.
// This reduces the layers presented to the user interface.
// When a second project is registered then FMultiProjectSuite is created.
// The second and subsequent projects is still added to the project manager's list.
// The change being introduced here is on creation the fist project and second
// projects are added to FMultiProjectSuite test iterator so inherited
// behaviour of ITestProject can be utilised.
// It may be possible in a second refactoring to change the project manager's
// list to a single entry which gets nil-ed early rather than later to help
// with memory management.

function TProjectManager.AddProject(const AProject: ITestProject): Integer;
var
  idx: Integer;
  LProject: ITestProject;

  function AsProject(const NewTests: ITestProject): ITestProject;
  begin
    if Supports(NewTests, ITestProject) then
      Result := NewTests
    else
    begin  // We need the registered instances to be projects not TestSuites.
      Result := TTestProject.Create(DefaultProject);
      Result.AddTest(NewTests);
    end
  end;

  function AddToProjectList: Integer;
  begin
    FProjectList.Add(LProject);
    Result := FProjectList.Count -1;
    LProject.ProjectID := Result;
  end;


begin // TProjectManager.AddProject(const AProject: ITestProject): Integer;
  Result := -1;
  if Assigned(AProject) then
    LProject := AsProject(AProject)
  else
    Exit;

  if (FProjectList.Count = 0) then  // Then no projects added yet.
  begin
    Result := AddToProjectList;
    if AProject.DisplayedName = DefaultProject then
      LProject.DisplayedName := FExeName;
    Exit;
  end;

  // See if a project with the same name already exists.
  Result := FindProjectID(LProject.DisplayedName);

  if Result = -1 then // This is not the first project and it isn't already registered
  begin
    Result := AddToProjectList;
    if not Assigned( FMultiProjectSuite) and (Result > 0) then
    begin // Introduce the project holding object so all projects can be run
      FMultiProjectSuite := TMultiProjectSuite.Create;
      FMultiProjectSuite.DisplayedName := FExeName;

      // Copy the first project into MultiProjectSuite's Iterator
      FMultiProjectSuite.AddTest((FProjectList.Items[0] as ITestProject));
    end;
  end
  else
  if Result = 0 then //i.e. we are adding to an existing pr
  begin
    raise Exception.Create('Project exists');
  end;

  if (Result > 0) then
  begin
    // If there are multiple projects and a default unnamed project exists, (i.e. it's been given ExeName)
    // then rename it back from ExeName to DefaultProject
    for idx := 0 to FProjectList.Count - 1 do
    if (FProjectList.Items[idx] as ITestProject).DisplayedName = FExeName then
    begin
      (FProjectList.Items[idx] as ITestProject).DisplayedName := DefaultProject;
      (FProjectList.Items[idx] as ITestProject).ParentPath := FExeName;
    end;

    // Add the new project to MultiProjectSuite's Iterator and set it's ParentPath
    FMultiProjectSuite.AddTest(LProject);
  end;
end;

procedure TProjectManager.AddListener(const ProjectID: Integer;
                                      const Listener: ITestListenerProxy);
begin
  if (ProjectID >= 0) and (ProjectID < FProjectList.Count) then
    if Assigned(Project[ProjectID]) then
      Project[ProjectID].Listener := Listener as IInterface;
end;

procedure TProjectManager.AddListener(const Listener: ITestListenerProxy);
var
  idx: Integer;
begin
  if (TestProject = nil) then
    Exit;

  for idx := 0 to Count -1 do
    if Assigned(Project[idx]) then
      Project[idx].Listener := Listener as IInterface;
end;

procedure TProjectManager.RemoveListener(const ProjectID: Integer;
                                         const Listener: ITestListenerProxy);
begin
  if (ProjectID >= 0) and (ProjectID <= Count) then
    Project[ProjectID].Listener := Listener as IInterface;
end;

procedure TProjectManager.RemoveListener(const Listener: ITestListenerProxy);
var
  idx: Integer;
begin
  if (TestProject = nil) then
    Exit;

  for idx := 0 to Count -1 do
    if Assigned(Project[idx]) then
      Project[idx].Listener := Listener as IInterface;
end;

function TProjectManager.SectionName(const AProject: ITestProject): string;
begin
  if (not Assigned(AProject)) or (AProject.ParentPath = '') then
    Result := 'Test'
  else
    Result := 'Test.' + AProject.ParentPath;
end;

procedure TProjectManager.SaveConfiguration(const FileName: string; const useRegistry, useMemIni: Boolean);
var
  f: TCustomIniFile;
  LProject: ITestProject;
  LFileName: string;
  LFinalPathFileName: string;
begin
  if FileName = '' then
    LFileName := ExtractFileName(FExeName)
  else
    LFileName := ExtractFileName(FileName);

  { TODO -cregistry : Remove windows registry references }
  LFinalPathFileName := {LocalAppDataPath +} LFileName;
{$IFNDEF UNIX}
  if useRegistry then
    f := TRegistryIniFile.Create(DUnitRegistryKey + LFileName)
  else
{$ENDIF}
    if useMemIni then
      f := TMemIniFileTrimmed.Create(LFinalPathFileName)
    else
      f := TIniFile.Create(LFinalPathFileName);
  try
    LProject := Projects;
    if not assigned(LProject) then
      LProject := TestProject;
    if assigned(LProject) then
      LProject.SaveConfiguration(f, SectionName(LProject));
    f.UpdateFile;
  finally
    f.free
  end
end;

procedure TProjectManager.LoadConfiguration(const FileName: string;
                                            const useRegistry, useMemIni: Boolean);
var
  f: TCustomIniFile;
  LProject: ITestProject;
  LFileName: string;
  LFinalPathFileName: string;
begin
  if FileName = '' then
    LFileName := ExtractFileName(FExeName)
  else
    LFileName := ExtractFileName(FileName);

  { TODO -cregistry : Remove windows registry references }
  LFinalPathFileName := {LocalAppDataPath +} LFileName;
{$IFNDEF UNIX}
  if useRegistry then
    f := TRegistryIniFile.Create(DUnitRegistryKey + FileName)
  else
{$ENDIF}
    if useMemIni then
      f := TMemIniFileTrimmed.Create(LFinalPathFileName)
    else
      f := TIniFile.Create(LFinalPathFileName);

  try
    LProject := Projects;
    if not assigned(LProject) then
      LProject := TestProject;
    if Assigned(LProject) then
    begin
      LProject.LoadConfiguration(f, SectionName(LProject));
      try
        LProject.FailsOnNoChecksExecuted := f.ReadBool(cnRunners,
          'FailOnNoChecksExecuted', LProject.FailsOnNoChecksExecuted);
        LProject.InhibitSummaryLevelChecks := f.ReadBool(cnRunners,
          'InhibitSummaryLevelChecks', LProject.InhibitSummaryLevelChecks);
        {$IFDEF FASTMM}
        LProject.FailsOnMemoryLeak := f.ReadBool(cnRunners,
          'FailOnMemoryLeaked', LProject.FailsOnMemoryLeak);
        LProject.IgnoresMemoryLeakInSetUpTearDown := f.ReadBool(cnRunners,
          'IgnoreSetUpTearDownLeaks', LProject.IgnoresMemoryLeakInSetUpTearDown);
        {$ENDIF}
      except
      end;
    end;
  finally
    f.free
  end
end;

function TProjectManager.get_Projects: ITestProject;
begin
  Result := FMultiProjectSuite;
end;

procedure TProjectManager.set_Projects(const Value: ITestProject);
begin
  FMultiProjectSuite := Value;
end;


{ TMultiProjectSuite }

function TMultiProjectSuite.FindFirstTest: ITest;
begin
  Result := FTestIterator.FindFirstTest;
  FForceFindFirstTest := False;
end;

function TMultiProjectSuite.FindNextTest: ITest;
var
  LProject: ITestProject;
begin
  Result := nil;
  LProject := FTestIterator.PriorTest as ITestProject;
  LProject := FTestIterator.FindNextTest as ITestProject;
  if Assigned(LProject) then
  begin
    if FForceFindFirstTest then
    begin
      Result := LProject.FindFirstTest;
      FForceFindFirstTest := False;
    end
    else
      Result := LProject.FindNextTest;

    if not Assigned(Result) then
    begin
      Result := FTestIterator.FindNextTest as ITestProject;
      FForceFindFirstTest := True;
    end;
  end;
end;

function TMultiProjectSuite.ExecutionControl: ITestExecControl;
var
  LProjectManager: IProjectManager;
begin
  if (FExecControl = nil) then
  begin
    LProjectManager := Manager as IProjectManager;
    FExecControl := LProjectManager.Project[0].ExecutionControl;
  end;
  Result := FExecControl;
end;

procedure TMultiProjectSuite.LoadConfiguration(const FileName: string;
                                               const useRegistry, useMemIni: Boolean);
var
  LProjectManager: IProjectManager;
begin
  LProjectManager := Manager as IProjectManager;
  LProjectManager.LoadConfiguration(FileName, useRegistry, useMemIni);
end;

procedure TMultiProjectSuite.SaveConfiguration(const FileName: string;
                                               const useRegistry, useMemIni: Boolean);
var
  LProjectManager: IProjectManager;
begin
  LProjectManager := Manager as IProjectManager;
  LProjectManager.SaveConfiguration(FileName, useRegistry, useMemIni);
end;

end.
