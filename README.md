# ReShade Splash Removal

A one-click Windows builder that downloads the official ReShade source code, disables the startup splash screen and builds both 32-bit and 64-bit DLLs.

The normal in-game ReShade overlay remains functional, including the default **Home** key shortcut.

## Quick Start

**No coding knowledge required.**

### 1. Download the builder
- Click the green **Code** button on this GitHub page.
- Select **Download ZIP**.
- Extract the downloaded ZIP file.

### 2. Build ReShade
- Double-click `Build Latest ReShade.bat`.
- A command window will open and automatically download and build ReShade.
- Wait for the process to finish.
- A success message will appear when both builds are complete.

### 3. Find your DLLs

Open the `Builds` folder, then open the folder for the version you just built.

You'll find:

- `ReShade32.dll` — for 32-bit applications.
- `ReShade64.dll` — for 64-bit applications.

### 4. Install
- Download and install the official ReShade setup from [reshade.me](https://reshade.me/).
- Select your game and graphics API.
- Back up your existing ReShade files.
- Replace the appropriate ReShade DLL with the modified DLL you built.
- Keep your existing configuration files.

**Note:** Vulkan installations use a different method from DirectX and OpenGL. Follow the appropriate Vulkan installation instructions rather than blindly replacing DLLs.

### 5. Done!

Launch your game. The startup splash screen should be gone, while the normal ReShade overlay should still work using the **Home** key.

## Features

- Automatically detects the highest stable version tag.
- Downloads source code from the official ReShade repository.
- Downloads required Git submodules.
- Applies the splash-screen modification automatically.
- Builds 32-bit and 64-bit Release DLLs.
- Saves builds in version-specific folders.
- Preserves previous builds.

## Requirements

- Windows 10 or 11.
- Git for Windows.
- Visual Studio with the **Desktop development with C++** workload.
- Internet connection.
- Sufficient free disk space for downloading and compiling ReShade.

The script locates Visual Studio automatically using `vswhere.exe`.

## What Does the Patch Change?

The patch modifies `source/runtime_gui.cpp` by inserting:

```cpp
_show_splash = false;
```

Immediately before `_rebuild_font_atlas = false;` in the font atlas rebuilding function.

This disables the startup splash screen without intentionally disabling the normal ReShade overlay.

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

To build a newer version, simply run `Build Latest ReShade.bat` again.

The script checks the official repository for the highest stable version tag and builds it automatically. Previous builds are preserved, while the temporary `Update-Work` directory is recreated.

## Troubleshooting

If a build fails, check `Last-Build-Log.txt` in the project folder.

If ReShade's source code changes and the expected patch location can no longer be found, the script stops rather than applying an uncertain modification.

## Disclaimer

This is an unofficial ReShade modification and build automation project. It is not affiliated with or endorsed by the ReShade developers.

Original ReShade source code, trademarks and licensing remain with their respective owners. This repository contains build automation and patch instructions, not redistributed official ReShade binaries.

## Credits

- [ReShade](https://github.com/crosire/reshade) — Original project.
- [crosire](https://github.com/crosire) — ReShade developer.
