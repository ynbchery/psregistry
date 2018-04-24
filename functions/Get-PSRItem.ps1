Function Get-PSRItem {
    param (
        [Parameter(Mandatory=$True,Position=0)]$Key,
        $Registry=$env:psr_registry
    )

    $RegistryPath = Join-Path -Path $env:PSRegistryDbPath -ChildPath ("$Registry" + ".psr")
    $Psr = Import-Clixml -Path $RegistryPath
    Return $Psr.$Key
}