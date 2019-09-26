Param (
    [Parameter(Mandatory = $true)]
    [string] $csprojPath,
    [Parameter(Mandatory = $true)]
    [string] $Build,
    [Parameter(Mandatory = $false)]
    [string] $BuildSufix
)

#$ErrorActionPreference = 'Stop'  # Stops executing on error instead of silent continue.

$fileContent = Get-Content $csprojPath | Out-String

$csprojVersionPattern = '(\<[Vv]ersion\>)((\d+\.\d+)(\.\d)?(\.\d)?)(\<\/[Vv]ersion\>)'

$buildVersionPattern = '([^\s]+)_(\d+)'
$currentBuildStr = [RegEx]::Match($Build, $buildVersionPattern).Groups[2].Value
if (!$currentBuildStr) {
    $currentBuildStr = $Build
}

if ($BuildSufix) {
    $currentBuildStr = $currentBuildStr + "-" + $BuildSufix
}

$currentVersionStr = [RegEx]::Match($fileContent, $csprojVersionPattern).Groups[3].Value

$newVersionStr = $currentVersionStr + "." + $currentBuildStr

$fileContent = [RegEx]::Replace($fileContent, $csprojVersionPattern, '${1}' + $newVersionStr + '${6}' )

$fileContent | Out-File $csprojPath
