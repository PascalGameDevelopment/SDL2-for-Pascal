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
 * Graeme Geldenhuys <graemeg@gmail.com>
 *
 *******************************************************************************
*)
unit TestExtensions;

{$IFDEF FPC}
  {$mode delphi}{$H+}
  {$UNDEF FASTMM}
{$ELSE}
  // If Delphi 7, turn off UNSAFE_* Warnings
  {$IFNDEF VER130}
    {$IFNDEF VER140}
      {$WARN UNSAFE_CODE OFF}
      {$WARN UNSAFE_CAST OFF}
    {$ENDIF}
  {$ENDIF}
{$ENDIF}

interface

uses
  TestFrameworkIfaces,
  TestFramework,
  Classes;

type
  ITestSetup = interface(ITestDecorator)
  ['{68B30444-F03D-4F57-A10D-DCC45381B126}']
  end;

  TTestSetup = class(TTestDecorator, ITestSetup)
  protected
    function GetName: string; override;
  end;


implementation

uses
  SysUtils;

{ TTestSetup }

function TTestSetup.GetName: string;
begin
  Result := Format('Setup decorator (%s)', [DisplayedName]);
end;

end.
