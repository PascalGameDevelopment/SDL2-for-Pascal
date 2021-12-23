// based on "sdl_pixels.h" (2.0.14, WIP)

{**
 *  \file SDL_pixels.h
 *
 *  Header for the enumerated pixel format definitions.
 *}

{**
 *  Transparency definitions
 *
 *  These define alpha as the opacity of a surface.
 *}

const
  SDL_ALPHA_OPAQUE = 255;
  SDL_ALPHA_TRANSPARENT = 0;

{** Pixel type. *}
type
  TSDL_PixelType = type Cardinal;

const
  SDL_PIXELTYPE_UNKNOWN  = TSDL_PixelType(0);
  SDL_PIXELTYPE_INDEX1   = TSDL_PixelType(1);
  SDL_PIXELTYPE_INDEX4   = TSDL_PixelType(2);
  SDL_PIXELTYPE_INDEX8   = TSDL_PixelType(3);
  SDL_PIXELTYPE_PACKED8  = TSDL_PixelType(4);
  SDL_PIXELTYPE_PACKED16 = TSDL_PixelType(5);
  SDL_PIXELTYPE_PACKED32 = TSDL_PixelType(6);
  SDL_PIXELTYPE_ARRAYU8  = TSDL_PixelType(7);
  SDL_PIXELTYPE_ARRAYU16 = TSDL_PixelType(8);
  SDL_PIXELTYPE_ARRAYU32 = TSDL_PixelType(9);
  SDL_PIXELTYPE_ARRAYF16 = TSDL_PixelType(10);
  SDL_PIXELTYPE_ARRAYF32 = TSDL_PixelType(11);

{** Bitmap pixel order, high bit -> low bit. *}
type
  TSDL_BitmapOrder = type Cardinal;

const
  SDL_BITMAPORDER_NONE = TSDL_BitmapOrder(0);
  SDL_BITMAPORDER_4321 = TSDL_BitmapOrder(1);
  SDL_BITMAPORDER_1234 = TSDL_BitmapOrder(2);

{** Packed component order, high bit -> low bit. *}
type
  TSDL_PackOrder = type Cardinal;

const
  SDL_PACKEDORDER_NONE = TSDL_PackOrder(0);
  SDL_PACKEDORDER_XRGB = TSDL_PackOrder(1);
  SDL_PACKEDORDER_RGBX = TSDL_PackOrder(2);
  SDL_PACKEDORDER_ARGB = TSDL_PackOrder(3);
  SDL_PACKEDORDER_RGBA = TSDL_PackOrder(4);
  SDL_PACKEDORDER_XBGR = TSDL_PackOrder(5);
  SDL_PACKEDORDER_BGRX = TSDL_PackOrder(6);
  SDL_PACKEDORDER_ABGR = TSDL_PackOrder(7);
  SDL_PACKEDORDER_BGRA = TSDL_PackOrder(8);

{** Array component order, low byte -> high byte. *}
type
  TSDL_ArrayOrder = type Cardinal;

const
  SDL_ARRAYORDER_NONE = TSDL_ArrayOrder(0);
  SDL_ARRAYORDER_RGB  = TSDL_ArrayOrder(1);
  SDL_ARRAYORDER_RGBA = TSDL_ArrayOrder(2);
  SDL_ARRAYORDER_ARGB = TSDL_ArrayOrder(3);
  SDL_ARRAYORDER_BGR  = TSDL_ArrayOrder(4);
  SDL_ARRAYORDER_BGRA = TSDL_ArrayOrder(5);
  SDL_ARRAYORDER_ABGR = TSDL_ArrayOrder(6);

{** Packed component layout. *}
type
  TSDL_PackedLayout = type Cardinal;

