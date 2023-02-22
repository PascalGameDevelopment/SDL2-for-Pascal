//from sdl_audio.h
 {**
   *   Audio format flags.
   *
   *  These are what the 16 bits in SDL_AudioFormat currently mean...
   *  (Unspecified bits are always zero).
   *
   *
      ++-----------------------sample is signed if set
      ||
      ||       ++-----------sample is bigendian if set
      ||       ||
      ||       ||          ++---sample is float if set
      ||       ||          ||
      ||       ||          || +---sample bit size---+
      ||       ||          || |                     |
      15 14 13 12 11 10 09 08 07 06 05 04 03 02 01 00
   *
   *  There are macros in SDL 2.0 and later to query these bits.
   *}
type
  TSDL_AudioFormat = cuint16;

  {**
   *   Audio flags
   *}
const
  SDL_AUDIO_MASK_BITSIZE      = ($FF);
  SDL_AUDIO_MASK_DATATYPE     = (1 shl 8);
  SDL_AUDIO_MASK_ENDIAN       = (1 shl 12);
  SDL_AUDIO_MASK_SIGNED       = (1 shl 15);

function SDL_AUDIO_BITSIZE(x: Cardinal): Cardinal;
function SDL_AUDIO_ISFLOAT(x: Cardinal): Cardinal;
function SDL_AUDIO_ISBIGENDIAN(x: Cardinal): Cardinal;
function SDL_AUDIO_ISSIGNED(x: Cardinal): Cardinal;
function SDL_AUDIO_ISINT(x: Cardinal): Cardinal;
function SDL_AUDIO_ISLITTLEENDIAN(x: Cardinal): Cardinal;
function SDL_AUDIO_ISUNSIGNED(x: Cardinal): Cardinal;

  {**
   *   Audio format flags
   *
   *  Defaults to LSB byte order.
   *}
const
  AUDIO_U8      = $0008;  {**< Unsigned 8-bit samples *}
  AUDIO_S8      = $8008;  {**< Signed 8-bit samples *}
  AUDIO_U16LSB  = $0010;  {**< Unsigned 16-bit samples *}
  AUDIO_S16LSB  = $8010;  {**< Signed 16-bit samples *}
  AUDIO_U16MSB  = $1010;  {**< As above, but big-endian byte order *}
  AUDIO_S16MSB  = $9010;  {**< As above, but big-endian byte order *}
  AUDIO_U16     = AUDIO_U16LSB;
  AUDIO_S16     = AUDIO_S16LSB;

  {**
   *   int32 support
   *}
const
  AUDIO_S32LSB  = $8020;  {**< 32-bit integer samples *}
  AUDIO_S32MSB  = $9020;  {**< As above, but big-endian byte order *}
  AUDIO_S32     = AUDIO_S32LSB;

  {**
   *   float32 support
   *}
const
  AUDIO_F32LSB  = $8120;  {**< 32-bit floating point samples *}
  AUDIO_F32MSB  = $9120;  {**< As above, but big-endian byte order *}
  AUDIO_F32     = AUDIO_F32LSB;

  {**
   *   Native audio byte ordering
   *}
{$IFDEF FPC}
   {$IF DEFINED(ENDIAN_LITTLE)}
      AUDIO_U16SYS = AUDIO_U16LSB;
      AUDIO_S16SYS = AUDIO_S16LSB;
      AUDIO_S32SYS = AUDIO_S32LSB;
      AUDIO_F32SYS = AUDIO_F32LSB;
   {$ELSEIF DEFINED(ENDIAN_BIG)}
      AUDIO_U16SYS = AUDIO_U16MSB;
      AUDIO_S16SYS = AUDIO_S16MSB;
      AUDIO_S32SYS = AUDIO_S32MSB;
      AUDIO_F32SYS = AUDIO_F32MSB;
   {$ELSE}
      {$FATAL Cannot determine endianness.}
   {$IFEND}
{$ENDIF}

  {**
   *   Allow change flags
   *
   *  Which audio format changes are allowed when opening a device.
   *}
const
  SDL_AUDIO_ALLOW_FREQUENCY_CHANGE  = $00000001;
  SDL_AUDIO_ALLOW_FORMAT_CHANGE     = $00000002;
  SDL_AUDIO_ALLOW_CHANNELS_CHANGE   = $00000004;
  SDL_AUDIO_ALLOW_ANY_CHANGE        = (SDL_AUDIO_ALLOW_FREQUENCY_CHANGE or
                                       SDL_AUDIO_ALLOW_FORMAT_CHANGE or
                                                SDL_AUDIO_ALLOW_CHANNELS_CHANGE);

  {*Audio flags*}

  {**
 *  This function is called when the audio device needs more data.
 *
 *  \param userdata An application-specific parameter saved in
 *                  the SDL_AudioSpec structure
 *  \param stream A pointer to the audio data buffer.
 *  \param len    The length of that buffer in bytes.
 *
 *  Once the callback returns, the buffer will no longer be valid.
 *  Stereo samples are stored in a LRLRLR ordering.
 *
 *  You can choose to avoid callbacks and use SDL_QueueAudio() instead, if
 *  you like. Just open your audio device with a NULL callback.
   *}
type
  TSDL_AudioCallback = procedure(userdata: Pointer; stream: pcuint8; len: cint); cdecl;

  {**
   *  The calculated values in this structure are calculated by SDL_OpenAudio().
   *
   *  For multi-channel audio, the default SDL channel mapping is:
   *  2:  FL FR                       (stereo)
   *  3:  FL FR LFE                   (2.1 surround)
   *  4:  FL FR BL BR                 (quad)
   *  5:  FL FR LFE BL BR             (4.1 surround)
   *  6:  FL FR FC LFE SL SR          (5.1 surround - last two can also be BL BR)
   *  7:  FL FR FC LFE BC SL SR       (6.1 surround)
   *  8:  FL FR FC LFE BL BR SL SR    (7.1 surround)
   *}
