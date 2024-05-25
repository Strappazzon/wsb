<!-- markdownlint-disable MD033 MD041 -->
<div align="center">
  <img width="96" src="./assets/logo.png" alt="Logo">
</div>

<div align="center">
  <strong>wsb</strong>
</div>

<p align="center">
  <em>Logon script for Windows Sandbox</em>
</p>
<!-- markdownlint-enable MD033 MD041 -->

This is my personal logon script for Windows Sandbox.

Tested on Windows 11. Some things may not work on a Windows 10 sandbox.

## Getting Started

Clone the repo and create your own configuration file.

```bat
git clone https://github.com/Strappazzon/wsb.git
cd wsb/
cp config.example.wsb config.wsb
```

For all configuration options, see: [Windows Sandbox configuration](https://learn.microsoft.com/en-us/windows/security/application-security/application-isolation/windows-sandbox/windows-sandbox-configure-using-wsb-file).
You can also create your configuration file with [WSBEditor](https://leestevetk.github.io/WSBEditor/WSBEditor-Latest.html).

## What the script does

This script will run at logon and will change / install the following:

### Settings

- Desktop
  - Set small icon size
  - Change wallpaper (if provided)
- Disable Windows SmartScreen
  - When running unsigned executables Windows tries to install SmartScreen.
    This tweak will allow execution.
- Start menu
  - Disable tips
  - Use "More recommendations" layout
- Performance tweaks
  - Disable animations
  - Disable Peek
  - Disable shadows
  - Disable transparency
- Set Dark theme
- Taskbar
  - Don't combine buttons
  - Hide search box
  - Hide "Task View" button
  - Show "End Task" when right clicking (*Windows 11 only*)
  - Use small icons (*Windows 10 only*)
- Windows Explorer
  - Enable compact mode
  - Launch Windows Explorer to "This PC"
  - Show all folders in the side panel
  - Show file extensions
  - Show protected system files

### Software

- 7zip
- dotPeek
- Git
- [HxD](https://mh-nexus.de/en/hxd/)
- Mozilla Firefox
- NanaZip Preview
- PowerShell
- [SysInternals Suite](https://learn.microsoft.com/en-us/sysinternals/)
- Visual Studio Code
  - Empty startup editor
  - Updates disabled
  - Workspace Trust disabled
- Windows Terminal

All software is installed using [scoop](https://github.com/ScoopInstaller/Scoop) and [winget](https://learn.microsoft.com/en-us/windows/package-manager/).
