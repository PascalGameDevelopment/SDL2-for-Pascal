// from SDL_hidapi.h

(**
 *  Header file for SDL HIDAPI functions.
 *
 *  This is an adaptation of the original HIDAPI interface by Alan Ott,
 *  and includes source code licensed under the following BSD license:
 *
    Copyright (c) 2010, Alan Ott, Signal 11 Software
    All rights reserved.

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice,
      this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of Signal 11 Software nor the names of its
      contributors may be used to endorse or promote products derived from
      this software without specific prior written permission.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
    AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
    IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
    ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
    LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
    CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
    SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
    INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
    CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
    ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
    POSSIBILITY OF SUCH DAMAGE.
 *
 * If you would like a version of SDL without this code, you can build SDL
 * with SDL_HIDAPI_DISABLED defined to 1. You might want to do this for example
 * on iOS or tvOS to avoid a dependency on the CoreBluetooth framework.
 *)

type
	// TODO: Move this to ctypes.inc
	pcwchar_t = ^cwchar_t;
	cwchar_t = uint32;

	(**
 	 *  \brief  A handle representing an open HID device.
 	 *)
	PSDL_hid_device = ^TSDL_hid_device;
	TSDL_hid_device = record end; // opaque struct

	PSDL_hid_device_info = ^TSDL_hid_device_info;

	(**
 	 *  \brief  Information about a connected HID device
 	 *)
	TSDL_hid_device_info = record
		(** Platform-specific device path *)
		path: PAnsiChar;
		(** Device Vendor ID *)
		vendor_id: pcushort;
		(** Device Product ID *)
		product_id: pcushort;
		(** Serial Number *)
		serial_number: pcwchar_t;
		(** Device Release Number in binary-coded decimal, also known as Device Version Number *)
		release_number: cushort;
		(** Manufacturer String *)
		manufacturer_string: pcwchar_t;
		(** Product string *)
		product_string: pcwchar_t;
		(** Usage Page for this Device/Interface (Windows/Mac only). *)
		usage_page: cushort;
		(** Usage for this Device/Interface (Windows/Mac only). *)
		usage: cushort;
		(**
 		 * The USB interface which this logical device represents.
 		 * Valid on both Linux implementations in all cases.
 		 * Valid on the Windows implementation only if the device
 		 * contains more than one interface.
 		 *)
		interface_number: cint;

		(**
 		 * Additional information about the USB interface.
 		 * Valid on libusb and Android implementations.
 		 *)
		interface_class: cint;
		interface_subclass: cint;
		interface_protocol: cint;

		(** Pointer to the next device *)
		next: PSDL_hid_device_info;
	end;

(**
 * Initialize the HIDAPI library.
 *
 * This function initializes the HIDAPI library. Calling it is not strictly
 * necessary, as it will be called automatically by SDL_hid_enumerate() and
 * any of the SDL_hid_open_*() functions if it is needed. This function should
 * be called at the beginning of execution however, if there is a chance of
 * HIDAPI handles being opened by different threads simultaneously.
 *
 * Each call to this function should have a matching call to SDL_hid_exit()
 *
 * \returns 0 on success and -1 on error.
 *
 * \since This function is available since SDL 2.0.18.
 *
 * \sa SDL_hid_exit
 *)
function SDL_hid_init(): cint; cdecl;
	external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_hid_init' {$ENDIF} {$ENDIF};

(**
 * Finalize the HIDAPI library.
 *
 * This function frees all of the static data associated with HIDAPI. It
 * should be called at the end of execution to avoid memory leaks.
 *
 * \returns 0 on success and -1 on error.
 *
 * \since This function is available since SDL 2.0.18.
 *
 * \sa SDL_hid_init
 *)
function SDL_hid_exit(): cint; cdecl;
	external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_hid_exit' {$ENDIF} {$ENDIF};

(**
 * Check to see if devices may have been added or removed.
 *
 * Enumerating the HID devices is an expensive operation, so you can call this
 * to see if there have been any system device changes since the last call to
 * this function. A change in the counter returned doesn't necessarily mean
 * that anything has changed, but you can call SDL_hid_enumerate() to get an
 * updated device list.
 *
 * Calling this function for the first time may cause a thread or other system
 * resource to be allocated to track device change notifications.
 *
 * \returns a change counter that is incremented with each potential device
 *          change, or 0 if device change detection isn't available.
 *
 * \since This function is available since SDL 2.0.18.
 *
 * \sa SDL_hid_enumerate
 *)
function SDL_hid_device_change_count(): cUint32; cdecl;
	external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_hid_device_change_count' {$ENDIF} {$ENDIF};
