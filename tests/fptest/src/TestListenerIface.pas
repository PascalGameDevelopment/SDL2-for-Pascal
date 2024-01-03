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

unit TestListenerIface;

{$IFDEF FPC}
  {$mode delphi}{$H+}
{$ENDIF}

interface

uses
  TestFrameworkIfaces,
  TestFrameworkProxyIfaces;
  
type
  IProgressSummary = interface
   ['{9F32649C-6E3B-46E6-A94F-9E17A2A8175A}']

    function  get_Errors: Integer;
    function  get_Failures: Integer;
    function  get_Warnings: Integer;
    function  get_TestsExcluded: Integer;
    function  get_TestsExecuted: Cardinal;
    function  Updated: boolean;
    procedure UpdateSummary(const ExecControl: ITestExecControl);
    property  Errors: Integer read get_Errors;
    property  Failures: Integer read get_Failures;
    property  Warnings: Integer read get_Warnings;
    property  TestsExecuted: Cardinal read get_TestsExecuted;
    property  TestsExcluded: Integer read get_TestsExcluded;
  end;

  ITestListenerProxy = interface
  ['{0B14441B-7193-4250-94B3-216F802ED665}']

    procedure AddListener(const Listener: ITestListener); overload;
    procedure TestingStarts;
    procedure StartSuite(Suite: ITest);
    procedure StartTest(Test: ITest);
    procedure EndTest(Test: ITest);
    procedure EndSuite(Suite: ITest);
    procedure TestingEnds;
    procedure ReleaseListeners;
    function  ShouldRunTest(const ATest :ITest) :Boolean;
    procedure Status(const ATest: ITest; const AMessage: string);
  end;

const
  cnRunners = 'DUnitCommon';

implementation

end.