const
  SDL_PACKEDLAYOUT_NONE    = TSDL_PackedLayout(0);
  SDL_PACKEDLAYOUT_332     = TSDL_PackedLayout(1);
  SDL_PACKEDLAYOUT_4444    = TSDL_PackedLayout(2);
  SDL_PACKEDLAYOUT_1555    = TSDL_PackedLayout(3);
  SDL_PACKEDLAYOUT_5551    = TSDL_PackedLayout(4);
  SDL_PACKEDLAYOUT_565     = TSDL_PackedLayout(5);
  SDL_PACKEDLAYOUT_8888    = TSDL_PackedLayout(6);
  SDL_PACKEDLAYOUT_2101010 = TSDL_PackedLayout(7);
  SDL_PACKEDLAYOUT_1010102 = TSDL_PackedLayout(8);

    {
        //todo!!
function SDL_DEFINE_PIXELFORMAT(type, order, layour, bit, bytes: cuint32): Result;

function SDL_DEFINE_PIXELFOURCC(A,B,C,D: Variant): Variant;

#define SDL_DEFINE_PIXELFORMAT(type, order, layout, bits, bytes) \
    ((1 << 28) | ((type) << 24) | ((order) << 20) | ((layout) << 16) | \
     ((bits) << 8) | ((bytes) << 0))
       }

function SDL_PIXELFLAG(X: Cardinal): Cardinal;
function SDL_PIXELTYPE(X: Cardinal): Cardinal;
function SDL_PIXELORDER(X: Cardinal): Cardinal;
function SDL_PIXELLAYOUT(X: Cardinal): Cardinal;
function SDL_BITSPERPIXEL(X: Cardinal): Cardinal;
     {
#define SDL_BYTESPERPIXEL(X) \
    (SDL_ISPIXELFORMAT_FOURCC(X) ? \
        ((((X) == SDL_PIXELFORMAT_YUY2) || \
          ((X) == SDL_PIXELFORMAT_UYVY) || \
          ((X) == SDL_PIXELFORMAT_YVYU)) ? 2 : 1) : (((X) >> 0) & 0xFF))

#define SDL_ISPIXELFORMAT_INDEXED(format)   \
    (!SDL_ISPIXELFORMAT_FOURCC(format) && \
     ((SDL_PIXELTYPE(format) == SDL_PIXELTYPE_INDEX1) || \
      (SDL_PIXELTYPE(format) == SDL_PIXELTYPE_INDEX4) || \
      (SDL_PIXELTYPE(format) == SDL_PIXELTYPE_INDEX8)))

#define SDL_ISPIXELFORMAT_PACKED(format) \
    (!SDL_ISPIXELFORMAT_FOURCC(format) && \
     ((SDL_PIXELTYPE(format) == SDL_PIXELTYPE_PACKED8) || \
      (SDL_PIXELTYPE(format) == SDL_PIXELTYPE_PACKED16) || \
      (SDL_PIXELTYPE(format) == SDL_PIXELTYPE_PACKED32)))

#define SDL_ISPIXELFORMAT_ARRAY(format) \
    (!SDL_ISPIXELFORMAT_FOURCC(format) && \
     ((SDL_PIXELTYPE(format) == SDL_PIXELTYPE_ARRAYU8) || \
      (SDL_PIXELTYPE(format) == SDL_PIXELTYPE_ARRAYU16) || \
      (SDL_PIXELTYPE(format) == SDL_PIXELTYPE_ARRAYU32) || \
      (SDL_PIXELTYPE(format) == SDL_PIXELTYPE_ARRAYF16) || \
      (SDL_PIXELTYPE(format) == SDL_PIXELTYPE_ARRAYF32)))

#define SDL_ISPIXELFORMAT_ALPHA(format)   \
    ((SDL_ISPIXELFORMAT_PACKED(format) && \
     ((SDL_PIXELORDER(format) == SDL_PACKEDORDER_ARGB) || \
      (SDL_PIXELORDER(format) == SDL_PACKEDORDER_RGBA) || \
      (SDL_PIXELORDER(format) == SDL_PACKEDORDER_ABGR) || \
      (SDL_PIXELORDER(format) == SDL_PACKEDORDER_BGRA))) || \
    (SDL_ISPIXELFORMAT_ARRAY(format) && \
     ((SDL_PIXELORDER(format) == SDL_ARRAYORDER_ARGB) || \
      (SDL_PIXELORDER(format) == SDL_ARRAYORDER_RGBA) || \
      (SDL_PIXELORDER(format) == SDL_ARRAYORDER_ABGR) || \
      (SDL_PIXELORDER(format) == SDL_ARRAYORDER_BGRA))))
       }

