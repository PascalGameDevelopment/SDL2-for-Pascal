unit sdl2_ttf;

{*
  SDL_ttf:  A companion library to SDL for working with TrueType (tm) fonts
  Copyright (C) 2001-2013 Sam Lantinga <slouken@libsdl.org>

  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgement in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.
*}

{* This library is a wrapper around the excellent FreeType 2.0 library,
   available at:
    http://www.freetype.org/
*}

interface

{$I jedi.inc}

uses
  {$IFDEF FPC}
  ctypes,
  {$ENDIF}
  SDL2;

{$I ctypes.inc}

const
  {$IFDEF WINDOWS}
    TTF_LibName = 'SDL2_ttf.dll';
  {$ENDIF}

  {$IFDEF UNIX}
    {$IFDEF DARWIN}
      TTF_LibName = 'libSDL2_tff.dylib';
    {$ELSE}
      {$IFDEF FPC}
        TTF_LibName = 'libSDL2_ttf.so';
      {$ELSE}
        TTF_LibName = 'libSDL2_ttf.so.0';
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}

  {$IFDEF MACOS}
    TTF_LibName = 'SDL2_ttf';
    {$IFDEF FPC}
      {$linklib libSDL2_ttf}
    {$ENDIF}
  {$ENDIF}

{* Set up for C function definitions, even when using C++ *}

{* Printable format: "%d.%d.%d", MAJOR, MINOR, PATCHLEVEL *}
const
  SDL_TTF_MAJOR_VERSION = 2;
  SDL_TTF_MINOR_VERSION = 0;
  SDL_TTF_PATCHLEVEL    = 18;

Procedure SDL_TTF_VERSION(Out X:TSDL_Version);

{* Backwards compatibility *}
const
  TTF_MAJOR_VERSION = SDL_TTF_MAJOR_VERSION;
  TTF_MINOR_VERSION = SDL_TTF_MINOR_VERSION;
  TTF_PATCHLEVEL    = SDL_TTF_PATCHLEVEL;

 {* This function gets the version of the dynamically linked SDL_ttf library.
   it should NOT be used to fill a version structure, instead you should
   use the SDL_TTF_VERSION() macro.
 *}
function TTF_Linked_Version: PSDL_Version cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_Linked_Version' {$ENDIF} {$ENDIF};

{* This function stores the version of the FreeType2 library in use.
   TTF_Init() should be called before calling this function.
 *}
procedure TTF_GetFreeTypeVersion(major, minor, path: pcint);
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetFreeTypeVersion' {$ENDIF} {$ENDIF};

{* This function stores the version of the HarfBuzz library in use,
   or 0 if HarfBuzz is not available.
 *}
procedure TTF_GetHarfBuzzVersion(major, minor, path: pcint);
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetHarfBuzzVersion' {$ENDIF} {$ENDIF};

{* ZERO WIDTH NO-BREAKSPACE (Unicode byte order mark) *}
const
  UNICODE_BOM_NATIVE  = $FEFF;
  UNICODE_BOM_SWAPPED = $FFFE;

{* This function tells the library whether UNICODE text is generally
   byteswapped.  A UNICODE BOM character in a string will override
   this setting for the remainder of that string.
*}
procedure TTF_ByteSwappedUNICODE(swapped: cint) cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_ByteSwappedUNICODE' {$ENDIF} {$ENDIF};

{* The internal structure containing font information *}
type
  PTTF_Font = ^TTTF_Font;
  TTTF_Font = record  end; //todo?

{* Initialize the TTF engine - returns 0 if successful, -1 on error *}
function TTF_Init(): cint cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_Init' {$ENDIF} {$ENDIF};

{* Open a font file and create a font of the specified point size.
 * Some .fon fonts will have several sizes embedded in the file, so the
 * point size becomes the index of choosing which size.  If the value
 * is too high, the last indexed size will be the default. *}
