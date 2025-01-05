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
	PPSDL_SpinLock = ^PSDL_SpinLock;
	PSDL_SpinLock = ^TSDL_SpinLock;
	TSDL_SpinLock = type cint;

{**
 * Try to lock a spin lock by setting it to a non-zero value.
 *}
{$ifdef SDL_RUNTIME_LOADING}
Type
  TSDL_AtomicTryLock_func = function (lock: PSDL_SpinLock): TSDL_bool; cdecl;
Var
  SDL_AtomicTryLock : TSDL_AtomicTryLock_func = Nil;
{$else}
function SDL_AtomicTryLock(lock: PSDL_SpinLock): TSDL_bool; cdecl;
	external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_AtomicTryLock' {$ENDIF} {$ENDIF};
{$endif}

{**
 * Lock a spin lock by setting it to a non-zero value.
 *}
{$ifdef SDL_RUNTIME_LOADING}
Type
  TSDL_AtomicLock_func = function (lock: PSDL_SpinLock): TSDL_bool; cdecl;
Var
  SDL_AtomicLock : TSDL_AtomicLock_func = Nil;
{$else}
function SDL_AtomicLock(lock: PSDL_SpinLock): TSDL_bool; cdecl;
	external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_AtomicLock' {$ENDIF} {$ENDIF};
{$endif}

{**
 * Unlock a spin lock by setting it to 0.
 *
 * Always returns immediately.
 *}
{$ifdef SDL_RUNTIME_LOADING}
Type
  TSDL_AtomicUnlock_proc = procedure (lock: PSDL_SpinLock); cdecl;
Var
  SDL_AtomicUnlock : TSDL_AtomicUnlock_proc = Nil;
{$else}
procedure SDL_AtomicUnlock(lock: PSDL_SpinLock); cdecl;
	external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_AtomicUnlock' {$ENDIF} {$ENDIF};
{$endif}

{**
 * The compiler barrier prevents the compiler from reordering
 * reads and writes to globally visible variables across the call.
 *}
procedure SDL_CompilerBarrier();

type
	{**
	 * A type representing an atomic integer value.  It is a record
	 * so people don't accidentally use numeric operations on it.
	 *}
	PPSDL_Atomic = ^PSDL_Atomic;
	PSDL_Atomic = ^TSDL_Atomic;
	TSDL_Atomic = record
		Value: cint
	end;

{**
 * Set an atomic variable to a new value if it is currently an old value.
 *}
 {$ifdef SDL_RUNTIME_LOADING}
 Type
   TSDL_AtomicCAS_func =  function (atomic: PSDL_Atomic; oldValue, newValue: cint): TSDL_bool; cdecl;
 Var
   SDL_AtomicCAS : TSDL_AtomicCAS_func = Nil;
 {$else}
 function SDL_AtomicCAS(atomic: PSDL_Atomic; oldValue, newValue: cint): TSDL_bool; cdecl;
	external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_AtomicCAS' {$ENDIF} {$ENDIF};
 {$endif}

{**
 * Set an atomic variable to a new value and return the old one.
 *
 * This function also acts as a full memory barrier.
 *}
 {$ifdef SDL_RUNTIME_LOADING}
 Type
   TSDL_AtomicSet_func =  function (atomic: PSDL_Atomic; value: cint): cint; cdecl;
 Var
   SDL_AtomicSet : TSDL_AtomicSet_func = Nil;
 {$else}
 function SDL_AtomicSet(atomic: PSDL_Atomic; value: cint): cint; cdecl;
	external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_AtomicSet' {$ENDIF} {$ENDIF};
 {$endif}

{**
 * Get the value of an atomic variable.
 *}
 {$ifdef SDL_RUNTIME_LOADING}
 Type
   TSDL_AtomicGet_func =  function (atomic: PSDL_Atomic): cint; cdecl;
 Var
   SDL_AtomicGet : TSDL_AtomicGet_func = Nil;
 {$else}
 function SDL_AtomicGet(atomic: PSDL_Atomic): cint; cdecl;
	external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_AtomicGet' {$ENDIF} {$ENDIF};
 {$endif}

{**
 * Add to an atomic variable, and return the old value.
 *
 * This function also acts as a full memory barrier.
 *}
 {$ifdef SDL_RUNTIME_LOADING}
 Type
   TSDL_AtomicAdd_func = function (atomic: PSDL_Atomic; value: cint): cint; cdecl;
 Var
   SDL_AtomicAdd : TSDL_AtomicAdd_func = Nil;
 {$else}
 function SDL_AtomicAdd(atomic: PSDL_Atomic; value: cint): cint; cdecl;
	external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_AtomicAdd' {$ENDIF} {$ENDIF};
 {$endif}

{**
 * Increment an atomic variable used as a reference count.
 *}
function SDL_AtomicIncRef(atomic: PSDL_Atomic): cint;
{**
 * Decrement an atomic variable used as a reference count
 * and check if it reached zero after decrementing.
 *}
function SDL_AtomicDecRef(atomic: PSDL_Atomic): Boolean;

{**
 * Set a pointer to a new value if it is currently an old value.
 *}
{$ifdef SDL_RUNTIME_LOADING}
Type
  TSDL_AtomicCASPtr_func = function (ptr: PPointer; oldValue, newValue: Pointer): TSDL_bool; cdecl;
Var
  SDL_AtomicCASPtr : TSDL_AtomicCASPtr_func = Nil;
{$else}
function SDL_AtomicCASPtr(ptr: PPointer; oldValue, newValue: Pointer): TSDL_bool; cdecl;
	external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_AtomicCASPtr' {$ENDIF} {$ENDIF};
{$endif}

{**
 * Set a pointer to a new value atomically, and return the old value.
 *}
{$ifdef SDL_RUNTIME_LOADING}
Type
  TSDL_AtomicSetPtr_func = function (ptr: PPointer; value: Pointer): Pointer; cdecl;
Var
  SDL_AtomicSetPtr : TSDL_AtomicSetPtr_func = Nil;
{$else}
function SDL_AtomicSetPtr(ptr: PPointer; value: Pointer): Pointer; cdecl;
	external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_AtomicSetPtr' {$ENDIF} {$ENDIF};
{$endif}

{**
 * Get the value of a pointer atomically.
 *}
{$ifdef SDL_RUNTIME_LOADING}
Type
  TSDL_AtomicGetPtr_func = function (ptr: PPointer): Pointer; cdecl;
Var
  SDL_AtomicGetPtr : TSDL_AtomicGetPtr_func = Nil;
{$else}
function SDL_AtomicGetPtr(ptr: PPointer): Pointer; cdecl;
	external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_AtomicGetPtr' {$ENDIF} {$ENDIF};
{$endif}

