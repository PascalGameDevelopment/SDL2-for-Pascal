//from "sdl_shape.h"

{**  SDL_shape.h
 *
 * Header file for the shaped window API.
 *}
const
  SDL_NONSHAPEABLE_WINDOW    = -1;
  SDL_INVALID_SHAPE_ARGUMENT = -2;
  SDL_WINDOW_LACKS_SHAPE     = -3;

  { Conv.:

      ATTENTION: A few function delcarations are missing here.
                 They would need forward declaration.

                 They are found in sdlvideo.inc!

                 - SDL_CreateShapedWindow
                 - SDL_IsShapedWindow
                 - SDL_GetShapedWindow
                 - SDL_SetShapedWindow
  }

{** \brief An enum denoting the specific type of contents present in an SDL_WindowShapeParams union. *}
type
  TWindowShapeMode = type Integer;

const
  {** \brief The default mode, a binarized alpha cutoff of 1. *}
  ShapeModeDefault               = TWindowShapeMode(0);
  {** \brief A binarized alpha cutoff with a given integer value. *}
  ShapeModeBinarizeAlpha         = TWindowShapeMode(1);
  {** \brief A binarized alpha cutoff with a given integer value, but with the opposite comparison. *}
  ShapeModeReverseBinarizeAlpha  = TWindowShapeMode(2);
  {** \brief A color key is applied. *}
  ShapeModeColorKey              = TWindowShapeMode(3);

{ #todo : Conv.: Macro interpreted correctly?
  //#define SDL_SHAPEMODEALPHA(mode) (mode == ShapeModeDefault || mode == ShapeModeBinarizeAlpha || mode == ShapeModeReverseBinarizeAlpha)}
function SDL_SHAPEMODEALPHA(mode: TWindowShapeMode): Boolean;

type
  {** A union containing parameters for shaped windows. *}
  TSDL_WindowShapeParams = record
    case cint of
      {** a cutoff alpha value for binarization of the window shape's alpha channel. *}
      0: (binarizationCutoff: cuint8;);
      1: (colorKey: TSDL_Color;);
  end;

  {** A struct that tags the SDL_WindowShapeParams union with an enum describing the type of its contents. *}
  PSDL_WindowShapeMode = ^TSDL_WindowShapeMode;
  TSDL_WindowShapeMode = record
    {** The mode of these window-shape parameters. *}
    mode: TWindowShapeMode;
    {** Window-shape parameters. *}
    parameters: TSDL_WindowShapeParams;
  end;
