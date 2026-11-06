# ReShade Splash Removal

A one-click Windows builder that downloads the official ReShade source code, applies a small modification to disable the startup splash screen, and builds both 32-bit and 64-bit ReShade DLLs.

The normal ReShade in-game overlay remains fully functional, including the default **Home** key shortcut.

## Features

- Automatically detects the newest stable ReShade version tag.
- Downloads source code directly from the official ReShade repository.
- Automatically downloads required Git submodules.
- Applies the splash-screen removal modification.
- Builds both 32-bit and 64-bit Release DLLs.
- Saves builds in version-specific folders.
- No manual source-code editing required.

## What does the patch change?

The patch modifies:

`source/runtime_gui.cpp`

It inserts:

```cpp
_show_splash = false;
```

immediately before `_rebuild_font_atlas = false;` in the font atlas rebuilding function.

This disables the startup splash screen without intentionally disabling the normal ReShade overlay.

## Requirements

- Windows 10 or Windows 11.
- Git for Windows.
- Python available in PATH.
- Visual Studio with the **Desktop development with C++** workload.
- An internet connection.
- Sufficient free disk space for downloading and compiling ReShade.

The build script locates Visual Studio using `vswhere.exe` and uses its command-line build tools.


Quick Start (Beginner Guide)

No coding or programming knowledge required.

This project builds modified ReShade files for you. Follow these steps:

Step 1 — Download the builder

Download this repository using the green Code button → Download ZIP.

Extract the ZIP file somewhere convenient, such as your Desktop.

You should see two files:

Build-Latest-ReShade.ps1

Build Latest ReShade.bat

Step 2 — Build ReShade

Double-click Build Latest ReShade.bat.

A command window will open and automatically download and build ReShade.

Wait for the process to finish. This can take several minutes.

If everything succeeds, you'll see a success message.

Step 3 — Find your finished files

Open the Builds folder.

Inside, open the folder for the version that was just built (for example, v6.8.0).

You'll find:

ReShade32.dll — for 32-bit applications.

ReShade64.dll — for 64-bit applications.

Step 4 — Install ReShade

Download and install the official ReShade setup from reshade.me.

Select your game and its graphics API during installation.

Open the game's installation folder.

Back up your existing ReShade files before replacing anything.

Replace the appropriate ReShade DLL with the modified DLL you built:

Use ReShade32.dll for 32-bit games.

Use ReShade64.dll for 64-bit games.

Keep your existing ReShade configuration files, including any .ini or .json files.

Important: Vulkan installations use a different installation method from DirectX and OpenGL. Don't blindly replace DLLs for Vulkan; follow the Vulkan installation instructions for your setup.

Step 5 — Done!

Launch your game.

The ReShade startup splash screen should no longer appear, but the normal in-game ReShade overlay should still work using the Home key.

Updating later

Whenever you want to build a newer version of ReShade, simply run Build Latest ReShade.bat again. The script checks for the newest stable version tag and builds it automatically.



## How to use

1. Download or clone this repository.
2. Extract the files into a folder.
3. Double-click `Build Latest ReShade.bat`.
4. The updater checks the official ReShade repository for the newest stable version.
5. It downloads the source code and submodules.
6. It applies the splash-screen modification.
7. It compiles both 32-bit and 64-bit Release builds.
8. The finished DLLs are copied into the `Builds` directory.

No manual editing of ReShade source files is necessary.

## Output

Compiled DLLs are saved in version-specific folders:

```text
Builds/
└── vX.X.X/
    ├── ReShade32.dll
    └── ReShade64.dll
```

Use the DLL matching your application's architecture.

## Updating

To build a newer version, simply run:

`Build Latest ReShade.bat`

The updater checks for the newest stable version tag and builds it automatically.

Previous compiled builds are preserved in the `Builds` directory.

The temporary `Update-Work` directory is recreated during each run.

## Installation

Installation depends on the graphics API used by the application.

For Vulkan installations, ReShade uses its registered Vulkan layer. The appropriate custom-built DLL can replace the installed DLL while preserving the existing JSON configuration files.

For other graphics APIs, use the appropriate ReShade installation method.

Always back up existing ReShade files before replacing them.

## Troubleshooting

If the updater encounters an error, it displays an error message and saves a build log:

`Last-Build-Log.txt`

Check this file when troubleshooting failed builds.

If the ReShade source code changes and the expected patch location can no longer be found, the updater stops rather than applying an uncertain modification.

## Disclaimer

This is an unofficial ReShade modification and build automation project.

It is not affiliated with, endorsed by, or supported by the ReShade developers.

All original ReShade source code, trademarks and licensing remain with their respective owners.

This repository contains the build automation and modification instructions, not redistributed official ReShade binaries.

## Credits

- [ReShade](https://github.com/crosire/reshade) — Original project.
- [crosire](https://github.com/crosire) — ReShade developer.
