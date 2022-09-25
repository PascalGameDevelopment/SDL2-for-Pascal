//from "sdl_video.h" and "sdl_sysvideo.h" and "sdl_shape.h"

{ ATTENTION Conv.:

    The SDL_HitTestResult-Enum. and the SDL_HitTest func. are shifted before
    TSDL_Window decl. because it need this.

    Since the HitTest constants would break Pascal's
    forward declaration rules, it has to be above
    forward declaration of TSDL_Window.

}

  {**
   *  \brief Possible return values from the SDL_HitTest callback.
   *
   *  \sa SDL_HitTest
   *}
  type
    TSDL_HitTestResult = type Integer;

  const
    SDL_HITTEST_NORMAL             = TSDL_HitTestResult(0);  {**< Region is normal. No special properties. *}
    SDL_HITTEST_DRAGGABLE          = TSDL_HitTestResult(1);  {**< Region can drag entire window. *}
    SDL_HITTEST_RESIZE_TOPLEFT     = TSDL_HitTestResult(2);
    SDL_HITTEST_RESIZE_TOP         = TSDL_HitTestResult(3);
    SDL_HITTEST_RESIZE_TOPRIGHT    = TSDL_HitTestResult(4);
    SDL_HITTEST_RESIZE_RIGHT       = TSDL_HitTestResult(5);
    SDL_HITTEST_RESIZE_BOTTOMRIGHT = TSDL_HitTestResult(6);
    SDL_HITTEST_RESIZE_BOTTOM      = TSDL_HitTestResult(7);
    SDL_HITTEST_RESIZE_BOTTOMLEFT  = TSDL_HitTestResult(8);
    SDL_HITTEST_RESIZE_LEFT        = TSDL_HitTestResult(9);

{ Conv.: Important forward declaration of SDL_Window. }
type
  PPSDL_Window = ^PSDL_Window;
  PSDL_Window = ^TSDL_Window;

  {**
    *  \brief Callback used for hit-testing.
    *
    *  \sa SDL_SetWindowHitTest
    *}
TSDL_HitTest = function(win: PSDL_Window; const area: PSDL_Point; data: Pointer): TSDL_HitTestResult; cdecl;

