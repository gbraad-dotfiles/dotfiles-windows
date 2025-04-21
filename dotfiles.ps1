function dotfiles {
    param (
        [Parameter(Mandatory=$true)]
        [ValidateSet("install", "update")]
        [string]$Command
    )

    # Set the dotfiles repository path to ~/.dotfiles
    $Home = [Environment]::GetFolderPath("UserProfile")
    $DotfilesRepo = "$Home\.dotfiles"

    function Install-Dotfiles {
        Write-Host "Installing dotfiles..."

        # Clone the repository if it doesn't exist
        if (-not (Test-Path $DotfilesRepo)) {
            Write-Host "Cloning dotfiles repository..."
            git clone https://github.com/gbraad-dotfiles/dotfiles-windows.git $DotfilesRepo
        } else {
            Write-Host "Dotfiles repository already exists at $DotfilesRepo."
        }

        # Create symbolic links for the files
        $FilesToLink = @(
            @{ Target = "$DotfilesRepo\Microsoft.PowerShell_profile.ps1"; Link = $PROFILE }
            #@{ Target = "$DotfilesRepo\.someconfig"; Link = "$Home\.someconfig" }
        )

        foreach ($File in $FilesToLink) {
            $Target = $File.Target
            $Link = $File.Link

            # Remove existing file or link if it exists
            if (Test-Path $Link) {
                Remove-Item -Path $Link -Force
            }

            # Create the symbolic link
            Write-Host "Creating symbolic link: $Link -> $Target"
            New-Item -ItemType SymbolicLink -Path $Link -Target $Target
        }

        Write-Host "Dotfiles installation complete!"
    }

    function Update-Dotfiles {
        Write-Host "Updating dotfiles repository..."

        # Check if the repository exists
        if (Test-Path $DotfilesRepo) {
            Set-Location $DotfilesRepo
            git pull
            Write-Host "Dotfiles repository updated!"
        } else {
            Write-Host "Dotfiles repository not found. Please run 'dotfiles install' first."
        }
    }

    # Delegate to the appropriate function based on the command
    switch ($Command) {
        "install" { Install-Dotfiles }
        "update" { Update-Dotfiles }
    }
}
