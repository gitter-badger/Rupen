function ApplyDefaultSettings
{
    [CmdletBinding()]
    Param
    (
        [switch] $preferences,
        [switch] $modules,
        [switch] $desktop,
		[switch] $running
    )

    if ($preferences)
    {
        #region DEVELOPMENT ENVIRONMENT VALUES
        #Clear-Host
        SetPreferences "Continue"
        #endregion
    }

    if ($modules)
    {
        #region Modules
        Write-Verbose "PSModulePath: $env:PSModulePath"
        $userModuleLocation = $env:PSModulePath.Split(';') | Where-Object {$_.Contains('Documents')}
        Write-Verbose "User Powershell Module location is: $userModuleLocation"
        #endregion
    }

    #region CURRENTDIRECTORY
    #$myInvocation = (Get-Variable MyInvocation).Value
    #$currentDirectory = Split-Path $myInvocation.MyCommand.Path
    $currentDirectory = [System.Environment]::CurrentDirectory
    if ($desktop)
    {
        $currentDirectory = [System.IO.Path]::Combine($env:USERPROFILE, "Desktop")
    } elseif ($running) {
		$currentDirectory =  (Get-Item -Path ".\" -Verbose).FullName
	}
	[System.Environment]::CurrentDirectory = $currentDirectory
	Write-Verbose "CURRENT_DIRECTORY: $currentDirectory"
    #endregion
}

function SetPreferences([string]$value)
{
    $VerbosePreference = $value
    $InformationPreference = $value
}

function SetPreferencesToSilentlyContinue()
{
    SetPreferences "SilentlyContinue"
}

function CreateDirectory
{
    [CmdletBinding()]
    Param
    (
        [parameter(Position=0, Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$path
    )
    $pathExist = Test-Path $path
	if (-not $pathExist)
	{
        Write-Verbose "Creating directory $path"
		New-Item -ItemType Directory -Force -Path $path
        Write-Host "Directory created"
	}
}

#region ONESCRIPTWAY
function Download([string]$url, [string]$file)
{
    [bool]$output = $false
    $fileExist = Test-Path $file
    if ($fileExist)
    {
        Write-Warning  "$file already exist!"
        $output = $true
        return $output
    }

	Write-Verbose "Starting to download file $url as $file"
    try
    {
	    #Invoke-WebRequest -Uri $url -OutFile $file
	    $webclient = New-Object System.Net.WebClient
        $webclient.DownloadFile($url, $file)
        Write-Host "Download completed."
        $output = $true
    }
    catch
    {
        Write-Error "Caught an exception:"
        Write-Error "Exception Type: $($_.Exception.GetType().FullName)"
        Write-Error "Exception Message: $($_.Exception.Message)"
    }

    return $output
}

function Extract([string]$file, [string]$path)
{
    [bool]$output = $false
    $fileExist = Test-Path $file
    if (-not $fileExist)
    {
        Write-Warning "$file does not exist!"
        return $output
    }
    $pathExist = Test-Path $path
	if ($pathExist)
	{
		Write-Warning "$path already exist, no extraction will be done"
        $output = $true
	} else {
		Write-Verbose "Starting to extract from $file to $path"
		Add-Type -assembly "System.IO.Compression.FileSystem"
		[System.IO.Compression.ZipFile]::ExtractToDirectory($file, $path)
		Write-Host "Extract completed."
        $output = $true
	}
    return $output
}
#endregion