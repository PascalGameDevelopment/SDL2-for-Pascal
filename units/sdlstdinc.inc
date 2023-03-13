//types from SDL_stdinc.h

{ SDL-For-Pascal: A lot of the functions are missing. Some functions are useless
                  if working with Pascal (e. g. memory management functions),
                  others could be useful (e. g. math functions).

  TODO: Investigate header file and translate potentially useful functions. }

type
  TSDL_Bool = cbool;

const
  SDL_FALSE = TSDL_Bool(0);
  SDL_TRUE  = TSDL_Bool(1);

  SDL_MAX_SINT8 = High(cint8);
  SDL_MIN_SINT8 = Low(cint8);

  SDL_MAX_UINT8 = High(cuint8);
  SDL_MIN_UINT8 = Low(cuint8);

  SDL_MAX_SINT16 = High(cint16);
  SDL_MIN_SINT16 = Low(cint16);

  SDL_MAX_UINT16 = High(cuint16);
  SDL_MIN_UINT16 = Low(cuint16);

  SDL_MAX_SINT32 = High(cint32);
  SDL_MIN_SINT32 = Low(cint32);

  SDL_MAX_UINT32 = High(cuint32);
  SDL_MIN_UINT32 = Low(cuint32);

  {$IFDEF Has_Int64}
    SDL_MAX_SINT64 = High(cint64);
    SDL_MIN_SINT64 = Low(cint64);

    SDL_MAX_UINT64 = High(cuint64);
    SDL_MIN_UINT64 = Low(cuint64);
  {$ELSE}
    SDL_MAX_SINT64: cuint64 = (hi: SDL_MAX_SINT32; lo: SDL_MAX_UINT32);
    SDL_MIN_SINT64: cuint64 = (hi: SDL_MIN_SINT32; lo: 0);

    SDL_MAX_UINT64: cuint64 = (hi: SDL_MAX_UINT32; lo: SDL_MAX_UINT32);
    SDL_MIN_UINT64: cuint64 = (hi: 0;              lo: 0);
  {$ENDIF}

  SDL_FLT_EPSILON = cfloat(1.1920928955078125e-07);

type
  TSDL_malloc_func = function(size: csize_t): Pointer; cdecl;
  PSDL_malloc_func = ^TSDL_malloc_func;

  TSDL_calloc_func = function(nmemb, size: csize_t): Pointer; cdecl;
  PSDL_calloc_func = ^TSDL_calloc_func;

  TSDL_realloc_func = function(mem: Pointer; size: csize_t): Pointer; cdecl;
  PSDL_realloc_func = ^TSDL_realloc_func;

  TSDL_free_func = procedure(mem: Pointer); cdecl;
  PSDL_free_func = ^TSDL_free_func;

{**
 * Get the original set of SDL memory functions
 *
 * \since This function is available since SDL 2.24.0.
 *}
procedure SDL_GetOriginalMemoryFunctions(
  malloc_func: PSDL_malloc_func;
  calloc_func: PSDL_calloc_func;
  realloc_func: PSDL_realloc_func;
  free_func: PSDL_free_func
); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetOriginalMemoryFunctions' {$ENDIF} {$ENDIF};

(**
 * Get the current set of SDL memory functions
 *
 * \since This function is available since SDL 2.0.7.
 *)
procedure SDL_GetMemoryFunctions(
  malloc_func: PSDL_malloc_func;
  calloc_func: PSDL_calloc_func;
  realloc_func: PSDL_realloc_func;
  free_func: PSDL_free_func
); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetMemoryFunctions' {$ENDIF} {$ENDIF};

(**
 * Replace SDL's memory allocation functions with a custom set
 *
 * \since This function is available since SDL 2.0.7.
 *)
function SDL_SetMemoryFunctions(
  malloc_func: TSDL_malloc_func;
  calloc_func: TSDL_calloc_func;
  realloc_func: TSDL_realloc_func;
  free_func: TSDL_free_func
): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_SetMemoryFunctions' {$ENDIF} {$ENDIF};

(**
 * Get the number of outstanding (unfreed) allocations
 *
 * \since This function is available since SDL 2.0.7.
 *)
function SDL_GetNumAllocations(): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetNumAllocations' {$ENDIF} {$ENDIF};

(**
 * Allocate a block of memory. The memory is *not* initialized.
 *)
function SDL_malloc(size: csize_t): Pointer; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_malloc' {$ENDIF} {$ENDIF};

(**
 * Allocate a block of memory that can fit an array of nmemb elements, each of given size.
 * The memory is initialized by setting every byte to 0.
 *)
function SDL_calloc(nmemb, size: csize_t): Pointer; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_calloc' {$ENDIF} {$ENDIF};

(**
 * Resize a block of memory allocated previously with SDL_malloc() or SDL_calloc().
 *
 * The returned pointer may or may not be the same as the original pointer.
 * If the new size is larger than the old size, any new memory will *not* be initialized.
 *)
function SDL_realloc(mem: Pointer; size: csize_t): Pointer; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_realloc' {$ENDIF} {$ENDIF};

(**
 * Free memory returned by functions like SDL_GetBasePath(), SDL_GetPrefPath(), etc.
 *
 * Calling SDL_free() on the same pointer twice is undefined behaviour and may cause
 * your program to crash or behave in unexpected ways.
 *)
procedure SDL_free(mem: Pointer); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_free' {$ENDIF} {$ENDIF};


(*** --- Character functions --- ***)


(**
 * Check if the provided ASCII character is an alphabetic character (a letter).
 *
 * \returns 1 if the check passes, 0 otherwise.
 *
 * \since This function is available since SDL 2.0.16.
 *)
function SDL_isalpha(x: cint):cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_isalpha' {$ENDIF} {$ENDIF};

