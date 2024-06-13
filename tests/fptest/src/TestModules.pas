{ $Id: TestModules.pas,v 1.7 2006/07/19 02:45:55 judc Exp $ }
{: DUnit: An XTreme testing framework for Delphi programs.
   @author  The DUnit Group.
   @version $Revision: 1.7 $ 2001/03/08 uberto
}
{#(@)$Id: $ }
{  DUnit: An XTreme testing framework for Delphi programs. }
(*
 * The contents of this file are subject to the Mozilla Public
 * License Version 1.1 (the "License"); you may not use this file
 * except in compliance with the License. You may obtain a copy of
 * the License at http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS
 * IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
 * implied. See the License for the specific language governing
 * rights and limitations under the License.
 *
 * The Original Code is DUnit.
 *
 * The Initial Developers of the Original Code are Kent Beck, Erich Gamma,
 * and Juancarlo Añez.
 * Portions created The Initial Developers are Copyright (C) 1999-2000.
 * Portions created by The DUnit Group are Copyright (C) 2000-2008.
 * All rights reserved.
 *
 * Contributor(s):
 * Kent Beck <kentbeck@csi.com>
 * Erich Gamma <Erich_Gamma@oti.com>
 * Juanco Añez <juanco@users.sourceforge.net>
 * Chris Morris <chrismo@users.sourceforge.net>
 * Jeff Moore <JeffMoore@users.sourceforge.net>
 * Uberto Barbini <uberto@usa.net>
 * Brett Shearer <BrettShearer@users.sourceforge.net>
 * Kris Golko <neuromancer@users.sourceforge.net>
 * The DUnit group at SourceForge <http://dunit.sourceforge.net>
 * Peter McNab <mcnabp@gmail.com>
 *
 *******************************************************************************
*)
unit TestModules;

interface
uses
  Windows,
  TestFrameworkIFaces;

const
  rcs_id :string = '#(@)$Id: TestModules.pas,v 1.7 2006/07/19 02:45:55 judc Exp $';

type
  TModuleRecord = record
    Handle :THandle;
    Test   :ITestCase;
  end;

  TGetTestFunc = function :ITestProject;

var
  __Modules   :array of TModuleRecord = nil;

function  LoadModuleTests(LibName: string) :ITestProject;
procedure RegisterModuleTests(LibName: string);
procedure UnloadTestModules;

implementation
uses
  TestFramework,
  SysUtils;

function LoadModuleTests(LibName: string) :ITestProject;
var
  LibHandle: THandle;
  GetTest: TGetTestFunc;
  U: IUnknown;
begin
  Result := nil;
  if ExtractFileExt(LibName) = '' then
  begin
    LibName := ChangeFileExt(LibName, '.dll');
    if not FileExists(LibName) then
       LibName := ChangeFileExt(LibName, '.dtl');
  end;

  LibHandle := LoadLibrary(PChar(LibName));
  if LibHandle = 0 then
    raise EDUnitException.Create(Format('Could not load module %s: %s', [LibName, SysErrorMessage(GetLastError)]))
  else
  begin
    GetTest := GetProcAddress(LibHandle, 'Test');
    if not Assigned(GetTest) then
      raise EDUnitException.Create(Format('Module "%s" does not export a "Test" function: %s', [LibName, SysErrorMessage(GetLastError)]))
    else
    begin
      U := GetTest;
      Assert(U <> nil, 'Cannot retrieve interface from DLL ' +  LibName);

      try
        Result := (U as ITestProject);
        Result.DisplayedName := LibName;
        SetLength(__Modules, 1 + Length(__Modules));
        __Modules[High(__Modules)].Handle := LibHandle;
        __Modules[High(__Modules)].Test   := Result;
      except
        on E: Exception do
          raise EDUnitException.Create(Format('Module "%s.Test" did not return an ITestProject', [LibName]))
      end;
    end;
  end;
end;

procedure RegisterModuleTests(LibName: string);
begin
  RegisterProject(ExtractFileName(LibName), LoadModuleTests(LibName));
end;

procedure UnloadTestModules;
var
  i :Integer;
begin
  for i := Low(__Modules) to High(__Modules) do
  begin
    __Modules[i].Test := nil;
    FreeLibrary(__Modules[i].Handle);
  end;
  __Modules := nil;
end;

initialization

finalization
  UnloadTestModules;
end.