function TTF_OpenFont(_file: PAnsiChar; ptsize: cint): PTTF_Font;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_OpenFont' {$ENDIF} {$ENDIF};
function TTF_OpenFontIndex(_file: PAnsiChar; ptsize: cint; index: clong): PTTF_Font;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_OpenFontIndex' {$ENDIF} {$ENDIF};
{* Open a font file from a SDL_RWops: 'src' must be kept alive for the lifetime of the TTF_Font.
 * 'freesrc' can be set so that TTF_CloseFont closes the RWops *}
function TTF_OpenFontRW(src: PSDL_RWops; freesrc, ptsize: cint): PTTF_Font;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_OpenFontRW' {$ENDIF} {$ENDIF};
function TTF_OpenFontIndexRW(src: PSDL_RWops; freesrc, ptsize: cint; index: clong): PTTF_Font;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_OpenFontIndexRW' {$ENDIF} {$ENDIF};

{* Opens a font using the given horizontal and vertical target resolutions (in DPI).
 * DPI scaling only applies to scalable fonts (e.g. TrueType).
 *}
function TTF_OpenFontDPI(file_: PAnsiChar; ptsize: cint; hdpi, vdpi: cuint): PTTF_Font;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_OpenFontDPI' {$ENDIF} {$ENDIF};
function TTF_OpenFontIndexDPI(file_: PAnsiChar; ptsize: cint; index: clong; hdpi, vdpi: cuint): PTTF_Font;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_OpenFontIndexDPI' {$ENDIF} {$ENDIF};
function TTF_OpenFontDPIRW(src: PSDL_RWops; freesrc, ptsize: cint; hdpi, vdpi: cuint): PTTF_Font;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_OpenFontDPIRW' {$ENDIF} {$ENDIF};
function TTF_OpenFontIndexDPIRW(src: PSDL_RWops; freesrc, ptsize: cuint; index: clong; hdpi, vdpi: cuint): PTTF_Font;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_OpenFontIndexDPIRW' {$ENDIF} {$ENDIF};

{* Set font size dynamically *}
function TTF_SetFontSize(font: PTTF_Font; ptsize: cint): cint;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SetFontSize' {$ENDIF} {$ENDIF};
function TTF_SetFontSizeDPI(font: PTTF_Font; ptsize: cint; hdpi, vdpi: cuint): cint;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SetFontSizeDPI' {$ENDIF} {$ENDIF};

{* Set and retrieve the font style *}
const
  TTF_STYLE_NORMAL        = $00;
  TTF_STYLE_BOLD          = $01;
  TTF_STYLE_ITALIC        = $02;
  TTF_STYLE_UNDERLINE     = $04;
  TTF_STYLE_STRIKETHROUGH = $08;

function TTF_GetFontStyle(font: PTTF_Font): cint cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetFontStyle' {$ENDIF} {$ENDIF};
procedure TTF_SetFontStyle(font: PTTF_Font; style: cint) cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SetFontStyle' {$ENDIF} {$ENDIF};
function TTF_GetFontOutline(font: PTTF_Font): cint cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetFontOutline' {$ENDIF} {$ENDIF};
procedure TTF_SetFontOutline(font: PTTF_Font; outline: cint) cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SetFontOutline' {$ENDIF} {$ENDIF};

{* Set and retrieve FreeType hinter settings *}
const
  TTF_HINTING_NORMAL         = 0;
  TTF_HINTING_LIGHT          = 1;
  TTF_HINTING_MONO           = 2;
  TTF_HINTING_NONE           = 3;
  TTF_HINTING_LIGHT_SUBPIXEL = 4;

function TTF_GetFontHinting(font: PTTF_Font): cint cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetFontHinting' {$ENDIF} {$ENDIF};
procedure TTF_SetFontHinting(font: PTTF_Font; hinting: cint) cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SetFontHinting' {$ENDIF} {$ENDIF};

{* Get the total height of the font - usually equal to point size *}
function TTF_FontHeight(font: PTTF_Font): cint cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_FontHeight' {$ENDIF} {$ENDIF};

{* Get the offset from the baseline to the top of the font
   This is a positive value, relative to the baseline.
 *}
function TTF_FontAscent(font: PTTF_Font): cint cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_FontAscent' {$ENDIF} {$ENDIF};

{* Get the offset from the baseline to the bottom of the font
   This is a negative value, relative to the baseline.
 *}
