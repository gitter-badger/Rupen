[CmdletBinding()]
Param
(
	[switch]$ApplyVersion,
    [string]$MajorVersion,
	[string]$MinorVersion,
	[string]$BuildSourceVersion,
	[string]$BuildBuildNumber
)

#region validations

# Make sure there is a build source version
if (-not $BuildSourceVersion)
{
	# Make sure environment build source version is available
	if (-not $Env:BuildSourceVersion)
	{
		Write-Warning ("BUILD_SOURCEVERSION environment variable is missing.")
		$BuildSourceVersion = 0
	} else {
		Write-Verbose "BUILD_SOURCEVERSION: $Env:BuildSourceVersion"
		$BuildSourceVersion = $Env:BuildSourceVersion
	}
}
Write-Verbose "BUILD_SOURCEVERSION: $BuildSourceVersion"

# Make sure there is a build number
if (-not $BuildBuildNumber)
{
	# Make sure environment build number is available
	if (-not $Env:BuildBuildNumber)
	{
		Write-Warning ("BUILD_BUILDNUMBER environment variable is missing.")
		$BuildBuildNumber = 0
	} else {
		Write-Verbose "ENV:BUILD_BUILDNUMBER: $Env:BuildBuildNumber"
		$BuildBuildNumber = $Env:BuildBuildNumber
	}
}
Write-Verbose "BUILD_BUILDNUMBER: $BuildBuildNumber"

# Make sure major version is available
if (-not $MajorVersion)
{
	# Make sure environment major version is available
	if (-not $Env:MajorVersion)
	{
		Write-Warning ("MAJORVERSION environment variable is missing.")
		$MajorVersion = 0
	} else {
		Write-Verbose "ENV:MAJORVERSION: $Env:MajorVersion"
		$MajorVersion = $Env:MajorVersion
	}
}
Write-Verbose "MAJORVERSION: $MajorVersion"

# Make sure minor version is available
if (-not $MinorVersion)
{
	# Make sure environment minor version is available
	if (-not $Env:MinorVersion)
	{
		Write-Warning ("MINORVERSION environment variable is missing.")
		$MinorVersion = 0
	} else {
		Write-Verbose "ENV:MINORVERSION: $Env:MinorVersion"
		$MinorVersion = $Env:MinorVersion
	}
}
Write-Verbose "MINORVERSION: $MinorVersion"

#endregion

$vsoBuildScriptSetBuildNumber = [System.IO.Path]::Combine($vsoBuildScriptsPath, "SetBuildNumber.ps1")
Write-Verbose "including [SetBuildNumber] from $vsoBuildScriptSetBuildNumber"
. $vsoBuildScriptSetBuildNumber

$buildNumberResult = (SetBuildNumber $MajorVersion $MinorVersion $BuildSourceVersion $BuildBuildNumber)
<#
foreach ($Data in $buildNumberResult)
{
	Write-Warning $buildNumberResult
}

$error.clear()
try { something }
catch { "Error occured" }
if (!$error) {
"No Error Occured"
}
#>

if ($buildNumberResult)
{
	if ($applyVersion)
	{
		$vsoBuildScriptApplyVersionToAssemblies = [System.IO.Path]::Combine($vsoBuildScriptsPath, "ApplyVersionToAssemblies.ps1")
		Write-Verbose "including [ApplyVersionToAssemblies] from $vsoBuildScriptApplyVersionToAssemblies"
		. $vsoBuildScriptApplyVersionToAssemblies
		(ApplyVersionToAssemblies $([System.Environment]::CurrentDirectory) $BuildBuildNumber)
	}
}

SetPreferencesToSilentlyContinue