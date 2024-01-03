program sdl2forpascaltests;

{

  sdl2forpascaltests - Testing SDL2-for-Pascal units

  These tests are meant to check if the SDL2-for-Pascal units/bindings
  are working as expected and - especially - according to the
  original SDL2 functions. These tests are not meant to pose
  as test cases for original SDL2.

  This file is part of

    SDL2-for-Pascal
    Copyright (C) 2020-2023 PGD Community
    Visit: https://github.com/PascalGameDevelopment/SDL2-for-Pascal

  Compile this file by

    fpc -Fu"fptest/src;fptest/3rdparty/epiktimer;../units" sdl2forpascaltests.pas
}

{$mode objfpc}{$H+}

uses
  Classes,
  TextTestRunner,
  sdl2testcases;

begin
  sdl2testcases.RegisterTests;

  RunRegisteredTests;
end.

