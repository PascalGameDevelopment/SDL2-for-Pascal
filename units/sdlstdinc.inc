//types from SDL_stdinc.h

type
  TSDL_Bool = type cint;

const
  SDL_FALSE = TSDL_Bool(0);
  SDL_TRUE  = TSDL_Bool(1);

{**
*  Free memory returned by functions like SDL_GetBasePath(), SDL_GetPrefPath(), etc.
*}
procedure SDL_free(mem: Pointer); cdecl; external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_free' {$ENDIF} {$ENDIF};
