{**
 *  \file SDL_guid.h
 *
 *  Include file for handling ::SDL_GUID values.
 *}

{**
 * An SDL_GUID is a 128-bit identifier for an input device that
 *   identifies that device across runs of SDL programs on the same
 *   platform.  If the device is detached and then re-attached to a
 *   different port, or if the base system is rebooted, the device
 *   should still report the same GUID.
 *
 * GUIDs are as precise as possible but are not guaranteed to
 *   distinguish physically distinct but equivalent devices.  For
 *   example, two game controllers from the same vendor with the same
 *   product ID and revision may have the same GUID.
 *
 * GUIDs may be platform-dependent (i.e., the same device may report
 *   different GUIDs on different operating systems).
 *}
type
  TSDL_GUID = record
    data: array[0..15] of cuint8;
  end;
