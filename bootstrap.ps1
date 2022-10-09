#
# Global Functions
#

Function Show-MessageBox([String]$Message, [String]$Title, [Int]$Buttons, [Int]$Type) {
	<#
	.SYNOPSIS
	Display a MessageBox
	.PARAMETER Message
	The content of the MessageBox
	.PARAMETER Title
	Title of the MessageBox
	.PARAMETER Buttons
	0 Ok
	1 OkCancel
	2 AbortRetryIgnore
	3 The message box contains Yes, No, and Cancel buttons.
	4 YesNo
	5 RetryCancel
	6 CancelTryContinue
	.LINK
	https://learn.microsoft.com/en-us/dotnet/api/system.windows.forms.messageboxbuttons
	.PARAMETER Type
	0 None
	16 Error
	16 Hand
	16 Stop
	32 Question
	48 Exclamation
	48 Warning
	64 Asterisk
	64 Information
	.LINK
	https://learn.microsoft.com/en-us/dotnet/api/system.windows.forms.messageboxicon
	.EXAMPLE
	Show-MessageBox -Message "This is a test message" -Title "Test" -Buttons 0 -Type 32
	#>

	Add-Type -AssemblyName PresentationFramework
	[System.Windows.MessageBox]::Show($Message, $Title, $Buttons, $Type)
}

Function Disable-Volume {
	<#
	.SYNOPSIS
	Mute sounds volume
	.LINK
	https://stackoverflow.com/a/12397737
	#>

	$obj = New-Object -ComObject WScript.Shell
	$obj.SendKeys([Char]173)
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
	Set-WallPaper -Image "C:\Wallpaper\Default.jpg"
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

	Get-Process -Name Explorer | Stop-Process -Force
	# Give Windows Explorer time to start
	Start-Sleep -Seconds 3

	# Verify that Windows Explorer has restarted
	Try {
		$p = Get-Process -Name Explorer -ErrorAction Stop
	} Catch {
		Try {
			Start-Process explorer.exe
		} Catch {
			# This should never be called
			Throw $_
		}
	}
}

#
# Personalization
#

# Disable News and Interests
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds' -Name 'ShellFeedsTaskbarViewMode' -Type DWord -Value 2 -Force
# Hide search in taskbar
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'SearchboxTaskbarMode' -Type DWord -Value 0
# Small taskbar icons
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'TaskbarSmallIcons' -Type DWord -Value 1
# Hide Task View button in taskbar
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowTaskViewButton' -Type DWord -Value 0
# Light theme
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'AppsUseLightTheme' -Type DWord -Value 1
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'SystemUsesLightTheme' -Type DWord -Value 1
# Small desktop icons
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\Shell\Bags\1\Desktop' -Name 'IconSize' -Type DWord -Value 32
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\Shell\Bags\1\Desktop' -Name 'LogicalViewMode' -Type DWord -Value 3
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\Shell\Bags\1\Desktop' -Name 'Mode' -Type DWord -Value 1
# Performance settings
Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'DragFullWindows' -Type String -Value 0
Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'MenuShowDelay' -Type String -Value 200
Set-ItemProperty -Path 'HKCU:\Control Panel\Keyboard' -Name 'KeyboardDelay' -Type DWord -Value 0
Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'UserPreferencesMask' -Type Binary -Value ([byte[]](144, 18, 3, 128, 16, 0, 0, 0))
Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop\WindowMetrics' -Name 'MinAnimate' -Type String -Value 0
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ListviewAlphaSelect' -Type DWord -Value 0
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ListviewShadow' -Type DWord -Value 0
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'TaskbarAnimations' -Type DWord -Value 0
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects' -Name 'VisualFXSetting' -Type DWord -Value 3
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\DWM' 'EnableAeroPeek' -Type DWord -Value 0
# Display Windows version over wallpaper
Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'PaintDesktopVersion' -Type DWord -Value 1
# Show file name extensions
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'HideFileExt' -Type DWord -Value 0
# Make navigation pane show all folders
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'NavPaneShowAllFolders' -Type DWord -Value 1

#Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\" -Name "Wallpaper" -Value "C:\Users\WDAGUtilityAccount\Desktop\bootstrap\theme\wallpaper.png"
Update-Wallpaper -Image 'C:\Users\WDAGUtilityAccount\Desktop\bootstrap\theme\wallpaper.png'
#Invoke-Command {c:\windows\System32\RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters 1,True}

# Mute sounds
Disable-Volume

Restart-Explorer

#
# Copy portable software/tools in a writable directory
#

Copy-Item 'C:\Users\WDAGUtilityAccount\Desktop\bootstrap\bin\SysinternalsSuite' -Destination 'C:\bin\SysinternalsSuite' -Recurse -Container
Copy-Item 'C:\Users\WDAGUtilityAccount\Desktop\bootstrap\bin\dnSpy' -Destination 'C:\bin\dnSpy' -Recurse -Container
Copy-Item 'C:\Users\WDAGUtilityAccount\Desktop\bootstrap\bin\vcredist_aio' -Destination "${env:TEMP}\vcredist_aio" -Recurse -Container

#
# Create Shortcuts
#

New-Shortcut -Target 'C:\bin\SysinternalsSuite' -Destination 'C:\Users\WDAGUtilityAccount\Desktop\Sysinternals.lnk'
New-Shortcut -Target 'C:\bin\dnSpy\dnSpy.exe' -Destination 'C:\Users\WDAGUtilityAccount\Desktop\dnSpy.lnk'

#
# Software Setup
#

Start-Process -FilePath "${env:TEMP}\vcredist_aio\VisualCppRedist_AIO_x86_x64.exe" -Wait
$program = 'C:\Users\WDAGUtilityAccount\Desktop\bootstrap\bin\ninite.exe'
Start-Process -FilePath $program -Wait
$program = 'C:\Users\WDAGUtilityAccount\Desktop\bootstrap\bin\vscode.exe'
Start-Process -FilePath $program -ArgumentList "/verysilent /suppressmsgboxes /MERGETASKS=`"!runcode,desktopicon,quicklaunchicon,addcontextmenufiles,addcontextmenufolders,addtopath`"" -Wait

Show-MessageBox -Message 'Sandbox set-up complete.' -Title 'Windows Sandbox' -Buttons 0 -Type 64