type
  PSDL_AudioSpec = ^TSDL_AudioSpec;
  TSDL_AudioSpec = record
    freq: cint;                    {**< DSP frequency -- samples per second *}
    format: TSDL_AudioFormat;      {**< Audio data format *}
    channels: cuint8;              {**< Number of channels: 1 mono, 2 stereo *}
    silence: cuint8;               {**< Audio buffer silence value (calculated) *}
    samples: cuint16;              {**< Audio buffer size in sample FRAMES (total samples divided by channel count) *}
    padding: cuint16;              {**< Necessary for some compile environments *}
    size: cuint32;                 {**< Audio buffer size in bytes (calculated) *}
    callback: TSDL_AudioCallback;  {**< Callback that feeds the audio device (NULL to use SDL_QueueAudio()). *}
    userdata: Pointer;             {**< Userdata passed to callback (ignored for NULL callbacks). *}
  end;

  {**
   *  \brief Upper limit of filters in SDL_AudioCVT
   *
   *  The maximum number of SDL_AudioFilter functions in SDL_AudioCVT is
   *  currently limited to 9. The SDL_AudioCVT.filters array has 10 pointers,
   *  one of which is the terminating NULL pointer.
   *}
const
  SDL_AUDIOCVT_MAX_FILTERS = 9;

type
  PSDL_AudioCVT = ^TSDL_AudioCVT;
  TSDL_AudioFilter = procedure(cvt: PSDL_AudioCVT; format: TSDL_AudioFormat); cdecl;

  {**
   *  \struct SDL_AudioCVT
   *  \brief A structure to hold a set of audio conversion filters and buffers.
   *
   *  Note that various parts of the conversion pipeline can take advantage
   *  of SIMD operations (like SSE2, for example). SDL_AudioCVT doesn't require
   *  you to pass it aligned data, but can possibly run much faster if you
   *  set both its (buf) field to a pointer that is aligned to 16 bytes, and its
   *  (len) field to something that's a multiple of 16, if possible.
   *}
  TSDL_AudioCVT = record
    needed: cint;                           {**< Set to 1 if conversion possible *}
    src_format: TSDL_AudioFormat;           {**< Source audio format *}
    dst_format: TSDL_AudioFormat;           {**< Target audio format *}
    rate_incr: cdouble;                     {**< Rate conversion increment *}
    buf: pcuint8;                           {**< Buffer to hold entire audio data *}
    len: cint;                              {**< Length of original audio buffer *}
    len_cvt: cint;                          {**< Length of converted audio buffer *}
    len_mult: cint;                         {**< buffer must be len*len_mult big *}
    len_ratio: cdouble;                     {**< Given len, final size is len*len_ratio *}
    filters: array[0..SDL_AUDIOCVT_MAX_FILTERS + 1] of TSDL_AudioFilter; {**< NULL-terminated list of filter functions *}
    filter_index: cint;                     {**< Current audio conversion function *}
  end;


  {* Function prototypes *}

  {**
   *   Driver discovery functions
   *
   *  These functions return the list of built in audio drivers, in the
   *  order that they are normally initialized by default.
   *}

  {**
   * Use this function to get the number of built-in audio drivers.
   *
   * This function returns a hardcoded number. This never returns a negative
   * value; if there are no drivers compiled into this build of SDL, this
   * function returns zero. The presence of a driver in this list does not mean
   * it will function, it just means SDL is capable of interacting with that
   * interface. For example, a build of SDL might have esound support, but if
   * there's no esound server available, SDL's esound driver would fail if used.
   *
   * By default, SDL tries all drivers, in its preferred order, until one is
   * found to be usable.
   *
   * \returns the number of built-in audio drivers.
   *
   * \since This function is available since SDL 2.0.0.
   *
   * \sa SDL_GetAudioDriver
   *}
function SDL_GetNumAudioDrivers: cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetNumAudioDrivers' {$ENDIF} {$ENDIF};

{**
 * Use this function to get the name of a built in audio driver.
 *
 * The list of audio drivers is given in the order that they are normally
 * initialized by default; the drivers that seem more reasonable to choose
 * first (as far as the SDL developers believe) are earlier in the list.
 *
 * The names of drivers are all simple, low-ASCII identifiers, like "alsa",
 * "coreaudio" or "xaudio2". These never have Unicode characters, and are not
 * meant to be proper names.
 *
 * \param index the index of the audio driver; the value ranges from 0 to
 *              SDL_GetNumAudioDrivers() - 1
 * \returns the name of the audio driver at the requested index, or NULL if an
 *          invalid index was specified.
 *
 * \since This function is available since SDL 2.0.0.
 *
 * \sa SDL_GetNumAudioDrivers
 *}
function SDL_GetAudioDriver(index: cint): PAnsiChar; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetAudioDriver' {$ENDIF} {$ENDIF};

  {**
   *   Initialization and cleanup
   *
   *  These functions are used internally, and should not be used unless
   *  you have a specific need to specify the audio driver you want to
   *  use.  You should normally use SDL_Init() or SDL_InitSubSystem().
   *}

{**
 * Use this function to initialize a particular audio driver.
 *
 * This function is used internally, and should not be used unless you have a
 * specific need to designate the audio driver you want to use. You should
 * normally use SDL_Init() or SDL_InitSubSystem().
 *
 * \param driver_name the name of the desired audio driver
 * \returns 0 on success or a negative error code on failure; call
 *          SDL_GetError() for more information.
 *
 * \since This function is available since SDL 2.0.0.
 *
 * \sa SDL_AudioQuit
 *}
function SDL_AudioInit(driver_name: PAnsiChar): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_AudioInit' {$ENDIF} {$ENDIF};

{**
 * Use this function to shut down audio if you initialized it with
 * SDL_AudioInit().
 *
 * This function is used internally, and should not be used unless you have a
 * specific need to specify the audio driver you want to use. You should
 * normally use SDL_Quit() or SDL_QuitSubSystem().
 *
 * \since This function is available since SDL 2.0.0.
 *
 * \sa SDL_AudioInit
 *}
procedure SDL_AudioQuit; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_AudioQuit' {$ENDIF} {$ENDIF};

  {**
 * Get the name of the current audio driver.
 *
 * The returned string points to internal static memory and thus never becomes
 * invalid, even if you quit the audio subsystem and initialize a new driver
 * (although such a case would return a different static string from another
 * call to this function, of course). As such, you should not modify or free
 * the returned string.
 *
 * \returns the name of the current audio driver or NULL if no driver has been
 *          initialized.
 *
 * \since This function is available since SDL 2.0.0.
 *
 * \sa SDL_AudioInit
 *}
