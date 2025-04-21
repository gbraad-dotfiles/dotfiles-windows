# Path to the INI file that defines container image names
$DevenvConfigPath = "$HOME\.config\dotfiles\devenv"

# Function to parse the INI file
function DevEnv-ParseIniFile {
    param (
        [string]$Path
    )
    $Result = @{}
    if (Test-Path $Path) {
        Get-Content $Path | ForEach-Object {
            if ($_ -match '^\s*([^=]+)\s*=\s*(.+)$') {
                $Result[$matches[1].Trim()] = $matches[2].Trim()
            }
        }
    }
    return $Result
}

# Load the INI file into a hashtable
$DevenvConfig = DevEnv-ParseIniFile -Path $DevenvConfigPath

# Function to start a container
function DevEnv-StartContainer {
    param (
        [string]$Prefix
    )
    if ($DevenvConfig.ContainsKey($Prefix)) {
        $Image = $DevenvConfig[$Prefix]
        Write-Host "Starting container with prefix '$Prefix' using image '$Image'..."
        podman run -d --name=$Prefix --hostname "podman-$Prefix" --systemd=always --cap-add=NET_ADMIN --cap-add=NET_RAW --device=/dev/net/tun -v "$HOME\Projects:/home/gbraad/Projects" $Image
    } else {
        Write-Host "Error: Prefix '$Prefix' not found in configuration."
    }
}

# Function to execute as root in the container
function DevEnv-ExecRoot {
    param (
        [string]$Prefix
    )
    Write-Host "Executing as root in container '$Prefix'..."
    podman exec -it $Prefix zsh
}

# Function to execute as user in the container
function DevEnv-ExecUser {
    param (
        [string]$Prefix
    )
    Write-Host "Executing as user in container '$Prefix'..."
    podman exec -it $Prefix su - gbraad
}

# Main devenv function
function DevEnv {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Prefix,

        [Parameter(Mandatory=$true)]
        [ValidateSet("sys", "root", "user")]
        [string]$Command
    )

    # Switch case to invoke appropriate functions
    switch ($Command) {
        "sys" { DevEnv-StartContainer -Prefix $Prefix }
        "root" { DevEnv-ExecRoot -Prefix $Prefix }
        "user" { DevEnv-ExecUser -Prefix $Prefix }
        default { Write-Host "Invalid command '$Command'." }
    }
}