function TTF_FontDescent(font: PTTF_Font): cint cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_FontDescent' {$ENDIF} {$ENDIF};

{* Get the recommended spacing between lines of text for this font *}
function TTF_FontLineSkip(font: PTTF_Font): cint cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_FontLineSkip' {$ENDIF} {$ENDIF};

{* Get/Set whether or not kerning is allowed for this font *}
function TTF_GetFontKerning(font: PTTF_Font): cint cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetFontKerning' {$ENDIF} {$ENDIF};
procedure TTF_SetFontKerning(font: PTTF_Font; allowed: cint) cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SetFontKerning' {$ENDIF} {$ENDIF};

{* Get the number of faces of the font *}
function TTF_FontFaces(font: PTTF_Font): LongInt cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_FontFaces' {$ENDIF} {$ENDIF};

{* Get the font face attributes, if any *}
function TTF_FontFaceIsFixedWidth(font: PTTF_Font): cint cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_FontFaceIsFixedWidth' {$ENDIF} {$ENDIF};
function TTF_FontFaceFamilyName(font: PTTF_Font): PAnsiChar cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_FontFaceFamilyName' {$ENDIF} {$ENDIF};
function TTF_FontFaceStyleName(font: PTTF_Font): PAnsiChar cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_FontFaceStyleName' {$ENDIF} {$ENDIF};

{* Check wether a glyph is provided by the font or not *}
function TTF_GlyphIsProvided(font: PTTF_Font; ch: cuint16): cint;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GlyphIsProvided' {$ENDIF} {$ENDIF};
function TTF_GlyphIsProvided32(font: PTTF_Font; ch: cuint32): cint;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GlyphIsProvided32' {$ENDIF} {$ENDIF};

{* Get the metrics (dimensions) of a glyph
   To understand what these metrics mean, here is a useful link:
    http://freetype.sourceforge.net/freetype2/docs/tutorial/step2.html
 *}
function TTF_GlyphMetrics(font: PTTF_Font; ch: cuint16; minX, maxX, minY, maxY, advance: pcint): cint;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GlyphMetrics' {$ENDIF} {$ENDIF};
function TTF_GlyphMetrics32(font: PTTF_Font; ch: cuint32; minX, maxX, minY, maxY, advance: pcint): cint;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GlyphMetrics32' {$ENDIF} {$ENDIF};

{* Get the dimensions of a rendered string of text *}
function TTF_SizeText(font: PTTF_Font; text: PAnsiChar; w, h: pcint): cint cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SizeText' {$ENDIF} {$ENDIF};
function TTF_SizeUTF8(font: PTTF_Font; text: PAnsiChar; w, h: pcint): cint cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SizeUTF8' {$ENDIF} {$ENDIF};
function TTF_SizeUNICODE(font: PTTF_Font; text: pcuint16; w, h: pcint): cint cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SizeUNICODE' {$ENDIF} {$ENDIF};

{* Get the measurement string of text without rendering
   e.g. the number of characters that can be rendered before reaching 'measure_width'

   inputs:
     measure_width - in pixels to measure this text
   outputs:
     count  - number of characters that can be rendered
     extent - latest calculated width
*}
function TTF_MeasureText(font: PTTF_Font; text: PAnsiChar; measure_width: cint; extent, count: pcint): cint;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_MeasureText' {$ENDIF} {$ENDIF};
function TTF_MeasureUTF8(font: PTTF_Font; text: PAnsiChar; measure_width: cint; extent, count: pcint): cint;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_MeasureUTF8' {$ENDIF} {$ENDIF};
function TTF_MeasureUNICODE(font: PTTF_Font; text: pcUint16; measure_width: cint; extent, count: pcint): cint;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_MeasureUNICODE' {$ENDIF} {$ENDIF};

