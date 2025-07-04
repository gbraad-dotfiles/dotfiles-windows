param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$DistroName,

    [Parameter(Mandatory = $true, Position = 1)]
    [ValidateSet("create", "exec", "start", "remove")]
    [string]$Action,

    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Args
)

$HomeDir = $env:USERPROFILE
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$IniFile = Join-Path $HomeDir "wslbox.ini"

function Parse-IniFile {
    param($Path)
    $ini = @{}
    $section = ""
    foreach ($line in Get-Content $Path) {
        $line = $line.Trim()
        if ($line -match '^\[(.+)\]$') {
            $section = $matches[1]
            $ini[$section] = @{}
        } elseif ($line -match '^(.+?)=(.+)$' -and $section) {
            $key = $matches[1].Trim()
            $val = $matches[2].Trim()
            $ini[$section][$key] = $val
        }
    }
    return $ini
}

$ini = Parse-IniFile $IniFile
$User = $ini["wslenv"]["user"]
$Images = $ini["images"]

$BaseDir = "$env:LOCALAPPDATA\Wslbox\$DistroName"
$RootFsPath = "$BaseDir\rootfs.tar.gz"
$DefaultWSLDir = "$BaseDir\wslroot"

function Distro-Exists {
    wsl -l -q | Where-Object { $_ -eq $DistroName }
}

function Create-Distro {
    if (Distro-Exists) {
        Write-Host "$DistroName already exists. Skipping import."
        return
    }
    $url = $Images[$DistroName]
    if (-not $url) {
        Write-Host "Image for $DistroName not found in INI."
        exit 1
    }
    if (-not (Test-Path $BaseDir)) { New-Item -ItemType Directory -Path $BaseDir | Out-Null }
    Write-Host "Downloading $url..."
    Invoke-WebRequest -Uri $url -OutFile $RootFsPath
    Write-Host "Importing $DistroName into WSL..."
    wsl --import $DistroName $DefaultWSLDir $RootFsPath
    Write-Host "Imported $DistroName"
}

function Exec-Distro {
    $cmd = $Args -join " "
    if (-not (Distro-Exists)) { Write-Error "$DistroName not found. Run create first."; exit 1 }
    if (-not $cmd) { $cmd = "bash" }
    wsl -d $DistroName -- $cmd
}

function Remove-Distro {
    if (-not (Distro-Exists)) { Write-Error "$DistroName not found."; exit 1 }
    Write-Host "Unregistering $DistroName..."
    wsl --unregister $DistroName
    if (Test-Path $BaseDir) { Remove-Item -Recurse -Force $BaseDir }
    Write-Host "$DistroName removed."
}

function Start-Distro {
    if (-not (Distro-Exists)) { Write-Error "$DistroName not found. Run create first."; exit 1 }
    wsl -d $DistroName
}

switch ($Action) {
    "create" { Create-Distro }
    "exec"   { Exec-Distro }
    "remove" { Remove-Distro }
    "start"  { Start-Distro }
    default  { Write-Error "Unknown action: $Action" }
}
