Function Get-File([String]$File, [String]$O) {
	<#
	.SYNOPSIS
	Download a file from the Internet
	.PARAMETER File
	URL to the file
	.PARAMETER O
	Output file name
	.EXAMPLE
	Get-File -File "https://dl.example.com/Program_v13_x64.exe" -O "C:\bin\program.exe"
	.LINK
	https://github.com/firefart/sandbox/blob/master/downloadFiles.ps1
	#>

	$obj = New-Object System.Net.WebClient
	Try {
		Write-Output "Downloading $($File)"
		$obj.DownloadFile($File, $O)
	}
	Catch {
		Throw $_
	}

	Write-Output "Download complete."
}

#
# Download Tools
#
Try {
	Get-File -File "https://update.code.visualstudio.com/latest/win32-x64-user/stable" -O "$($PSScriptRoot)\bin\vscode.exe"
	Get-File -File "https://download.sysinternals.com/files/SysinternalsSuite.zip" -O "$($PSScriptRoot)\bin\sysinternals.zip"
	Get-File -File "https://github.com/dnSpy/dnSpy/releases/latest/download/dnSpy-net-win64.zip" -O "$($PSScriptRoot)\bin\dnSpy.zip"
	# Get latest version of VisualCppRedist AIO
	$versionFromJson = Invoke-WebRequest "https://api.github.com/repos/abbodi1406/vcredist/releases/latest" | Select-Object -Expand Content | ConvertFrom-Json
	Get-File -File $versionFromJson.assets.browser_download_url -O "$($PSScriptRoot)\bin\vcredist_aio.zip"
}
Catch {
	$error[0] | Format-List * -Force
}

#
# Unzip Tools
#
Try {
	Expand-Archive -LiteralPath "$($PSScriptRoot)\bin\sysinternals.zip" -DestinationPath "$($PSScriptRoot)\bin\SysinternalsSuite"
	Expand-Archive -LiteralPath "$($PSScriptRoot)\bin\dnSpy.zip" -DestinationPath "$($PSScriptRoot)\bin\dnSpy"
	Expand-Archive -LiteralPath "$($PSScriptRoot)\bin\vcredist_aio.zip" -DestinationPath "$($PSScriptRoot)\bin\vcredist_aio"
}
Catch {
	$error[0] | Format-List * -Force
}
