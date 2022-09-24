//types from SDL_stdinc.h

{ SDL-For-Pascal: A lot of the functions are missing. Some functions are useless
                  if working with Pascal (e. g. memory management functions),
                  others could be useful (e. g. math functions).

  TODO: Investigate header file and translate potentially useful functions. }

type
  TSDL_Bool = cbool;

const
  SDL_FALSE = TSDL_Bool(0);
  SDL_TRUE  = TSDL_Bool(1);

{**
*  Free memory returned by functions like SDL_GetBasePath(), SDL_GetPrefPath(), etc.
*}
procedure SDL_free(mem: Pointer); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_free' {$ENDIF} {$ENDIF};
