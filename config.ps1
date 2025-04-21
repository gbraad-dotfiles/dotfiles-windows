function dotconfig {
    param (
        [Parameter(Mandatory=$true)]
        [ValidateSet("install", "update")]
        [string]$Command
    )

    # Path to the shared configuration repository
    $ConfigRepo = "$HOME\.dotconfig"

    function Install-Config {
        Write-Host "Installing shared configuration..."

        # Clone the repository if it doesn't exist
        if (-not (Test-Path $ConfigRepo)) {
            Write-Host "Cloning shared configuration repository..."
            git clone https://github.com/gbraad-dotfiles/shared-config.git $ConfigRepo
        } else {
            Write-Host "Configuration repository already exists at $ConfigRepo."
        }
    }

    function Update-Config {
        Write-Host "Updating shared configuration repository..."

        # Check if the repository exists
        if (Test-Path $ConfigRepo) {
            Set-Location $ConfigRepo
            git pull
            Write-Host "Configuration repository updated!"
        } else {
            Write-Host "Configuration repository not found. Please run 'dotconfig install' first."
        }
    }

    # Delegate to the appropriate function based on the command
    switch ($Command) {
        "install" { Install-Config }
        "update" { Update-Config }
    }
}
