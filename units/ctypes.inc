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

