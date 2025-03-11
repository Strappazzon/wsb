# Suppress iwr progress
$ProgressPreference = 'SilentlyContinue'

#region Functions

Function Set-RegistryValue([String]$Path, [String]$Name, $Value, [String]$Type) {
  <#
  .SYNOPSIS
  Edit or create a registry value
  .PARAMETER Path
  Path to the registry key
  .PARAMETER Name
  Name of the registry entry
  .PARAMETER Value
  Value of the registry entry
  .PARAMETER Type
  Type of the registry entry
  .EXAMPLE
  Set-RegistryValue -Path "HKLM:\SOFTWARE\Strappazzon\wsb" -Name "Example" -Value 1 -Type DWord
  Set-RegistryValue -Path "HKLM:\SOFTWARE\Strappazzon\wsb" -Name "Example" -Value "Yes" -Type String
  #>

  If (!(Test-Path $Path)) {
    New-Item -Path $Path -Force | Out-Null
  }
  If (Get-ItemProperty -Path $Path -Name $Name -ErrorAction SilentlyContinue) {
    Set-ItemProperty -Path $Path -Name $Name -Value $Value -Type $Type
  } Else {
    New-ItemProperty -Path $Path -Name $Name -Value $Value -Type $Type -Force | Out-Null
  }
}

# https://stackoverflow.com/a/9701907/16036749
Function New-Shortcut([String]$Target, [String]$Destination) {
  <#
  .SYNOPSIS
  Create a shortcut
  .PARAMETER Target
  Path to file
  .PARAMETER Destination
  Path to shortcut including the .lnk extension
  .EXAMPLE
  New-Shortcut -Target "C:\bin\Program.exe" -Destination "C:\Users\WDAGUtilityAccount\Desktop\Program.lnk"
  #>

  $WScriptShell = New-Object -ComObject WScript.Shell
  $Shortcut = $WScriptShell.CreateShortcut($Destination)
  $Shortcut.TargetPath = $Target
  $Shortcut.Save()
}

Function Update-Wallpaper([String]$Image) {
  <#
  .SYNOPSIS
  Applies a specified wallpaper to the current user Desktop
  .PARAMETER Image
  Path to the image
  .EXAMPLE
  Set-WallPaper -Image "C:\bootstrap\theme\wallpaper.jpg"
  .LINK
  https://www.joseespitia.com/2017/09/15/set-wallpaper-powershell-function/
  #>

  Add-Type -TypeDefinition @'
  using System;
  using System.Runtime.InteropServices;
  public class Params {
    [DllImport("User32.dll",CharSet=CharSet.Unicode)]
    public static extern int SystemParametersInfo (Int32 uAction, Int32 uParam, String lpvParam, Int32 fuWinIni);
  }
'@

  $SPI_SETDESKWALLPAPER = 0x0014
  $UpdateIniFile = 0x01
  $SendChangeEvent = 0x02

  $fWinIni = $UpdateIniFile -bor $SendChangeEvent

  $ret = [Params]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $Image, $fWinIni)
}

Function Restart-Explorer {
  <#
  .SYNOPSIS
  Restart Windows Explorer
  #>

  Stop-Process -Name 'Explorer' -Force
  # Give Windows Explorer time to start
  Start-Sleep -Seconds 3

  # Verify that Windows Explorer has restarted
  Try {
    $p = Get-Process -Name 'Explorer' -ErrorAction Stop
  } Catch {
    Try {
      Invoke-Item 'explorer.exe'
      # Start-Process 'explorer.exe'
    } Catch {
      # This should never be called
      Throw $_
    }
  }
}

# https://stackoverflow.com/a/74251719
Function Test-WinVersion([String]$MatchString) {
  # (Get-ComputerInfo | Select-Object -ExpandProperty 'OsName') -like "*${MatchString}*"
  (Get-ComputerInfo | Select-Object -ExpandProperty 'OsName') -match $MatchString | Out-Null
}

#endregion Functions

#region Tweaks

Write-Host 'Applying tweaks...' -ForegroundColor Blue

