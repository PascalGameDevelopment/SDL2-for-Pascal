// from "SDL_system.h"

(* Platform specific functions for Windows *)
{$IF DEFINED(WIN32) OR DEFINED(WIN64)} 

  {**
   *  \brief Set a function that is called for every windows message, before TranslateMessage()
   *}
Type
  TSDL_WindowsMessageHook = Procedure(userdata, hWnd: Pointer; mesage: cuint; wParam: cuint64; lParam: cint64); cdecl;

Procedure SDL_SetWindowsMessageHook(callback: TSDL_WindowsMessageHook; userdata: Pointer); cdecl;
  external SDL_LibName;

  {* Returns the D3D9 adapter index that matches the specified display index.
   * This adapter index can be passed to IDirect3D9::CreateDevice and controls
   * on which monitor a full screen application will appear.
   *}
Function SDL_Direct3D9GetAdapterIndex(displayIndex:cint):cint; cdecl;
  external SDL_LibName;

Type
  PIDirect3DDevice9 = type Pointer;
  PID3D11Device = type Pointer;
  PID3D12Device = type Pointer;

  {* Returns the D3D device associated with a renderer, or NULL if it's not a D3D renderer.
   * Once you are done using the device, you should release it to avoid a resource leak.
   *}
Function SDL_RenderGetD3D9Device(renderer:PSDL_Renderer):PIDirect3DDevice9; cdecl;
  external SDL_LibName;

{**
 * Get the D3D11 device associated with a renderer.
 *
 * Once you are done using the device, you should release it to avoid a
 * resource leak.
 *
 * \param renderer the renderer from which to get the associated D3D11 device
 * \returns the D3D11 device associated with given renderer or NIL if it is
 *          not a D3D11 renderer; call SDL_GetError() for more information.
 *
 * \since This function is available since SDL 2.0.16.
 *}
Function SDL_RenderGetD3D11Device(renderer:PSDL_Renderer):PID3D11Device; cdecl;
  external SDL_LibName;

{**
 * Get the D3D12 device associated with a renderer.
 *
 * Once you are done using the device, you should release it to avoid a
 * resource leak.
 *
 * \param renderer the renderer from which to get the associated D3D12 device
 * \returns the D3D12 device associated with given renderer or NIL if it is
 *          not a D3D12 renderer; call SDL_GetError() for more information.
 *
 * \since This function is available since SDL 2.24.0.
 *}
Function SDL_RenderGetD3D12Device(renderer:PSDL_Renderer):PID3D12Device; cdecl;
  external SDL_LibName;

{* Returns the DXGI Adapter and Output indices for the specified display index. 
 * These can be passed to EnumAdapters and EnumOutputs respectively to get the objects
 *  required to create a DX10 or DX11 device and swap chain.
 *}
function SDL_DXGIGetOutputInfo(displayIndex: cint; adapterIndex, outputIndex: pcint): TSDL_Bool;
  external SDL_LibName;

{$ENDIF}


(* Platform specific functions for Linux *)
{$IFDEF LINUX}
{**
 * Sets the UNIX nice value for a thread.
 *
 * This uses setpriority() if possible, and RealtimeKit if available.
 *
 * \param threadID the Unix thread ID to change priority of.
 * \param priority The new, Unix-specific, priority value.
 * \returns 0 on success, or -1 on error.
 *
 * \since This function is available since SDL 2.0.9.
 *}
function SDL_LinuxSetThreadPriority(threadID: cint64; priority: cint): cint; cdecl;
  external SDL_LibName;

{**
 * Sets the priority (not nice level) and scheduling policy for a thread.
 *
 * This uses setpriority() if possible, and RealtimeKit if available.
 *
 * \param threadID The Unix thread ID to change priority of.
 * \param sdlPriority The new SDL_ThreadPriority value.
 * \param schedPolicy The new scheduling policy (SCHED_FIFO, SCHED_RR,
 *                    SCHED_OTHER, etc...)
 * \returns 0 on success, or -1 on error.
 *
 * \since This function is available since SDL 2.0.18.
 *}
function SDL_LinuxSetThreadPriorityAndPolicy(threadID: cint64; sdlPriority, schedPolicy: cint): cint; cdecl;
  external SDL_LibName;
{$ENDIF}


(* Platform specific functions for iOS *)
{$IFDEF __IPHONEOS__}

