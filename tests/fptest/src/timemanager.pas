{
    This unit pulls in the EpikTimer dependency. EpikTimer is platform
    independent and replaces Windows.QueryPerformanceCounter() calls.
}
unit TimeManager;

{$mode objfpc}{$H+}

interface

uses
  EpikTimer;

// Simple singleton to access the timer.
function gTimer: TEpikTimer;

// Convert elapsed time in seconds.milliseconds into human readable DD:HH:MM:SS.zzz string format
function ElapsedDHMS(const AElapsed: Extended; const APrecision: integer = 3; const AWantDays: boolean = false; const AWantMS: boolean = True): String;


implementation

uses
  SysUtils;

var
  uTimer: TEpikTimer;

function gTimer: TEpikTimer;
begin
  if not Assigned(uTimer) then
    uTimer := TEpikTimer.Create(nil);
  Result := uTimer;
end;


// Convert elapsed time in seconds.milliseconds into human readable DD:HH:MM:SS.zzz string format
function ElapsedDHMS(const AElapsed: Extended; const APrecision: integer = 3; const AWantDays: boolean = false; const AWantMS: boolean = True): String;
var
  Tmp, MS: extended;
  D, H, M, S: Integer;
  P, SM: string;
begin
  Tmp := AElapsed;
  P := inttostr(APrecision);
    MS := frac(Tmp);
    SM:=format('%0.'+P+'f',[MS]);
    delete(SM,1,1);
  D := trunc(Tmp / 84600);
    Tmp:=Trunc(tmp) mod 84600;
  H := trunc(Tmp / 3600);
    Tmp:=Trunc(Tmp) mod 3600;
  M := Trunc(Tmp / 60);
    S:=(trunc(Tmp) mod 60);
  If AWantDays then
    Result := format('%2.3d:%2.2d:%2.2d:%2.2d',[D,H,M,S])
  else
    Result := format('%2.2d:%2.2d:%2.2d',[H,M,S]);
  If AWantMS then
    Result := Result+SM;
end;



initialization
  uTimer := nil;

finalization
  uTimer.Free;

end.

