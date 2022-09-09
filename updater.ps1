# https://github.com/firefart/sandbox/blob/master/downloadFiles.ps1
function dlFile {
	param ([string]$i, [string]$o)

	Write-Output "Downloading $($i)"

	$wc = New-Object System.Net.WebClient

	Try {
		$wc.DownloadFile($i, $o)
	}
	Catch {
		throw $_
	}

	Write-Output "Download complete."
}

# https://github.com/julianosaless/powershellzip/blob/be12549e2f36c23e923821d547ce55194b1da784/powershell-zip.ps1#L25
function unzip {
	param([string]$i, [string]$o)

	Write-Output "Expanding archive $($i)"

	[System.IO.Compression.ZipFile]::ExtractToDirectory($i, $o) *>$null

	Write-Output "Done."
}

#
# Download Tools
#
Try {
	dlFile -i "https://update.code.visualstudio.com/latest/win32-x64-user/stable" -o "$($PSScriptRoot)\bin\vscode.exe"
	dlFile -i "https://download.sysinternals.com/files/SysinternalsSuite.zip" -o "$($PSScriptRoot)\bin\sysinternals.zip"
	dlFile -i "https://github.com/dnSpy/dnSpy/releases/latest/download/dnSpy-net-win64.zip" -o "$($PSScriptRoot)\bin\dnSpy.zip"
	# This link must be updated manually
	dlFile -i 'https://de1-dl.techpowerup.com/files/jppJEai2MQTrHR75bicEYg/1662787324/Visual-C-Runtimes-All-in-One-Jul-2022.zip' -o "$($PSScriptRoot)\bin\vcredist_aio.zip"
}
Catch {
	$error[0] | Format-List * -Force
}

#
# Unzip Tools
#
Try {
	unzip -i "$($PSScriptRoot)\bin\sysinternals.zip" -o "$($PSScriptRoot)\bin\SysinternalsSuite\"
	unzip -i "$($PSScriptRoot)\bin\dnSpy.zip" -o "$($PSScriptRoot)\bin\dnSpy\"
	unzip -i "$($PSScriptRoot)\bin\vcredist_aio.zip" -o "$($PSScriptRoot)\bin\vcredist_aio\"
}
Catch {
	$error[0] | Format-List * -Force
}
