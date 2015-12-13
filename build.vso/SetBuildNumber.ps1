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
        [string]$BuildSourceVersion,			#e.g. CS1234 or dd6558d478fd3cc3cd6fbe5eacdee94a5094273a
	    [parameter(Position=3, Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$BuildBuildNumber,				#e.g. 09.0824.236.1 => $(Year:yy).$(Month)$(DayOfMonth).$(DayOfYear).$(Rev:r)
	    [parameter(Position=4, Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$BuildBuildId,
		[parameter(Position=5, Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
		[string]$BuildRepositoryProvider		# TFVC, TfGit, Git
    )

	#region Construct the version
	[string[]]$buildNumber = $BuildBuildNumber.Split(".",[System.StringSplitOptions]::RemoveEmptyEntries)

	# TEMPORARY COMMENTED due to https://connect.microsoft.com/VisualStudio/Feedback/Details/2122771
	# [string]$buildVersion = ($BuildSourceVersion -replace'\D+(\d+)','$1')
	# [string]$revisionVersion = $buildNumber[2].PadLeft(3, "0") + $buildNumber[3]

	[string]$buildVersion = $BuildBuildId
	[string]$revisionVersion = $buildNumber[2].PadLeft(3, "0") + $buildNumber[3]

	Write-Host $BuildRepositoryProvider

	if ($BuildRepositoryProvider -eq "TFVC")
	{
		$revisionVersion = ($BuildSourceVersion -replace'\D+(\d+)','$1')
	}

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