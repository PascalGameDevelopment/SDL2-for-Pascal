//types from SDL_stdinc.h
type

  TSDL_Bool = (SDL_FALSE = 0,SDL_TRUE = 1);

  DWord = LongWord;

  PUInt8Array = ^TUInt8Array;
  TUInt8Array = array [0..MAXINT shr 1] of cuint8;

  ppcuint8 = ^pcuint8;

  {$IFDEF FPC}
    PInt = pcint;
  {$ELSE}
    PInt = ^LongInt;
  {$ENDIF}

  {$IFDEF FPC}
    PShortInt = pcshort;
  {$ELSE}
    PShortInt = ^ShortInt;
  {$ENDIF}

  {$IFDEF FPC}
    //csize_t = csize_t;
  {$ELSE}
    {$IFNDEF WIN64}
      csize_t = cuint32;
    {$ELSE}
      csize_t = cuint64;
    {$ENDIF}
  {$ENDIF}
  {$EXTERNALSYM SIZE_T}


{**
*  Free memory returned by functions like SDL_GetBasePath(), SDL_GetPrefPath(), etc.
*}
procedure SDL_free(mem: Pointer); cdecl; external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_free' {$ENDIF} {$ENDIF};
