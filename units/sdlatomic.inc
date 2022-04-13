// from SDL_atomic.h

{**
 * Atomic locks are efficient spinlocks using CPU instructions,
 * but are vulnerable to starvation and can spin forever if a thread
 * holding a lock has been terminated.  For this reason you should
 * minimize the code executed inside an atomic lock and never do
 * expensive things like API or system calls while holding them.
 *
 * The atomic locks are not safe to lock recursively.
 *}
type
	PSDL_SpinLock = ^TSDL_SpinLock;
	TSDL_SpinLock = type cint;

{**
 * Try to lock a spin lock by setting it to a non-zero value.
 *}
function SDL_AtomicTryLock(lock: PSDL_SpinLock): TSDL_bool; cdecl;
	external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_AtomicTryLock' {$ENDIF} {$ENDIF};

{**
 * Lock a spin lock by setting it to a non-zero value.
 *}
function SDL_AtomicLock(lock: PSDL_SpinLock): TSDL_bool; cdecl;
	external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_AtomicLock' {$ENDIF} {$ENDIF};

{**
 * Unlock a spin lock by setting it to 0.
 *
 * Always returns immediately.
 *} 
procedure SDL_AtomicUnlock(lock: PSDL_SpinLock); cdecl;
	external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_AtomicUnlock' {$ENDIF} {$ENDIF};