# Performance
# Set-RegistryValue -Path 'HKCU:\Control Panel\Desktop'                                            -Name 'DragFullWindows'       -Value 0                                      -Type String
Set-RegistryValue -Path 'HKCU:\Control Panel\Desktop'                                            -Name 'MenuShowDelay'         -Value 200                                    -Type String
Set-RegistryValue -Path 'HKCU:\Control Panel\Desktop'                                            -Name 'UserPreferencesMask'   -Value ([byte[]](90, 12, 3, 80, 10, 0, 0, 0)) -Type Binary
Set-RegistryValue -Path 'HKCU:\Control Panel\Desktop\WindowMetrics'                              -Name 'MinAnimate'            -Value 0                                      -Type String
Set-RegistryValue -Path 'HKCU:\Control Panel\Keyboard'                                           -Name 'KeyboardDelay'         -Value 0                                      -Type DWord
Set-RegistryValue -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced'      -Name 'DisablePreviewDesktop' -Value 1                                      -Type DWord
Set-RegistryValue -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced'      -Name 'ListviewAlphaSelect'   -Value 0                                      -Type DWord
Set-RegistryValue -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced'      -Name 'ListviewShadow'        -Value 0                                      -Type DWord
Set-RegistryValue -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced'      -Name 'TaskbarAnimations'     -Value 0                                      -Type DWord
Set-RegistryValue -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects' -Name 'VisualFXSetting'       -Value 3                                      -Type DWord
Set-RegistryValue -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize'     -Name 'EnableTransparency'    -Value 0                                      -Type DWord
Set-RegistryValue -Path 'HKCU:\SOFTWARE\Microsoft\Windows\DWM'                                   -Name 'EnableAeroPeek'        -Value 0                                      -Type DWord

# Start menu
# Disable tips
Set-RegistryValue -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'Start_IrisRecommendations' -Value 0 -Type DWord

# Taskbar
# Show "End Task" when right clicking
If (Test-WinVersion -MatchString 'Windows 11') {
  Set-RegistryValue -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings' -Name 'TaskbarEndTask' -Value 1 -Type DWord
}

# Windows Explorer
Set-RegistryValue -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'HideFileExt'           -Value 0 -Type DWord
Set-RegistryValue -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'LaunchTo'              -Value 1 -Type DWord
Set-RegistryValue -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'NavPaneShowAllFolders' -Value 1 -Type DWord
# Don't hide system files
Set-RegistryValue -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowSuperHidden'       -Value 1 -Type DWord

# Disable SmartScreen
# https://superuser.com/a/1778345
Set-RegistryValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System'               -Name 'EnableSmartScreen' -Value 0 -Type DWord
Set-RegistryValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\PhishingFilter' -Name 'EnabledV9'         -Value 0 -Type DWord

#endregion Tweaks

#region Personalization

Write-Host 'Personalizing sandbox...' -ForegroundColor Blue

# Desktop
# Small icons
Set-RegistryValue -Path 'HKCU:\SOFTWARE\Microsoft\Windows\Shell\Bags\1\Desktop' -Name 'IconSize'        -Value 32 -Type DWord
Set-RegistryValue -Path 'HKCU:\SOFTWARE\Microsoft\Windows\Shell\Bags\1\Desktop' -Name 'LogicalViewMode' -Value 3  -Type DWord
Set-RegistryValue -Path 'HKCU:\SOFTWARE\Microsoft\Windows\Shell\Bags\1\Desktop' -Name 'Mode'            -Value 1  -Type DWord
# Wallpaper
$wallpaper = 'C:\bootstrap\theme\wallpaper.jpg'
If (Test-Path -Path "${wallpaper}" -PathType Leaf) {
  Update-Wallpaper -Image $wallpaper
  # Set-RegistryValue -Path 'HKCU:\Control Panel\Desktop\' -Name 'Wallpaper' -Value "${wallpaper}" -Type String
  # Invoke-Command { C:\windows\System32\RUNDLL32.EXE user32.dll, UpdatePerUserSystemParameters 1, True }
}

# Start menu
# "More recommendations" setting
If (Test-WinVersion -MatchString 'Windows 11') {
  Set-RegistryValue -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'Start_Layout' -Value 2 -Type DWord
}

# Taskbar
# Hide search box
Set-RegistryValue -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search'              -Name 'SearchboxTaskbarMode' -Value 0 -Type DWord
# Small icons
If (Test-WinVersion -MatchString 'Windows 10') {
  Set-RegistryValue -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'TaskbarSmallIcons'    -Value 1 -Type DWord
}
# Hide Task View button
Set-RegistryValue -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced'   -Name 'ShowTaskViewButton'   -Value 0 -Type DWord
# Don't combine taskbar buttons
Set-RegistryValue -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced'   -Name 'TaskbarGlomLevel'     -Value 1 -Type DWord
# Disable "Show Desktop"
Set-RegistryValue -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced'   -Name 'TaskbarSd'            -Value 0 -Type DWord

# Windows Explorer
Set-RegistryValue -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'UseCompactMode' -Value 1 -Type DWord

