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

    $RegistryPath = Join-Path -Path $env:PSRegistryDbPath -ChildPath ($Name + ".psr")
    $PSRObject | Export-Clixml -Path $RegistryPath
    Write-Host "Registry:$Name was successfully created"
    Write-Host "To use registry:$Name, type 'Change-PSRegistry $Name'"
}