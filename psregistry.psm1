# Initialize Environment Variables
$env:psr_registry = "default"
$env:PSRegistryPath = Join-Path -Path $HOME -ChildPath ".psregistry"
$env:PSRegistryDbPath = Join-Path -Path $env:PSRegistryPath -ChildPath "db"
$env:PSRegistryBackupsPath = Join-Path -Path $env:PSRegistryPath -ChildPath "backups"
$env:PSRegistryObjectsPath = Join-Path -Path $env:PSRegistryPath -ChildPath "objects"
$env:PSRegistryDefaultPath = Join-Path -Path $env:PSRegistryDbPath -ChildPath "default.psr"


$Functions = @(Get-ChildItem -Path $PSScriptRoot\functions\*.ps1 -Recurse -ErrorAction SilentlyContinue)

# Unblock powershell files within the module
ForEach ($import in @($Functions))
{
    Try
    {
        Unblock-File -Path $import.FullName
    }
    Catch
    {
        Write-Error -Message "Could not unblock file $($import.fullname): $_"
    }
}

# Load all functions within the module
Foreach($import in @($Functions))
{
    Try
    {
        . $import.FullName
    }
    Catch
    {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

Export-ModuleMember -Function $Functions.Basename

# Set Aliases
Set-Alias -Name gpsr -Value "Get-PSRItem"
Set-Alias -Name apsr -Value "Add-PSRItem"
Set-Alias -Name spsr -Value "Show-PSRItems"
Set-Alias -Name opsr -Value "Out-PSRItem"
Export-ModuleMember -Alias *