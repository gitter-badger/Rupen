function ApplyVersionToAssemblies
{
    [CmdletBinding()]
    Param
    (
		[parameter(Position=0, Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
		[string]$BuildSourcePath,
		[parameter(Position=1, Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$BuildBuildNumber
    )

	# Regular expression pattern to find the version in the build number
	# and then apply it to the assemblies
	$VersionRegex = "\d+\.\d+\.\d+\.\d+"

	# Apply the version to the assembly property files
	$files = Get-ChildItem $BuildSourcePath -recurse -include "*AssemblyInfo.cs"

	if($files)
	{
		Write-Output "Will apply $BuildBuildNumber to $($files.count) files in $BuildSourcePath"

		foreach ($file in $files) {
			$filecontent = Get-Content($file)
			attrib $file -r
			$filecontent -replace $VersionRegex, $BuildBuildNumber | Out-File $file
			Write-Verbose "$file.FullName - version applied"
		}
	}
	else
	{
		Write-Warning "No file found at $BuildSourcePath"
	}
}