{* Create an 8-bit palettized surface and render the given text at
   fast quality with the given font and color.  The 0 pixel is the
   colorkey, giving a transparent background, and the 1 pixel is set
   to the text color.
   This function returns the new surface, or NULL if there was an error.
*}
function TTF_RenderText_Solid(font: PTTF_Font; text: PAnsiChar; fg: TSDL_Color): PSDL_Surface cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderText_Solid' {$ENDIF} {$ENDIF};
function TTF_RenderUTF8_Solid(font: PTTF_Font; text: PAnsiChar; fg: TSDL_Color): PSDL_Surface cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderUTF8_Solid' {$ENDIF} {$ENDIF};
function TTF_RenderUNICODE_Solid(font: PTTF_Font; text: pcuint16; fg: TSDL_Color): PSDL_Surface cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderUNICODE_Solid' {$ENDIF} {$ENDIF};

{* Create an 8-bit palettized surface and render the given text at
   fast quality with the given font and color.  The 0 pixel is the
   colorkey, giving a transparent background, and the 1 pixel is set
   to the text color.
   Text is wrapped to multiple lines on line endings and on word boundaries
   if it extends beyond wrapLength in pixels.
   If wrapLength is 0, only wrap on new lines.
   This function returns the new surface, or NULL if there was an error.
*}
function TTF_RenderText_Solid_Wrapped(font: PTTF_Font; text: PAnsiChar; fg: TSDL_Color; wrapLength: cUint32): PSDL_Surface;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderText_Solid_Wrapped' {$ENDIF} {$ENDIF};
function TTF_RenderUTF8_Solid_Wrapped(font: PTTF_Font; text: PAnsiChar; fg: TSDL_Color; wrapLength: cUint32): PSDL_Surface;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderUTF8_Solid_Wrapped' {$ENDIF} {$ENDIF};
function TTF_RenderUNICODE_Solid_Wrapped(font: PTTF_Font; text: pcUint16; fg: TSDL_Color; wrapLength: cUint32): PSDL_Surface;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderUNICODE_Solid_Wrapped' {$ENDIF} {$ENDIF};

{* Create an 8-bit palettized surface and render the given glyph at
   fast quality with the given font and color.  The 0 pixel is the
   colorkey, giving a transparent background, and the 1 pixel is set
   to the text color.  The glyph is rendered without any padding or
   centering in the X direction, and aligned normally in the Y direction.
   This function returns the new surface, or NULL if there was an error.
*}
function TTF_RenderGlyph_Solid(font: PTTF_Font; ch: cUint16; fg: TSDL_Color): PSDL_Surface;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderGlyph_Solid' {$ENDIF} {$ENDIF};
function TTF_RenderGlyph_Solid32(font: PTTF_Font; ch: cUint32; fg: TSDL_Color): PSDL_Surface;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderGlyph_Solid32' {$ENDIF} {$ENDIF};

{* Create an 8-bit palettized surface and render the given text at
   high quality with the given font and colors.  The 0 pixel is background,
   while other pixels have varying degrees of the foreground color.
   This function returns the new surface, or NULL if there was an error.
*}
function TTF_RenderText_Shaded(font: PTTF_Font; text: PAnsiChar; fg, bg: TSDL_Color): PSDL_Surface cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderText_Shaded' {$ENDIF} {$ENDIF};
function TTF_RenderUTF8_Shaded(font: PTTF_Font; text: PAnsiChar; fg, bg: TSDL_Color): PSDL_Surface cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderUTF8_Shaded' {$ENDIF} {$ENDIF};
function TTF_RenderUNICODE_Shaded(font: PTTF_Font; text: pcuint16; fg, bg: TSDL_Color): PSDL_Surface cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderUNICODE_Shaded' {$ENDIF} {$ENDIF};

{* Create an 8-bit palettized surface and render the given text at
   high quality with the given font and colors.  The 0 pixel is background,
   while other pixels have varying degrees of the foreground color.
   Text is wrapped to multiple lines on line endings and on word boundaries
   if it extends beyond wrapLength in pixels.
   If wrapLength is 0, only wrap on new lines.
   This function returns the new surface, or NULL if there was an error.
*}
function TTF_RenderText_Shaded_Wrapped(font: PTTF_Font; text: PAnsiChar; fg, bg: TSDL_Color; wrapLength: cUint32): PSDL_Surface;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderText_Shaded_Wrapped' {$ENDIF} {$ENDIF};
function TTF_RenderUTF8_Shaded_Wrapped(font: PTTF_Font; text: PAnsiChar; fg, bg: TSDL_Color; wrapLength: cUint32): PSDL_Surface;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderUTF8_Shaded_Wrapped' {$ENDIF} {$ENDIF};
function TTF_RenderUNICODE_Shaded_Wrapped(font: PTTF_Font; text: pcUint16; fg, bg: TSDL_Color; wrapLength: cUint32): PSDL_Surface;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderUNICODE_Shaded_Wrapped' {$ENDIF} {$ENDIF};

