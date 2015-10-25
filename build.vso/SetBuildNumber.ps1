[CmdletBinding()]
param(
	[string]$MajorVersion
)

# Enable -Verbose option
$VerbosePreference = 'Continue'

#region validations
# Make sure there is a build number
if (-not $Env:BUILD_SOURCEVERSION)
{
    Write-Error ("BUILD_SOURCEVERSION environment variable is missing.")
    exit 1
}
Write-Verbose "BUILD_SOURCEVERSION: $Env:BUILD_SOURCEVERSION"

# Make sure there is a build number
if (-not $Env:BUILD_BUILDNUMBER)
{
    Write-Error ("BUILD_BUILDNUMBER environment variable is missing.")
    exit 1
}
Write-Verbose "BUILD_BUILDNUMBER: $Env:BUILD_BUILDNUMBER"

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
#endregion

#region Construct the version
$buildNumber = $Env:BUILD_BUILDNUMBER.Split(".",[System.StringSplitOptions]::RemoveEmptyEntries)
$minorVersion = ($Env:BUILD_SOURCEVERSION -replace'\D+(\d+)','$1')
$buildVersion = $buildNumber[0].PadLeft(3, "0")
$revisionVersion = $buildNumber[1].PadLeft(2, "0") + $buildNumber[2].PadLeft(2, "0") + $buildNumber[3] 
$version = $MajorVersion + "." + $minorVersion + "." + $buildVersion + "." + $revisionVersion
Write-Verbose "Version: $version"
#endregion

#region Set the version
$Env:BUILD_BUILDNUMBER = $version
#[Environment]::SetEnvironmentVariable("$Env:BUILD_BUILDNUMBER", "$version", "User")
Write-Host ("##vso[task.setvariable variable=build.buildnumber;]$version")
Write-Host ("##vso[build.updatebuildnumber]$version")
#endregion