# Windows theme
Set-RegistryValue -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'AppsUseLightTheme'    -Value 0 -Type DWord
Set-RegistryValue -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'SystemUsesLightTheme' -Value 0 -Type DWord

# Restart Windows Explorer to apply the registry changes
Restart-Explorer

#endregion Personalization

#region winget

# https://learn.microsoft.com/en-us/windows/package-manager/winget/#install-winget-on-windows-sandbox
Write-Host 'Installing Windows Package Manager...' -ForegroundColor Blue
Install-PackageProvider -Name NuGet -Force | Out-Null
Install-Module -Name Microsoft.WinGet.Client -Force -Repository PSGallery | Out-Null
Repair-WinGetPackageManager

# Install packages (msstore)
@(
  '9NZL0LRP1BNL', # NanaZip Preview
  '9N0DX20HK701'  # Windows Terminal
) | ForEach-Object {
  Write-Host "Installing ${_}..." -ForegroundColor Blue;
  & { winget install "${_}" --source msstore --accept-source-agreements --accept-package-agreements } | Out-Null
}

# Install packages
@(
  'Microsoft.PowerShell',
  'MHNexus.HxD',
  'Microsoft.VCRedist.2015+.x64',
  'Microsoft.VCRedist.2015+.x86',
  'Mozilla.Firefox'
) | ForEach-Object {
  Write-Host "Installing ${_}..." -ForegroundColor Blue;
  & { winget install --id="${_}" --exact --silent --scope machine --accept-source-agreements --accept-package-agreements } | Out-Null
}

# Install packages with custom parameters
Write-Host 'Installing Microsoft.VisualStudioCode...' -ForegroundColor Blue
& { winget install --id='Microsoft.VisualStudioCode' --exact --scope machine --override '/SILENT /MERGETASKS=!runcode,desktopicon,quicklaunchicon,associatewithfiles,addtopath,addcontextmenufiles,addcontextmenufolders' --accept-package-agreements } | Out-Null

#endregion winget

#region scoop

Write-Host 'Installing scoop package manager...' -ForegroundColor Blue

Invoke-RestMethod 'https://get.scoop.sh' | Invoke-Expression | Out-Null
# Invoke-Expression "& {$(Invoke-RestMethod get.scoop.sh)} -RunAsAdmin" | Out-Null

# Configure scoop
Write-Host '- Configuring scoop...' -ForegroundColor Blue
scoop config aria2-enabled $true
scoop config aria2-warning-enabled $false

# Minimal scoop install
@(
  '7zip',
  'aria2',
  'git'
) | ForEach-Object {
  # Write-Host "Installing ${_} ..." -ForegroundColor Blue;
  scoop install $_
}

# Add additional sources
@(
  'extras'
) | ForEach-Object {
  scoop bucket add $_
}

# Install additional packages
@(
  'dotpeek',
  'sysinternals'
) | ForEach-Object {
  # Write-Host "Installing ${_} ..." -ForegroundColor Blue;
  scoop install $_
}

#endregion scoop

#region Settings

Write-Host 'Configuring Visual Studio Code...' -ForegroundColor Blue
New-Item "${env:APPDATA}\code\User" -ItemType Directory -Force | Out-Null
# TODO: Copy settings file instead?
$codeSettings = @'
{
  "security.workspace.trust.enabled": false,
  "update.mode": "none",
  "update.enableWindowsBackgroundUpdates": false,
  "workbench.startupEditor": "none",
}
'@
Set-Content -Path "${env:APPDATA}\code\User\settings.json" -Value "${codeSettings}" -Encoding utf8

#endregion Settings

#region Shortcuts

Write-Host 'Creating shortcuts...' -ForegroundColor Blue

New-Shortcut -Target "${env:APPDATA}\Microsoft\Windows\Start Menu\Programs\Scoop Apps\SysInternals" -Destination "${env:USERPROFILE}\Desktop\SysInternals.lnk"
New-Shortcut -Target "${env:PROGRAMFILES}\PowerShell\7\pwsh.exe" -Destination "${env:USERPROFILE}\Desktop\PowerShell.lnk"
New-Shortcut -Target "${env:USERPROFILE}\scoop\apps\dotpeek\current\dotpeek.exe" -Destination "${env:USERPROFILE}\Desktop\dotPeek.lnk"
New-Shortcut -Target "${env:PROGRAMFILES}\HxD\HxD.exe" -Destination "${env:USERPROFILE}\Desktop\HxD.lnk"

#endregion Shortcuts

Write-Host 'Sandbox set-up complete. Press any key to exit.' -ForegroundColor Green
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
