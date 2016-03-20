function ReplaceVersion([string]$BuildSourcePath, [string] $versionFile, [string] $regexPattern, [string]$finalVersion)
{
    [bool]$output = $false
    $files = Get-ChildItem $BuildSourcePath -recurse -include $versionFile
    if ($files)
    {
        $output = $true
		Write-Host "Will apply $BuildBuildNumber to $($files.count) files in $BuildSourcePath"

		foreach ($file in $files) {
			$filecontent = Get-Content($file)
			attrib $file -r
			$filecontent -replace $regexPattern, $finalVersion | Out-File $file
			Write-Verbose "$file - version applied"
		}
    }
    return $output
}

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

	$replaceSucceed1 = (ReplaceVersion $BuildSourcePath "project.json" '\s*\"version\"\s*:\s*\"\d+\.\d+\.\d+-\*?(\w*)\"' '  "version": "' + $BuildBuildNumber + '"')
	$replaceSucceed2 = (ReplaceVersion $BuildSourcePath "*AssemblyInfo.cs" "\d+\.\d+\.\d+\.\d+" $BuildBuildNumber)
	    if ($replaceSucceed1 = $false & $replaceSucceed2 = $false)
	    	Write-Warning "No file found at $BuildSourcePath"
	    }
	}
}
