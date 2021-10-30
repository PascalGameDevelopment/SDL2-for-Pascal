//types from SDL_stdinc.h
type

  TSDL_Bool = (SDL_FALSE = 0,SDL_TRUE = 1);

{**
*  Free memory returned by functions like SDL_GetBasePath(), SDL_GetPrefPath(), etc.
*}
procedure SDL_free(mem: Pointer); cdecl; external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_free' {$ENDIF} {$ENDIF};
