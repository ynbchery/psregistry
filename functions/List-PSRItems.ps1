Function List-PSRItems {
    param (
        $Registry=$env:psr_registry
    )

    $RegistryPath = Join-Path -Path $PSRegistryDbPath -ChildPath ("$Registry" + ".psr")
    $Psr = Import-Clixml -Path $RegistryPath | Format-List
    Return $Psr
}