function SDL_GetCurrentAudioDriver: PAnsiChar; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetCurrentAudioDriver' {$ENDIF} {$ENDIF};

{**
 * This function is a legacy means of opening the audio device.
 *
 * This function remains for compatibility with SDL 1.2, but also because it's
 * slightly easier to use than the new functions in SDL 2.0. The new, more
 * powerful, and preferred way to do this is SDL_OpenAudioDevice().
 *
 * This function is roughly equivalent to:
 *
 * ```c
 * SDL_OpenAudioDevice(NULL, 0, desired, obtained, SDL_AUDIO_ALLOW_ANY_CHANGE);
 * ```
 *
 * With two notable exceptions:
 *
 * - If `obtained` is NULL, we use `desired` (and allow no changes), which
 *   means desired will be modified to have the correct values for silence,
 *   etc, and SDL will convert any differences between your app's specific
 *   request and the hardware behind the scenes.
 * - The return value is always success or failure, and not a device ID, which
 *   means you can only have one device open at a time with this function.
 *
 * \param desired an SDL_AudioSpec structure representing the desired output
 *                format. Please refer to the SDL_OpenAudioDevice
 *                documentation for details on how to prepare this structure.
 * \param obtained an SDL_AudioSpec structure filled in with the actual
 *                 parameters, or NULL.
 * \returns 0 if successful, placing the actual hardware parameters in the
 *          structure pointed to by `obtained`.
 *
 *          If `obtained` is NULL, the audio data passed to the callback
 *          function will be guaranteed to be in the requested format, and
 *          will be automatically converted to the actual hardware audio
 *          format if necessary. If `obtained` is NULL, `desired` will have
 *          fields modified.
 *
 *          This function returns a negative error code on failure to open the
 *          audio device or failure to set up the audio thread; call
 *          SDL_GetError() for more information.
 *
 * \since This function is available since SDL 2.0.0.
 *
 * \sa SDL_CloseAudio
 * \sa SDL_LockAudio
 * \sa SDL_PauseAudio
 * \sa SDL_UnlockAudio
 *}
function SDL_OpenAudio(desired: PSDL_AudioSpec; obtained: PSDL_AudioSpec): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_OpenAudio' {$ENDIF} {$ENDIF};

  {**
   *  SDL Audio Device IDs.
   *
   *  A successful call to SDL_OpenAudio() is always device id 1, and legacy
   *  SDL audio APIs assume you want this device ID. SDL_OpenAudioDevice() calls
   *  always returns devices >= 2 on success. The legacy calls are good both
   *  for backwards compatibility and when you don't care about multiple,
   *  specific, or capture devices.
   *}
type
  TSDL_AudioDeviceID = cuint32;

{**
 * Get the number of built-in audio devices.
 *
 * This function is only valid after successfully initializing the audio
 * subsystem.
 *
 * Note that audio capture support is not implemented as of SDL 2.0.4, so the
 * `iscapture` parameter is for future expansion and should always be zero for
 * now.
 *
 * This function will return -1 if an explicit list of devices can't be
 * determined. Returning -1 is not an error. For example, if SDL is set up to
 * talk to a remote audio server, it can't list every one available on the
 * Internet, but it will still allow a specific host to be specified in
 * SDL_OpenAudioDevice().
 *
 * In many common cases, when this function returns a value <= 0, it can still
 * successfully open the default device (NULL for first argument of
 * SDL_OpenAudioDevice()).
 *
 * This function may trigger a complete redetect of available hardware. It
 * should not be called for each iteration of a loop, but rather once at the
 * start of a loop:
 *
 * ```c
 * // Don't do this:
 * for (int i = 0; i < SDL_GetNumAudioDevices(0); i++)
 *
 * // do this instead:
 * const int count = SDL_GetNumAudioDevices(0);
 * for (int i = 0; i < count; ++i)  do_something_here();
 * ```
 *
 * \param iscapture zero to request playback devices, non-zero to request
 *                  recording devices
 * \returns the number of available devices exposed by the current driver or
 *          -1 if an explicit list of devices can't be determined. A return
 *          value of -1 does not necessarily mean an error condition.
 *
 * \since This function is available since SDL 2.0.0.
 *
 * \sa SDL_GetAudioDeviceName
 * \sa SDL_OpenAudioDevice
 *}
function SDL_GetNumAudioDevices(iscapture: cint): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetNumAudioDevices' {$ENDIF} {$ENDIF};

{**
 * Get the human-readable name of a specific audio device.
 *
 * This function is only valid after successfully initializing the audio
 * subsystem. The values returned by this function reflect the latest call to
 * SDL_GetNumAudioDevices(); re-call that function to redetect available
 * hardware.
 *
 * The string returned by this function is UTF-8 encoded, read-only, and
 * managed internally. You are not to free it. If you need to keep the string
 * for any length of time, you should make your own copy of it, as it will be
 * invalid next time any of several other SDL functions are called.
 *
 * \param index the index of the audio device; valid values range from 0 to
 *              SDL_GetNumAudioDevices() - 1
 * \param iscapture non-zero to query the list of recording devices, zero to
 *                  query the list of output devices.
 * \returns the name of the audio device at the requested index, or NULL on
 *          error.
 *
 * \since This function is available since SDL 2.0.0.
 *
 * \sa SDL_GetNumAudioDevices
 * \sa SDL_GetDefaultAudioInfo
 *}
function SDL_GetAudioDeviceName(index: cint; iscapture: cint): PAnsiChar; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetAudioDeviceName' {$ENDIF} {$ENDIF};

{*
 * Get the preferred audio format of a specific audio device.
 *
 * This function is only valid after a successfully initializing the audio
 * subsystem. The values returned by this function reflect the latest call to
 * SDL_GetNumAudioDevices(); re-call that function to redetect available
 * hardware.
 *
 * `spec` will be filled with the sample rate, sample format, and channel
 * count.
 *
 * \param index the index of the audio device; valid values range from 0 to
 *              SDL_GetNumAudioDevices() - 1
 * \param iscapture non-zero to query the list of recording devices, zero to
 *                  query the list of output devices.
 * \param spec The SDL_AudioSpec to be initialized by this function.
 * \returns 0 on success, nonzero on error
 *
 * \since This function is available since SDL 2.0.16.
 *
 * \sa SDL_GetNumAudioDevices
 * \sa SDL_GetDefaultAudioInfo
  }
