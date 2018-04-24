Function Backup-PSRegistry {
    param (
        $Registry=$env:psr_registry
    )

    $RegistryPath = Join-Path -Path $env:PSRegistryDbPath -ChildPath ("$Registry" + ".psr")
    $Psr = Import-Clixml -Path $RegistryPath
    $D = $Psr.Date
    $BackupDate = ($D.Year.ToString() + $D.Month.ToString() + $D.Day.ToString() + $D.Hour.ToString() + $D.Minute.ToString() + $D.Second.ToString() )
    $BackupPath = Join-Path -Path $env:PSRegistryBackupsPath -ChildPath ("$BackupDate" + "_" + "$Registry" + "_backup" + ".psr")
    $Psr | Export-Clixml -Path $BackupPath
    $BackupTest = Test-Path -Path $BackupPath
    if ($BackupTest -eq $false) {
        Write-Error "Backup of Registry:$Registry was unsuccessful"
    }
    Write-Host "Backup of Registry:$Name was successful"
}