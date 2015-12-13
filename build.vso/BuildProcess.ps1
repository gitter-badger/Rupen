[CmdletBinding()]
Param
(
	[switch]$ApplyVersion,
    [string]$Directory,
	[string]$MajorVersion,
	[string]$MinorVersion,
	[string]$BuildSourceVersion = "C325",
	[string]$BuildBuildNumber = "365.1"
)

#region validations

# Make sure there is a build source version
if (-not $BuildSourceVersion)
{
	# Make sure environment build source version is available
	if (-not $Env:BUILD_SOURCEVERSION)
	{
		Write-Warning ("BUILD_SOURCEVERSION environment variable is missing.")
		$BuildSourceVersion = 0
	} else {
		Write-Verbose "ENV:BUILD_SOURCEVERSION: $Env:BUILD_SOURCEVERSION"
		$BuildSourceVersion = $Env:BUILD_SOURCEVERSION
	}
}
Write-Verbose "BUILD_SOURCEVERSION: $BuildSourceVersion"

# Make sure there is a build number
if (-not $BuildBuildNumber)
{
	# Make sure environment build number is available
	if (-not $Env:BUILD_BUILDNUMBER)
	{
		Write-Warning ("BUILD_BUILDNUMBER environment variable is missing.")
		$BuildBuildNumber = 0
	} else {
		Write-Verbose "ENV:BUILD_BUILDNUMBER: $Env:BUILD_BUILDNUMBER"
		$BuildBuildNumber = $Env:BUILD_BUILDNUMBER
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

$version = (SetBuildNumber $MajorVersion $MinorVersion $BuildSourceVersion $BuildBuildNumber)

if ($ApplyVersion)
{
	$vsoBuildScriptApplyVersionToAssemblies = [System.IO.Path]::Combine($vsoBuildScriptsPath, "ApplyVersionToAssemblies.ps1")
	Write-Verbose "including [ApplyVersionToAssemblies] from $vsoBuildScriptApplyVersionToAssemblies"
	. $vsoBuildScriptApplyVersionToAssemblies
	(ApplyVersionToAssemblies $directory $version)
}

SetPreferencesToSilentlyContinue