(**
 * Check if the provided ASCII character is an alphanumeric character.
 *
 * \returns 1 if the check passes, 0 otherwise.
 *
 * \since This function is available since SDL 2.0.16.
 *)
function SDL_isalnum(x: cint):cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_isalnum' {$ENDIF} {$ENDIF};

(**
 * Check if the provided ASCII character is a blank character (a space or a tab).
 *
 * \returns 1 if the check passes, 0 otherwise.
 *
 * \since This function is available since SDL 2.0.16.
 *)
function SDL_isblank(x: cint):cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_isblank' {$ENDIF} {$ENDIF};

(**
 * Check if the provided ASCII character is a control character.
 *
 * \returns 1 if the check passes, 0 otherwise.
 *
 * \since This function is available since SDL 2.0.16.
 *)
function SDL_iscntrl(x: cint):cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_iscntrl' {$ENDIF} {$ENDIF};

(**
 * Check if the provided ASCII character is a decimal digit.
 *
 * \returns 1 if the check passes, 0 otherwise.
 *
 * \since This function is available since SDL 2.0.4.
 *)
function SDL_isdigit(x: cint):cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_isdigit' {$ENDIF} {$ENDIF};

(**
 * Check if the provided ASCII character is a hexadecimal digit.
 *
 * \returns 1 if the check passes, 0 otherwise.
 *
 * \since This function is available since SDL 2.0.16.
 *)
function SDL_isxdigit(x: cint):cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_isxdigit' {$ENDIF} {$ENDIF};

(**
 * Check if the provided ASCII character is any printable character
 * which is not a space or an alphanumeric character.
 *
 * \returns 1 if the check passes, 0 otherwise.
 *
 * \since This function is available since SDL 2.0.16.
 *)
function SDL_ispunct(x: cint):cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_ispunct' {$ENDIF} {$ENDIF};

(**
 * Check if the provided ASCII character is a whitespace character.
 * This set includes the following characters: space,
 * form feed (FF), newline/line feed (LF), carriage return (CR),
 * horizontal tab (HT), vertical tab (VT).
 *
 * \returns 1 if the check passes, 0 otherwise.
 *
 * \since This function is available since SDL 2.0.4.
 *)
function SDL_isspace(x: cint):cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_isspace' {$ENDIF} {$ENDIF};

(**
 * Check if the provided ASCII character is an uppercase letter.
 *
 * \returns 1 if the check passes, 0 otherwise.
 *
 * \since This function is available since SDL 2.0.12.
 *)
function SDL_isupper(x: cint):cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_isupper' {$ENDIF} {$ENDIF};

(**
 * Check if the provided ASCII character is a lowercase letter.
 *
 * \returns 1 if the check passes, 0 otherwise.
 *
 * \since This function is available since SDL 2.0.12.
 *)
function SDL_islower(x: cint):cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_islower' {$ENDIF} {$ENDIF};

(**
 * Check if the provided ASCII character is a printable character (including space).
 *
 * \returns 1 if the check passes, 0 otherwise.
 *
 * \since This function is available since SDL 2.0.16.
 *)
function SDL_isprint(x: cint):cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_isprint' {$ENDIF} {$ENDIF};

(**
 * Check if the provided ASCII character is a printable character (excluding space).
 *
 * \returns 1 if the check passes, 0 otherwise.
 *
 * \since This function is available since SDL 2.0.16.
 *)
function SDL_isgraph(x: cint):cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_isgraph' {$ENDIF} {$ENDIF};

(**
 * If the given ASCII character is a lowercase letter, converts it to uppercase.
 * Otherwise returns the original value.
 *
 * \since This function is available since SDL 2.0.4.
 *)
function SDL_toupper(x: cint):cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_toupper' {$ENDIF} {$ENDIF};

(**
 * If the given ASCII character is an uppercase letter, converts it to lowercase.
 * Otherwise returns the original value.
 *
 * \since This function is available since SDL 2.0.4.
 *)
function SDL_tolower(x: cint):cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_tolower' {$ENDIF} {$ENDIF};


(*** --- iconv functions --- ***)


(**
 * This function converts a string between encodings in one pass, returning a
 * string that must be freed with SDL_free(), or NIL on error.
 *
 * \since This function is available since SDL 2.0.0.
 *)
function SDL_iconv_string(Const tocode, fromcode, inbuf: PAnsiChar; inbytesleft: csize_t): PAnsiChar; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_iconv_string' {$ENDIF} {$ENDIF};

// These are macros in the original C headers, we will reimplement them as simple Pascal functions.
function SDL_iconv_utf8_locale(Const str: PAnsiChar): PAnsiChar; cdecl;
function SDL_iconv_utf8_ucs2(Const str: PAnsiChar): pcUint16; cdecl;
function SDL_iconv_utf8_ucs4(Const str: PAnsiChar): pcUint32; cdecl;

(* The SDL implementation of iconv() returns these error codes *)
const
  SDL_ICONV_ERROR  = csize_t(-1);
  SDL_ICONV_E2BIG  = csize_t(-2);
  SDL_ICONV_EILSEQ = csize_t(-3);
  SDL_ICONV_EINVAL = csize_t(-4);

type
  TSDL_iconv = record end;
  PSDL_iconv = ^TSDL_iconv;

function SDL_iconv_open(Const tocode, fromcode: PAnsiChar): PSDL_iconv; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_iconv_open' {$ENDIF} {$ENDIF};

function SDL_iconv_close(cd: PSDL_iconv): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_iconv_close' {$ENDIF} {$ENDIF};

function SDL_iconv(cd: PSDL_iconv; Const inbuf: PPAnsiChar; inbytesleft: pcsize_t; outbuf: PPAnsiChar; outbytesleft: pcsize_t): csize_t; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_iconv' {$ENDIF} {$ENDIF};
