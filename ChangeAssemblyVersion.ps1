Param (
    [Parameter(Mandatory=$true)]
    [string[]] $AssemblyInfoFilesPath,
    [Parameter(Mandatory=$true)]
    [Version] $Version
)

$ErrorActionPreference = 'Stop'  # Stops executing on error instead of silent continue.
Set-StrictMode -Version Latest   # Enforces coding rules in expressions, scripts, and script blocks. Uninitialized variables are not permitted.

function Change-AssemblyVersion([string] $assemblyInfoFilePath, [Version] $newVersion)
{
    $fileContent = Get-Content $assemblyInfoFilePath | Out-String
    $assemblyVersionReplacePattern = '(AssemblyVersion\(")\d+\.\d+\.\d+\.\d+("\))'
    $fileVersionReplacePattern = '(AssemblyFileVersion\(")\d+\.\d+\.\d+\.\d+("\))'

    $fileContent = [RegEx]::Replace($fileContent, $assemblyVersionReplacePattern, '${1}' + $newVersion + '${2}')
    $fileContent = [RegEx]::Replace($fileContent, $fileVersionReplacePattern, '${1}' + $newVersion + '${2}')

    $fileContent | Out-File $assemblyInfoFilePath
}

function Normalize-Version([Version] $version)
{
    $newBuild = If ($version.Build -ge 0) { $version.Build } Else { 0 }
    $newRevision = If ($version.Revision -ge 0) { $version.Revision } Else { 0 }

    New-Object Version($version.Major, $version.Minor, $newBuild, $newRevision)
}

$Version = Normalize-Version $Version

$AssemblyInfoFilesPath | ForEach-Object { Change-AssemblyVersion $_ $Version }