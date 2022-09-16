#
# Global Functions
#

# https://github.com/gordonbay/Windows-On-Reins/blob/91bfd2dc38421dbcc1a795764134ba1a074373b9/wor.ps1#L512-L543
function regChange($path, $thing, $value, $desc, $type) {
	Write-Output ($desc)

	# String: Specifies a null-terminated string. Equivalent to REG_SZ.
	# ExpandString: Specifies a null-terminated string that contains unexpanded references to environment variables that are expanded when the value is retrieved. Equivalent to REG_EXPAND_SZ.
	# Binary: Specifies binary data in any form. Equivalent to REG_BINARY.
	# DWord: Specifies a 32-bit binary number. Equivalent to REG_DWORD.
	# MultiString: Specifies an array of null-terminated strings terminated by two null characters. Equivalent to REG_MULTI_SZ.
	# Qword: Specifies a 64-bit binary number. Equivalent to REG_QWORD.
	# Unknown: Indicates an unsupported registry data type, such as REG_RESOURCE_LIST.

	$type2 = "String"
	if (-not ([string]::IsNullOrEmpty($type))) {
		$type2 = $type
	}

	If (!(Test-Path ("HKLM:\" + $path))) {
		New-Item -Path ("HKLM:\" + $path) -Force | out-null
	}
	If (!(Test-Path ("HKCU:\" + $path))) {
		New-Item -Path ("HKCU:\" + $path) -Force | out-null
	}
	If (Test-Path ("HKLM:\" + $path)) {
		Set-ItemProperty ("HKLM:\" + $path) $thing -Value $value -Type $type2 -PassThru:$false | out-null
	}
	If (Test-Path ("HKCU:\" + $path)) {
		Set-ItemProperty ("HKCU:\" + $path) $thing -Value $value -Type $type2 -PassThru:$false | out-null
	}
}

function killProc {
	# Just type the process name without the extension and quotes
	# killProc explorer
	# killProc notepad

	param($procName)

	$p = Get-Process $procName -ErrorAction SilentlyContinue
	if ($p) {
		Stop-Process $p -Force
	}
}

# https://stackoverflow.com/a/9701907/16036749
function createShortcut {
	param ([string]$t, [string]$s)
	$WScriptShell = New-Object -ComObject WScript.Shell
	$Shortcut = $WScriptShell.CreateShortcut($s)
	$Shortcut.TargetPath = $t
	$Shortcut.Save()
}

#
# Copy portable software/tools in a writable directory
#

Copy-Item "C:\Users\WDAGUtilityAccount\Desktop\bootstrap\bin\SysinternalsSuite" -Destination "C:\bin\SysinternalsSuite" -Recurse -Container
Copy-Item "C:\Users\WDAGUtilityAccount\Desktop\bootstrap\bin\dnSpy" -Destination "C:\bin\dnSpy" -Recurse -Container
Copy-Item "C:\Users\WDAGUtilityAccount\Desktop\bootstrap\bin\vcredist_aio" -Destination "${env:TEMP}\vcredist_aio" -Recurse -Container

#
# Software Setup
#

$program = "C:\Users\WDAGUtilityAccount\Desktop\bootstrap\bin\ninite.exe"
Start-Process -FilePath $program -Wait
$program = "C:\Users\WDAGUtilityAccount\Desktop\bootstrap\bin\vscode.exe"
Start-Process -FilePath $program -ArgumentList "/verysilent /suppressmsgboxes /MERGETASKS=`"!runcode,desktopicon,quicklaunchicon,addcontextmenufiles,addcontextmenufolders,addtopath`"" -Wait
Start-Process -FilePath "${env:TEMP}\vcredist_aio\VisualCppRedist_AIO_x86_x64.exe" -Wait

#
# Create Shortcuts
#

createShortcut "C:\bin\SysinternalsSuite" "C:\Users\WDAGUtilityAccount\Desktop\Sysinternals.lnk"
createShortcut "C:\bin\dnSpy\dnSpy.exe" "C:\Users\WDAGUtilityAccount\Desktop\dnSpy.lnk"

#
# Personalization
#

regChange "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarSmallIcons" "1" "Changing taskbar icons size" "DWord"
regChange "SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" "AppsUseLightTheme" "1" "Enabling light theme" "DWord"
regChange "SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" "SystemUsesLightTheme" "1" "Enabling light theme for system" "DWord"
# https://www.tenforums.com/tutorials/62393-change-size-desktop-icons-windows-10-a.html
regChange "SOFTWARE\Microsoft\Windows\Shell\Bags\1\Desktop" "IconSize" "32" "Resizing desktop icons" "DWord"
regChange "SOFTWARE\Microsoft\Windows\Shell\Bags\1\Desktop" "Mode" "1" "..." "DWord"
regChange "SOFTWARE\Microsoft\Windows\Shell\Bags\1\Desktop" "LogicalViewMode" "3" "..." "DWord"
# https://github.com/ChrisTitusTech/win10script/blob/3f3ce770f899445ea71de09899ee803f440ecb87/win10debloat.ps1#L1582-L1596
Write-Output "Adjusting visual effects for performance"
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "DragFullWindows" -Type String -Value 0
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Type String -Value 200
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "UserPreferencesMask" -Type Binary -Value ([byte[]](144,18,3,128,16,0,0,0))
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Name "MinAnimate" -Type String -Value 0
Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "KeyboardDelay" -Type DWord -Value 0
regChange "Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ListviewAlphaSelect" "0" "..." "DWord"
regChange "Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ListviewShadow" "0" "..." "DWord"
regChange "Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarAnimations" "0" "..." "DWord"
regChange "Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" "VisualFXSetting" "3" "..." "DWord"
regChange "Software\Microsoft\Windows\DWM" "EnableAeroPeek" "0" "..." "DWord"
# Display Windows version over wallpaper
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "PaintDesktopVersion" -Type DWord -Value 1
# Disable News and Interests
regChange "Software\Microsoft\Windows\CurrentVersion\Feeds" "ShellFeedsTaskbarViewMode" "2" "Hiding News and Interests" "DWord"
# Show file name extensions
regChange "Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "HideFileExt" "0" "Showing file name extensions" "DWord"

Sleep 3

# https://stackoverflow.com/a/43188780/16036749
$setWallpaper = @"
	using System.Runtime.InteropServices;
	public class wallpaper {
		public const int SetDesktopWallpaper = 20;
		public const int UpdateIniFile = 0x01;
		public const int SendWinIniChange = 0x02;
		[DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
		private static extern int SystemParametersInfo (int uAction, int uParam, string lpvParam, int fuWinIni);
		public static void SetWallpaper (string path) {
			SystemParametersInfo(SetDesktopWallpaper, 0, path, UpdateIniFile | SendWinIniChange);
		}
	}
"@
Add-Type -TypeDefinition $setWallpaper
[wallpaper]::SetWallpaper("C:\Users\WDAGUtilityAccount\Desktop\bootstrap\theme\wallpaper.png")

Write-Output "Restarting Explorer to apply changes..."; killProc explorer

# End of script
Add-Type -AssemblyName PresentationFramework
[System.Windows.MessageBox]::Show("Windows Sandbox setup complete.", "WSB Bootstrap", "Ok", "Information")