function SDL_GetAudioDeviceSpec(index: cint; iscapture: cint; spec: PSDL_AudioSpec): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetAudioDeviceSpec' {$ENDIF} {$ENDIF};

{*
 * Get the name and preferred format of the default audio device.
 *
 * Some (but not all!) platforms have an isolated mechanism to get information
 * about the "default" device. This can actually be a completely different
 * device that's not in the list you get from SDL_GetAudioDeviceSpec(). It can
 * even be a network address! (This is discussed in SDL_OpenAudioDevice().)
 *
 * As a result, this call is not guaranteed to be performant, as it can query
 * the sound server directly every time, unlike the other query functions. You
 * should call this function sparingly!
 *
 * `spec` will be filled with the sample rate, sample format, and channel
 * count, if a default device exists on the system. If `name` is provided,
 * will be filled with either a dynamically-allocated UTF-8 string or nil.
 *
 * \param name A pointer to be filled with the name of the default device (can
 *             be nil). Please call SDL_free() when you are done with this
 *             pointer!
 * \param spec The SDL_AudioSpec to be initialized by this function.
 * \param iscapture non-zero to query the default recording device, zero to
 *                  query the default output device.
 * \returns 0 on success, nonzero on error
 *
 * \since This function is available since SDL 2.24.0.
 *
 * \sa SDL_GetAudioDeviceName
 * \sa SDL_GetAudioDeviceSpec
 * \sa SDL_OpenAudioDevice
  }
function SDL_GetDefaultAudioInfo(name: PPAnsiChar; spec: PSDL_AudioSpec; iscapture: cint): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetDefaultAudioInfo' {$ENDIF} {$ENDIF};

{**
 * Open a specific audio device.
 *
 * SDL_OpenAudio(), unlike this function, always acts on device ID 1. As such,
 * this function will never return a 1 so as not to conflict with the legacy
 * function.
 *
 * Please note that SDL 2.0 before 2.0.5 did not support recording; as such,
 * this function would fail if `iscapture` was not zero. Starting with SDL
 * 2.0.5, recording is implemented and this value can be non-zero.
 *
 * Passing in a `device` name of NULL requests the most reasonable default
 * (and is equivalent to what SDL_OpenAudio() does to choose a device). The
 * `device` name is a UTF-8 string reported by SDL_GetAudioDeviceName(), but
 * some drivers allow arbitrary and driver-specific strings, such as a
 * hostname/IP address for a remote audio server, or a filename in the
 * diskaudio driver.
 *
 * An opened audio device starts out paused, and should be enabled for playing
 * by calling SDL_PauseAudioDevice(devid, 0) when you are ready for your audio
 * callback function to be called. Since the audio driver may modify the
 * requested size of the audio buffer, you should allocate any local mixing
 * buffers after you open the audio device.
 *
 * The audio callback runs in a separate thread in most cases; you can prevent
 * race conditions between your callback and other threads without fully
 * pausing playback with SDL_LockAudioDevice(). For more information about the
 * callback, see SDL_AudioSpec.
 *
 * Managing the audio spec via 'desired' and 'obtained':
 *
 * When filling in the desired audio spec structure:
 *
 * - `desired->freq` should be the frequency in sample-frames-per-second (Hz).
 * - `desired->format` should be the audio format (`AUDIO_S16SYS`, etc).
 * - `desired->samples` is the desired size of the audio buffer, in _sample
 *   frames_ (with stereo output, two samples--left and right--would make a
 *   single sample frame). This number should be a power of two, and may be
 *   adjusted by the audio driver to a value more suitable for the hardware.
 *   Good values seem to range between 512 and 8096 inclusive, depending on
 *   the application and CPU speed. Smaller values reduce latency, but can
 *   lead to underflow if the application is doing heavy processing and cannot
 *   fill the audio buffer in time. Note that the number of sample frames is
 *   directly related to time by the following formula: `ms =
 *   (sampleframes*1000)/freq`
 * - `desired->size` is the size in _bytes_ of the audio buffer, and is
 *   calculated by SDL_OpenAudioDevice(). You don't initialize this.
 * - `desired->silence` is the value used to set the buffer to silence, and is
 *   calculated by SDL_OpenAudioDevice(). You don't initialize this.
 * - `desired->callback` should be set to a function that will be called when
 *   the audio device is ready for more data. It is passed a pointer to the
 *   audio buffer, and the length in bytes of the audio buffer. This function
 *   usually runs in a separate thread, and so you should protect data
 *   structures that it accesses by calling SDL_LockAudioDevice() and
 *   SDL_UnlockAudioDevice() in your code. Alternately, you may pass a NULL
 *   pointer here, and call SDL_QueueAudio() with some frequency, to queue
 *   more audio samples to be played (or for capture devices, call
 *   SDL_DequeueAudio() with some frequency, to obtain audio samples).
 * - `desired->userdata` is passed as the first parameter to your callback
 *   function. If you passed a NULL callback, this value is ignored.
 *
 * `allowed_changes` can have the following flags OR'd together:
 *
 * - `SDL_AUDIO_ALLOW_FREQUENCY_CHANGE`
 * - `SDL_AUDIO_ALLOW_FORMAT_CHANGE`
 * - `SDL_AUDIO_ALLOW_CHANNELS_CHANGE`
 * - `SDL_AUDIO_ALLOW_SAMPLES_CHANGE`
 * - `SDL_AUDIO_ALLOW_ANY_CHANGE`
 *
 * These flags specify how SDL should behave when a device cannot offer a
 * specific feature. If the application requests a feature that the hardware
 * doesn't offer, SDL will always try to get the closest equivalent.
 *
 * For example, if you ask for float32 audio format, but the sound card only
 * supports int16, SDL will set the hardware to int16. If you had set
 * SDL_AUDIO_ALLOW_FORMAT_CHANGE, SDL will change the format in the `obtained`
 * structure. If that flag was *not* set, SDL will prepare to convert your
 * callback's float32 audio to int16 before feeding it to the hardware and
 * will keep the originally requested format in the `obtained` structure.
 *
 * The resulting audio specs, varying depending on hardware and on what
 * changes were allowed, will then be written back to `obtained`.
 *
 * If your application can only handle one specific data format, pass a zero
 * for `allowed_changes` and let SDL transparently handle any differences.
 *
 * \param device a UTF-8 string reported by SDL_GetAudioDeviceName() or a
 *               driver-specific name as appropriate. NULL requests the most
 *               reasonable default device.
 * \param iscapture non-zero to specify a device should be opened for
 *                  recording, not playback
 * \param desired an SDL_AudioSpec structure representing the desired output
 *                format; see SDL_OpenAudio() for more information
 * \param obtained an SDL_AudioSpec structure filled in with the actual output
 *                 format; see SDL_OpenAudio() for more information
 * \param allowed_changes 0, or one or more flags OR'd together
 * \returns a valid device ID that is > 0 on success or 0 on failure; call
 *          SDL_GetError() for more information.
 *
 *          For compatibility with SDL 1.2, this will never return 1, since
 *          SDL reserves that ID for the legacy SDL_OpenAudio() function.
 *
 * \since This function is available since SDL 2.0.0.
 *
 * \sa SDL_CloseAudioDevice
 * \sa SDL_GetAudioDeviceName
 * \sa SDL_LockAudioDevice
 * \sa SDL_OpenAudio
 * \sa SDL_PauseAudioDevice
 * \sa SDL_UnlockAudioDevice
 *}
