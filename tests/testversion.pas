program testversion;

{

  Test version macros/functions of SDL2 system.

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

var
  CompiledVersion: TSDL_Version = (major: 0; minor: 0; patch: 0);
  LinkedVersion: TSDL_Version = (major: 0; minor: 0; patch: 0);
  VersionNum: Cardinal = 0;
begin
  write('Start SDL2 version test... ');

  try
    VersionNum := SDL_VERSIONNUM(1,2,3);
    if (VersionNum <> 1203) then
      raise ESDL2Error.Create('SDL_VERSIONNUM failed: 1203 expected, found: ' + IntToStr(VersionNum));

    SDL_VERSION(CompiledVersion);
    if (SDL_COMPILEDVERSION <> SDL_VERSIONNUM(CompiledVersion.major, CompiledVersion.minor, CompiledVersion.patch)) then
      raise ESDL2Error.Create('SDL_VERSION or SDL_COMPILEDVERSION failed: Version results do not match!');

    if not SDL_VERSION_ATLEAST(2,0,0) then
      raise ESDL2Error.Create('SDL_VERSION_ATLEAST failed: Version at least 2.0.0 should be true!');

    if SDL_VERSION_ATLEAST(3,0,0) then
      raise ESDL2Error.Create('SDL_VERSION_ATLEAST failed: Version at least 3.0.0 should be false!');

    SDL_GetVersion(@LinkedVersion);
    if @LinkedVersion = nil then
      raise ESDL2Error.Create('SDL_GetVersion failed: ' + SDL_GetError());

    if SDL_VERSIONNUM(LinkedVersion.major, LinkedVersion.minor, LinkedVersion.patch) = 0 then
      raise ESDL2Error.Create('SDL_GetVersion failed: Returns 0.0.0 .');
  except
  end;

  writeln('finished.');
end.

