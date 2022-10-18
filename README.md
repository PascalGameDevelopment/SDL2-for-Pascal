# SDL2-for-Pascal

Unit files for building
[Free Pascal](https://freepascal.org/) / [Delphi](https://www.embarcadero.com/products/delphi) applications
using the [SDL2 library](https://libsdl.org).

This repository is a community-maintained fork of the [Pascal-SDL-2-Headers](https://github.com/ev1313/Pascal-SDL-2-Headers) repo.

## Installation

Simply add the units to your include path. You can achieve this by:
 - (FPC) using the `{$UNITPATH XXX}` directive in your source code;
 - (FPC) using the `-FuXXX` command-line argument to the compiler;
 - just copying & pasting the units into the same directory as your main source code.

Use the `sdl2` unit for the main SDL2 library (should be always needed). Units for the other SDL2 libraries are also provided:
 - [`sdl2_gfx`](https://www.ferzkopp.net/wordpress/2016/01/02/sdl_gfx-sdl2_gfx/)
 - [`sdl2_image`](https://www.libsdl.org/projects/SDL_image/)
 - [`sdl2_mixer`](https://www.libsdl.org/projects/SDL_mixer/)
 - [`sdl2_net`](https://www.libsdl.org/projects/SDL_net/)
 - [`sdl2_ttf`](https://www.libsdl.org/projects/SDL_ttf/)

## Bugs / Contributions / ToDos

If you have any contributions or bugfixes, feel free to drop a pull request or send in a patch.

Please use the GitHub issue tracker for bug reports.

### ToDos

- (Continously) Update files by new SDL2 functions and types which are present in more recent SDL2 versions.
- (Continously atm.) Translate integer aliases into typed enums.
See part Enums on the [Cheat sheet](CHEATSHEET.md) for reference.
- (Continously) improve Delphi-compatibility (and even more important, DO NOT break it)
- (Continously) Adapt comments to [PasDoc format](https://pasdoc.github.io). (See issue [#22](https://github.com/PascalGameDevelopment/SDL2-for-Pascal/issues/22))

## Code style guidelines

The main principle is to stay as tight as possible at the names in the C headers.
These guidelines aim to have better consistency in this community project and make
it easier to find certain code parts in the C headers/Pascal includes. Feel free
to discuss or extend these guidelines, use the issue tracker.

1. Names of C defines (constants) and function parameters shall not be modified or "pascalified"
Ex: `SDL_INIT_VIDEO` does not change into `SDLInitVideo`.

2. Names corresponding to reserved key words are kept and an underscore is added.
Ex.: `type` in C function `SDL_HasEvent(Uint32 type)` changes into `type_`
in Pascal function `SDL_HasEvent(type_: TSDL_EventType)`.

3. Use C data types like `cuint8`, `cuint16`, `cuint32`, `cint8`, `cint16`,
`cint32`, `cfloat` and so on if native C data types are used  in the
original code. Note: For FPC you need to add the unit `ctypes` to use these C
data types. For Delphi we have a temporary solution provided. (see issue [#67](https://github.com/PascalGameDevelopment/SDL2-for-Pascal/issues/67))

**Example:** Use `cuint32` (if `Uint32` is used in
the original code) instead of `UInt32`, `Cardinal`, `LongWord` or `DWord`.
Exception: Replace `*char` by `PAnsiChar`! (see issue [#26](https://github.com/PascalGameDevelopment/SDL2-for-Pascal/issues/26))

**Hint:** Use `TSDL_Bool` to translate `SDL_bool`. For [macro functions](CHEATSHEET.md) use `Boolean`. (see issue [#30](https://github.com/PascalGameDevelopment/SDL2-for-Pascal/issues/30)).

4. If an identifier or a function declaration is gone, mark them as `deprecated`. (see issue [#34](https://github.com/PascalGameDevelopment/SDL2-for-Pascal/issues/34))

5. Have a look at our [Translation Cheat Sheet](CHEATSHEET.md) for reference.

## Versions

The version tag (see [tags](https://github.com/PascalGameDevelopment/SDL2-for-Pascal/tags)) refers to the version of this translation package [SDL2 for Pascal](https://github.com/PascalGameDevelopment/SDL2-for-Pascal), not the `SDL2 library`.

### v2.x (work in progress)

- be up-to-date with _at least_ version 2.0.14 of the `SDL2 library`
- replaced all aliases by typed enums
- (done) update SDL_ttf.pas to latest version 2.21.0
- (done) replace data types by c data types (see PR [#29](https://github.com/PascalGameDevelopment/SDL2-for-Pascal/pull/29)) 
- (done) add folders to project
- (done) shift all units into unit folder (see PR [#27](https://github.com/PascalGameDevelopment/SDL2-for-Pascal/pull/27))

### v2.1 (Compatibility Release)

- This release has all commits until the change of the project folder structure (see PR [#27](https://github.com/PascalGameDevelopment/SDL2-for-Pascal/pull/27)). Compare the disucssion in issue #22.
- Moving the units to a new location may (1) raise difficulties in committing new changes if the branch was started before and (2) make updates of project research pathes necessary.
- updates of SDL2_Mixer, SDL2_Image, SDL2_TTF and some include files
- introduce float point types
- bugfixes

### v2.0

- first official release of the PGD community fork of the [Pascal-SDL-2-Headers](https://github.com/ev1313/Pascal-SDL-2-Headers)
  - its latest version git tag is 1.72, in the sdl2.pas it goes even up to version 1.80; hence starting with v2.0 for this fork is a senseful distinction
- this ia a highly Delphi-compatible and stable fallback package
- loosely is up-to-date with version 2.0.4 of the `SDL2 library`

## License

You may license the Pascal SDL2 units either
with the [MPL license](blob/master/MPL-LICENSE) or
with the [zlib license](blob/master/zlib-LICENSE).
