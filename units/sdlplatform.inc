// based on "sdl_platform.h" (2.0.14)

{**
 *  Gets the name of the platform.
 *}
function SDL_GetPlatform: PAnsiChar cdecl; external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetPlatform' {$ENDIF} {$ENDIF};
