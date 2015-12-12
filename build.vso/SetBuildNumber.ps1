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
        [string]$BuildBuildNumber				#$Env:BUILD_BUILDNUMBER e.g.365.1
    )

	#region Construct the version
	[string[]]$buildNumber = $BuildBuildNumber.Split(".",[System.StringSplitOptions]::RemoveEmptyEntries)
	[string]$buildVersion = ($BuildSourceVersion -replace'\D+(\d+)','$1')
	[string]$revisionVersion = $buildNumber[0].PadLeft(3, "0") + $buildNumber[1]
	[string]$version = $MajorVersion + "." + $MinorVersion + "." + $buildVersion + "." + $revisionVersion
	Write-Output "VERSION: $version"
	#endregion

	if ($version -eq "0.0.0.000")
	{
		Write-Error "Version number can't be has an error!"
		exit -1
	}

	#region Set the version
	#[Environment]::SetEnvironmentVariable("$Env:BUILD_BUILDNUMBER", "$version", "User")
	Write-Output ("##vso[task.setvariable variable=build.buildnumber;]$version")
	Write-Output ("##vso[build.updatebuildnumber]$version")
	#endregion
}