{ ATTENTION Conv.:

    The following declarations are from SDL_sysvideo.h.

    Remark: The way SDL_video.h and SDL_sysvideo.h are intertwisted
            it is best to keep them both in sdlvideo.inc because
            Pascal has more strict rules regarding forward declarations.

}

  {* Define the SDL window-shaper structure *}
  PSDL_WindowShaper = ^TSDL_WindowShaper;
  TSDL_WindowShaper = record
    {* The window associated with the shaper *}
    window: PSDL_Window;

    {* The user's specified coordinates for the window, for once we give it a shape. *}
    userx,usery: cuint32;

    {* The parameters for shape calculation. *}
    mode: TSDL_WindowShapeMode;

    {* Has this window been assigned a shape? *}
    hasshape: TSDL_Bool;

    driverdata: Pointer;
  end;

 {* Define the SDL shape driver structure *}
  PSDL_ShapeDriver = ^TSDL_ShapeDriver;
  TSDL_ShapeDriver = record
    CreateShaper: function(window: PSDL_Window): PSDL_WindowShaper; cdecl;
    SetWindowShaper: function(shaper: PSDL_WindowShaper; shape: PSDL_Surface; shape_mode: PSDL_WindowShapeMode): cint; cdecl;
    ResizeWindowShape: function(window: PSDL_Window): cint; cdecl;
  end;

  PSDL_WindowUserData = ^TSDL_WindowUserData;
  TSDL_WindowUserData = record
    name: PAnsiChar;
    data: Pointer;
    next: PSDL_WindowUserData;
  end;

{ ATTENTION Conv.:

    Everything below this comment is mostly from SDL_video.h.

}

  {**
   *  The structure that defines a display mode
   *
   *   SDL_GetNumDisplayModes()
   *   SDL_GetDisplayMode()
   *   SDL_GetDesktopDisplayMode()
   *   SDL_GetCurrentDisplayMode()
   *   SDL_GetClosestDisplayMode()
   *   SDL_SetWindowDisplayMode()
   *   SDL_GetWindowDisplayMode()
   *}
  PSDL_DisplayMode = ^TSDL_DisplayMode;
  TSDL_DisplayMode = record
    format: cuint32;              {**< pixel format *}
    w: cint;                      {**< width *}
    h: cint;                      {**< height *}
    refresh_rate: cint;           {**< refresh rate (or zero for unspecified) *}
    driverdata: Pointer;          {**< driver-specific data, initialize to 0 *}
  end;

  {**
   *  The type used to identify a window
   *
   *   SDL_CreateWindow()
   *   SDL_CreateWindowFrom()
   *   SDL_DestroyWindow()
   *   SDL_GetWindowData()
   *   SDL_GetWindowFlags()
   *   SDL_GetWindowGrab()
   *   SDL_GetWindowKeyboardGrab()
   *   SDL_GetWindowMouseGrab()
   *   SDL_GetWindowMouseRect()
   *   SDL_GetWindowPosition()
   *   SDL_GetWindowSize()
   *   SDL_GetWindowTitle()
   *   SDL_HideWindow()
   *   SDL_MaximizeWindow()
   *   SDL_MinimizeWindow()
   *   SDL_RaiseWindow()
   *   SDL_RestoreWindow()
   *   SDL_SetWindowData()
   *   SDL_SetWindowFullscreen()
   *   SDL_SetWindowGrab()
   *   SDL_SetWindowKeyboardGrab()
   *   SDL_SetWindowMouseGrab()
   *   SDL_SetWindowMouseRect()
   *   SDL_SetWindowIcon()
   *   SDL_SetWindowPosition()
   *   SDL_SetWindowSize()
   *   SDL_SetWindowBordered()
   *   SDL_SetWindowTitle()
   *   SDL_ShowWindow()
   *}

  { ATTENTION Conv.: TSDL_Window declaration from SDL_sysvideo.h. }
  {* Define the SDL window structure, corresponding to toplevel windows *}
  TSDL_Window = record
    magic: Pointer;
    id: cuint32;
    title: PAnsiChar;
    icon: PSDL_Surface;
    x,y: cint;
    w,h: cint;
    min_w, min_h: cint;
    max_w, max_h: cint;
    flags: cuint32;
    last_fullscreen_flags: cuint32;

    {* Stored position and size for windowed mode * }
    windowed: TSDL_Rect;

    fullscreen_mode: TSDL_DisplayMode;

    opacity: cfloat;

    brightness: cfloat;
    gamma: pcuint16;
    saved_gamma: pcuint16;  {* (just offset into gamma) *}

    surface: PSDL_Surface;
    surface_valid: TSDL_Bool;

    is_hiding: TSDL_Bool;
    is_destroying: TSDL_Bool;
    is_dropping: TSDL_Bool; {* drag/drop in progress, expecting SDL_SendDropComplete(). *}

    shaper: PSDL_WindowShaper;

    hit_test: TSDL_HitTest;
    hit_test_data: Pointer;

    data: PSDL_WindowUserData;

    driverdata: Pointer;

    prev: PSDL_Window;
    next: PSDL_Window;
  end;

  function FULLSCREEN_VISIBLE(W: PSDL_Window): Variant;

{ Functions from "sdl_shape.h" }

   {**
   *  Create a window that can be shaped with the specified position, dimensions, and flags.
   *
   *   title The title of the window, in UTF-8 encoding.
   *   x     The x position of the window, ::SDL_WINDOWPOS_CENTERED, or
   *               ::SDL_WINDOWPOS_UNDEFINED.
   *   y     The y position of the window, ::SDL_WINDOWPOS_CENTERED, or
   *               ::SDL_WINDOWPOS_UNDEFINED.
   *   w     The width of the window.
   *   h     The height of the window.
   *   flags The flags for the window, a mask of SDL_WINDOW_BORDERLESS with any of the following:
   *         SDL_WINDOW_OPENGL,     SDL_WINDOW_INPUT_GRABBED,
   *         SDL_WINDOW_SHOWN,      SDL_WINDOW_RESIZABLE,
   *         SDL_WINDOW_MAXIMIZED,  SDL_WINDOW_MINIMIZED,
   *         SDL_WINDOW_BORDERLESS is always set, and SDL_WINDOW_FULLSCREEN is always unset.
   *
   *   The window created, or NULL if window creation failed.
   *
   *  SDL_DestroyWindow()
   *}
function SDL_CreateShapedWindow(title: PAnsiChar; x: cuint; y: cuint; w: cuint; h: cuint; flags: cuint32): PSDL_Window; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_CreateShapedWindow' {$ENDIF} {$ENDIF};

  {**
   * Return whether the given window is a shaped window.
   *
   *  window The window to query for being shaped.
   *
   *  SDL_TRUE if the window is a window that can be shaped, SDL_FALSE if the window is unshaped or NULL.
   *  SDL_CreateShapedWindow
   *}
function SDL_IsShapedWindow(window: PSDL_Window): TSDL_Bool; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_IsShapedWindow' {$ENDIF} {$ENDIF};

   {**
   * Set the shape and parameters of a shaped window.
   *
   *  window The shaped window whose parameters should be set.
   *  shape A surface encoding the desired shape for the window.
   *  shape_mode The parameters to set for the shaped window.
   *
   *  0 on success, SDL_INVALID_SHAPE_ARGUMENT on invalid an invalid shape argument, or SDL_NONSHAPEABLE_WINDOW
   *  if the SDL_Window* given does not reference a valid shaped window.
   *
   *  SDL_WindowShapeMode
   *  SDL_GetShapedWindowMode.
   *}
function SDL_SetWindowShape(window: PSDL_Window; shape: PSDL_Surface; shape_mode: PSDL_WindowShapeMode): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_SetWindowShape' {$ENDIF} {$ENDIF};

  {**
   * Get the shape parameters of a shaped window.
   *
   *  window The shaped window whose parameters should be retrieved.
   *  shape_mode An empty shape-mode structure to fill, or NULL to check whether the window has a shape.
   *
   *  0 if the window has a shape and, provided shape_mode was not NULL, shape_mode has been filled with the mode
   *  data, SDL_NONSHAPEABLE_WINDOW if the SDL_Window given is not a shaped window, or SDL_WINDOW_LACKS_SHAPE if
   *  the SDL_Window* given is a shapeable window currently lacking a shape.
   *
   *  SDL_WindowShapeMode
   *  SDL_SetWindowShape
   *}
function SDL_GetShapedWindowMode(window: PSDL_Window; shape_mode: TSDL_WindowShapeMode): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetShapedWindowMode' {$ENDIF} {$ENDIF};

{**
 *  The flags on a window
 *
 *   SDL_GetWindowFlags()
 *}
type
  TSDL_WindowFlags = type cuint32;

const
  SDL_WINDOW_FULLSCREEN    = TSDL_WindowFlags($00000001);      {**< fullscreen window *}
  SDL_WINDOW_OPENGL        = TSDL_WindowFlags($00000002);      {**< window usable with OpenGL context *}
  SDL_WINDOW_SHOWN         = TSDL_WindowFlags($00000004);      {**< window is visible *}
  SDL_WINDOW_HIDDEN        = TSDL_WindowFlags($00000008);      {**< window is not visible *}
  SDL_WINDOW_BORDERLESS    = TSDL_WindowFlags($00000010);      {**< no window decoration *}
  SDL_WINDOW_RESIZABLE     = TSDL_WindowFlags($00000020);      {**< window can be resized *}
  SDL_WINDOW_MINIMIZED     = TSDL_WindowFlags($00000040);      {**< window is minimized *}
  SDL_WINDOW_MAXIMIZED     = TSDL_WindowFlags($00000080);      {**< window is maximized *}
  SDL_WINDOW_INPUT_GRABBED = TSDL_WindowFlags($00000100);      {**< window has grabbed input focus *}
  SDL_WINDOW_INPUT_FOCUS   = TSDL_WindowFlags($00000200);      {**< window has input focus *}
  SDL_WINDOW_MOUSE_FOCUS   = TSDL_WindowFlags($00000400);      {**< window has mouse focus *}
  SDL_WINDOW_FULLSCREEN_DESKTOP = TSDL_WindowFlags(SDL_WINDOW_FULLSCREEN or $00001000);
  SDL_WINDOW_FOREIGN       = TSDL_WindowFlags($00000800);      {**< window not created by SDL *}
  SDL_WINDOW_ALLOW_HIGHDPI = TSDL_WindowFlags($00002000);      {**< window should be created in high-DPI mode if supported.
                                                   On macOS NSHighResolutionCapable must be set true in the
                                                   application's Info.plist for this to have any effect. *}
  SDL_WINDOW_MOUSE_CAPTURE = TSDL_WindowFlags($00004000);      {**< window has mouse captured (unrelated to INPUT_GRABBED) *}
  SDL_WINDOW_ALWAYS_ON_TOP = TSDL_WindowFlags($00008000);      {**< window should always be above others *}
  SDL_WINDOW_SKIP_TASKBAR  = TSDL_WindowFlags($00010000);      {**< window should not be added to the taskbar *}
  SDL_WINDOW_UTILITY       = TSDL_WindowFlags($00020000);      {**< window should be treated as a utility window *}
  SDL_WINDOW_TOOLTIP       = TSDL_WindowFlags($00040000);      {**< window should be treated as a tooltip *}
  SDL_WINDOW_POPUP_MENU    = TSDL_WindowFlags($00080000);      {**< window should be treated as a popup menu *}
  SDL_WINDOW_VULKAN        = TSDL_WindowFlags($10000000);      {**< window usable for Vulkan surface *}
  SDL_WINDOW_METAL         = TSDL_WindowFlags($20000000);      {**< window usable for Metal view *}

  {**
  *  Used to indicate that you don't care what the window position is.
  *}
const SDL_WINDOWPOS_UNDEFINED_MASK = $1FFF0000;
function SDL_WINDOWPOS_UNDEFINED_DISPLAY(X: Variant): Variant;
const SDL_WINDOWPOS_UNDEFINED = SDL_WINDOWPOS_UNDEFINED_MASK or 0;
function SDL_WINDOWPOS_ISUNDEFINED(X: Variant): Variant;


  {**
   *  Used to indicate that the window position should be centered.
   *}
const SDL_WINDOWPOS_CENTERED_MASK = $2FFF0000;
function SDL_WINDOWPOS_CENTERED_DISPLAY(X: Variant): Variant;
const SDL_WINDOWPOS_CENTERED = SDL_WINDOWPOS_CENTERED_MASK or 0;
function SDL_WINDOWPOS_ISCENTERED(X: Variant): Variant;

  {**
   *  Event subtype for window events
   *}
type
  PSDL_WindowEventID = ^TSDL_WindowEventID;
  TSDL_WindowEventID = type DWord;
const
  SDL_WINDOWEVENT_NONE = TSDL_WindowEventID(0);           {**< Never used *}
  SDL_WINDOWEVENT_SHOWN = TSDL_WindowEventID(1);          {**< Window has been shown *}
  SDL_WINDOWEVENT_HIDDEN = TSDL_WindowEventID(2);         {**< Window has been hidden *}
  SDL_WINDOWEVENT_EXPOSED = TSDL_WindowEventID(3);        {**< Window has been exposed and should be redrawn *}
  SDL_WINDOWEVENT_MOVED = TSDL_WindowEventID(4);          {**< Window has been moved to data1; data2 *}
  SDL_WINDOWEVENT_RESIZED = TSDL_WindowEventID(5);        {**< Window has been resized to data1xdata2 *}
  SDL_WINDOWEVENT_SIZE_CHANGED = TSDL_WindowEventID(6);   {**< The window size has changed; either as a result of an API call or through the system or user changing the window size. *}
  SDL_WINDOWEVENT_MINIMIZED = TSDL_WindowEventID(7);      {**< Window has been minimized *}
  SDL_WINDOWEVENT_MAXIMIZED = TSDL_WindowEventID(8);      {**< Window has been maximized *}
  SDL_WINDOWEVENT_RESTORED = TSDL_WindowEventID(9);       {**< Window has been restored to normal size and position *}
  SDL_WINDOWEVENT_ENTER = TSDL_WindowEventID(10);          {**< Window has gained mouse focus *}
  SDL_WINDOWEVENT_LEAVE = TSDL_WindowEventID(11);          {**< Window has lost mouse focus *}
  SDL_WINDOWEVENT_FOCUS_GAINED = TSDL_WindowEventID(12);   {**< Window has gained keyboard focus *}
  SDL_WINDOWEVENT_FOCUS_LOST = TSDL_WindowEventID(13);     {**< Window has lost keyboard focus *}
  SDL_WINDOWEVENT_CLOSE = TSDL_WindowEventID(14);          {**< The window manager requests that the window be closed *}
  SDL_WINDOWEVENT_TAKE_FOCUS = TSDL_WindowEventID(15);     {**< Window is being offered a focus (should SetWindowInputFocus() on itself or a subwindow, or ignore) *}
  SDL_WINDOWEVENT_HIT_TEST = TSDL_WindowEventID(16);       {**< Window had a hit test that wasn't SDL_HITTEST_NORMAL. *}

{**
 *  \brief Event subtype for display events
 *}
type
  TSDL_DisplayEventID = type Integer;

const
  SDL_DISPLAYEVENT_NONE          = TSDL_DisplayEventID(0);   {**< Never used *}
  SDL_DISPLAYEVENT_ORIENTATION   = TSDL_DisplayEventID(1);   {**< Display orientation has changed to data1 *}
  SDL_DISPLAYEVENT_CONNECTED     = TSDL_DisplayEventID(2);   {**< Display has been added to the system *}
  SDL_DISPLAYEVENT_DISCONNECTED  = TSDL_DisplayEventID(3);   {**< Display has been removed from the system *}

type
  TSDL_DisplayOrientation = type Integer;

const
  SDL_ORIENTATION_UNKNOWN           = TSDL_DisplayOrientation(0);   {**< The display orientation can't be determined *}
  SDL_ORIENTATION_LANDSCAPE         = TSDL_DisplayOrientation(1);   {**< The display is in landscape mode, with the right side up, relative to portrait mode *}
  SDL_ORIENTATION_LANDSCAPE_FLIPPED = TSDL_DisplayOrientation(2);   {**< The display is in landscape mode, with the left side up, relative to portrait mode *}
  SDL_ORIENTATION_PORTRAIT          = TSDL_DisplayOrientation(3);   {**< The display is in portrait mode *}
  SDL_ORIENTATION_PORTRAIT_FLIPPED  = TSDL_DisplayOrientation(4);   {**< The display is in portrait mode, upside down *}

  {**
   *  \brief Window flash operation
   *}
type
  TSDL_FlashOperation = type Integer;

const
  SDL_FLASH_CANCEL               = TSDL_FlashOperation(0);   {**< Cancel any window flash state *}
  SDL_FLASH_BRIEFLY              = TSDL_FlashOperation(1);   {**< Flash the window briefly to get attention *}
  SDL_FLASH_UNTIL_FOCUSED        = TSDL_FlashOperation(2);   {**< Flash the window until it gets focus *}

  {**
   *  An opaque handle to an OpenGL context.
   *}
type
  TSDL_GLContext = Pointer;

  {**
   *  OpenGL configuration attributes
   *}
type
  TSDL_GLattr = type Integer;

const
  SDL_GL_RED_SIZE                         = TSDL_GLattr(0);
  SDL_GL_GREEN_SIZE                       = TSDL_GLattr(1);
  SDL_GL_BLUE_SIZE                        = TSDL_GLattr(2);
  SDL_GL_ALPHA_SIZE                       = TSDL_GLattr(3);
  SDL_GL_BUFFER_SIZE                      = TSDL_GLattr(4);
  SDL_GL_DOUBLEBUFFER                     = TSDL_GLattr(5);
  SDL_GL_DEPTH_SIZE                       = TSDL_GLattr(6);
  SDL_GL_STENCIL_SIZE                     = TSDL_GLattr(7);
  SDL_GL_ACCUM_RED_SIZE                   = TSDL_GLattr(8);
  SDL_GL_ACCUM_GREEN_SIZE                 = TSDL_GLattr(9);
  SDL_GL_ACCUM_BLUE_SIZE                  = TSDL_GLattr(10);
  SDL_GL_ACCUM_ALPHA_SIZE                 = TSDL_GLattr(11);
  SDL_GL_STEREO                           = TSDL_GLattr(12);
  SDL_GL_MULTISAMPLEBUFFERS               = TSDL_GLattr(13);
  SDL_GL_MULTISAMPLESAMPLES               = TSDL_GLattr(14);
  SDL_GL_ACCELERATED_VISUAL               = TSDL_GLattr(15);
  SDL_GL_RETAINED_BACKING                 = TSDL_GLattr(16);
  SDL_GL_CONTEXT_MAJOR_VERSION            = TSDL_GLattr(17);
  SDL_GL_CONTEXT_MINOR_VERSION            = TSDL_GLattr(18);
  SDL_GL_CONTEXT_EGL                      = TSDL_GLattr(19);
  SDL_GL_CONTEXT_FLAGS                    = TSDL_GLattr(20);
  SDL_GL_CONTEXT_PROFILE_MASK             = TSDL_GLattr(21);
  SDL_GL_SHARE_WITH_CURRENT_CONTEXT       = TSDL_GLattr(22);
  SDL_GL_FRAMEBUFFER_SRGB_CAPABLE         = TSDL_GLattr(23);
  SDL_GL_CONTEXT_RELEASE_BEHAVIOR         = TSDL_GLattr(24);
  SDL_GL_CONTEXT_RESET_NOTIFICATION       = TSDL_GLattr(25);
  SDL_GL_CONTEXT_NO_ERROR                 = TSDL_GLattr(26);

type
  TSDL_GLprofile = type Integer;

const
  SDL_GL_CONTEXT_PROFILE_CORE           = TSDL_GLprofile($0001);
  SDL_GL_CONTEXT_PROFILE_COMPATIBILITY  = TSDL_GLprofile($0002);
  SDL_GL_CONTEXT_PROFILE_ES             = TSDL_GLprofile($0004);

type
  TSDL_GLcontextFlag = type Integer;

const
  SDL_GL_CONTEXT_DEBUG_FLAG              = TSDL_GLcontextFlag($0001);
  SDL_GL_CONTEXT_FORWARD_COMPATIBLE_FLAG = TSDL_GLcontextFlag($0002);
  SDL_GL_CONTEXT_ROBUST_ACCESS_FLAG      = TSDL_GLcontextFlag($0004);
  SDL_GL_CONTEXT_RESET_ISOLATION_FLAG    = TSDL_GLcontextFlag($0008);

type
  TSDL_GLcontextReleaseFlag = type Integer;

const
  SDL_GL_CONTEXT_RELEASE_BEHAVIOR_NONE   = TSDL_GLcontextReleaseFlag($0000);
  SDL_GL_CONTEXT_RELEASE_BEHAVIOR_FLUSH  = TSDL_GLcontextReleaseFlag($0001);

type
  TSDL_GLContextResetNotification = type Integer;

const
  SDL_GL_CONTEXT_RESET_NO_NOTIFICATION   = TSDL_GLContextResetNotification($0000);
  SDL_GL_CONTEXT_RESET_LOSE_CONTEXT      = TSDL_GLContextResetNotification($0001);

  {* Function prototypes *}

  {**
   *  Get the number of video drivers compiled into SDL
   *
   *  SDL_GetVideoDriver()
   *}

function SDL_GetNumVideoDrivers: cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetNumVideoDrivers' {$ENDIF} {$ENDIF};

  {**
   *  Get the name of a built in video driver.
   *
   *  The video drivers are presented in the order in which they are
   *  normally checked during initialization.
   *
   *  SDL_GetNumVideoDrivers()
   *}

function SDL_GetVideoDriver(index: cint): PAnsiChar; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetVideoDriver' {$ENDIF} {$ENDIF};

  {**
   *  Initialize the video subsystem, optionally specifying a video driver.
   *
   *  driver_name Initialize a specific driver by name, or nil for the
   *  default video driver.
   *
   *  0 on success, -1 on error
   *
   *  This function initializes the video subsystem; setting up a connection
   *  to the window manager, etc, and determines the available display modes
   *  and pixel formats, but does not initialize a window or graphics mode.
   *
   *  SDL_VideoQuit()
   *}

function SDL_VideoInit(const driver_name: PAnsiChar): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_VideoInit' {$ENDIF} {$ENDIF};

  {**
   *  Shuts down the video subsystem.
   *
   *  function closes all windows, and restores the original video mode.
   *  
   *  SDL_VideoInit()
   *}
procedure SDL_VideoQuit; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_VideoQuit' {$ENDIF} {$ENDIF};

  {**
   *  Returns the name of the currently initialized video driver.
   *
   *  The name of the current video driver or nil if no driver
   *  has been initialized
   *
   *  SDL_GetNumVideoDrivers()
   *  SDL_GetVideoDriver()
   *}

function SDL_GetCurrentVideoDriver: PAnsiChar; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetCurrentVideoDriver' {$ENDIF} {$ENDIF};

  {**
   *  Returns the number of available video displays.
   *  
   *  SDL_GetDisplayBounds()
   *}

function SDL_GetNumVideoDisplays: cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetNumVideoDisplays' {$ENDIF} {$ENDIF};

  {**
   *  Get the name of a display in UTF-8 encoding
   *
   *  The name of a display, or nil for an invalid display index.
   *  
   *  SDL_GetNumVideoDisplays()
   *}

function SDL_GetDisplayName(displayIndex: cint): PAnsiChar; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetDisplayName' {$ENDIF} {$ENDIF};

  {**
   *  Get the desktop area represented by a display, with the primary
   *  display located at 0,0
   *
   *  0 on success, or -1 if the index is out of range.
   *
   *  SDL_GetNumVideoDisplays()
   *}

function SDL_GetDisplayBounds(displayIndex: cint; rect: PSDL_Rect): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetDisplayBounds' {$ENDIF} {$ENDIF};

{**
 *  \brief Get the usable desktop area represented by a display, with the
 *         primary display located at 0,0
 *
 *  This is the same area as SDL_GetDisplayBounds() reports, but with portions
 *  reserved by the system removed. For example, on Mac OS X, this subtracts
 *  the area occupied by the menu bar and dock.
 *
 *  Setting a window to be fullscreen generally bypasses these unusable areas,
 *  so these are good guidelines for the maximum space available to a
 *  non-fullscreen window.
 *
 *  \return 0 on success, or -1 if the index is out of range.
 *
 *  \sa SDL_GetDisplayBounds()
 *  \sa SDL_GetNumVideoDisplays()
 *}
function SDL_GetDisplayUsableBounds(displayIndex: cint; rect: PSDL_Rect): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetDisplayUsableBounds' {$ENDIF} {$ENDIF};

  {**
   *  \brief Get the dots/pixels-per-inch for a display
   *
   *  \note Diagonal, horizontal and vertical DPI can all be optionally
   *        returned if the parameter is non-NULL.
   *
   *  \return 0 on success, or -1 if no DPI information is available or the index is out of range.
   *
   *  \sa SDL_GetNumVideoDisplays()
   *}
function SDL_GetDisplayDPI(displayIndex: cint; ddpi, hdpi, vdpi: pcfloat): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetDisplayDPI' {$ENDIF} {$ENDIF};

{**
 *  \brief Get the orientation of a display
 *
 *  \return The orientation of the display, or SDL_ORIENTATION_UNKNOWN if it isn't available.
 *
 *  \sa SDL_GetNumVideoDisplays()
 *}
function SDL_DisplayOrientation(displayIndex: cint): TSDL_DisplayOrientation; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_DisplayOrientation' {$ENDIF} {$ENDIF};

  {**
   *  Returns the number of available display modes.
   *
   *  SDL_GetDisplayMode()
   *}

function SDL_GetNumDisplayModes(displayIndex: cint): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetNumDisplayModes' {$ENDIF} {$ENDIF};

  {**
   *  Fill in information about a specific display mode.
   *
   *  The display modes are sorted in this priority:
   *        bits per pixel -> more colors to fewer colors
   *        width -> largest to smallest
   *        height -> largest to smallest
   *        refresh rate -> highest to lowest
   *
   *  SDL_GetNumDisplayModes()
   *}

function SDL_GetDisplayMode(displayIndex: cint; modeIndex: cint; mode: PSDL_DisplayMode): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetDisplayMode' {$ENDIF} {$ENDIF};

  {**
   *  Fill in information about the desktop display mode.
   *}

function SDL_GetDesktopDisplayMode(displayIndex: cint; mode: PSDL_DisplayMode): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetDesktopDisplayMode' {$ENDIF} {$ENDIF};

  {**
   *  Fill in information about the current display mode.
   *}

function SDL_GetCurrentDisplayMode(displayIndex: cint; mode: PSDL_DisplayMode): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetCurrentDisplayIndex' {$ENDIF} {$ENDIF};

  {**
   *  Get the closest match to the requested display mode.
   *
   *  mode The desired display mode
   *  closest A pointer to a display mode to be filled in with the closest
   *  match of the available display modes.
   *
   *  The passed in value closest, or nil if no matching video mode
   *  was available.
   *  
   *  The available display modes are scanned, and closest is filled in with the
   *  closest mode matching the requested mode and returned.  The mode format and 
   *  refresh_rate default to the desktop mode if they are 0.  The modes are
   *  scanned with size being first priority, format being second priority, and 
   *  finally checking the refresh_rate.  If all the available modes are too
   *  small, then nil is returned.
   *
   *  SDL_GetNumDisplayModes()
   *  SDL_GetDisplayMode()
   *}

function SDL_GetClosestDisplayMode(displayIndex: cint; const mode: PSDL_DisplayMode; closest: PSDL_DisplayMode): PSDL_DisplayMode; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetClosestDisplayMode' {$ENDIF} {$ENDIF};

  {**
   *  Get the display index associated with a window.
   *  
   *  the display index of the display containing the center of the
   *  window, or -1 on error.
   *}

function SDL_GetWindowDisplayIndex(window: PSDL_Window): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetWindowDisplayIndex' {$ENDIF} {$ENDIF};

  {**
   *  Set the display mode used when a fullscreen window is visible.
   *
   *  By default the window's dimensions and the desktop format and refresh rate
   *  are used.
   *  
   *  mode The mode to use, or nil for the default mode.
   *  
   *  0 on success, or -1 if setting the display mode failed.
   *  
   *  SDL_GetWindowDisplayMode()
   *  SDL_SetWindowFullscreen()
   *}

function SDL_SetWindowDisplayMode(window: PSDL_Window; const mode: PSDL_DisplayMode): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_SetWindowDisplayMode' {$ENDIF} {$ENDIF};

  {**
   *  Fill in information about the display mode used when a fullscreen
   *  window is visible.
   *
   *  SDL_SetWindowDisplayMode()
   *  SDL_SetWindowFullscreen()
   *}

function SDL_GetWindowDisplayMode(window: PSDL_Window; mode: PSDL_DisplayMode): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetWindowDisplayMode' {$ENDIF} {$ENDIF};

  {**
   *  Get the pixel format associated with the window.
   *}

function SDL_GetWindowPixelFormat(window: PSDL_Window): cuint32; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetWindowPixelFormat' {$ENDIF} {$ENDIF};

  {**
   *  \brief Create a window with the specified position, dimensions, and flags.
   *
   *  \param title The title of the window, in UTF-8 encoding.
   *  \param x     The x position of the window, ::SDL_WINDOWPOS_CENTERED, or
   *               ::SDL_WINDOWPOS_UNDEFINED.
   *  \param y     The y position of the window, ::SDL_WINDOWPOS_CENTERED, or
   *               ::SDL_WINDOWPOS_UNDEFINED.
   *  \param w     The width of the window, in screen coordinates.
   *  \param h     The height of the window, in screen coordinates.
   *  \param flags The flags for the window, a mask of any of the following:
   *               ::SDL_WINDOW_FULLSCREEN,    ::SDL_WINDOW_OPENGL,
   *               ::SDL_WINDOW_HIDDEN,        ::SDL_WINDOW_BORDERLESS,
   *               ::SDL_WINDOW_RESIZABLE,     ::SDL_WINDOW_MAXIMIZED,
   *               ::SDL_WINDOW_MINIMIZED,     ::SDL_WINDOW_INPUT_GRABBED,
   *               ::SDL_WINDOW_ALLOW_HIGHDPI, ::SDL_WINDOW_VULKAN.
   *
   *  \return The created window, or NULL if window creation failed.
   *
   *  If the window is created with the SDL_WINDOW_ALLOW_HIGHDPI flag, its size
   *  in pixels may differ from its size in screen coordinates on platforms with
   *  high-DPI support (e.g. iOS and Mac OS X). Use SDL_GetWindowSize() to query
   *  the client area's size in screen coordinates, and SDL_GL_GetDrawableSize(),
   *  SDL_Vulkan_GetDrawableSize(), or SDL_GetRendererOutputSize() to query the
   *  drawable size in pixels.
   *
   *  If the window is created with any of the SDL_WINDOW_OPENGL or
   *  SDL_WINDOW_VULKAN flags, then the corresponding LoadLibrary function
   *  (SDL_GL_LoadLibrary or SDL_Vulkan_LoadLibrary) is called and the
   *  corresponding UnloadLibrary function is called by SDL_DestroyWindow().
   *
   *  If SDL_WINDOW_VULKAN is specified and there isn't a working Vulkan driver,
   *  SDL_CreateWindow() will fail because SDL_Vulkan_LoadLibrary() will fail.
   *
   *  \note On non-Apple devices, SDL requires you to either not link to the
   *        Vulkan loader or link to a dynamic library version. This limitation
   *        may be removed in a future version of SDL.
   *
   *  \sa SDL_DestroyWindow()
   *  \sa SDL_GL_LoadLibrary()
   *  \sa SDL_Vulkan_LoadLibrary()
   *}

function SDL_CreateWindow(const title: PAnsiChar; x: cint; y: cint; w: cint; h: cint; flags: TSDL_WindowFlags): PSDL_Window; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_CreateWindow' {$ENDIF} {$ENDIF};

  {**
   *  Create an SDL window from an existing native window.
   *  
   *  data A pointer to driver-dependent window creation data
   *  
   *  The id of the window created, or zero if window creation failed.
   *
   *  SDL_DestroyWindow()
   *}

function SDL_CreateWindowFrom(const data: Pointer): PSDL_Window; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_CreateWindowFrom' {$ENDIF} {$ENDIF};

  {**
   *  Get the numeric ID of a window, for logging purposes.
   *}

function SDL_GetWindowID(window: PSDL_Window): cuint32; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetWindowID' {$ENDIF} {$ENDIF};

  {**
   *  Get a window from a stored ID, or nil if it doesn't exist.
   *}

function SDL_GetWindowFromID(id: cuint32): PSDL_Window; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetWindowFromID' {$ENDIF} {$ENDIF};

  {**
   *  Get the window flags.
   *}

function SDL_GetWindowFlags(window: PSDL_Window): TSDL_WindowFlags; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetWindowFlags' {$ENDIF} {$ENDIF};

  {**
   *  Set the title of a window, in UTF-8 format.
   *  
   *  SDL_GetWindowTitle()
   *}

procedure SDL_SetWindowTitle(window: PSDL_Window; const title: PAnsiChar); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetWindowTitle' {$ENDIF} {$ENDIF};

  {**
   *  Get the title of a window, in UTF-8 format.
   *
   *  SDL_SetWindowTitle()
   *}

function SDL_GetWindowTitle(window: PSDL_Window): PAnsiChar; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetWindowTitle' {$ENDIF} {$ENDIF};

  {**
   *  Set the icon for a window.
   *
   *  icon The icon for the window.
   *}

procedure SDL_SetWindowIcon(window: PSDL_Window; icon: PSDL_Surface); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_SetWindowIcon' {$ENDIF} {$ENDIF};

  {**
   *  Associate an arbitrary named pointer with a window.
   *  
   *  window   The window to associate with the pointer.
   *  name     The name of the pointer.
   *  userdata The associated pointer.
   *
   *  The previous value associated with 'name'
   *
   *  The name is case-sensitive.
   *
   *  SDL_GetWindowData()
   *}

function SDL_SetWindowData(window: PSDL_Window; const name: PAnsiChar; userdata: Pointer): Pointer; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_SetWindowData' {$ENDIF} {$ENDIF};

  {**
   *  Retrieve the data pointer associated with a window.
   *
   *  window   The window to query.
   *  name     The name of the pointer.
   *
   *  The value associated with 'name'
   *
   *  SDL_SetWindowData()
   *}

function SDL_GetWindowData(window: PSDL_Window; const name: PAnsiChar): Pointer; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetWindowData' {$ENDIF} {$ENDIF};

  {**
   *  Set the position of a window.
   *
   *  window   The window to reposition.
   *  x        The x coordinate of the window, SDL_WINDOWPOS_CENTERED, or
   *                  SDL_WINDOWPOS_UNDEFINED.
   *  y        The y coordinate of the window, SDL_WINDOWPOS_CENTERED, or
   *                  SDL_WINDOWPOS_UNDEFINED.
   *
   *  The window coordinate origin is the upper left of the display.
   *
   *  SDL_GetWindowPosition()
   *}

procedure SDL_SetWindowPosition(window: PSDL_Window; x: cint; y: cint); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_SetWindowPosition' {$ENDIF} {$ENDIF};

  {**
   *  Get the position of a window.
   *
   *  x        Pointer to variable for storing the x position, may be nil
   *  y        Pointer to variable for storing the y position, may be nil
   *
   *  SDL_SetWindowPosition()
   *}

procedure SDL_GetWindowPosition(window: PSDL_Window; x: pcint; y: pcint); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetWindowPosition' {$ENDIF} {$ENDIF};

  {**
   *  Set the size of a window's client area.
   *
   *  w        The width of the window, must be >0
   *  h        The height of the window, must be >0
   *
   *  You can't change the size of a fullscreen window, it automatically
   *  matches the size of the display mode.
   *  
   *  SDL_GetWindowSize()
   *}

procedure SDL_SetWindowSize(window: PSDL_Window; w: cint; h: cint); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_SetWindowSize' {$ENDIF} {$ENDIF};

  {**
   *  Get the size of a window's client area.
   *  
   *  w        Pointer to variable for storing the width, may be nil
   *  h        Pointer to variable for storing the height, may be nil
   *  
   *  SDL_SetWindowSize()
   *}

procedure SDL_GetWindowSize(window: PSDL_Window; w: pcint; h: pcint); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetWindowSize' {$ENDIF} {$ENDIF};

  {**
   *  \brief Get the size of a window's borders (decorations) around the client area.
   *
   *  \param window The window to query.
   *  \param top Pointer to variable for storing the size of the top border. NULL is permitted.
   *  \param left Pointer to variable for storing the size of the left border. NULL is permitted.
   *  \param bottom Pointer to variable for storing the size of the bottom border. NULL is permitted.
   *  \param right Pointer to variable for storing the size of the right border. NULL is permitted.
   *
   *  \return 0 on success, or -1 if getting this information is not supported.
   *
   *  \note if this function fails (returns -1), the size values will be
   *        initialized to 0, 0, 0, 0 (if a non-NULL pointer is provided), as
   *        if the window in question was borderless.
   *}
function SDL_GetWindowBordersSize(window: PSDL_Window; top, left, bottom, right: pcint): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetWindowBordersSize' {$ENDIF} {$ENDIF};

  {**
   *  Set the minimum size of a window's client area.
   *  
   *  min_w     The minimum width of the window, must be >0
   *  min_h     The minimum height of the window, must be >0
   *
   *  You can't change the minimum size of a fullscreen window, it
   *  automatically matches the size of the display mode.
   *
   *  SDL_GetWindowMinimumSize()
   *  SDL_SetWindowMaximumSize()
   *}

procedure SDL_SetWindowMinimumSize(window: PSDL_Window; min_w: cint; min_h: cint); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_SetWindowMinimumSize' {$ENDIF} {$ENDIF};
    
  {**
   *  Get the minimum size of a window's client area.
   *  
   *  w        Pointer to variable for storing the minimum width, may be nil
   *  h        Pointer to variable for storing the minimum height, may be nil
   *
   *  SDL_GetWindowMaximumSize()
   *  SDL_SetWindowMinimumSize()
   *}

procedure SDL_GetWindowMinimumSize(window: PSDL_Window; w: pcint; h: pcint); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetWindowMinimumSize' {$ENDIF} {$ENDIF};

  {**
   *  Set the maximum size of a window's client area.
   *
   *  max_w     The maximum width of the window, must be >0
   *  max_h     The maximum height of the window, must be >0
   *
   *  You can't change the maximum size of a fullscreen window, it
   *  automatically matches the size of the display mode.
   *
   *  SDL_GetWindowMaximumSize()
   *  SDL_SetWindowMinimumSize()
   *}

procedure SDL_SetWindowMaximumSize(window: PSDL_Window; max_w: cint; max_h: cint); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_SetWindowMaximumSize' {$ENDIF} {$ENDIF};

  {**
   *  Get the maximum size of a window's client area.
   *  
   *  w        Pointer to variable for storing the maximum width, may be nil
   *  h        Pointer to variable for storing the maximum height, may be nil
   *
   *  SDL_GetWindowMinimumSize()
   *  SDL_SetWindowMaximumSize()
   *}

procedure SDL_GetWindowMaximumSize(window: PSDL_Window; w: pcint; h: pcint); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetWindowMaximumSize' {$ENDIF} {$ENDIF};

  {**
   *  Set the border state of a window.
   *
   *  This will add or remove the window's SDL_WINDOW_BORDERLESS flag and
   *  add or remove the border from the actual window. This is a no-op if the
   *  window's border already matches the requested state.
   *
   *  window The window of which to change the border state.
   *  bordered SDL_FALSE to remove border, SDL_TRUE to add border.
   *
   *  You can't change the border state of a fullscreen window.
   *  
   *  SDL_GetWindowFlags()
   *}

procedure SDL_SetWindowBordered(window: PSDL_Window; bordered: TSDL_Bool); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_SetWindowBordered' {$ENDIF} {$ENDIF};

  {**
   *  \brief Set the user-resizable state of a window.
   *
   *  This will add or remove the window's SDL_WINDOW_RESIZABLE flag and
   *  allow/disallow user resizing of the window. This is a no-op if the
   *  window's resizable state already matches the requested state.
   *
   *  \param window The window of which to change the resizable state.
   *  \param resizable SDL_TRUE to allow resizing, SDL_FALSE to disallow.
   *
   *  \note You can't change the resizable state of a fullscreen window.
   *
   *  \sa SDL_GetWindowFlags()
   *}
procedure SDL_SetWindowResizable(window: PSDL_Window; resizable: TSDL_Bool); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_SetWindowResizable' {$ENDIF} {$ENDIF};

  {**
   *  Show a window.
   *  
   *  SDL_HideWindow()
   *}

procedure SDL_ShowWindow(window: PSDL_Window); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_ShowWindow' {$ENDIF} {$ENDIF};

  {**
   *  Hide a window.
   *  
   *  SDL_ShowWindow()
   *}

procedure SDL_HideWindow(window: PSDL_Window); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_HideWindow' {$ENDIF} {$ENDIF};

  {**
   *  Raise a window above other windows and set the input focus.
   *}

procedure SDL_RaiseWindow(window: PSDL_Window); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_RaiseWindow' {$ENDIF} {$ENDIF};

  {**
   *  Make a window as large as possible.
   *  
   *  SDL_RestoreWindow()
   *}

procedure SDL_MaximizeWindow(window: PSDL_Window); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_MaximizeWindow' {$ENDIF} {$ENDIF};

  {**
   *  Minimize a window to an iconic representation.
   *
   *  SDL_RestoreWindow()
   *}

procedure SDL_MinimizeWindow(window: PSDL_Window); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_MinimizeWindow' {$ENDIF} {$ENDIF};

  {**
   *  Restore the size and position of a minimized or maximized window.
   *  
   *  SDL_MaximizeWindow()
   *  SDL_MinimizeWindow()
   *}

procedure SDL_RestoreWindow(window: PSDL_Window); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_RestoreWindow' {$ENDIF} {$ENDIF};

  {**
   *  Set a window's fullscreen state.
   *  
   *  0 on success, or -1 if setting the display mode failed.
   *  
   *  SDL_SetWindowDisplayMode()
   *  SDL_GetWindowDisplayMode()
   *}

function SDL_SetWindowFullscreen(window: PSDL_Window; flags: TSDL_WindowFlags): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_SetWindowFullscreen' {$ENDIF} {$ENDIF};

  {**
   *  Get the SDL surface associated with the window.
   *
   *  The window's framebuffer surface, or nil on error.
   *
   *  A new surface will be created with the optimal format for the window,
   *  if necessary. This surface will be freed when the window is destroyed.
   *
   *  You may not combine this with 3D or the rendering API on this window.
   *
   *  SDL_UpdateWindowSurface()
   *  SDL_UpdateWindowSurfaceRects()
   *}

function SDL_GetWindowSurface(window: PSDL_Window): PSDL_Surface; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetWindowSurface' {$ENDIF} {$ENDIF};

  {**
   *  Copy the window surface to the screen.
   *
   *  0 on success, or -1 on error.
   *
   *  SDL_GetWindowSurface()
   *  SDL_UpdateWindowSurfaceRects()
   *}

function SDL_UpdateWindowSurface(window: PSDL_Window): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_UpdateWindowSurface' {$ENDIF} {$ENDIF};

  {**
   *  Copy a number of rectangles on the window surface to the screen.
   *
   *  0 on success, or -1 on error.
   *
   *  SDL_GetWindowSurface()
   *  SDL_UpdateWindowSurfaceRect()
   *}

function SDL_UpdateWindowSurfaceRects(window: PSDL_Window; rects: PSDL_Rect; numrects: cint): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_UpdateWindowSurfaceRects' {$ENDIF} {$ENDIF};

  {**
   *  Set a window's input grab mode.
   *  
   *  grabbed This is SDL_TRUE to grab input, and SDL_FALSE to release input.
   *  
   *  SDL_GetWindowGrab()
   *}

procedure SDL_SetWindowGrab(window: PSDL_Window; grabbed: TSDL_Bool); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_SetWindowGrab' {$ENDIF} {$ENDIF};

  {**
   *  Get a window's input grab mode.
   *  
   *  This returns SDL_TRUE if input is grabbed, and SDL_FALSE otherwise.
   *
   *  SDL_SetWindowGrab()
   *}

function SDL_GetWindowGrab(window: PSDL_Window): TSDL_Bool; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetWindowGrab' {$ENDIF} {$ENDIF};
  
  {**
   *  Set a window's keyboard grab mode.
   *
   *  window The window for which the keyboard grab mode should be set.
   *  rect This is SDL_TRUE to grab keyboard, and SDL_FALSE to release.
   *
   *  SDL_GetWindowKeyboardGrab()
   *}

procedure SDL_SetWindowKeyboardGrab(window: PSDL_Window; rect: PSDL_Rect); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_SetWindowKeyboardGrab' {$ENDIF} {$ENDIF};

  {**
   *  Get a window's keyboard grab mode.
   *
   *  Returns SDL_TRUE if keyboard is grabbed, and SDL_FALSE otherwise.
   *
   *  SDL_SetWindowKeyboardGrab()
   *}

function SDL_GetWindowKeyboardGrab(window: PSDL_Window): TSDL_Bool; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetWindowKeyboardGrab' {$ENDIF} {$ENDIF};

  {**
   *  Set a window's mouse grab mode.
   *
   *  window The window for which the mouse grab mode should be set.
   *  grabbed This is SDL_TRUE to grab mouse, and SDL_FALSE to release.
   *
   *  SDL_GetWindowMouseGrab()
   *}

procedure SDL_SetWindowMouseGrab(window: PSDL_Window; grabbed: TSDL_Bool); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_SetWindowMouseGrab' {$ENDIF} {$ENDIF};

  {**
   *  Get a window's mouse grab mode.
   *
   *  Returns SDL_TRUE if mouse is grabbed, and SDL_FALSE otherwise.
   *
   *  SDL_SetWindowMouseGrab()
   *}

function SDL_GetWindowMouseGrab(window: PSDL_Window): TSDL_Bool; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetWindowMouseGrab' {$ENDIF} {$ENDIF};

  {**
   *  Confines the cursor to the specified area of a window.
   *
   *  window The window that will be associated with the barrier.
   *  rect A rectangle area in window-relative coordinates. If NULL the barrier for the specified window will be destroyed.
   *
   *  SDL_GetWindowMouseRect()
   *}

procedure SDL_SetWindowMouseRect(window: PSDL_Window; rect: PSDL_Rect); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_SetWindowMouseRect' {$ENDIF} {$ENDIF};

  {**
   *  Get the mouse confinement rectangle of a window.
   *
   *  Returns A pointer to the mouse confinement rectangle of a window, or NULL if there isn't one.
   *
   *  SDL_SetWindowMouseRect()
   *}

function SDL_GetWindowMouseRect(window: PSDL_Window): PSDL_Rect; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetWindowMouseRect' {$ENDIF} {$ENDIF};

  {**
   *  \brief Get the window that currently has an input grab enabled.
   *
   *  \return This returns the window if input is grabbed, and NULL otherwise.
   *
   *  \sa SDL_SetWindowGrab()
   *}
function SDL_GetGrabbedWindow(): PSDL_Window; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetGrabbedWindow' {$ENDIF} {$ENDIF};

  {**
   *  Set the brightness (gamma correction) for a window.
   *
   *  0 on success, or -1 if setting the brightness isn't supported.
   *
   *  SDL_GetWindowBrightness()
   *  SDL_SetWindowGammaRamp()
   *}

function SDL_SetWindowBrightness(window: PSDL_Window; brightness: cfloat): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_SetWindowBrightness' {$ENDIF} {$ENDIF};

  {**
   *  Get the brightness (gamma correction) for a window.
   *  
   *  The last brightness value passed to SDL_SetWindowBrightness()
   *
   *  SDL_SetWindowBrightness()
   *}

function SDL_GetWindowBrightness(window: PSDL_Window): cfloat; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetWindowBrightness' {$ENDIF} {$ENDIF};

  {**
   *  \brief Set the opacity for a window
   *
   *  \param window The window which will be made transparent or opaque
   *  \param opacity Opacity (0.0f - transparent, 1.0f - opaque) This will be
   *                 clamped internally between 0.0f and 1.0f.
   * 
   *  \return 0 on success, or -1 if setting the opacity isn't supported.
   *
   *  \sa SDL_GetWindowOpacity()
   *}
function SDL_SetWindowOpacity(window: PSDL_Window; opacity: cfloat): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_SetWindowOpacity' {$ENDIF} {$ENDIF};

  {**
   *  \brief Get the opacity of a window.
   *
   *  If transparency isn't supported on this platform, opacity will be reported
   *  as 1.0f without error.
   *
   *  \param window The window in question.
   *  \param out_opacity Opacity (0.0f - transparent, 1.0f - opaque)
   *
   *  \return 0 on success, or -1 on error (invalid window, etc).
   *
   *  \sa SDL_SetWindowOpacity()
   *}
function SDL_GetWindowOpacity(window: PSDL_Window; out_opacity: pcfloat): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetWindowOpacity' {$ENDIF} {$ENDIF};

  {** 
   *  \brief Sets the window as a modal for another window
   *
   *  \param modal_window The window that should be modal
   *  \param parent_window The parent window
   * 
   *  \return 0 on success, or -1 otherwise.
   *}
function SDL_SetWindowModalFor(modal_window, parent_window: PSDL_Window): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_SetWindowModalFor' {$ENDIF} {$ENDIF};

  {**
   *  \brief Explicitly sets input focus to the window.
   *
   *  You almost certainly want SDL_RaiseWindow() instead of this function. Use
   *  this with caution, as you might give focus to a window that's completely
   *  obscured by other windows.
   *
   *  \param window The window that should get the input focus
   * 
   *  \return 0 on success, or -1 otherwise.
   *  \sa SDL_RaiseWindow()
   *}
function SDL_SetWindowInputFocus(window: PSDL_Window): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_SetWindowInputFocus' {$ENDIF} {$ENDIF};

  {**
   *  Set the gamma ramp for a window.
   *  
   *  red The translation table for the red channel, or nil.
   *  green The translation table for the green channel, or nil.
   *  blue The translation table for the blue channel, or nil.
   *
   *  0 on success, or -1 if gamma ramps are unsupported.
   *  
   *  Set the gamma translation table for the red, green, and blue channels
   *  of the video hardware.  Each table is an array of 256 16-bit quantities,
   *  representing a mapping between the input and output for that channel.
   *  The input is the index into the array, and the output is the 16-bit
   *  gamma value at that index, scaled to the output color precision.
   *
   *  SDL_GetWindowGammaRamp()
   *}

function SDL_SetWindowGammaRamp(window: PSDL_Window; const red: pcuint16; const green: pcuint16; const blue: pcuint16): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_SetWindowGammaRamp' {$ENDIF} {$ENDIF};

  {**
   *  Get the gamma ramp for a window.
   *
   *  red   A pointer to a 256 element array of 16-bit quantities to hold
   *        the translation table for the red channel, or nil.
   *  green A pointer to a 256 element array of 16-bit quantities to hold
   *        the translation table for the green channel, or nil.
   *  blue  A pointer to a 256 element array of 16-bit quantities to hold
   *        the translation table for the blue channel, or nil.
   *   
   *  0 on success, or -1 if gamma ramps are unsupported.
   *
   *  SDL_SetWindowGammaRamp()
   *}

function SDL_GetWindowGammaRamp(window: PSDL_Window; red: pcuint16; green: pcuint16; blue: pcuint16): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetWindowGammaRamp' {$ENDIF} {$ENDIF};

  { ATTENTION Conv.:

      The SDL_HitTestResult-Enum. and the SDL_HitTest func. are shifted before
      TSDL_Window decl. because it need this.

  }

  {**
   *  \brief Provide a callback that decides if a window region has special properties.
   *
   *  Normally windows are dragged and resized by decorations provided by the
   *  system window manager (a title bar, borders, etc), but for some apps, it
   *  makes sense to drag them from somewhere else inside the window itself; for
   *  example, one might have a borderless window that wants to be draggable
   *  from any part, or simulate its own title bar, etc.
   *
   *  This function lets the app provide a callback that designates pieces of
   *  a given window as special. This callback is run during event processing
   *  if we need to tell the OS to treat a region of the window specially; the
   *  use of this callback is known as "hit testing."
   *
   *  Mouse input may not be delivered to your application if it is within
   *  a special area; the OS will often apply that input to moving the window or
   *  resizing the window and not deliver it to the application.
   *
   *  Specifying NULL for a callback disables hit-testing. Hit-testing is
   *  disabled by default.
   *
   *  Platforms that don't support this functionality will return -1
   *  unconditionally, even if you're attempting to disable hit-testing.
   *
   *  Your callback may fire at any time, and its firing does not indicate any
   *  specific behavior (for example, on Windows, this certainly might fire
   *  when the OS is deciding whether to drag your window, but it fires for lots
   *  of other reasons, too, some unrelated to anything you probably care about
   *  _and when the mouse isn't actually at the location it is testing_).
   *  Since this can fire at any time, you should try to keep your callback
   *  efficient, devoid of allocations, etc.
   *
   *  \param window The window to set hit-testing on.
   *  \param callback The callback to call when doing a hit-test.
   *  \param callback_data An app-defined void pointer passed to the callback.
   *  \return 0 on success, -1 on error (including unsupported).
   *}
function SDL_SetWindowHitTest(window: PSDL_Window; callback: TSDL_HitTest; callback_data: Pointer): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_SetWindowHitTest' {$ENDIF} {$ENDIF};

  {**
   * Request a window to demand attention from the user.
   *
   * \param window the window to be flashed
   * \param operation the flash operation
   * \returns 0 on success or a negative error code on failure; call
   *          SDL_GetError() for more information.
   *
   * \since This function is available since SDL 2.0.16.
   *}
function SDL_FlashWindow(window: PSDL_Window; operation: TSDL_FlashOperation): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_FlashWindow' {$ENDIF} {$ENDIF};

  {**
   *  Destroy a window.
   *}

procedure SDL_DestroyWindow(window: PSDL_Window); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_DestroyWindow' {$ENDIF} {$ENDIF};

  {**
   *  Returns whether the screensaver is currently enabled (default on).
   *  
   *  SDL_EnableScreenSaver()
   *  SDL_DisableScreenSaver()
   *}

function SDL_IsScreenSaverEnabled: TSDL_Bool; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_IsScreenSaverEnabled' {$ENDIF} {$ENDIF};

  {**
   *  Allow the screen to be blanked by a screensaver
   *
   *  SDL_IsScreenSaverEnabled()
   *  SDL_DisableScreenSaver()
   *}

procedure SDL_EnableScreenSaver; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_EnableScreenSaver' {$ENDIF} {$ENDIF};

  {**
   *  Prevent the screen from being blanked by a screensaver
   *
   *  SDL_IsScreenSaverEnabled()
   *  SDL_EnableScreenSaver()
   *}

procedure SDL_DisableScreenSaver; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_DisableScreenSaver' {$ENDIF} {$ENDIF};

  {**
   *  OpenGL support functions
   *}

  {**
   *  Dynamically load an OpenGL library.
   *
   *  path The platform dependent OpenGL library name, or nil to open the
   *              default OpenGL library.
   *
   *  0 on success, or -1 if the library couldn't be loaded.
   *
   *  This should be done after initializing the video driver, but before
   *  creating any OpenGL windows.  If no OpenGL library is loaded, the default
   *  library will be loaded upon creation of the first OpenGL window.
   *
   *  If you do this, you need to retrieve all of the GL functions used in
   *  your program from the dynamic library using SDL_GL_GetProcAddress().
   *
   *  SDL_GL_GetProcAddress()
   *  SDL_GL_UnloadLibrary()
   *}

function SDL_GL_LoadLibrary(const path: PAnsiChar): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GL_LoadLibrary' {$ENDIF} {$ENDIF};

  {**
   *  Get the address of an OpenGL function.
   *}

function SDL_GL_GetProcAddress(const proc: PAnsiChar): Pointer; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GL_GetProcAddress' {$ENDIF} {$ENDIF};

  {**
   *  Unload the OpenGL library previously loaded by SDL_GL_LoadLibrary().
   *
   *  SDL_GL_LoadLibrary()
   *}

procedure SDL_GL_UnloadLibrary; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GL_UnloadLibrary' {$ENDIF} {$ENDIF};

  {**
   *  Return true if an OpenGL extension is supported for the current
   *  context.
   *}

function SDL_GL_ExtensionSupported(const extension: PAnsiChar): TSDL_Bool; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GL_ExtensionSupported' {$ENDIF} {$ENDIF};

  {**
   *  Reset all previously set OpenGL context attributes to their default values
   *}
procedure SDL_GL_ResetAttributes(); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GL_ResetAttributes' {$ENDIF} {$ENDIF};

  {**
   *  Set an OpenGL window attribute before window creation.
   *}

function SDL_GL_SetAttribute(attr: TSDL_GLattr; value: cint): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GL_SetAttribute' {$ENDIF} {$ENDIF};

  {**
   *  Get the actual value for an attribute from the current context.
   *}

function SDL_GL_GetAttribute(attr: TSDL_GLattr; value: pcint): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GL_GetAttribute' {$ENDIF} {$ENDIF};

  {**
   *  Create an OpenGL context for use with an OpenGL window, and make it
   *  current.
   *
   *  SDL_GL_DeleteContext()
   *}

function SDL_GL_CreateContext(window: PSDL_Window): TSDL_GLContext; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GL_CreateContext' {$ENDIF} {$ENDIF};

  {**
   *  Set up an OpenGL context for rendering into an OpenGL window.
   *
   *  The context must have been created with a compatible window.
   *}

function SDL_GL_MakeCurrent(window: PSDL_Window; context: TSDL_GLContext): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GL_MakeCurrent' {$ENDIF} {$ENDIF};

  {**
   *  Get the currently active OpenGL window.
   *}
function SDL_GL_GetCurrentWindow: PSDL_Window; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GL_GetCurrentWindow' {$ENDIF} {$ENDIF};

  {**
   *  Get the currently active OpenGL context.
   *}
function SDL_GL_GetCurrentContext: TSDL_GLContext; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GL_GetCurrentContext' {$ENDIF} {$ENDIF};

  {**
   *  Get the size of a window's underlying drawable in pixels (for use
   *  with glViewport).
   *
   *  window   Window from which the drawable size should be queried
   *  w        Pointer to variable for storing the width in pixels, may be NULL
   *  h        Pointer to variable for storing the height in pixels, may be NULL
   *
   * This may differ from SDL_GetWindowSize() if we're rendering to a high-DPI
   * drawable, i.e. the window was created with SDL_WINDOW_ALLOW_HIGHDPI on a
   * platform with high-DPI support (Apple calls this "Retina"), and not disabled
   * by the SDL_HINT_VIDEO_HIGHDPI_DISABLED hint.
   *
   *  SDL_GetWindowSize()
   *  SDL_CreateWindow()
   *}
   
procedure SDL_GL_GetDrawableSize(window: PSDL_Window; w: pcint; h: pcint); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GL_GetDrawableSize' {$ENDIF} {$ENDIF};

  {**
   *  Set the swap interval for the current OpenGL context.
   *  
   *  interval 0 for immediate updates, 1 for updates synchronized with the
   *  vertical retrace. If the system supports it, you may
   *  specify -1 to allow late swaps to happen immediately
   *  instead of waiting for the next retrace.
   *
   *  0 on success, or -1 if setting the swap interval is not supported.
   *
   *  SDL_GL_GetSwapInterval()
   *}

function SDL_GL_SetSwapInterval(interval: cint): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GL_SetSwapInterval' {$ENDIF} {$ENDIF};

  {**
   *  Get the swap interval for the current OpenGL context.
   *
   *  0 if there is no vertical retrace synchronization, 1 if the buffer
   *  swap is synchronized with the vertical retrace, and -1 if late
   *  swaps happen immediately instead of waiting for the next retrace.
   *  If the system can't determine the swap interval, or there isn't a
   *  valid current context, this will return 0 as a safe default.
   *  
   *  SDL_GL_SetSwapInterval()
   *}

function SDL_GL_GetSwapInterval: cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GL_GetSwapInterval' {$ENDIF} {$ENDIF};

  {**
   *  Swap the OpenGL buffers for a window, if double-buffering is
   *  supported.
   *}

procedure SDL_GL_SwapWindow(window: PSDL_Window); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GL_SwapWindow' {$ENDIF} {$ENDIF};

  {**
   *  Delete an OpenGL context.
   *  
   *  SDL_GL_CreateContext()
   *}

procedure SDL_GL_DeleteContext(context: TSDL_GLContext); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GL_DeleteContext' {$ENDIF} {$ENDIF};

  {*OpenGL support functions*}
