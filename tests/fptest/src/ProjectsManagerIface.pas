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

unit ProjectsManagerIface;

{$IFDEF FPC}
  {$mode delphi}{$H+}
{$ENDIF}

interface

uses
  TestFrameworkIfaces,
  TestListenerIface;

const
  DefaultProject = 'Default Project'; // Default project title;

type
  IProjectManager = interface
  ['{B059F5CD-64C5-46F1-8E2F-4A9F9CFBB291}']

    function  get_Project(const idx: integer): ITestProject;
    procedure set_Project(const idx: integer; const AProject: ITestProject);
    property  Project[const index: integer]: ITestProject read get_Project write set_Project;
    function  get_Projects: ITestProject;
    procedure set_Projects(const Value: ITestProject);
    property  Projects: ITestProject read get_Projects write set_Projects;
    function  get_Count: integer;
    property  Count: integer read get_Count;
    function  FindProjectID(const AName: string): integer;
    procedure SaveConfiguration(const FileName: string; const useRegistry, useMemIni: Boolean);
    procedure LoadConfiguration(const FileName: string; const useRegistry, useMemIni: Boolean);

    procedure AddListener(const Listener: ITestListenerProxy); overload;
    procedure RemoveListener(const ProjectID: integer; const Listener: ITestListenerProxy); overload;
    procedure RemoveListener(const Listener: ITestListenerProxy); overload;
    procedure AddListener(const ProjectID: integer; const Listener: ITestListenerProxy); overload;
    procedure ReleaseProject(const AProject: ITestProject);
    procedure ReleaseProjects;
    function  AddProject(const AProject: ITestProject): integer;
  end;

implementation

end.
