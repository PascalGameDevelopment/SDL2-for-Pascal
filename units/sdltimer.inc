// based on "sdl_timer.h" (2.0.14)

{**
 *  Get the number of milliseconds since the SDL library initialization.
 *
 *  This value wraps if the program runs for more than ~49 days.
 *}
function SDL_GetTicks: cuint32; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetTicks' {$ENDIF} {$ENDIF};

{**
 * Get the number of milliseconds since SDL library initialization.
 *
 * Note that you should not use the SDL_TICKS_PASSED macro with values
 * returned by this function, as that macro does clever math to compensate for
 * the 32-bit overflow every ~49 days that SDL_GetTicks() suffers from. 64-bit
 * values from this function can be safely compared directly.
 *}
function SDL_GetTicks64: cuint64; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetTicks64' {$ENDIF} {$ENDIF};

{**
 * \brief Compare SDL ticks values, and return true if A has passed B
 *
 * e.g. if you want to wait 100 ms, you could do this:
 *  Uint32 timeout = SDL_GetTicks() + 100;
 *  while (!SDL_TICKS_PASSED(SDL_GetTicks(), timeout)) [
 *      ... do work until timeout has elapsed
 *  ]
 *}
// #define SDL_TICKS_PASSED(A, B)  ((Sint32)((B) - (A)) <= 0)
{ Type conversion unnecessary bc. types are declared in func. param. list! }
function SDL_TICKS_PASSED(const A, B: cint32): Boolean;

{**
 *  Get the current value of the high resolution counter
 *}
function SDL_GetPerformanceCounter: cuint64; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetPerformanceCounter' {$ENDIF} {$ENDIF};

{**
 *  Get the count per second of the high resolution counter
 *}
function SDL_GetPerformanceFrequency: cuint64; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetPerformanceFrequency' {$ENDIF} {$ENDIF};

{**
 *  Wait a specified number of milliseconds before returning.
 *}
{$ifdef SDL_DYNAMIC_LINKING}
Type
  TSDL_Delay_proc = procedure(ms: cuint32); cdecl;
Var
  SDL_Delay : TSDL_Delay_proc = Nil;
{$else}

procedure SDL_Delay(ms: cuint32); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_Delay' {$ENDIF} {$ENDIF};
{$endif}

type
  {**
   *  Function prototype for the timer callback function.
   *
   *  The callback function is passed the current timer interval and returns
   *  the next timer interval.  If the returned value is the same as the one
   *  passed in, the periodic alarm continues, otherwise a new alarm is
   *  scheduled.  If the callback returns 0, the periodic alarm is cancelled.
   *}
  PPSDL_TimerCallback = ^PSDL_TimerCallback;
  PSDL_TimerCallback = ^TSDL_TimerCallback;
  TSDL_TimerCallback = function(interval: cuint32; param: Pointer): cuint32; cdecl;

  {**
   * Definition of the timer ID type.
   *}
  PPSDL_TimerID = ^PSDL_TimerID;
  PSDL_TimerID = ^TSDL_TimerID;
  TSDL_TimerID = cint;

{**
 *  Add a new timer to the pool of timers already running.
 *
 *  A timer ID, or NULL when an error occurs.
 *}
{$ifdef SDL_DYNAMIC_LINKING}
Type
  TSDL_AddTimer_fun = function(interval: cuint32; callback: TSDL_TimerCallback; param: Pointer): TSDL_TimerID; cdecl;
Var
  SDL_AddTimer : TSDL_AddTimer_fun = Nil;
{$else}

function SDL_AddTimer(interval: cuint32; callback: TSDL_TimerCallback; param: Pointer): TSDL_TimerID; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_AddTimer' {$ENDIF} {$ENDIF};
{$endif}

{**
 *  Remove a timer knowing its ID.
 *
 *  A boolean value indicating success or failure.
 *
 *  It is not safe to remove a timer multiple times.
 *}
{$ifdef SDL_DYNAMIC_LINKING}
Type
  TSDL_RemoveTimer_fun = function(id: TSDL_TimerID): Boolean; cdecl;
Var
  SDL_RemoveTimer : TSDL_RemoveTimer_fun = Nil;
{$else}

function SDL_RemoveTimer(id: TSDL_TimerID): Boolean; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_RemoveTimer' {$ENDIF} {$ENDIF};
{$endif}