function SDL_OpenAudioDevice(device: PAnsiChar;
                             iscapture: cint;
                             desired: PSDL_AudioSpec;
                             obtained: PSDL_AudioSpec;
                             allowed_changes: cint): TSDL_AudioDeviceID; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_OpenAudioDevice' {$ENDIF} {$ENDIF};

  {**
   *   Audio state
   *
   *  Get the current audio state.
   *}

type
  PSDL_AudioStatus = ^TSDL_AudioStatus;
  TSDL_AudioStatus = cint;

const
  SDL_AUDIO_STOPPED = TSDL_AudioStatus(0);
  SDL_AUDIO_PLAYING = TSDL_AudioStatus(1);
  SDL_AUDIO_PAUSED  = TSDL_AudioStatus(2);

{**
 * This function is a legacy means of querying the audio device.
 *
 * New programs might want to use SDL_GetAudioDeviceStatus() instead. This
 * function is equivalent to calling...
 *
 * ```c
 * SDL_GetAudioDeviceStatus(1);
 * ```
 *
 * ...and is only useful if you used the legacy SDL_OpenAudio() function.
 *
 * \returns the SDL_AudioStatus of the audio device opened by SDL_OpenAudio().
 *
 * \since This function is available since SDL 2.0.0.
 *
 * \sa SDL_GetAudioDeviceStatus
 *}
function SDL_GetAudioStatus: TSDL_AudioStatus; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetAudioStatus' {$ENDIF} {$ENDIF};

{**
 * Use this function to get the current audio state of an audio device.
 *
 * \param dev the ID of an audio device previously opened with
 *            SDL_OpenAudioDevice()
 * \returns the SDL_AudioStatus of the specified audio device.
 *
 * \since This function is available since SDL 2.0.0.
 *
 * \sa SDL_PauseAudioDevice
 *}
function SDL_GetAudioDeviceStatus(dev: TSDL_AudioDeviceID): TSDL_AudioStatus; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetAudioDeviceStatus' {$ENDIF} {$ENDIF};

{*Audio State*}

  {**
   *   Pause audio functions
   *
   *  These functions pause and unpause the audio callback processing.
   *  They should be called with a parameter of 0 after opening the audio
   *  device to start playing sound.  This is so you can safely initialize
   *  data for your callback function after opening the audio device.
   *  Silence will be written to the audio device during the pause.
   *}

{**
 * This function is a legacy means of pausing the audio device.
 *
 * New programs might want to use SDL_PauseAudioDevice() instead. This
 * function is equivalent to calling...
 *
 * ```c
 * SDL_PauseAudioDevice(1, pause_on);
 * ```
 *
 * ...and is only useful if you used the legacy SDL_OpenAudio() function.
 *
 * \param pause_on non-zero to pause, 0 to unpause
 *
 * \since This function is available since SDL 2.0.0.
 *
 * \sa SDL_GetAudioStatus
 * \sa SDL_PauseAudioDevice
 *}
procedure SDL_PauseAudio(pause_on: cint); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_PauseAudio' {$ENDIF} {$ENDIF};

{**
 * Use this function to pause and unpause audio playback on a specified
 * device.
 *
 * This function pauses and unpauses the audio callback processing for a given
 * device. Newly-opened audio devices start in the paused state, so you must
 * call this function with **pause_on**=0 after opening the specified audio
 * device to start playing sound. This allows you to safely initialize data
 * for your callback function after opening the audio device. Silence will be
 * written to the audio device while paused, and the audio callback is
 * guaranteed to not be called. Pausing one device does not prevent other
 * unpaused devices from running their callbacks.
 *
 * Pausing state does not stack; even if you pause a device several times, a
 * single unpause will start the device playing again, and vice versa. This is
 * different from how SDL_LockAudioDevice() works.
 *
 * If you just need to protect a few variables from race conditions vs your
 * callback, you shouldn't pause the audio device, as it will lead to dropouts
 * in the audio playback. Instead, you should use SDL_LockAudioDevice().
 *
 * \param dev a device opened by SDL_OpenAudioDevice()
 * \param pause_on non-zero to pause, 0 to unpause
 *
 * \since This function is available since SDL 2.0.0.
 *
 * \sa SDL_LockAudioDevice
 *}
procedure SDL_PauseAudioDevice(dev: TSDL_AudioDeviceID; pause_on: cint); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_PauseAudioDevice' {$ENDIF} {$ENDIF};

