// C-types

{

type

  pcint8 = ^cint8;
  cint8 = ShortInt;
  {$EXTERNALSYM cint8}

  //ppcuint8 = ^pcuint8; // See sdlstdinc.inc!
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




  cint = Integer;

  {$IFNDEF WIN64}
    csize_t = cuint32;
  {$ELSE}
    csize_t = cuint64;
  {$ENDIF}
  {$EXTERNALSYM SIZE_T}

  pcfloat = ^cfloat;
  cfloat = Single;
  {$EXTERNALSYM cfloat}
}
