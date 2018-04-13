Param (
    [Parameter(Mandatory=$true)]
    [string] $AssemblyInfoPath,
    [Parameter(Mandatory=$true)]
    [string] $Build
)
$ErrorActionPreference = 'Stop'  # Stops executing on error instead of silent continue.
Set-StrictMode -Version Latest   # Enforces coding rules in expressions, scripts, and script blocks. Uninitialized variables are not permitted.

$fileContent = Get-Content $AssemblyInfoPath | Out-String

#$assemblyVersionPattern = '(AssemblyVersion\(")(\d+\.\d+\.\d+(\.\d)?)("\))'
$assemblyFileVersionPattern = '(AssemblyFileVersion\(")(\d+\.\d+\.\d+(\.\d)?)("\))'

#$currentVersionStr = [RegEx]::Match($fileContent, $assemblyVersionPattern).Groups[2].Value
#$newVersionStr = $currentVersionStr + "." + $Build

$currentFileVersionStr = [RegEx]::Match($fileContent, $assemblyFileVersionPattern).Groups[2].Value
$newFileVersionStr = $currentFileVersionStr + "." + $Build

#$fileContent = [RegEx]::Replace($fileContent, $assemblyVersionPattern, '${1}' + $newVersionStr + '${4}' )
$fileContent = [RegEx]::Replace($fileContent, $assemblyFileVersionPattern, '${1}' + $newFileVersionStr + '${4}' )

$fileContent | Out-File $AssemblyInfoPath