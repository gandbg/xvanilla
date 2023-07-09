function Write-Success {
	param (
		[Parameter(Mandatory=$true)][string]$Message
	)

	Write-Host $Message -ForegroundColor Green
}
