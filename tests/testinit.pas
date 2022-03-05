program testinit;

{

  Test initilization of SDL2 system with a sample of flags.

  This file is part of

    SDL2-for-Pascal
    Copyright (C) 2020-2022 PGD Community
    Visit: https://github.com/PascalGameDevelopment/SDL2-for-Pascal

}

{$I testsettings.inc}

uses
  Classes, SysUtils, SDL2;

type
  ESDL2Error = class(Exception);

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
  write('Start SDL2 inilization test... ');
  for Flag in Flags do
  begin
    try
      if SDL_Init(Flag) <> 0 then
        raise ESDL2Error.Create('SDL_Init failed: Flag = ' + IntToStr(Flag));
    except
      on E: ESDL2Error do
      try
        SDL_Quit;
      except
        raise;
      end;
    end;
    SDL_Quit;
  end;
  writeln(' finished.');
end.

