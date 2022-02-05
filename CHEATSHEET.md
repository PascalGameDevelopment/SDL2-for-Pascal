# SDL2 Translation Cheat Sheet (C to Pascal)

This cheat sheet helps to quickly translate often found C constructs in the
SDL2 package into Pascal according to the Code style guidelines of the
conversion project.

## Defines

C:

```
#define SDL_HAT_CENTERED    0x00
#define SDL_HAT_UP          0x01
#define SDL_HAT_RIGHT       0x02
#define SDL_HAT_DOWN        0x04
#define SDL_HAT_LEFT        0x08
#define SDL_HAT_RIGHTUP     (SDL_HAT_RIGHT|SDL_HAT_UP)
#define SDL_HAT_RIGHTDOWN   (SDL_HAT_RIGHT|SDL_HAT_DOWN)
#define SDL_HAT_LEFTUP      (SDL_HAT_LEFT|SDL_HAT_UP)
#define SDL_HAT_LEFTDOWN    (SDL_HAT_LEFT|SDL_HAT_DOWN)
```

Pascal:

```
const
  SDL_HAT_CENTERED  = $00;
  SDL_HAT_UP        = $01;
  SDL_HAT_RIGHT     = $02;
  SDL_HAT_DOWN      = $04;
  SDL_HAT_LEFT      = $08;
  SDL_HAT_RIGHTUP   = SDL_HAT_RIGHT or SDL_HAT_UP;
  SDL_HAT_RIGHTDOWN = SDL_HAT_RIGHT or SDL_HAT_DOWN;
  SDL_HAT_LEFTUP    = SDL_HAT_LEFT or SDL_HAT_UP;
  SDL_HAT_LEFTDOWN  = SDL_HAT_LEFT or SDL_HAT_DOWN;
```

## Enums

C:

```
typedef enum
{
   SDL_JOYSTICK_POWER_UNKNOWN = -1,
   SDL_JOYSTICK_POWER_EMPTY,   /* <= 5% */
   SDL_JOYSTICK_POWER_LOW,     /* <= 20% */
   SDL_JOYSTICK_POWER_MEDIUM,  /* <= 70% */
   SDL_JOYSTICK_POWER_FULL,    /* <= 100% */
   SDL_JOYSTICK_POWER_WIRED,
   SDL_JOYSTICK_POWER_MAX
} SDL_JoystickPowerLevel;
```

Pascal:

```
type
  TSDL_JoystickPowerLevel = type Integer;

const
  SDL_JOYSTICK_POWER_UNKNOWN = TSDL_JoystickPowerLevel(-1);
  SDL_JOYSTICK_POWER_EMPTY   = TSDL_JoystickPowerLevel(0);  {* <= 5% *}
  SDL_JOYSTICK_POWER_LOW     = TSDL_JoystickPowerLevel(1);  {* <= 20% *}
  SDL_JOYSTICK_POWER_MEDIUM  = TSDL_JoystickPowerLevel(2);  {* <= 70% *}
  SDL_JOYSTICK_POWER_FULL    = TSDL_JoystickPowerLevel(3);  {* <= 100% *}
  SDL_JOYSTICK_POWER_WIRED   = TSDL_JoystickPowerLevel(4);
  SDL_JOYSTICK_POWER_MAX     = TSDL_JoystickPowerLevel(5);
```

Hint 1: C enums start at 0 if no explicit value is set.

Hint 2: The type should be Word if only unsigned values are possible. Otherwise
it should be Integer.

Hint 3: Do not translate C enums to Pascal enums. C enums are handled like plain
integers which will make bitwise operations (e. g. in macros) possible
without typecasting.

## Structs

C:

```
typedef struct SDL_version
{
    Uint8 major;        /**< major version */
    Uint8 minor;        /**< minor version */
    Uint8 patch;        /**< update version */
} SDL_version;
```

Pascal:

```
type
  PSDL_Version = ^TSDL_Version;
  TSDL_Version = record
    major: cuint8    { major version }
    minor: cuint8    { minor version }
    patch: cuint8;   { update version }
  end;
```

Hint 1: If you have something like ```typedef struct name name```. it is likely
that the declaration is somewhere else (even other file).

## Unions

C:

```
typedef union {
    /** \brief A cutoff alpha value for binarization of the window shape's alpha channel. */
    Uint8 binarizationCutoff;
    SDL_Color colorKey;
} SDL_WindowShapeParams;
```

Pascal:

```
type
  PSDL_WindowShapeParams = ^TSDL_WindowShapeParams;
  TSDL_WindowShapeParams = record
  case cint of
    { A cutoff alpha value for binarization of the window shape's alpha channel. }
    0: (binarizationCutoff: cuint8);
    1: (colorKey: TSDL_ColorKey);
  end;
```

## Functions

C:

```
extern DECLSPEC void SDLCALL SDL_LockJoysticks(void);

extern DECLSPEC const char *SDLCALL SDL_JoystickNameForIndex(int device_index);
```

Pascal:

```
procedure SDL_LockJoysticks(); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_LockJoysticks' {$ENDIF} {$ENDIF};

function SDL_JoystickNameForIndex(device_index: cint): PAnsiChar; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_JoystickNameForIndex' {$ENDIF} {$ENDIF};
```


