$PSRegistryPath = Join-Path -Path $HOME -ChildPath ".psregistry"
$PSRegistryDbPath = Join-Path -Path $PSRegistryPath -ChildPath "db"
$PSRegistryBackupsPath = Join-Path -Path $PSRegistryPath -ChildPath "backups"
$PSRegistryObjectsPath = Join-Path -Path $PSRegistryPath -ChildPath "objects"
$PSRegistryDefaultPath = Join-Path -Path $PSRegistryDbPath -ChildPath "default.psr"

Function New-PSRegistry {
    [cmdletbinding()]
    param (
        [Parameter(Mandatory=$True,Position=0)]$Name,
        [parameter(ValueFromPipeline)]$Input
    )
    $PSRObject = New-Object PSObject -Property @{                
        Date = (Get-Date) 
    }

    if ($Input) {
        $Input | ForEach-Object {
            $PSRObject | Add-Member -MemberType NoteProperty -Name ($PSItem.psobject.properties.Name).toString() -Value $PSItem.psobject.properties.Value
        }
    }

    $RegistryPath = Join-Path -Path $PSRegistryDbPath -ChildPath ($Name + ".psr")
    $PSRObject | Export-Clixml -Path $RegistryPath
    Write-Host "Registry:$Name was successfully created"
    Write-Host "To use registry:$Name, type 'Change-PSRegistry $Name'"
}

Function Change-PSRegistry {
    param (
        [Parameter(Mandatory=$True,Position=0)]$Name
    )

    $RegistryPath = Join-Path -Path $PSRegistryDbPath -ChildPath ($Name + ".psr")
    $RegistryPathTest = Test-Path -Path $RegistryPath

    if ($RegistryPathTest -eq $false) {
        Write-Error "Registry:$Name could not be found"
    }

    elseif ($RegistryPathTest -eq $true) {
        $env:psr_registry = $Name
        Write-Host "Registry:$Name is now active"
    }
    
}

Function Initialize-PSRegistry {

    $PSRegistryDb = New-Item -Path $PSRegistryDbPath -ItemType Directory -Force
    $PSRegistryBackups = New-Item -Path $PSRegistryBackupsPath -ItemType Directory -Force
    $PSRegistryObjects = New-Item -Path $PSRegistryObjectsPath -ItemType Directory -Force

    if ($PSRegistryDb) {
        # Create default registry
        $PSRegistryDefault = Test-Path -Path $PSRegistryDefaultPath

        if ($PSRegistryDefault -eq $true) {
            Write-Host "Default registry already exist, no action taken"
        }

        elseif ($PSRegistryDefault -eq $false) {
            $PSRObject = New-Object PSObject -Property @{                
                Date = (Get-Date)
                Domain = @($env:USERDOMAIN,$env:LOGONSERVER) 
            }

            $PSRObject | Export-Clixml -Path $PSRegistryDefaultPath

            if ($PSRegistryDefaultNew) {
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

Function Get-PSRItem {
    param (
        [Parameter(Mandatory=$True,Position=0)]$Key,
        $Registry=$env:psr_registry
    )

    $RegistryPath = Join-Path -Path $PSRegistryDbPath -ChildPath ("$Registry" + ".psr")
    $Psr = Import-Clixml -Path $RegistryPath
    Return $Psr.$Key
}

Function Set-PSRItem {
    param (
        [Parameter(Mandatory=$True,Position=0)]$Key,
        [Parameter(Mandatory=$True,Position=1)]$Value,
        $Registry=$env:psr_registry
    )

    $RegistryPath = Join-Path -Path $PSRegistryDbPath -ChildPath ("$Registry" + ".psr")
    $Psr = Import-Clixml -Path $RegistryPath
    $Psr | Add-Member -MemberType NoteProperty -Name $Key -Value $Value -Force
    $Psr | Add-Member -MemberType NoteProperty -Name Date -Value (Get-Date) -Force
    $Psr | Export-Clixml -Path $RegistryPath
    $NewPsr = Import-Clixml -Path $RegistryPath
    Return ("$Key : " + $NewPsr.$Key + " Stored successfully!")
}

Function Out-PSRItem {
    [cmdletbinding()]
    param (
        [Parameter(Mandatory=$True,Position=0)]$Key,
        [parameter(ValueFromPipeline)]$Input,
        $Registry=$env:psr_registry
    )

    $RegistryPath = Join-Path -Path $PSRegistryDbPath -ChildPath ("$Registry" + ".psr")
    $Psr = Import-Clixml -Path $RegistryPath
    $Psr | Add-Member -MemberType NoteProperty -Name $Key -Value $Input -Force
    $Psr | Add-Member -MemberType NoteProperty -Name Date -Value (Get-Date) -Force
    $Psr | Export-Clixml -Path $RegistryPath
    $NewPsr = Import-Clixml -Path $RegistryPath
    Return ("$Key : " + $NewPsr.$Key + " Stored successfully!")
}

Function List-PSRItems {
    param (
        $Registry=$env:psr_registry
    )

    $RegistryPath = Join-Path -Path $PSRegistryDbPath -ChildPath ("$Registry" + ".psr")
    $Psr = Import-Clixml -Path $RegistryPath | Format-List
    Return $Psr
}

Set-Alias -Name gpsr -Value "Get-PSRItem"
Set-Alias -Name spsr -Value "Set-PSRItem"
Set-Alias -Name lpsr -Value "List-PSRItems"
Set-Alias -Name opsr -Value "Out-PSRItem"