{* Create an 8-bit palettized surface and render the given glyph at
   high quality with the given font and colors.  The 0 pixel is background,
   while other pixels have varying degrees of the foreground color.
   The glyph is rendered without any padding or centering in the X
   direction, and aligned normally in the Y direction.
   This function returns the new surface, or NULL if there was an error.
*}
function TTF_RenderGlyph_Shaded(font: PTTF_Font; ch: cUint16; fg, bg: TSDL_Color): PSDL_Surface;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderGlyph_Shaded' {$ENDIF} {$ENDIF};
function TTF_RenderGlyph_Shaded32(font: PTTF_Font; ch: cUint32; fg, bg: TSDL_Color): PSDL_Surface;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderGlyph_Shaded32' {$ENDIF} {$ENDIF};

{* Create a 32-bit ARGB surface and render the given text at high quality,
   using alpha blending to dither the font with the given color.
   This function returns the new surface, or NULL if there was an error.
*}
function TTF_RenderText_Blended(font: PTTF_Font; text: PAnsiChar; fg: TSDL_Color): PSDL_Surface cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderText_Blended' {$ENDIF} {$ENDIF};
function TTF_RenderUTF8_Blended(font: PTTF_Font; text: PAnsiChar; fg: TSDL_Color): PSDL_Surface cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderUTF8_Blended' {$ENDIF} {$ENDIF};
function TTF_RenderUNICODE_Blended(font: PTTF_Font; text: pcuint16; fg: TSDL_Color): PSDL_Surface cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderUNICODE_Blended' {$ENDIF} {$ENDIF};

{* Create a 32-bit ARGB surface and render the given text at high quality,
   using alpha blending to dither the font with the given color.
   Text is wrapped to multiple lines on line endings and on word boundaries
   if it extends beyond wrapLength in pixels.
   This function returns the new surface, or NULL if there was an error.
*}
function TTF_RenderText_Blended_Wrapped(font: PTTF_Font; text: PAnsiChar; fg: TSDL_Color; wrapLength: cuint32): PSDL_Surface cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderText_Blended_Wrapped' {$ENDIF} {$ENDIF};
function TTF_RenderUTF8_Blended_Wrapped(font: PTTF_Font; text: PAnsiChar; fg: TSDL_Color; wrapLength: cuint32): PSDL_Surface cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderUTF8_Blended_Wrapped' {$ENDIF} {$ENDIF};
function TTF_RenderUNICODE_Blended_Wrapped(font: PTTF_Font; text: pcuint16; fg: TSDL_Color; wrapLength: cuint32): PSDL_Surface cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderUNICODE_Blended_Wrapped' {$ENDIF} {$ENDIF};

{* Create a 32-bit ARGB surface and render the given glyph at high quality,
   using alpha blending to dither the font with the given color.
   The glyph is rendered without any padding or centering in the X
   direction, and aligned normally in the Y direction.
   This function returns the new surface, or NULL if there was an error.
*}
function TTF_RenderGlyph_Blended(font: PTTF_Font; ch: cUint16; fg: TSDL_Color): PSDL_Surface;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderGlyph_Blended' {$ENDIF} {$ENDIF};
function TTF_RenderGlyph_Blended32(font: PTTF_Font; ch: cUint32; fg: TSDL_Color): PSDL_Surface;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderGlyph_Blended32' {$ENDIF} {$ENDIF};

