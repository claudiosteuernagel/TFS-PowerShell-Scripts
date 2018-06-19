Param (
    [Parameter(Mandatory=$true)]
    [string] $NuspecPath,
    [Parameter(Mandatory=$true)]
    [string] $Build
)

#$ErrorActionPreference = 'Stop'  # Stops executing on error instead of silent continue.

$fileContent = Get-Content $NuspecPath | Out-String

$nuspecVersionPattern = '(\<version\>)(\d+\.\d+\.\d+(\.\d)?)(\<\/version\>)'

$buildVersionPattern = '([^\s]+)_(\d+)'
$currentBuildStr = [RegEx]::Match($Build, $buildVersionPattern).Groups[2].Value
if(!$currentBuildStr)
{
    $currentBuildStr = $Build
}

$currentVersionStr = [RegEx]::Match($fileContent, $nuspecVersionPattern).Groups[2].Value
$newVersionStr = $currentVersionStr + "." + $currentBuildStr
$fileContent = [RegEx]::Replace($fileContent, $nuspecVersionPattern, '${1}' + $newVersionStr + '${4}' )

$dependencyVersionPattern = '(\<dependency id="[^\s]+" version=")('+$currentVersionStr+')("\s?\/>)'
$dependencyVersionStr = [RegEx]::Match($fileContent, $dependencyVersionPattern).Groups[2].Value
if($dependencyVersionStr)
{
    $newdependencyVersionStr = $dependencyVersionStr + "." + $currentBuildStr
    $fileContent = [RegEx]::Replace($fileContent, $dependencyVersionPattern, '${1}' + $newdependencyVersionStr + '${3}' )
}

$fileContent | Out-File $NuspecPath