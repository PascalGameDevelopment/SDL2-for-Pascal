
{*
 * \file SDL_clipboard.h
 *
 * Include file for SDL clipboard handling
  }

{* Function prototypes *}

{*
 * Put UTF-8 text into the clipboard.
 *
 * \param text the text to store in the clipboard
 * \returns 0 on success or a negative error code on failure; call
 *          SDL_GetError() for more information.
 *
 * \since This function is available since SDL 2.0.0.
 *
 * \sa SDL_GetClipboardText
 * \sa SDL_HasClipboardText
  }
{$ifdef SDL_DYNAMIC_LINKING}
Type
  TSDL_SetClipboardText_fun = function(text: PAnsiChar): cint; cdecl;
Var
  SDL_SetClipboardText : TSDL_SetClipboardText_fun = Nil;
{$else}

function SDL_SetClipboardText(text: PAnsiChar): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_SetClipboardText' {$ENDIF} {$ENDIF};
{$endif}

{*
 * Get UTF-8 text from the clipboard, which must be freed with SDL_free().
 *
 * This functions returns empty string if there was not enough memory left for
 * a copy of the clipboard's content.
 *
 * \returns the clipboard text on success or an empty string on failure; call
 *          SDL_GetError() for more information. Caller must call SDL_free()
 *          on the returned pointer when done with it (even if there was an
 *          error).
 *
 * \since This function is available since SDL 2.0.0.
 *
 * \sa SDL_HasClipboardText
 * \sa SDL_SetClipboardText
  }
{$ifdef SDL_DYNAMIC_LINKING}
Type
  TSDL_GetClipboardText_fun = function(): PAnsiChar; cdecl;
Var
  SDL_GetClipboardText : TSDL_GetClipboardText_fun = Nil;
{$else}

function SDL_GetClipboardText(): PAnsiChar; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetClipboardText' {$ENDIF} {$ENDIF};
{$endif}

{*
 * Query whether the clipboard exists and contains a non-empty text string.
 *
 * \returns SDL_TRUE if the clipboard has text, or SDL_FALSE if it does not.
 *
 * \since This function is available since SDL 2.0.0.
 *
 * \sa SDL_GetClipboardText
 * \sa SDL_SetClipboardText
  }
{$ifdef SDL_DYNAMIC_LINKING}
Type
  TSDL_HasClipboardText_fun = function(): TSDL_bool; cdecl;
Var
  SDL_HasClipboardText : TSDL_HasClipboardText_fun = Nil;
{$else}

function SDL_HasClipboardText(): TSDL_bool; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_HasClipboardText' {$ENDIF} {$ENDIF};
{$endif}

{*
 * Put UTF-8 text into the primary selection.
 *
 * \param text the text to store in the primary selection
 * \returns 0 on success or a negative error code on failure; call
 *          SDL_GetError() for more information.
 *
 * \since This function is available since SDL 2.26.1.
 *
 * \sa SDL_GetPrimarySelectionText
 * \sa SDL_HasPrimarySelectionText
  }
{$ifdef SDL_DYNAMIC_LINKING}
Type
  TSDL_SetPrimarySelectionText_fun = function(text: PAnsiChar): cint; cdecl;
Var
  SDL_SetPrimarySelectionText : TSDL_SetPrimarySelectionText_fun = Nil;
{$else}

function SDL_SetPrimarySelectionText(text: PAnsiChar): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_SetPrimarySelectionText' {$ENDIF} {$ENDIF};
{$endif}

{*
 * Get UTF-8 text from the primary selection, which must be freed with
 * SDL_free().
 *
 * This functions returns empty string if there was not enough memory left for
 * a copy of the primary selection's content.
 *
 * \returns the primary selection text on success or an empty string on
 *          failure; call SDL_GetError() for more information. Caller must
 *          call SDL_free() on the returned pointer when done with it (even if
 *          there was an error).
 *
 * \since This function is available since SDL 2.26.1.
 *
 * \sa SDL_HasPrimarySelectionText
 * \sa SDL_SetPrimarySelectionText
  }
{$ifdef SDL_DYNAMIC_LINKING}
Type
  TSDL_GetPrimarySelectionText_fun = function(): PAnsiChar; cdecl;
Var
  SDL_GetPrimarySelectionText : TSDL_GetPrimarySelectionText_fun = Nil;
{$else}

function SDL_GetPrimarySelectionText(): PAnsiChar; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetPrimarySelectionText' {$ENDIF} {$ENDIF};
{$endif}

{*
 * Query whether the primary selection exists and contains a non-empty text
 * string.
 *
 * \returns SDL_TRUE if the primary selection has text, or SDL_FALSE if it
 *          does not.
 *
 * \since This function is available since SDL 2.26.1.
 *
 * \sa SDL_GetPrimarySelectionText
 * \sa SDL_SetPrimarySelectionText
  }
{$ifdef SDL_DYNAMIC_LINKING}
Type
  TSDL_HasPrimarySelectionText_fun = function(): TSDL_bool; cdecl;
Var
  SDL_HasPrimarySelectionText : TSDL_HasPrimarySelectionText_fun = Nil;
{$else}

function SDL_HasPrimarySelectionText(): TSDL_bool; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_HasPrimarySelectionText' {$ENDIF} {$ENDIF};
{$endif}
