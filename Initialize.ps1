[CmdletBinding()]
Param
(
	[switch]$Build,
	[switch]$ApplyVersion
)

$currentDirectory = Split-Path $MyInvocation.MyCommand.Path

#include Base
$baseScript = [System.IO.Path]::Combine($currentDirectory, "Base.ps1")
Write-Verbose "Including [Base] from $baseScript"

. $baseScript
ApplyDefaultSettings -preferences

if ($Build)
{
	$vsoBuildScriptsPath = [System.IO.Path]::Combine($currentDirectory, "build.vso")
	Write-Verbose "BUILD_SCRIPTS_PATH: $vsoBuildScriptsPath"

	$vsoBuildScriptBuildProcess = [System.IO.Path]::Combine($vsoBuildScriptsPath, "BuildProcess.ps1")
	Write-Verbose "Including [BuildProcess] from $vsoBuildScriptBuildProcess"

	if ($ApplyVersion)
	{
		. $vsoBuildScriptBuildProcess -ApplyVersion
	} else {
		. $vsoBuildScriptBuildProcess
	}
}