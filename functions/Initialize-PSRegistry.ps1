Function Initialize-PSRegistry {

    $PSRegistryDb = New-Item -Path $env:PSRegistryDbPath -ItemType Directory -Force
    $PSRegistryBackups = New-Item -Path $env:PSRegistryBackupsPath -ItemType Directory -Force
    $PSRegistryObjects = New-Item -Path $env:PSRegistryObjectsPath -ItemType Directory -Force

    if ($PSRegistryDb) {

        $PSRegistryDefault = Test-Path -Path $env:PSRegistryDefaultPath

        if ($PSRegistryDefault -eq $true) {
            Write-Host "Default registry already exist, no action taken"
        }

        elseif ($PSRegistryDefault -eq $false) {
            $PSRObject = New-Object PSObject -Property @{                
                Date = (Get-Date)
                Domain = @($env:USERDOMAIN,$env:LOGONSERVER) 
            }

            $PSRObject | Export-Clixml -Path $env:PSRegistryDefaultPath
            $PSRegistryDefault = Test-Path -Path $env:PSRegistryDefaultPath

            if ($PSRegistryDefault) {
                Write-Host "Default registry was successfully created"
            }

            else {
                Write-Error "Could not create default registry, please check permissions"
            }
        }

        else { Write-Error "No action taken"}
    }

    else {
        Write-Error "Could not create default registry, please check permissions"
    }
}