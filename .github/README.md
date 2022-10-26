<img src="https://img.icons8.com/fluency/144/000000/automatic.png" align="right">

# Windows Sandbox Configuration

This is my configuration for Windows Sandbox.

For configuration options in the `.wsb` file please read <https://docs.microsoft.com/en-us/windows/security/threat-protection/windows-sandbox/windows-sandbox-configure-using-wsb-file>.

## Software installed

- [scoop](https://github.com/ScoopInstaller/Scoop) with:
  - [dotPeek](https://www.jetbrains.com/decompiler/)
  - [HxD](https://mh-nexus.de/en/hxd/)
  - Mozilla Firefox
  - PowerShell
  - Sysinternals Suite
  - [VisualCppRedist AIO](https://github.com/abbodi1406/vcredist)
  - Visual Studio Code

## Additional configuration

- Change desktop background
- Use small desktop icons
- Adjust visual effects for performance
- Show file name extensions

### Windows 10 only

- Use light system theme
- Display Windows version on desktop
- Disable News and Interests

## Usage

- [Create](https://leestevetk.github.io/WSBEditor/WSBEditor-Latest.html) your WSB configuration file
- Make sure the WSB configuration matches your own folder structure
- Edit scoop packages that will be installed
- Double click the `.wsb` file to launch the sandbox

## Getting Started

```ps1
cd ~\.config
git clone https://github.com/Strappazzon/wsb ; cd wsb
WindowsSandbox .\config.wsb
```
