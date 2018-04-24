Function Change-PSRegistry {
    param (
        [Parameter(Mandatory=$True,Position=0)]$Name
    )

    $RegistryPath = Join-Path -Path $env:PSRegistryDbPath -ChildPath ($Name + ".psr")
    $RegistryPathTest = Test-Path -Path $RegistryPath

    if ($RegistryPathTest -eq $false) {
        Write-Error "Registry:$Name could not be found"
    }

    elseif ($RegistryPathTest -eq $true) {
        $env:psr_registry = $Name
        Write-Host "Registry:$Name is now active"
    }
    
}