{*Pause audio functions*}

  {**
 * Load the audio data of a WAVE file into memory.
 *
 * Loading a WAVE file requires `src`, `spec`, `audio_buf` and `audio_len` to
 * be valid pointers. The entire data portion of the file is then loaded into
 * memory and decoded if necessary.
 *
 * If `freesrc` is non-zero, the data source gets automatically closed and
 * freed before the function returns.
 *
 * Supported formats are RIFF WAVE files with the formats PCM (8, 16, 24, and
 * 32 bits), IEEE Float (32 bits), Microsoft ADPCM and IMA ADPCM (4 bits), and
 * A-law and mu-law (8 bits). Other formats are currently unsupported and
 * cause an error.
 *
 * If this function succeeds, the pointer returned by it is equal to `spec`
 * and the pointer to the audio data allocated by the function is written to
 * `audio_buf` and its length in bytes to `audio_len`. The SDL_AudioSpec
 * members `freq`, `channels`, and `format` are set to the values of the audio
 * data in the buffer. The `samples` member is set to a sane default and all
 * others are set to zero.
 *
 * It's necessary to use SDL_FreeWAV() to free the audio data returned in
 * `audio_buf` when it is no longer used.
 *
 * Because of the underspecification of the .WAV format, there are many
 * problematic files in the wild that cause issues with strict decoders. To
 * provide compatibility with these files, this decoder is lenient in regards
 * to the truncation of the file, the fact chunk, and the size of the RIFF
 * chunk. The hints `SDL_HINT_WAVE_RIFF_CHUNK_SIZE`,
 * `SDL_HINT_WAVE_TRUNCATION`, and `SDL_HINT_WAVE_FACT_CHUNK` can be used to
 * tune the behavior of the loading process.
 *
 * Any file that is invalid (due to truncation, corruption, or wrong values in
 * the headers), too big, or unsupported causes an error. Additionally, any
 * critical I/O error from the data source will terminate the loading process
 * with an error. The function returns NULL on error and in all cases (with
 * the exception of `src` being NULL), an appropriate error message will be
 * set.
 *
 * It is required that the data source supports seeking.
 *
 * Example:
 *
 * ```c
 * SDL_LoadWAV_RW(SDL_RWFromFile("sample.wav", "rb"), 1, &spec, &buf, &len);
 * ```
 *
 * Note that the SDL_LoadWAV macro does this same thing for you, but in a less
 * messy way:
 *
 * ```c
 * SDL_LoadWAV("sample.wav", &spec, &buf, &len);
 * ```
 *
 * \param src The data source for the WAVE data
 * \param freesrc If non-zero, SDL will _always_ free the data source
 * \param spec An SDL_AudioSpec that will be filled in with the wave file's
 *             format details
 * \param audio_buf A pointer filled with the audio data, allocated by the
 *                  function.
 * \param audio_len A pointer filled with the length of the audio data buffer
 *                  in bytes
 * \returns This function, if successfully called, returns `spec`, which will
 *          be filled with the audio data format of the wave source data.
 *          `audio_buf` will be filled with a pointer to an allocated buffer
 *          containing the audio data, and `audio_len` is filled with the
 *          length of that audio buffer in bytes.
 *
 *          This function returns NULL if the .WAV file cannot be opened, uses
 *          an unknown data format, or is corrupt; call SDL_GetError() for
 *          more information.
 *
 *          When the application is done with the data returned in
 *          `audio_buf`, it should call SDL_FreeWAV() to dispose of it.
 *
 * \since This function is available since SDL 2.0.0.
 *
 * \sa SDL_FreeWAV
 * \sa SDL_LoadWAV
 *}
function SDL_LoadWAV_RW(src: PSDL_RWops;
                        freesrc: cint;
                        spec: PSDL_AudioSpec;
                        audio_buf: ppcuint8;
                        audio_len: pcuint32): PSDL_AudioSpec; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_LoadWAV_RW' {$ENDIF} {$ENDIF};

{**
 *  Loads a WAV from a file.
 *  Compatibility convenience function.
 *}
function SDL_LoadWAV(_file: PAnsiChar; spec: PSDL_AudioSpec; audio_buf: ppcuint8; audio_len: pcuint32): PSDL_AudioSpec;

{**
 * Free data previously allocated with SDL_LoadWAV() or SDL_LoadWAV_RW().
 *
 * After a WAVE file has been opened with SDL_LoadWAV() or SDL_LoadWAV_RW()
 * its data can eventually be freed with SDL_FreeWAV(). It is safe to call
 * this function with a NULL pointer.
 *
 * \param audio_buf a pointer to the buffer created by SDL_LoadWAV() or
 *                  SDL_LoadWAV_RW()
 *
 * \since This function is available since SDL 2.0.0.
 *
 * \sa SDL_LoadWAV
 * \sa SDL_LoadWAV_RW
 *}
procedure SDL_FreeWAV(audio_buf: pcuint8); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_FreeWAV' {$ENDIF} {$ENDIF};

{**
 * Initialize an SDL_AudioCVT structure for conversion.
 *
 * Before an SDL_AudioCVT structure can be used to convert audio data it must
 * be initialized with source and destination information.
 *
 * This function will zero out every field of the SDL_AudioCVT, so it must be
 * called before the application fills in the final buffer information.
 *
 * Once this function has returned successfully, and reported that a
 * conversion is necessary, the application fills in the rest of the fields in
 * SDL_AudioCVT, now that it knows how large a buffer it needs to allocate,
 * and then can call SDL_ConvertAudio() to complete the conversion.
 *
 * \param cvt an SDL_AudioCVT structure filled in with audio conversion
 *            information
 * \param src_format the source format of the audio data; for more info see
 *                   SDL_AudioFormat
 * \param src_channels the number of channels in the source
 * \param src_rate the frequency (sample-frames-per-second) of the source
 * \param dst_format the destination format of the audio data; for more info
 *                   see SDL_AudioFormat
 * \param dst_channels the number of channels in the destination
 * \param dst_rate the frequency (sample-frames-per-second) of the destination
 * \returns 1 if the audio filter is prepared, 0 if no conversion is needed,
 *          or a negative error code on failure; call SDL_GetError() for more
 *          information.
 *
 * \since This function is available since SDL 2.0.0.
 *
 * \sa SDL_ConvertAudio
 *}
