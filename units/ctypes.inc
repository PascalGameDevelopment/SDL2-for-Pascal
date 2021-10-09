// C-types

{

type

  cint8 = ShortInt;
  cuint8 = Byte;
  cint16 = SmallInt;
  cuint16 = Word;
  cint32 = LongInt;
  cuint32 = LongWord;
  cint64 = Int64;
  cuint64 = UInt64;

  {$IFNDEF WIN64}
    csize_t = cuint32;
  {$ELSE}
    csize_t = cuint64;
  {$ENDIF}
  {$EXTERNALSYM SIZE_T}
}
