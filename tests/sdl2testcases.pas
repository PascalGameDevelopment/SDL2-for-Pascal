unit sdl2testcases;

{

  sdl2testcases - Test cases for the SDL2-for-Pascal units

  Implementation of the test cases.

  This file is part of

    SDL2-for-Pascal
    Copyright (C) 2020-2023 PGD Community
    Visit: https://github.com/PascalGameDevelopment/SDL2-for-Pascal

}

{$mode ObjFPC}{$H+}

interface

uses
  TestFramework;

type
  TTestCaseInit = class(TTestCase)
  published
    { Test initilization of SDL2 system with a sample of flags.  }
    procedure TestInit;
  end;

type

  { TTestCaseBasic }

  TTestCaseBasic = class(TTestCase)
  protected
    procedure SetUpOnce; override;
    procedure TeardownOnce; override;
  published
    { Test version macros/functions of SDL2 system. }
    procedure TestVersion;
  end;


procedure RegisterTests;


implementation

uses
  Classes,
  SysUtils,
  SDL2;

{ here we register all our test classes }
procedure RegisterTests;
begin
  TestFramework.RegisterTest(TTestCaseInit.Suite);
  TestFrameWork.RegisterTest(TTestCaseBasic.Suite);
end;

procedure TTestCaseInit.TestInit;
const
  Flags: array[0..12] of TSDL_Init = (
    { single flags }
    SDL_INIT_TIMER, SDL_INIT_AUDIO, SDL_INIT_VIDEO,
    SDL_INIT_JOYSTICK, SDL_INIT_HAPTIC, SDL_INIT_GAMECONTROLLER,
    SDL_INIT_EVENTS, SDL_INIT_SENSOR, SDL_INIT_NOPARACHUTE,
    SDL_INIT_EVERYTHING,
    { typically combined flags }
    SDL_INIT_AUDIO or SDL_INIT_VIDEO,
    SDL_INIT_VIDEO or SDL_INIT_JOYSTICK,
    SDL_INIT_VIDEO or SDL_INIT_GAMECONTROLLER or SDL_INIT_AUDIO);
var
  Flag: TSDL_Init;
begin
  for Flag in Flags do
  begin
    CheckEquals(0, SDL_Init(Flag), 'SDL_Init failed: Flag = ' + IntToStr(Flag));
    SDL_Quit;
  end;
end;

procedure TTestCaseBasic.SetUpOnce;
begin
  inherited SetUpOnce;
  SDL_Init(SDL_INIT_EVERYTHING);
end;

procedure TTestCaseBasic.TeardownOnce;
begin
  SDL_Quit;
  inherited TeardownOnce;
end;

procedure TTestCaseBasic.TestVersion;
var
  CompiledVersion: TSDL_Version = (major: 0; minor: 0; patch: 0);
  LinkedVersion: TSDL_Version = (major: 0; minor: 0; patch: 0);
begin
  CheckEquals(1203, SDL_VERSIONNUM(1,2,3), 'SDL_VERSIONNUM failed: 1203 expected, found: ' + IntToStr(SDL_VERSIONNUM(1,2,3)));

  SDL_VERSION(CompiledVersion);
  CheckEquals(SDL_COMPILEDVERSION, SDL_VERSIONNUM(CompiledVersion.major, CompiledVersion.minor, CompiledVersion.patch), 'SDL_VERSION or SDL_COMPILEDVERSION failed: Version results do not match!');

  CheckTrue(SDL_VERSION_ATLEAST(2,0,0), 'SDL_VERSION_ATLEAST failed: Version at least 2.0.0 should be true!');

  CheckFalse(SDL_VERSION_ATLEAST(3,0,0), 'SDL_VERSION_ATLEAST failed: Version at least 3.0.0 should be false!');

  SDL_GetVersion(@LinkedVersion);
  CheckNotNull(@LinkedVersion, 'SDL_GetVersion failed');
end;

end.

