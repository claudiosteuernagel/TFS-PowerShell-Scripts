Param (
    [Parameter(Mandatory=$true)]
    [string] $Destination,
    [Parameter(Mandatory=$true)]
    [string] $Origin,
    [Parameter(Mandatory=$true)]
    [string] $Files
)

$Backupdir=$Destination +"\Backup-"+ (Get-Date -format MM-dd-yyyy)

If(!(test-path $Backupdir))
{
      New-Item -ItemType Directory -Force -Path $Backupdir
}

$Files=$Files.split(",")

foreach ($File in $Files) {
    $filePath = $Origin+"\"+$File
    $newFilePath = $Backupdir+"\"+$File
    Copy-Item $filePath $newFilePath -Force
}
