# A Modern Makefile for C and C++

Set it and forget it -- throw it in a C/C++ project and type `make`

## Motivation

Building a C/C++ project should be as simple as typing a single command.

Unfortunately, C/C++ projects often use byzantine, brittle, and bespoke
Makefiles or instead use elaborate or exotic build systems¹.

Make is a venerable, versatile, and nearly universal build system, but it is
missing a universal C/C++ Makefile!

The solution is a simple, reusable, and cross-platform Makefile for C/C++. It
supports small, medium, and large C/C++ projects in less than 130 lines of Make.

## Features

* Supports building mixed C and C++ projects
* Rebuilds objects which depend on headers when headers are modified
* Supports `make all`, `make clean`, and `make objects` out-of-the-box
* Build flag defaults to enhance the security of executable (overridable)
* Automatically builds everything in the current directory (overridable)
* Automatically names the build as the parent directory (overridable)
* Automatically builds an executable or shared library with the right file
extension (overridable)
* Ability to debug Makefile variables
* Documentation for each Makefile section

## Compatibility

This Makefile should work on any machine that has at least GNU Make 3.8 (from
2002!)² and various flavors of OpenBSD and FreeBSD Make.

It has been explicitly tested on the following versions of Mac, Linux, and
Windows:

* MacOS 10.6 and later
* Linux
    * Ubuntu 12.04 and later
    * Alpine 3.2 and later
    * RHEL/CentOS 7 and later
    * Fedora 20 and later
* Windows 7 and later
    * Cygwin
    * Mingw32/64
    * MSYS2
    * WSL1/2

## Adding includes and external libraries

Includes should be added to the `MY_CFLAGS` variable of the Makefile. For
example, if your program requires certain headers from `/usr/local/include`:

```sh
CFLAGS  = -I/usr/local/include
```

Libraries should be added to the `MY_LIBS` variable of the Makefile. For
example, if your program uses `<math.h>`, you may need to link the `libm`
library:

```sh
MY_LIBS   = -lm
```

Similarly, if you have a library in a custom path, this path should be added to
the `MY_LIBS` variable **before** the library:

```sh
MY_LIBS   = -L/usr/local/lib -lz
```

## Notes

¹ I get sad every time I need to use CMake, Autotools, Bazel, Ninja, Premake,
Meson, Cake, qmake, Rake, or SCons 😭 (Tup and xmake are cool but rare)

² I am not sure when I originally wrote it, but I have been using it since at
least 2014.