type
  TSDL_iPhoneAnimationCallback = procedure(callbackParam: Pointer); cdecl;

{**
 * Use this function to set the animation callback on Apple iOS.
 *
 * This function is only available on Apple iOS.
 *
 * For more information see:
 * https://github.com/libsdl-org/SDL/blob/main/docs/README-ios.md
 *
 * This functions is also accessible using the macro
 * SDL_iOSSetAnimationCallback() since SDL 2.0.4.
 *
 * \param window the window for which the animation callback should be set
 * \param interval the number of frames after which **callback** will be
 *                 called
 * \param callback the function to call for every frame.
 * \param callbackParam a pointer that is passed to `callback`.
 * \returns 0 on success or a negative error code on failure; call
 *          SDL_GetError() for more information.
 *
 * \since This function is available since SDL 2.0.0.
 *
 * \sa SDL_iPhoneSetEventPump
 *}
function SDL_iPhoneSetAnimationCallback(window: PSDL_Window; interval: cint; callback: TSDL_iPhoneAnimationCallback; callbackParam: Pointer); cdecl;
  external SDL_LibName;

{**
 * Use this function to enable or disable the SDL event pump on Apple iOS.
 *
 * This function is only available on Apple iOS.
 *
 * This functions is also accessible using the macro SDL_iOSSetEventPump()
 * since SDL 2.0.4.
 *
 * \param enabled SDL_TRUE to enable the event pump, SDL_FALSE to disable it
 *
 * \since This function is available since SDL 2.0.0.
 *
 * \sa SDL_iPhoneSetAnimationCallback
 *}
procedure SDL_iPhoneSetEventPump(enabled: TSDL_Bool); cdecl;
  external SDL_LibName;
{$ENDIF}


(* Platform specific functions for WinRT *)
{$IFDEF __WINRT__}

  {**
   *  \brief WinRT / Windows Phone path types
   *}
Type
  TSDL_WinRT_Path = (

    {** \brief The installed app's root directory.
        Files here are likely to be read-only. *}
    SDL_WINRT_PATH_INSTALLED_LOCATION = 0,

    {** \brief The app's local data store.  Files may be written here *}
    SDL_WINRT_PATH_LOCAL_FOLDER = 1,

    {** \brief The app's roaming data store.  Unsupported on Windows Phone.
        Files written here may be copied to other machines via a network
        connection.
    *}
    SDL_WINRT_PATH_ROAMING_FOLDER = 2,

    {** \brief The app's temporary data store.  Unsupported on Windows Phone.
        Files written here may be deleted at any time. *}
    SDL_WINRT_PATH_TEMP_FOLDER = 3

  );


  {**
   *  \brief Retrieves a WinRT defined path on the local file system
   *
   *  \note Documentation on most app-specific path types on WinRT
   *      can be found on MSDN, at the URL:
   *      http://msdn.microsoft.com/en-us/library/windows/apps/hh464917.aspx
   *
   *  \param pathType The type of path to retrieve.
   *  \ret A UCS-2 string (16-bit, wide-char) containing the path, or NULL
   *      if the path is not available for any reason.  Not all paths are
   *      available on all versions of Windows.  This is especially true on
   *      Windows Phone.  Check the documentation for the given
   *      SDL_WinRT_Path for more information on which path types are
   *      supported where.
   *}
Function SDL_WinRTGetFSPathUNICODE(pathType :TSDL_WinRT_Path):PWideChar;
   cdecl; external SDL_LibName;


  {**
   *  \brief Retrieves a WinRT defined path on the local file system
   *
   *  \note Documentation on most app-specific path types on WinRT
   *      can be found on MSDN, at the URL:
   *      http://msdn.microsoft.com/en-us/library/windows/apps/hh464917.aspx
   *
   *  \param pathType The type of path to retrieve.
   *  \ret A UTF-8 string (8-bit, multi-byte) containing the path, or NULL
   *      if the path is not available for any reason.  Not all paths are
   *      available on all versions of Windows.  This is especially true on
   *      Windows Phone.  Check the documentation for the given
   *      SDL_WinRT_Path for more information on which path types are
   *      supported where.
   *}
Function SDL_WinRTGetFSPathUTF8(pathType :TSDL_WinRT_Path):PChar;
   cdecl; external SDL_LibName;

{$ENDIF}
