Import-Module "$PSScriptRoot/Write-Success.psm1"

Write-Success -Message "Locating Modrinth (.mrpack) package"
$ModrinthPackage = (Get-ChildItem -Path "./*" -Include "*.mrpack")[0] #Get the full path of the .mrpack file
$ModrinthZipPackage = [System.IO.Path]::ChangeExtension($ModrinthPackage, '.zip') #Generate a new path where the extension is .zip
Move-Item -Path $ModrinthPackage -Destination $ModrinthZipPackage #Rename the file

#------------------------------------------------------

Write-Success -Message "Building dependency tree"

Expand-Archive -Path $ModrinthZipPackage -DestinationPath "./modrinth-package" #Temporarly extract package to get the modrinth.index.json file
Move-Item -Path $ModrinthZipPackage -Destination $ModrinthPackage #Revert the name change

$ModrinthIndex = Get-Content "./modrinth-package/modrinth.index.json" | ConvertFrom-Json #Load modrinth index
$ModrinthDependencies = @() #Initialize dependency tree
$ModrinthIndex.files | ForEach-Object { #Build dependency tree
	$FileUrl = [uri]$_.downloads[0]
	$ModrinthDependencies += [PSCustomObject]@{
		version_id = $FileUrl.AbsolutePath.Split('/')[4]
		project_id = $FileUrl.AbsolutePath.Split('/')[2]
		file_name = $FileUrl.AbsolutePath.Split('/')[5]
		dependency_type = "embedded"
	}
}

#TODO upload stack
#TODO delete temporary package extraction
