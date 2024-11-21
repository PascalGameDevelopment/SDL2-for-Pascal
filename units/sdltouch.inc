//from "sdl_touch.h"

type
  PPSDL_TouchID = ^PSDL_TouchID;
  PSDL_TouchID  = ^TSDL_TouchID;
  TSDL_TouchID  = type cint64;

  PPSDL_FingerID = ^PSDL_FingerID;
  PSDL_FingerID = ^TSDL_FingerID;
  TSDL_FingerID = type cint64;

  PPSDL_TouchDeviceType = ^PSDL_TouchDeviceType;
  PSDL_TouchDeviceType = ^TSDL_TouchDeviceType;
  TSDL_TouchDeviceType = type cint;

const
  SDL_TOUCH_DEVICE_INVALID           = TSDL_TouchDeviceType(-1);
  SDL_TOUCH_DEVICE_DIRECT            = TSDL_TouchDeviceType(0);  {* touch screen with window-relative coordinates *}
  SDL_TOUCH_DEVICE_INDIRECT_ABSOLUTE = TSDL_TouchDeviceType(1);  {* trackpad with absolute device coordinates *}
  SDL_TOUCH_DEVICE_INDIRECT_RELATIVE = TSDL_TouchDeviceType(2);  {* trackpad with relative device coordinates *}

type
  PPSDL_Finger = ^PSDL_Finger;
  PSDL_Finger = ^TSDL_Finger;
  TSDL_Finger = record
    id: TSDL_FingerID;
    x: cfloat;
    y: cfloat;
    pressure: cfloat;
  end;

const
  {* Used as the device ID for mouse events simulated with touch input *}
  SDL_TOUCH_MOUSEID = cuint32(-1);
  {* Used as the SDL_TouchID for touch events simulated with mouse input *}
  SDL_MOUSE_TOUCHID = TSDL_TouchID(-1);

  {* Function prototypes *}

  {**
   *  Get the number of registered touch devices.
   *}
{$ifdef SDL_RUNTIME_LOADING}
Type
  TSDL_GetNumTouchDevices_fun = function(): cint; cdecl;
Var
  SDL_GetNumTouchDevices : TSDL_GetNumTouchDevices_fun = Nil;
{$else}

function SDL_GetNumTouchDevices(): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetNumTouchDevices' {$ENDIF} {$ENDIF};
{$endif}

  {**
   *  Get the touch ID with the given index, or 0 if the index is invalid.
   *}
{$ifdef SDL_RUNTIME_LOADING}
Type
  TSDL_GetTouchDevice_fun = function(index: cint): TSDL_TouchID; cdecl;
Var
  SDL_GetTouchDevice : TSDL_GetTouchDevice_fun = Nil;
{$else}

function SDL_GetTouchDevice(index: cint): TSDL_TouchID; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetTouchDevice' {$ENDIF} {$ENDIF};
{$endif}

{**
 * Get the touch device name as reported from the driver,
 * or NIL if the index is invalid.
 *
 * \since This function is available since SDL 2.0.22.
 *}
{$ifdef SDL_RUNTIME_LOADING}
Type
  TSDL_GetTouchName_fun = function(index: cint): PAnsiChar; cdecl;
Var
  SDL_GetTouchName : TSDL_GetTouchName_fun = Nil;
{$else}

function SDL_GetTouchName(index: cint): PAnsiChar; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetTouchName' {$ENDIF} {$ENDIF};
{$endif}

{**
 * Get the type of the given touch device.
 *
 * \since This function is available since SDL 2.0.10.
 *}
{$ifdef SDL_RUNTIME_LOADING}
Type
  TSDL_GetTouchDeviceType_fun = function(touchID: TSDL_TouchID): TSDL_TouchDeviceType; cdecl;
Var
  SDL_GetTouchDeviceType : TSDL_GetTouchDeviceType_fun = Nil;
{$else}

function SDL_GetTouchDeviceType(touchID: TSDL_TouchID): TSDL_TouchDeviceType; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetTouchDeviceType' {$ENDIF} {$ENDIF};
{$endif}

  {**
   *  Get the number of active fingers for a given touch device.
   *}
{$ifdef SDL_RUNTIME_LOADING}
Type
  TSDL_GetNumTouchFingers_fun = function(touchID: TSDL_TouchID): cint; cdecl;
Var
  SDL_GetNumTouchFingers : TSDL_GetNumTouchFingers_fun = Nil;
{$else}

function SDL_GetNumTouchFingers(touchID: TSDL_TouchID): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetNumTouchFingers' {$ENDIF} {$ENDIF};
{$endif}

  {**
   *  Get the finger object of the given touch, with the given index.
   *}
{$ifdef SDL_RUNTIME_LOADING}
Type
  TSDL_GetTouchFinger_fun = function(touchID: TSDL_TouchID; index: cint): PSDL_Finger; cdecl;
Var
  SDL_GetTouchFinger : TSDL_GetTouchFinger_fun = Nil;
{$else}

function SDL_GetTouchFinger(touchID: TSDL_TouchID; index: cint): PSDL_Finger; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetTouchFinger' {$ENDIF} {$ENDIF};
{$endif}

