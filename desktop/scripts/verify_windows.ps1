param(
    [Parameter(Mandatory=$true)]
    [string]$Version,

    [Parameter(Mandatory=$true)]
    [string]$BuildNum,
    
    [Parameter(Mandatory=$true)]
    [ValidateSet('community', 'enterprise')]
    [string]$Edition
)

Push-Location "$PSScriptRoot\.."

# Create lib directory
New-Item -Type Directory -ErrorAction Ignore lib
Push-Location lib

# Download and unzip the Couchbase Lite zip file
if ($BuildNum -eq "0") {
    $ZipFilename = "couchbase-lite-c-${Edition}-${Version}-windows-x86_64.zip"
    $DownloadUrl = "https://packages.couchbase.com/releases/couchbase-lite-c/${Version}/${ZipFilename}"
} else {
    $ZipFilename = "couchbase-lite-c-${Edition}-${Version}-${BuildNum}-windows-x86_64.zip"
    $DownloadUrl = "http://latestbuilds.service.couchbase.com/builds/latestbuilds/couchbase-lite-c/${Version}/${BuildNum}/${ZipFilename}"
}
Write-Host "Zip Filename: $ZipFilename"
Write-Host "Download URL: $DownloadUrl"

Invoke-WebRequest -Uri $DownloadUrl -OutFile $ZipFilename
Expand-Archive -Path $ZipFilename -DestinationPath .
Remove-Item -Force $ZipFilename
Pop-Location

# Create the build directory
New-Item -Type Directory -ErrorAction Ignore build
Push-Location build

# Run CMake to configure and build the project
if ($Edition -eq "enterprise") {
    $BuildEnt = "ON"
} else {
    $BuildEnt = "OFF"
}
$CblLibDir = Join-Path $PSScriptRoot "..\lib"
cmake -DCMAKE_PREFIX_PATH="$CblLibDir\libcblite-$Version" -DCMAKE_BUILD_TYPE=Release ..
cmake --build . --config Release

# Run the verify executable
Push-Location "Release"
Copy-Item -Force "$CblLibDir\libcblite-${Version}\bin\cblite.dll" .
.\verify.exe