{* The flag is set to 1 because 0x1? is not in the printable ASCII range *}
function SDL_ISPIXELFORMAT_FOURCC(format: Variant): Boolean;

  { TODO : Use SDL_DEFINE_FORMAT macro? Examine results in detail. }
{* Note: If you modify this list, update SDL_GetPixelFormatName() *}
const
    SDL_PIXELFORMAT_UNKNOWN = 0;
    SDL_PIXELFORMAT_INDEX1LSB = (1 shl 28)                    or
                                (SDL_PIXELTYPE_INDEX1 shl 24) or
                                (SDL_BITMAPORDER_4321 shl 20) or
                                (0 shl 16)                    or
                                (1 shl 8)                     or
                                (0 shl 0);

    SDL_PIXELFORMAT_INDEX1MSB = (1 shl 28)                    or
                                (SDL_PIXELTYPE_INDEX1 shl 24) or
                                (SDL_BITMAPORDER_1234 shl 20) or
                                (0 shl 16)                    or
                                (1 shl 8)                     or
                                (0 shl 0);

    SDL_PIXELFORMAT_INDEX4LSB = (1 shl 28)                    or
                                (SDL_PIXELTYPE_INDEX4 shl 24) or
                                (SDL_BITMAPORDER_4321 shl 20) or
                                (0 shl 16)                    or
                                (4 shl 8)                     or
                                (0 shl 0);

    SDL_PIXELFORMAT_INDEX4MSB = (1 shl 28)                    or
                                (SDL_PIXELTYPE_INDEX4 shl 24) or
                                (SDL_BITMAPORDER_1234 shl 20) or
                                (0 shl 16)                    or
                                (4 shl 8)                     or
                                (0 shl 0);

    SDL_PIXELFORMAT_INDEX8 =    (1 shl 28)                      or
                                (SDL_PIXELTYPE_PACKED8 shl 24)  or
                                (0 shl 20)                      or
                                (0 shl 16)                      or
                                (8 shl 8)                       or
                                (1 shl 0);

    SDL_PIXELFORMAT_RGB332 =    (1 shl 28)                      or
                                (SDL_PIXELTYPE_PACKED8 shl 24)  or
                                (SDL_PACKEDORDER_XRGB shl 20)   or
                                (SDL_PACKEDLAYOUT_332 shl 16)   or
                                (8 shl 8)                       or
                                (1 shl 0);

    SDL_PIXELFORMAT_RGB444 =    (1 shl 28)                      or
                                (SDL_PIXELTYPE_PACKED16 shl 24) or
                                (SDL_PACKEDORDER_XRGB shl 20)   or
                                (SDL_PACKEDLAYOUT_4444 shl 16)  or
                                (12 shl 8)                      or
                                (2 shl 0);

    SDL_PIXELFORMAT_RGB555 =    (1 shl 28)                      or
                                (SDL_PIXELTYPE_PACKED16 shl 24) or
                                (SDL_PACKEDORDER_XRGB shl 20)   or
                                (SDL_PACKEDLAYOUT_1555 shl 16)  or
                                (15 shl 8)                      or
                                (2 shl 0);

    SDL_PIXELFORMAT_BGR555 =    (1 shl 28)                      or
                                (SDL_PIXELTYPE_PACKED16 shl 24) or
                                (SDL_PACKEDORDER_XBGR shl 20)   or
                                (SDL_PACKEDLAYOUT_1555 shl 16)  or
                                (15 shl 8)                      or
                                (2 shl 0);

    SDL_PIXELFORMAT_ARGB4444 =  (1 shl 28)                      or
                                (SDL_PIXELTYPE_PACKED16 shl 24) or
                                (SDL_PACKEDORDER_ARGB shl 20)   or
                                (SDL_PACKEDLAYOUT_4444 shl 16)  or
                                (16 shl 8)                      or
                                (2 shl 0);

    SDL_PIXELFORMAT_RGBA4444 =  (1 shl 28)                      or
                                (SDL_PIXELTYPE_PACKED16 shl 24) or
                                (SDL_PACKEDORDER_RGBA shl 20)   or
                                (SDL_PACKEDLAYOUT_4444 shl 16)  or
                                (16 shl 8)                      or
                                (2 shl 0);

    SDL_PIXELFORMAT_ABGR4444 =  (1 shl 28)                      or
                                (SDL_PIXELTYPE_PACKED16 shl 24) or
                                (SDL_PACKEDORDER_ABGR shl 20)   or
                                (SDL_PACKEDLAYOUT_4444 shl 16)  or
                                (16 shl 8)                      or
                                (2 shl 0);

    SDL_PIXELFORMAT_BGRA4444 =  (1 shl 28)                      or
                                (SDL_PIXELTYPE_PACKED16 shl 24) or
                                (SDL_PACKEDORDER_BGRA shl 20)   or
                                (SDL_PACKEDLAYOUT_4444 shl 16)  or
                                (16 shl 8)                      or
                                (2 shl 0);

    SDL_PIXELFORMAT_ARGB1555 =  (1 shl 28)                      or
                                (SDL_PIXELTYPE_PACKED16 shl 24) or
                                (SDL_PACKEDORDER_ARGB shl 20)   or
                                (SDL_PACKEDLAYOUT_1555 shl 16)  or
                                (16 shl 8)                      or
                                (2 shl 0);

    SDL_PIXELFORMAT_RGBA5551 =  (1 shl 28)                      or
                                (SDL_PIXELTYPE_PACKED16 shl 24) or
                                (SDL_PACKEDORDER_RGBA shl 20)   or
                                (SDL_PACKEDLAYOUT_5551 shl 16)  or
                                (16 shl 8)                      or
                                (2 shl 0);

    SDL_PIXELFORMAT_ABGR1555 =  (1 shl 28)                      or
                                (SDL_PIXELTYPE_PACKED16 shl 24) or
                                (SDL_PACKEDORDER_ABGR shl 20)   or
                                (SDL_PACKEDLAYOUT_1555 shl 16)  or
                                (16 shl 8)                      or
                                (2 shl 0);

    SDL_PIXELFORMAT_BGRA5551 =  (1 shl 28)                      or
                                (SDL_PIXELTYPE_PACKED16 shl 24) or
                                (SDL_PACKEDORDER_BGRA shl 20)   or
                                (SDL_PACKEDLAYOUT_5551 shl 16)  or
                                (16 shl 8)                      or
                                (2 shl 0);

    SDL_PIXELFORMAT_RGB565 =    (1 shl 28)                      or
                                (SDL_PIXELTYPE_PACKED16 shl 24) or
                                (SDL_PACKEDORDER_XRGB shl 20)   or
                                (SDL_PACKEDLAYOUT_565 shl 16)   or
                                (16 shl 8)                      or
                                (2 shl 0);

    SDL_PIXELFORMAT_BGR565 =    (1 shl 28)                      or
                                (SDL_PIXELTYPE_PACKED16 shl 24) or
                                (SDL_PACKEDORDER_XBGR shl 20)   or
                                (SDL_PACKEDLAYOUT_1555 shl 16)  or
                                (16 shl 8)                      or
                                (2 shl 0);

    SDL_PIXELFORMAT_RGB24 =     (1 shl 28)                      or
                                (SDL_PIXELTYPE_ARRAYU8 shl 24)  or
                                (SDL_ARRAYORDER_RGB shl 20)     or
                                (0 shl 16)                      or
                                (24 shl 8)                      or
                                (3 shl 0);

    SDL_PIXELFORMAT_BGR24 =     (1 shl 28)                      or
                                (SDL_PIXELTYPE_ARRAYU8 shl 24)  or
                                (SDL_ARRAYORDER_BGR shl 20)     or
                                (0 shl 16)                      or
                                (24 shl 8)                      or
                                (3 shl 0);

    SDL_PIXELFORMAT_RGB888 =    (1 shl 28)                      or
                                (SDL_PIXELTYPE_PACKED32 shl 24) or
                                (SDL_PACKEDORDER_XRGB shl 20)   or
                                (SDL_PACKEDLAYOUT_8888 shl 16)  or
                                (24 shl 8)                      or
                                (4 shl 0);

    SDL_PIXELFORMAT_RGBX8888 =  (1 shl 28)                      or
                                (SDL_PIXELTYPE_PACKED32 shl 24) or
                                (SDL_PACKEDORDER_RGBX shl 20)   or
                                (SDL_PACKEDLAYOUT_8888 shl 16)  or
                                (24 shl 8)                      or
                                (4 shl 0);

    SDL_PIXELFORMAT_BGR888 =    (1 shl 28)                      or
                                (SDL_PIXELTYPE_PACKED32 shl 24) or
                                (SDL_PACKEDORDER_XBGR shl 20)   or
                                (SDL_PACKEDLAYOUT_8888 shl 16)  or
                                (24 shl 8)                      or
                                (4 shl 0);

    SDL_PIXELFORMAT_BGRX8888 =  (1 shl 28)                      or
                                (SDL_PIXELTYPE_PACKED32 shl 24) or
                                (SDL_PACKEDORDER_BGRX shl 20)   or
                                (SDL_PACKEDLAYOUT_8888 shl 16)  or
                                (24 shl 8)                      or
                                (4 shl 0);

    SDL_PIXELFORMAT_ARGB8888 =  (1 shl 28)                      or
                                (SDL_PIXELTYPE_PACKED32 shl 24) or
                                (SDL_PACKEDORDER_ARGB shl 20)   or
                                (SDL_PACKEDLAYOUT_8888 shl 16)  or
                                (32 shl 8)                      or
                                (4 shl 0);

    SDL_PIXELFORMAT_RGBA8888 =  (1 shl 28)                      or
                                (SDL_PIXELTYPE_PACKED32 shl 24) or
                                (SDL_PACKEDORDER_RGBA shl 20)   or
                                (SDL_PACKEDLAYOUT_8888 shl 16)  or
                                (32 shl 8)                      or
                                (4 shl 0);

    SDL_PIXELFORMAT_ABGR8888 =  (1 shl 28)                      or
                                (SDL_PIXELTYPE_PACKED32 shl 24) or
                                (SDL_PACKEDORDER_ABGR shl 20)   or
                                (SDL_PACKEDLAYOUT_8888 shl 16)  or
                                (32 shl 8)                      or
                                (4 shl 0);

    SDL_PIXELFORMAT_BGRA8888 =  (1 shl 28)                      or
                                (SDL_PIXELTYPE_PACKED32 shl 24) or
                                (SDL_PACKEDORDER_RGBX shl 20)   or
                                (SDL_PACKEDLAYOUT_8888 shl 16)  or
                                (32 shl 8)                      or
                                (4 shl 0);

    SDL_PIXELFORMAT_ARGB2101010 = (1 shl 28)                       or
                                  (SDL_PIXELTYPE_PACKED32 shl 24)  or
                                  (SDL_PACKEDORDER_ARGB shl 20)    or
                                  (SDL_PACKEDLAYOUT_2101010 shl 16)or
                                  (32 shl 8)                       or
                                  (4 shl 0);

    (* Aliases for RGBA byte arrays of color data, for the current platform *)
    {$IFDEF FPC}
      {$IF DEFINED(ENDIAN_LITTLE)}
        SDL_PIXELFORMAT_RGBA32 = SDL_PIXELFORMAT_ABGR8888;
        SDL_PIXELFORMAT_ARGB32 = SDL_PIXELFORMAT_BGRA8888;
        SDL_PIXELFORMAT_BGRA32 = SDL_PIXELFORMAT_ARGB8888;
        SDL_PIXELFORMAT_ABGR32 = SDL_PIXELFORMAT_RGBA8888;
      {$ELSEIF DEFINED(ENDIAN_BIG)}
        SDL_PIXELFORMAT_RGBA32 = SDL_PIXELFORMAT_RGBA8888;
        SDL_PIXELFORMAT_ARGB32 = SDL_PIXELFORMAT_ARGB8888;
        SDL_PIXELFORMAT_BGRA32 = SDL_PIXELFORMAT_BGRA8888;
        SDL_PIXELFORMAT_ABGR32 = SDL_PIXELFORMAT_ABGR8888;
      {$ELSE}
        {$FATAL Cannot determine endianness.}
      {$IFEND}
    {$ENDIF}

    {**< Planar mode: Y + V + U  (3 planes) *}
    SDL_PIXELFORMAT_YV12 = (cint('Y')       ) or
                           (cint('V') shl  8) or
                           (cint('1') shl 16) or
                           (cint('2') shl 24);
    {**< Planar mode: Y + U + V  (3 planes) *}
    SDL_PIXELFORMAT_IYUV = (cint('I')       ) or
                           (cint('Y') shl  8) or
                           (cint('U') shl 16) or
                           (cint('V') shl 24);
    {**< Packed mode: Y0+U0+Y1+V0 (1 plane) *}
    SDL_PIXELFORMAT_YUY2 = (cint('Y')       ) or
                           (cint('U') shl  8) or
                           (cint('Y') shl 16) or
                           (cint('2') shl 24);
    {**< Packed mode: U0+Y0+V0+Y1 (1 plane) *}
    SDL_PIXELFORMAT_UYVY = (cint('U')       ) or
                           (cint('Y') shl  8) or
                           (cint('V') shl 16) or
                           (cint('Y') shl 24);
    {**< Packed mode: Y0+V0+Y1+U0 (1 plane) *}
    SDL_PIXELFORMAT_YVYU = (cint('Y')       ) or
                           (cint('V') shl  8) or
                           (cint('Y') shl 16) or
                           (cint('U') shl 24);
    {**< Planar mode: Y + U/V interleaved  (2 planes) *}
    SDL_PIXELFORMAT_NV12 = (cint('N')       ) or
                           (cint('V') shl  8) or
                           (cint('1') shl 16) or
                           (cint('2') shl 24);
    {**< Planar mode: Y + V/U interleaved  (2 planes) *}
    SDL_PIXELFORMAT_NV21 = (cint('N')       ) or
                           (cint('V') shl  8) or
                           (cint('2') shl 16) or
                           (cint('1') shl 24);
    {**< Android video texture format *}
    SDL_PIXELFORMAT_EXTERMAL_OES
                         = (cint('O')       ) or
                           (cint('E') shl  8) or
                           (cint('S') shl 16) or
                           (cint(' ') shl 24);

