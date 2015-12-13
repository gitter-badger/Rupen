function SetBuildNumber
{
    [CmdletBinding()]
    Param
    (
        [parameter(Position=0, Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$MajorVersion,
	    [parameter(Position=1, Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$MinorVersion,
	    [parameter(Position=2, Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$BuildSourceVersion,			#$Env:BUILD_SOURCEVERSION e.g. C325
	    [parameter(Position=3, Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$BuildBuildNumber				#$Env:BUILD_BUILDNUMBER e.g.365.1 => $(DayOfYear).$(Rev:r).$(Build.BuildId)
    )

	#region Construct the version
	[string[]]$buildNumber = $BuildBuildNumber.Split(".",[System.StringSplitOptions]::RemoveEmptyEntries)
	[string]$buildVersion = ($BuildSourceVersion -replace'\D+(\d+)','$1')

	# TEMPORARY COMMENTED due to https://connect.microsoft.com/VisualStudio/Feedback/Details/2122771
	# [string]$revisionVersion = $buildNumber[0].PadLeft(3, "0") + $buildNumber[1]
	[string]$revisionVersion = $buildNumber[0].PadLeft(3, "0") + $buildNumber[2]
	[string]$version = $MajorVersion + "." + $MinorVersion + "." + $buildVersion + "." + $revisionVersion
	Write-Host "VERSION: $version"
	#endregion

	if ($version -eq "0.0.0.000")
	{
		Write-Error "Version number can't be a zero!"
		exit -1
	}

	#[Environment]::SetEnvironmentVariable($Env:BUILD_BUILDNUMBER,$version, "User")

	Write-Host "##vso[task.setvariable variable=build.buildnumber;]$version"
	Write-Host "##vso[build.updatebuildnumber]$version"

	return $version
}