function SDL_BuildAudioCVT(cvt: PSDL_AudioCVT;
                           src_format: TSDL_AudioFormat;
                           src_channels: cuint8;
                           src_rate: cint;
                           dst_format: TSDL_AudioFormat;
                           dst_channels: cuint8;
                           dst_rate: cint): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_BuildAudioCVT' {$ENDIF} {$ENDIF};

{**
 * Convert audio data to a desired audio format.
 *
 * This function does the actual audio data conversion, after the application
 * has called SDL_BuildAudioCVT() to prepare the conversion information and
 * then filled in the buffer details.
 *
 * Once the application has initialized the `cvt` structure using
 * SDL_BuildAudioCVT(), allocated an audio buffer and filled it with audio
 * data in the source format, this function will convert the buffer, in-place,
 * to the desired format.
 *
 * The data conversion may go through several passes; any given pass may
 * possibly temporarily increase the size of the data. For example, SDL might
 * expand 16-bit data to 32 bits before resampling to a lower frequency,
 * shrinking the data size after having grown it briefly. Since the supplied
 * buffer will be both the source and destination, converting as necessary
 * in-place, the application must allocate a buffer that will fully contain
 * the data during its largest conversion pass. After SDL_BuildAudioCVT()
 * returns, the application should set the `cvt->len` field to the size, in
 * bytes, of the source data, and allocate a buffer that is `cvt->len *
 * cvt->len_mult` bytes long for the `buf` field.
 *
 * The source data should be copied into this buffer before the call to
 * SDL_ConvertAudio(). Upon successful return, this buffer will contain the
 * converted audio, and `cvt->len_cvt` will be the size of the converted data,
 * in bytes. Any bytes in the buffer past `cvt->len_cvt` are undefined once
 * this function returns.
 *
 * \param cvt an SDL_AudioCVT structure that was previously set up by
 *            SDL_BuildAudioCVT().
 * \returns 0 if the conversion was completed successfully or a negative error
 *          code on failure; call SDL_GetError() for more information.
 *
 * \since This function is available since SDL 2.0.0.
 *
 * \sa SDL_BuildAudioCVT
 *}
function SDL_ConvertAudio(cvt: PSDL_AudioCVT): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_ConvertAudio' {$ENDIF} {$ENDIF};

{ SDL_AudioStream is a new audio conversion interface.
   The benefits vs SDL_AudioCVT:
    - it can handle resampling data in chunks without generating
      artifacts, when it doesn't have the complete buffer available.
    - it can handle incoming data in any variable size.
    - You push data as you have it, and pull it when you need it
  }
{ this is opaque to the outside world.  }
type
  PSDL_AudioStream = ^TSDL_AudioStream;
  TSDL_AudioStream = record end;

{*
 * Create a new audio stream.
 *
 * \param src_format The format of the source audio
 * \param src_channels The number of channels of the source audio
 * \param src_rate The sampling rate of the source audio
 * \param dst_format The format of the desired audio output
 * \param dst_channels The number of channels of the desired audio output
 * \param dst_rate The sampling rate of the desired audio output
 * \returns 0 on success, or -1 on error.
 *
 * \since This function is available since SDL 2.0.7.
 *
 * \sa SDL_AudioStreamPut
 * \sa SDL_AudioStreamGet
 * \sa SDL_AudioStreamAvailable
 * \sa SDL_AudioStreamFlush
 * \sa SDL_AudioStreamClear
 * \sa SDL_FreeAudioStream
  }
function SDL_NewAudioStream(src_format: TSDL_AudioFormat; src_channels: cuint8; src_rate: cint; dst_format: TSDL_AudioFormat; dst_channels: cuint8;
           dst_rate: cint): PSDL_AudioStream; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_NewAudioStream' {$ENDIF} {$ENDIF};


const
  SDL_MIX_MAXVOLUME = 128;

  {**
   *  This takes two audio buffers of the playing audio format and mixes
   *  them, performing addition, volume adjustment, and overflow clipping.
   *  The volume ranges from 0 - 128, and should be set to ::SDL_MIX_MAXVOLUME
   *  for full audio volume.  Note this does not change hardware volume.
   *  This is provided for convenience -- you can mix your own audio data.
   *}
procedure SDL_MixAudio(dst: pcuint8; src: pcuint8; len: cuint32; volume: cint) cdecl; external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_MixAudio' {$ENDIF} {$ENDIF};

  {**
   *  This works like SDL_MixAudio(), but you specify the audio format instead of
   *  using the format of audio device 1. Thus it can be used when no audio
   *  device is open at all.
   *}
procedure SDL_MixAudioFormat(dst: pcuint8; src: pcuint8; format: TSDL_AudioFormat; len: cuint32; volume: cint) cdecl; external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_MixAudioFormat' {$ENDIF} {$ENDIF};

  {**
   *  Queue more audio on non-callback devices.
   *
   *  SDL offers two ways to feed audio to the device: you can either supply a
   *  callback that SDL triggers with some frequency to obtain more audio
   *  (pull method), or you can supply no callback, and then SDL will expect
   *  you to supply data at regular intervals (push method) with this function.
   *
   *  There are no limits on the amount of data you can queue, short of
   *  exhaustion of address space. Queued data will drain to the device as
   *  necessary without further intervention from you. If the device needs
   *  audio but there is not enough queued, it will play silence to make up
   *  the difference. This means you will have skips in your audio playback
   *  if you aren't routinely queueing sufficient data.
   *
   *  This function copies the supplied data, so you are safe to free it when
   *  the function returns. This function is thread-safe, but queueing to the
   *  same device from two threads at once does not promise which buffer will
   *  be queued first.
   *
   *  You may not queue audio on a device that is using an application-supplied
   *  callback; doing so returns an error. You have to use the audio callback
   *  or queue audio with this function, but not both.
   *
   *  You should not call SDL_LockAudio() on the device before queueing; SDL
   *  handles locking internally for this function.
   *
   *  \param dev The device ID to which we will queue audio.
   *  \param data The data to queue to the device for later playback.
   *  \param len The number of bytes (not samples!) to which (data) points.
   *  \return zero on success, -1 on error.
   *
   *  \sa SDL_GetQueuedAudioSize
   *  \sa SDL_ClearQueuedAudio
   *}
