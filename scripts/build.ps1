Import-Module "$PSScriptRoot/Write-Success.psm1"

Write-Success -Message "Exporting Modrinth (.mrpack) package"
packwiz modrinth export --restrictDomains
