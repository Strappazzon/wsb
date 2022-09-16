# Windows Sandbox Configuration

This is my configuration for Windows Sandbox.

For configuration options in the `.wsb` file please read <https://docs.microsoft.com/en-us/windows/security/threat-protection/windows-sandbox/windows-sandbox-configure-using-wsb-file>.

## Software installed

- [Ninite](https://ninite.com/)
- Visual Studio Code
- Sysinternals Suite
- dnSpy
- [VisualCppRedist AIO](https://github.com/abbodi1406/vcredist)

## Additional configuration

- Change desktop background
- Use small desktop icons
- Use light system theme
- Adjust visual effects for performance
- Display Windows version on desktop
- Disable News and Interests
- Show file name extensions

## Usage

- Create your WSB configuration file from scratch or start from mine
- Create your [Ninite](https://ninite.com/), place it inside `\bin\ninite.exe`
- Run `updater.ps1` to download the latest versions of the software that will be installed
- Edit WSB configuration file to match your folder structure
- Double click the `.wsb` file to launch the sandbox
