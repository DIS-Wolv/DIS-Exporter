
$ModName = "@DIS-Exporter"
$fileToAdd = @(
    "dis.paa",
    "disMoto.jpg",
    "mod.cpp",
    "DllTest1_x64.dll",
	"loggerhttp.py"
)

# Define paths for the mod and tools
$KeyFolder = "C:\Users\SteamCMD\Documents\Arma3Keys"
$A3ToolsPath = "C:\Program Files (x86)\Steam\steamapps\common\Arma 3 Tools"
$AddonBuilderPath = "$A3ToolsPath\AddonBuilder\AddonBuilder.exe"

# check if the mod directory already exists
if (Test-Path -Path $ModName) {
	Write-Output "Removing existing mod directory: $ModName"
	Remove-Item -Path $ModName -Force -Recurse
}

# create the mod directory structure
New-Item -Path $ModName -ItemType Directory
New-Item -Path "$ModName\addons" -ItemType Directory
New-Item -Path "$ModName\keys" -ItemType Directory

# Copy files to the mod directory
ForEach ($file in $fileToAdd) {
	$sourcePath = ".\$file"
	$destinationPath = "$ModName\$file"
	
	Copy-Item -Path $sourcePath -Destination $destinationPath -Force
	Write-Output "Adding $file to $ModName"
}

# Process each directory in the addons folder
$destinationDir = "$(Get-Location)\$ModName\addons\"
ForEach ($dir in (Get-ChildItem -Path ".\addons" -Directory)) {
	write-Output "Processing directory: $($dir.name)"
	
	$sourcePath = "$(Get-Location)\addons\$($dir.name)"
	if (Test-Path -Path (".\addons\$($dir.name)\"+'$PREFIX$')) {
		$prefix = Get-Content -Path (".\addons\$($dir.name)\"+'$PREFIX$') -First 1
		& $AddonBuilderPath $sourcePath $destinationDir -packonly -sign="$KeyFolder\dis.biprivatekey" -toolsDirectory="$A3ToolsPath" -prefix=$prefix
	}
	else {
		write-Output "No prefix file found in $($dir.name), using default settings."
		& $AddonBuilderPath $sourcePath $destinationDir -packonly -sign="$KeyFolder\dis.biprivatekey" -toolsDirectory="$A3ToolsPath"
	}
}

# create the key file
$pubKeyFilePath = "$KeyFolder\dis.bikey"
Copy-Item -Path $pubKeyFilePath -Destination "$ModName\keys\dis.bikey" -Force
