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
