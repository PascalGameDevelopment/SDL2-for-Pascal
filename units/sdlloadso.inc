//from sdl_loadso.h

{*
 *  \file SDL_loadso.h
 *
 *  System dependent library loading routines
 *
 *  Some things to keep in mind:
 *  \li These functions only work on C function names.  Other languages may
 *      have name mangling and intrinsic language support that varies from
 *      compiler to compiler.
 *  \li Make sure you declare your function pointers with the same calling
 *      convention as the actual library function.  Your code will crash
 *      mysteriously if you do not do this.
 *  \li Avoid namespace collisions.  If you load a symbol from the library,
 *      it is not defined whether or not it goes into the global symbol
 *      namespace for the application.  If it does and it conflicts with
 *      symbols in your code or other shared libraries, you will not get
 *      the results you expect.:)
  }

{**
 *  This function dynamically loads a shared object and returns a pointer
 *  to the object handle (or NULL if there was an error).
 *  The 'sofile' parameter is a system dependent name of the object file.
 *}
function SDL_LoadObject(Const sofile: PAnsiChar): Pointer; cdecl;
   external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_LoadObject' {$ENDIF}{$ENDIF};

{**
 *  Given an object handle, this function looks up the address of the
 *  named function in the shared object and returns it.  This address
 *  is no longer valid after calling SDL_UnloadObject().
 *}
function SDL_LoadFunction(handle: Pointer; Const name: PAnsiChar): Pointer; cdecl;
   external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_LoadFunction' {$ENDIF}{$ENDIF};

{**
 *  Unload a shared object from memory.
 *}
procedure SDL_UnloadObject(handle: Pointer); cdecl;
   external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_UnloadObject' {$ENDIF}{$ENDIF};