type
  PSDL_Color = ^TSDL_Color;
  TSDL_Color = record
    r: cuint8;
    g: cuint8;
    b: cuint8;
    a: cuint8;
  end;

  TSDL_Colour = TSDL_Color;
  PSDL_Colour = ^TSDL_Colour;

  PSDL_Palette = ^TSDL_Palette;
  TSDL_Palette = record
    ncolors: cint;
    colors: PSDL_Color;
    version: cuint32;
    refcount: cint;
  end;

  {**
   *  Everything in the pixel format structure is read-only.
   *}

  PSDL_PixelFormat = ^TSDL_PixelFormat;
  TSDL_PixelFormat = record
    format: cuint32;
    palette: PSDL_Palette;
    BitsPerPixel: cuint8;
    BytesPerPixel: cuint8;
    padding: array[0..1] of cuint8;
    Rmask: cuint32;
    Gmask: cuint32;
    Bmask: cuint32;
    Amask: cuint32;
    Rloss: cuint8;
    Gloss: cuint8;
    Bloss: cuint8;
    Aloss: cuint8;
    Rshift: cuint8;
    Gshift: cuint8;
    Bshift: cuint8;
    Ashift: cuint8;
    refcount: cint;
    next: PSDL_PixelFormat;
  end;

{**
 *  Get the human readable name of a pixel format
 *}