{* For compatibility with previous versions, here are the old functions *}
function TTF_RenderText(font: PTTF_Font; text: PAnsiChar; fg, bg: TSDL_Color): PSDL_Surface;
function TTF_RenderUTF8(font: PTTF_Font; text: PAnsiChar; fg, bg: TSDL_Color): PSDL_Surface;
function TTF_RenderUNICODE(font: PTTF_Font; text: pcuint16; fg, bg: TSDL_Color): PSDL_Surface;

{* Set Direction and Script to be used for text shaping, when using HarfBuzz.
   - direction is of type hb_direction_t
   - script is of type hb_script_t

   This functions returns always 0, or -1 if SDL_ttf is not compiled with HarfBuzz
*}
function TTF_SetDirection(direction: cint): cint;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SetDirection' {$ENDIF} {$ENDIF};
function TTF_SetScript(script: cint): cint;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SetScript' {$ENDIF} {$ENDIF};

{* Close an opened font file *}
procedure TTF_CloseFont(font: PTTF_Font) cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_CloseFont' {$ENDIF} {$ENDIF};

{* De-initialize the TTF engine *}
procedure TTF_Quit() cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_Quit' {$ENDIF} {$ENDIF};

{* Check if the TTF engine is initialized *}
function TTF_WasInit: Boolean cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_WasInit' {$ENDIF} {$ENDIF};

{* Get the kerning size of two glyphs

   DEPRECATED: this function requires FreeType font indexes, not glyphs,
     by accident, which we don't expose through this API, so it could give
     wildly incorrect results, especially with non-ASCII values.
     Going forward, please use TTF_GetFontKerningSizeGlyphs() instead, which
     does what you probably expected this function to do.
*}
function TTF_GetFontKerningSize(font: PTTF_Font; prev_index, index: cint): cint cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetFontKerningSize' {$ENDIF} {$ENDIF};
  deprecated 'This function requires FreeType font indexes, not glyphs. Use TTF_GetFontKerningSizeGlyphs() instead';

{* Get the kerning size of two glyphs *}
function TTF_GetFontKerningSizeGlyphs(font: PTTF_Font; previous_ch, ch: cUint16): cint;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetFontKerningSizeGlyphs' {$ENDIF} {$ENDIF};
function TTF_GetFontKerningSizeGlyphs32(font: PTTF_Font; previous_ch, ch: cUint32): cint;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetFontKerningSizeGlyphs32' {$ENDIF} {$ENDIF};

{* Enable Signed Distance Field rendering (with the Blended APIs) *}
function TTF_SetFontSDF(font: PTTF_Font; on_off: TSDL_Bool): cint;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SetFontSDF' {$ENDIF} {$ENDIF};
function TTF_GetFontSDF(font: PTTF_Font): TSDL_Bool;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetFontSDF' {$ENDIF} {$ENDIF};

{* We'll use SDL for reporting errors *}
function TTF_SetError(const fmt: PAnsiChar): cint32; cdecl;
function TTF_GetError: PAnsiChar; cdecl;

implementation

Procedure SDL_TTF_VERSION(Out X:TSDL_Version);
begin
  x.major := SDL_TTF_MAJOR_VERSION;
  x.minor := SDL_TTF_MINOR_VERSION;
  x.patch := SDL_TTF_PATCHLEVEL;
end;

function TTF_SetError(const fmt: PAnsiChar): cint32; cdecl;
begin
  Result := SDL_SetError(fmt);
end;

function TTF_GetError: PAnsiChar; cdecl;
begin
  Result := SDL_GetError();
end;

function TTF_RenderText(font: PTTF_Font; text: PAnsiChar; fg, bg: TSDL_Color): PSDL_Surface;
begin
  Result := TTF_RenderText_Shaded(font, text, fg, bg);
end;

function TTF_RenderUTF8(font: PTTF_Font; text: PAnsiChar; fg, bg: TSDL_Color): PSDL_Surface;
begin
  Result := TTF_RenderUTF8_Shaded(font, text, fg, bg);
end;

function TTF_RenderUNICODE(font: PTTF_Font; text: pcuint16; fg, bg: TSDL_Color): PSDL_Surface;
begin
  Result := TTF_RenderUNICODE_Shaded(font, text, fg, bg);
end;

end.

