Param (
    [Parameter(Mandatory=$true)]
    [string] $AssemblyInfoPath,
    [string] $PropertiesFilePath = 'EnvInjectProperties.txt',
    [string] $PropertyName = 'NEXT_VERSION'
)

$ErrorActionPreference = 'Stop'  # Stops executing on error instead of silent continue.
Set-StrictMode -Version Latest   # Enforces coding rules in expressions, scripts, and script blocks. Uninitialized variables are not permitted.

$fileContent = Get-Content $AssemblyInfoPath | Out-String
$assemblyVersionPattern = 'AssemblyVersion\("(\d+\.\d+\.\d+\.\d+)"\)'

$currentVersionStr = [RegEx]::Match($fileContent, $assemblyVersionPattern).Groups[1].Value
$currentVersion = New-Object Version($currentVersionStr)

$newVersion = New-Object Version($currentVersion.Major, $currentVersion.Minor, $currentVersion.Build, ($currentVersion.Revision + 1))

Add-Content $PropertiesFilePath "$PropertyName=$newVersion"