function SDL_GetPixelFormatName(format: cuint32): PAnsiChar; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetPixelFormatName' {$ENDIF} {$ENDIF};

{**
 *  Convert one of the enumerated pixel formats to a bpp and RGBA masks.
 *
 *  SDL_TRUE, or SDL_FALSE if the conversion wasn't possible.
 *
 *  SDL_MasksToPixelFormatEnum()
 *}
function SDL_PixelFormatEnumToMasks(format: cuint32; bpp: pcint;
  Rmask: pcuint32; Gmask: pcuint32; Bmask: pcuint32; Amask: pcuint32): TSDL_Bool; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_PixelFormatEnumToMasks' {$ENDIF} {$ENDIF};

{**
 *  Convert a bpp and RGBA masks to an enumerated pixel format.
 *
 *  The pixel format, or SDL_PIXELFORMAT_UNKNOWN if the conversion
 *  wasn't possible.
 *
 *  SDL_PixelFormatEnumToMasks()
 *}
function SDL_MasksToPixelFormatEnum(bpp: cint; Rmask: cuint32; Gmask: cuint32; Bmask: cuint32; Amask: cuint32): cuint32; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_MasksToPixelFormatEnum' {$ENDIF} {$ENDIF};

{**
 *  Create an SDL_PixelFormat structure from a pixel format enum.
 *}
