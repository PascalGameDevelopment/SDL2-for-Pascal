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
