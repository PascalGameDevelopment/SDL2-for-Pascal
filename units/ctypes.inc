// C data types

{
  Simple DirectMedia Layer
  Copyright (C) 1997-2013 Sam Lantinga <slouken@libsdl.org>

  Pascal-Header-Conversion
  Copyright (C) 2012-2020 Tim Blume aka End/EV1313

  SDL2-for-Pascal
  Copyright (C) 2020-2021 PGD Community

  This file is part of the project above. It has solely the purpose
  to map common C data types correctly by Pascal compilers.

  FPC: Most C data types are found in the native ctypes unit.
  Delphi + others: Relies on this file for C data type mapping.

  These native C types should be strictly separated from
  types defined by SDL which can be found in sdlstdinc.inc.
}

{$IFNDEF FPC}
type
  DWord = LongWord;

  pcbool = ^cbool;
  cbool = LongBool;
  {$EXTERNALSYM cbool}

  pcint = ^cint;
  cint = Integer;
  {$EXTERNALSYM cint}

  pcint8 = ^cint8;
  cint8 = ShortInt;
  {$EXTERNALSYM cint8}

  pcuint8 = ^cuint8;
  cuint8 = Byte;
  {$EXTERNALSYM cuint8}

  pcint16 = ^cint16;
  cint16 = SmallInt;
  {$EXTERNALSYM cint16}

  pcuint16 = ^cuint16;
  cuint16 = Word;
  {$EXTERNALSYM cuint16}

  pcushort = ^cushort;
  cushort = Word;
  {$EXTERNALSYM cushort}

  pcint32 = ^cint32;
  cint32 = LongInt;
  {$EXTERNALSYM cint32}

  pcuint32 = ^cuint32;
  cuint32 = LongWord;
  {$EXTERNALSYM cuint32}

  culong = LongWord;
  {$EXTERNALSYM culong}

  cuint = LongWord;
  {$EXTERNALSYM cuint}

  {$IFNDEF Has_Int64}
     pcint64 = ^cint64;
     cint64 = record
       hi: cuint32;
       lo: cuint32;
     end;
    {$EXTERNALSYM cint64}

    pcuint64 = ^cuint64;
    cuint64 = record
      hi: cuint32;
      lo: cuint32;
    end;
    {$EXTERNALSYM cuint64}
  {$ELSE}
    pcint64 = ^cint64;
    cint64 = Int64;
    {$EXTERNALSYM cint64}

    pcuint64 = ^cuint64;
    cuint64 = UInt64;
    {$EXTERNALSYM cuint64}
  {$ENDIF}

  pcsize_t = ^csize_t;
  {$IFNDEF WIN64}
    csize_t = cuint32;
  {$ELSE}
    csize_t = cuint64;
  {$ENDIF}
  {$EXTERNALSYM SIZE_T}

  pcfloat = ^cfloat;
  cfloat = Single;
  {$EXTERNALSYM cfloat}
{$ENDIF}

{ Data types for all compilers }
type
  PUInt8Array = ^TUInt8Array;
  TUInt8Array = array [0..MAXINT shr 1] of cuint8;

  ppcuint8 = ^pcuint8;

  (* wchar_t is the "wide character" type of the C language.
   * The size of this type is platform- and compiler-dependent.
   *
   * While FPC does have it's own "wide character" type, System.WideChar,
   * that one is defined as always being 16-bits, so we can't re-use it here.
   *
   * When using FPC on Unices, the UnixType unit provides a wchar_t definition.
   *
   * On other systems/compiler combos, let's just go
   * by what the CPP reference wiki claims, i.e:
   * - wchar_t is 16-bits on Windows
   * - wchar_t is 32-bits on Linux "and many other non-Windows systems"
   *
   * See: https://en.cppreference.com/w/cpp/language/types#Character_types
   *)
  {$IF DEFINED(FPC) AND DEFINED(UNIX)}
    cwchar_t = UnixType.wchar_t;
  {$ELSE}
    {$IF DEFINED(WIN32) OR DEFINED(WIN64)}
      cwchar_t = cuint16;
    {$ELSE}
      cwchar_t = cuint32;
    {$ENDIF}
  {$ENDIF}
  {$EXTERNALSYM cwchar_t}
  pcwchar_t = ^cwchar_t;