function SDL_AllocFormat(pixel_format: cuint32): PSDL_PixelFormat; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_AllocFormat' {$ENDIF} {$ENDIF};

{**
 *  Free an SDL_PixelFormat structure.
 *}
procedure SDL_FreeFormat(format: PSDL_PixelFormat); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_FreeFormat' {$ENDIF} {$ENDIF};

{**
 *  Create a palette structure with the specified number of color
 *  entries.
 *
 *  A new palette, or nil if there wasn't enough memory.
 *
 *  The palette entries are initialized to white.
 *
 *  SDL_FreePalette()
 *}
function SDL_AllocPalette(ncolors: cint): PSDL_Palette; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_AllocPalette' {$ENDIF} {$ENDIF};

{**
 *  Set the palette for a pixel format structure.
 *}
function SDL_SetPixelFormatPalette(format: PSDL_PixelFormat; palette: PSDL_Palette): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_SetPixelFormatPalette' {$ENDIF} {$ENDIF};

{**
 *  Set a range of colors in a palette.
 *
 *  palette    The palette to modify.
 *  colors     An array of colors to copy into the palette.
 *  firstcolor The index of the first palette entry to modify.
 *  ncolors    The number of entries to modify.
 *
 *  0 on success, or -1 if not all of the colors could be set.
 *}
