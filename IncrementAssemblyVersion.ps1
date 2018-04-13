Param (
    [Parameter(Mandatory=$true)]
    [string] $AssemblyInfoPath
)

$ErrorActionPreference = 'Stop'  # Stops executing on error instead of silent continue.
Set-StrictMode -Version Latest   # Enforces coding rules in expressions, scripts, and script blocks. Uninitialized variables are not permitted.

$fileContent = Get-Content $AssemblyInfoPath | Out-String
$assemblyVersionCapturePattern = 'AssemblyVersion\("\d+\.\d+\.\d+\.(\d+)"\)'
$assemblyVersionReplacePattern = '(AssemblyVersion\("\d+\.\d+\.\d+\.)\d+("\))'
$fileVersionReplacePattern = '(AssemblyFileVersion\("\d+\.\d+\.\d+\.)\d+("\))'

$currentRevision = [int][RegEx]::Match($fileContent, $assemblyVersionCapturePattern).Groups[1].Value
$newRevision = $currentRevision + 1

$fileContent = [RegEx]::Replace($fileContent, $assemblyVersionReplacePattern, '${1}' + $newRevision + '${2}')
$fileContent = [RegEx]::Replace($fileContent, $fileVersionReplacePattern, '${1}' + $newRevision + '${2}')

$fileContent | Out-File $AssemblyInfoPath