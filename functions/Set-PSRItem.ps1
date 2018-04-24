Function Set-PSRItem {
    param (
        [Parameter(Mandatory=$True,Position=0)]$Key,
        [Parameter(Mandatory=$True,Position=1)]$Value,
        $Registry=$env:psr_registry
    )

    $RegistryPath = Join-Path -Path $env:PSRegistryDbPath -ChildPath ("$Registry" + ".psr")
    $Psr = Import-Clixml -Path $RegistryPath
    $Psr | Add-Member -MemberType NoteProperty -Name $Key -Value $Value -Force
    $Psr | Add-Member -MemberType NoteProperty -Name Date -Value (Get-Date) -Force
    $Psr | Export-Clixml -Path $RegistryPath
    $NewPsr = Import-Clixml -Path $RegistryPath
    Return ("$Key : " + $NewPsr.$Key + " Stored successfully!")
}