//types from SDL_stdinc.h
type

  TSDL_Bool = (SDL_FALSE = 0,SDL_TRUE = 1);

  DWord = LongWord;

  PUInt8Array = ^TUInt8Array;
  {$IFDEF FPC}
    PUInt8 = pcuint8;
    PPUInt8 = ^pcuint8;
    //cuint8 = cuint8;
  {$ELSE}
    PUInt8 = ^cuint8;
    PPUInt8 = ^PUInt8;
    cuint8 = Byte;
  {$ENDIF}
  {$EXTERNALSYM cuint8}
  TUInt8Array = array [0..MAXINT shr 1] of cuint8;

  {$IFDEF FPC}
    PUInt16 = pcuint16;
    //cuint16 = cuint16;
  {$ELSE}
    PUInt16 = ^cuint16;
    cuint16 = Word;
  {$ENDIF}
  {$EXTERNALSYM cuint16}

  {$IFDEF FPC}
    PSInt8 = pcint8;
    //cint8 = cint8;
  {$ELSE}
    PSInt8 = ^cint8;
    cint8 = ShortInt;
  {$ENDIF}
  {$EXTERNALSYM cint8}

  {$IFDEF FPC}
    PSInt16 = pcint16;
    //cint16 = cint16;
  {$ELSE}
    PSInt16 = ^cint16;
    cint16 = SmallInt;
  {$ENDIF}
  {$EXTERNALSYM cint16}

  {$IFDEF FPC}
    PUInt32 = pcuint32;
    //cuint32 = cuint32;
  {$ELSE}
    PUInt32 = ^cuint32;
    cuint32 = Cardinal;
  {$ENDIF}
  {$EXTERNALSYM cuint32}

  {$IFDEF FPC}
    PFloat = pcfloat;
    Float = cfloat;
  {$ELSE}
    PFloat = ^Float;
    Float = Single;
  {$ENDIF}
  {$EXTERNALSYM Float}

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
    PUInt64 = pcuint64;
    //cuint64 = cuint64;
    {$EXTERNALSYM cuint64}

    PInt64 = pcint64;
    Int64 = cint64;
    {$EXTERNALSYM Int64}

    PSInt64 = PInt64;
    cint64 = Int64;
    {$EXTERNALSYM cint64}
  {$ELSE}
    {$IFNDEF Has_Int64}
      PUInt64 = ^cuint64;
      cuint64 = record
        hi: cuint32;
        lo: cuint32;
      end;
      {$EXTERNALSYM cuint64}

      PInt64 = ^Int64;
      Int64 = record
        hi: cuint32;
        lo: cuint32;
      end;
    {$EXTERNALSYM Int64}

    PSInt64 = ^cint64;
    cint64 = Int64;
    {$EXTERNALSYM cint64}
    {$ELSE}

      { Int64/cuint64 def. missing here ? }

      PSInt64 = ^cint64;
      cint64 = Int64;
    {$ENDIF}
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