function SDL_SetPaletteColors(palette: PSDL_Palette; const colors: PSDL_Color; firstcolor: cint; ncolors: cint): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_SetPaletteColors' {$ENDIF} {$ENDIF};

{**
 *  Free a palette created with SDL_AllocPalette().
 *
 *  SDL_AllocPalette()
 *}
procedure SDL_FreePalette(palette: PSDL_Palette); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_FreePalette' {$ENDIF} {$ENDIF};

{**
 *  Maps an RGB triple to an opaque pixel value for a given pixel format.
 *
 *  SDL_MapRGBA
 *}
function SDL_MapRGB(const format: PSDL_PixelFormat; r: cuint8; g: cuint8; b: cuint8): cuint32; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_MapRGB' {$ENDIF} {$ENDIF};

{**
 *  Maps an RGBA quadruple to a pixel value for a given pixel format.
 *
 *  SDL_MapRGB
 *}
function SDL_MapRGBA(const format: PSDL_PixelFormat; r: cuint8; g: cuint8; b: cuint8; a: cuint8): cuint32; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_MapRGBA' {$ENDIF} {$ENDIF};

{**
 *  Get the RGB components from a pixel of the specified format.
 *
 *  SDL_GetRGBA
 *}
procedure SDL_GetRGB(pixel: cuint32; const format: PSDL_PixelFormat; r: pcuint8; g: pcuint8; b: pcuint8); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetRGB' {$ENDIF} {$ENDIF};

{**
 *  Get the RGBA components from a pixel of the specified format.
 *
 *  SDL_GetRGB
 *}
procedure SDL_GetRGBA(pixel: cuint32; const format: PSDL_PixelFormat; r: pcuint8; g: pcuint8; b: pcuint8; a: pcuint8); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetRGBA' {$ENDIF} {$ENDIF};

{**
 *  Calculate a 256 entry gamma ramp for a gamma value.
 *}
procedure SDL_CalculateGammaRamp(gamma: cfloat; ramp: pcuint16); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_CalculateGammaRamp' {$ENDIF} {$ENDIF};
