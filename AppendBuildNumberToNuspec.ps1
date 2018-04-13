Param (
    [Parameter(Mandatory=$true)]
    [string] $NuspecPath,
    [Parameter(Mandatory=$true)]
    [string] $Build
)
#$NuspecPath = 'C:\Users\claudio\source\repos\ClassLibrary\ClassLibrary\ClassLibrary.nuspec'
$ErrorActionPreference = 'Stop'  # Stops executing on error instead of silent continue.
Set-StrictMode -Version Latest   # Enforces coding rules in expressions, scripts, and script blocks. Uninitialized variables are not permitted.

$fileContent = Get-Content $NuspecPath | Out-String

$nuspecVersionPattern = '(\<version\>)(\d+\.\d+\.\d+(\.\d)?)(\<\/version\>)'

$buildVersionPattern = '([^\s]+)_(\d+)'
$currentBuildStr = [RegEx]::Match($Build, $buildVersionPattern).Groups[2].Value

$currentVersionStr = [RegEx]::Match($fileContent, $nuspecVersionPattern).Groups[2].Value
$newVersionStr = $currentVersionStr + "." + $currentBuildStr

$fileContent = [RegEx]::Replace($fileContent, $nuspecVersionPattern, '${1}' + $newVersionStr + '${4}' )

$fileContent | Out-File $AssemblyInfoPath