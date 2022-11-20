//based on "sdl_rect.h" (2.0.14)

{**
 *  \file SDL_rect.h
 *
 *  Header file for SDL_rect definition and management functions.
 *}

type
  {**
    *  \brief  The structure that defines a point (integer)
    *
    *  \sa SDL_EnclosePoints
    *  \sa SDL_PointInRect
   *}
  PSDL_Point = ^TSDL_Point;
  TSDL_Point = record
    x: cint;
    y: cint;
  end;

  {**
   *  \brief  The structure that defines a point (floating point)
   *
   *  \sa SDL_EnclosePoints
   *  \sa SDL_PointInRect
   *}
  PSDL_FPoint = ^TSDL_FPoint;
  TSDL_FPoint = record
    x: cfloat;
    y: cfloat;
  end;

  {**
   *  \brief A rectangle, with the origin at the upper left (integer).
   *
   *  \sa SDL_RectEmpty
   *  \sa SDL_RectEquals
   *  \sa SDL_HasIntersection
   *  \sa SDL_IntersectRect
   *  \sa SDL_UnionRect
   *  \sa SDL_EnclosePoints
   *}
  PSDL_Rect = ^TSDL_Rect;
  TSDL_Rect = record
    x,y: cint;
    w,h: cint;
  end;

  {**
   *  A rectangle, with the origin at the upper left. (floating point)
   *}
  PSDL_FRect = ^TSDL_FRect;
  TSDL_FRect = record
    x,y: cfloat;
    w,h: cfloat;
  end;

{**
 *  Returns true if point resides inside a rectangle.
 *}
function SDL_PointInRect(const p: PSDL_Point; const r: PSDL_Rect): Boolean; Inline;

{**
 *  Returns true if the rectangle has no area.
 *}
function SDL_RectEmpty(const r: PSDL_Rect): Boolean; inline;

{**
 *  Returns true if the two rectangles are equal.
 *}
function SDL_RectEquals(const a, b: PSDL_Rect): Boolean; inline;

{**
 *  Determine whether two rectangles intersect.
 *
 *  SDL_TRUE if there is an intersection, SDL_FALSE otherwise.
 *}
function SDL_HasIntersection(const a, b: PSDL_Rect): TSDL_Bool; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_HasIntersection' {$ENDIF} {$ENDIF};

{**
 *  Calculate the intersection of two rectangles.
 *
 *  SDL_TRUE if there is an intersection, SDL_FALSE otherwise.
 *}
function SDL_IntersectRect(const A, B: PSDL_Rect; result: PSDL_Rect): TSDL_Bool; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_IntersectRect' {$ENDIF} {$ENDIF};

{**
 *  Calculate the union of two rectangles.
 *}
procedure SDL_UnionRect(const A, B: PSDL_Rect; result: PSDL_Rect); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_UnionRect' {$ENDIF} {$ENDIF};

{**
 *  Calculate a minimal rectangle enclosing a set of points
 *
 *  SDL_TRUE if any points were within the clipping rect
 *}
function SDL_EnclosePoints(const points: PSDL_Point; count: cint; const clip: PSDL_Rect; result: PSDL_Rect): TSDL_Bool; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_EnclosePoints' {$ENDIF} {$ENDIF};

{**
 *  Calculate the intersection of a rectangle and line segment.
 *
 *  SDL_TRUE if there is an intersection, SDL_FALSE otherwise.
 *}
function SDL_IntersectRectAndLine(const rect: PSDL_Rect; X1, Y1, X2, Y2: pcint): TSDL_Bool; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_IntersectRectAndLine' {$ENDIF} {$ENDIF};

{**
 *  Returns true if point resides inside a rectangle.
 *}
function SDL_PointInFRect(const p: PSDL_FPoint; const r: PSDL_FRect): Boolean; Inline;

{**
 *  Returns true if the rectangle has no area.
 *}
function SDL_FRectEmpty(const r: PSDL_FRect): Boolean; inline;

{**
 * Returns true if the two rectangles are equal, within some given epsilon.
 *
 * \since This function is available since SDL 2.0.22.
 *}
function SDL_FRectEqualsEpsilon(const a, b: PSDL_FRect; const epsilon: cfloat): Boolean; Inline;

{**
 * Returns true if the two rectangles are equal, using a default epsilon.
 *
 * \since This function is available since SDL 2.0.22.
 *}
function SDL_FRectEquals(const a, b: PSDL_FRect): Boolean; Inline;

{**
 * Determine whether two rectangles intersect with float precision.
 *
 * If either pointer is NIL the function will return SDL_FALSE.
 *
 * \param A an SDL_FRect structure representing the first rectangle
 * \param B an SDL_FRect structure representing the second rectangle
 * \returns SDL_TRUE if there is an intersection, SDL_FALSE otherwise.
 *
 * \since This function is available since SDL 2.0.22.
 *
 * \sa SDL_IntersectRect
 *}
function SDL_HasIntersectionF(const a, b: PSDL_FRect): TSDL_Bool; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_HasIntersectionF' {$ENDIF} {$ENDIF};

{**
 * Calculate the intersection of two rectangles with float precision.
 *
 * If `result` is NIL then this function will return SDL_FALSE.
 *
 * \param A an SDL_FRect structure representing the first rectangle
 * \param B an SDL_FRect structure representing the second rectangle
 * \param result an SDL_FRect structure filled in with the intersection of
 *               rectangles `A` and `B`
 * \returns SDL_TRUE if there is an intersection, SDL_FALSE otherwise.
 *
 * \since This function is available since SDL 2.0.22.
 *
 * \sa SDL_HasIntersectionF
 *}
function SDL_IntersectFRect(const a, b: PSDL_FRect; result: PSDL_FRect): TSDL_Bool; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_IntersectFRect' {$ENDIF} {$ENDIF};
