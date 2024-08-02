# Tests for SDL2-for-Pascal Units

## Goal
These test cases are meant to ensure a basic quality of the
[SDL2-for-Pascal Units](https://github.com/PascalGameDevelopment/SDL2-for-Pascal).

## Testing Framework
We use the [fptest](https://github.com/graemeg/fptest) testing framework to
perform the testing. For more details on this framework see the _README.adoc_ file.

We modified it:
- many accompanied files (e. g. demo files) are not shipped (go to
[fptest](https://github.com/graemeg/fptest) to get the full package)
- it allows for checking of (classic) pointers now
- we applied a [fix](https://github.com/graemeg/epiktimer/pull/4) to the
[EpikTimer](https://wiki.freepascal.org/EpikTimer) unit

## Writing a test
Just add a test case to *sdl2testcases.pas* by extending the test classes or
add a new test class if suitable.