function SDL_QueueAudio(dev: TSDL_AudioDeviceID; data: Pointer; len: cuint32): cint32; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_QueueAudio' {$ENDIF} {$ENDIF};

  {**
   *  Dequeue more audio on non-callback devices.
   *
   *  (If you are looking to queue audio for output on a non-callback playback
   *  device, you want SDL_QueueAudio() instead. This will always return 0
   *  if you use it with playback devices.)
   *
   *  SDL offers two ways to retrieve audio from a capture device: you can
   *  either supply a callback that SDL triggers with some frequency as the
   *  device records more audio data, (push method), or you can supply no
   *  callback, and then SDL will expect you to retrieve data at regular
   *  intervals (pull method) with this function.
   *
   *  There are no limits on the amount of data you can queue, short of
   *  exhaustion of address space. Data from the device will keep queuing as
   *  necessary without further intervention from you. This means you will
   *  eventually run out of memory if you aren't routinely dequeueing data.
   *
   *  Capture devices will not queue data when paused; if you are expecting
   *  to not need captured audio for some length of time, use
   *  SDL_PauseAudioDevice() to stop the capture device from queueing more
   *  data. This can be useful during, say, level loading times. When
   *  unpaused, capture devices will start queueing data from that point,
   *  having flushed any capturable data available while paused.
   *
   *  This function is thread-safe, but dequeueing from the same device from
   *  two threads at once does not promise which thread will dequeued data
   *  first.
   *
   *  You may not dequeue audio from a device that is using an
   *  application-supplied callback; doing so returns an error. You have to use
   *  the audio callback, or dequeue audio with this function, but not both.
   *
   *  You should not call SDL_LockAudio() on the device before queueing; SDL
   *  handles locking internally for this function.
   *
   *  \param dev The device ID from which we will dequeue audio.
   *  \param data A pointer into where audio data should be copied.
   *  \param len The number of bytes (not samples!) to which (data) points.
   *  \return number of bytes dequeued, which could be less than requested.
   *
   *  \sa SDL_GetQueuedAudioSize
   *  \sa SDL_ClearQueuedAudio
   *}
function SDL_DequeueAudio(dev: TSDL_AudioDeviceID; data: Pointer; len:Uint32):Uint32; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_DequeueAudio' {$ENDIF} {$ENDIF};

  {**
   *  Get the number of bytes of still-queued audio.
   *
   *  This is the number of bytes that have been queued for playback with
   *  SDL_QueueAudio(), but have not yet been sent to the hardware.
   *
   *  Once we've sent it to the hardware, this function can not decide the exact
   *  byte boundary of what has been played. It's possible that we just gave the
   *  hardware several kilobytes right before you called this function, but it
   *  hasn't played any of it yet, or maybe half of it, etc.
   *
   *  You may not queue audio on a device that is using an application-supplied
   *  callback; calling this function on such a device always returns 0.
   *  You have to use the audio callback or queue audio with SDL_QueueAudio(),
   *  but not both.
   *
   *  You should not call SDL_LockAudio() on the device before querying; SDL
   *  handles locking internally for this function.
   *
   *  \param dev The device ID of which we will query queued audio size.
   *  \return Number of bytes (not samples!) of queued audio.
   *
   *  \sa SDL_QueueAudio
   *  \sa SDL_ClearQueuedAudio
   *}
function SDL_GetQueuedAudioSize(dev: TSDL_AudioDeviceID): cuint32; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetQueuedAudioSize' {$ENDIF} {$ENDIF};

  {**
   *  Drop any queued audio data waiting to be sent to the hardware.
   *
   *  Immediately after this call, SDL_GetQueuedAudioSize() will return 0 and
   *  the hardware will start playing silence if more audio isn't queued.
   *
   *  This will not prevent playback of queued audio that's already been sent
   *  to the hardware, as we can not undo that, so expect there to be some
   *  fraction of a second of audio that might still be heard. This can be
   *  useful if you want to, say, drop any pending music during a level change
   *  in your game.
   *
   *  You may not queue audio on a device that is using an application-supplied
   *  callback; calling this function on such a device is always a no-op.
   *  You have to use the audio callback or queue audio with SDL_QueueAudio(),
   *  but not both.
   *
   *  You should not call SDL_LockAudio() on the device before clearing the
   *  queue; SDL handles locking internally for this function.
   *
   *  This function always succeeds and thus returns void.
   *
   *  \param dev The device ID of which to clear the audio queue.
   *
   *  \sa SDL_QueueAudio
   *  \sa SDL_GetQueuedAudioSize
   *}
procedure SDL_ClearQueuedAudio(dev: TSDL_AudioDeviceID); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_ClearQueuedAudio' {$ENDIF} {$ENDIF};

  {**
   *   Audio lock functions
   *
   *  The lock manipulated by these functions protects the callback function.
   *  During a SDL_LockAudio()/SDL_UnlockAudio() pair, you can be guaranteed that
   *  the callback function is not running.  Do not call these from the callback
   *  function or you will cause deadlock.
   *}

procedure SDL_LockAudio cdecl; external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_LockAudio' {$ENDIF} {$ENDIF};
procedure SDL_LockAudioDevice(dev: TSDL_AudioDeviceID) cdecl; external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_LockAudioDevice' {$ENDIF} {$ENDIF};
procedure SDL_UnlockAudio cdecl; external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_Unlock' {$ENDIF} {$ENDIF};
procedure SDL_UnlockAudioDevice(dev: TSDL_AudioDeviceID) cdecl; external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_UnlockAudioDevice' {$ENDIF} {$ENDIF};
  {*Audio lock functions*}

  {**
   *  This function shuts down audio processing and closes the audio device.
   *}
procedure SDL_CloseAudio cdecl; external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_CloseAudio' {$ENDIF} {$ENDIF};
procedure SDL_CloseAudioDevice(dev: TSDL_AudioDeviceID) cdecl; external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_CloseAudioDevice' {$ENDIF} {$ENDIF};

  {**
   *  1 if audio device is still functioning, zero if not, -1 on error.
   *}
function SDL_AudioDeviceConnected(dev: TSDL_AudioDeviceID): cint cdecl; external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_AudioDeviceConnected' {$ENDIF} {$ENDIF};

