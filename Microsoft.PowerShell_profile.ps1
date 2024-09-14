function git_newbranch {
    <#
    .SYNOPSIS
        Creates a new local branch from a remote source branch and pushes it to the remote repository.

    .DESCRIPTION
        This function automates the creation of a new local branch based on a specified remote branch.
        It also pushes the new branch to the remote repository to ensure seamless operation with the gitc command.

    .PARAMETER LocalBranch
        The name of the new local branch to create.

    .PARAMETER RemoteSourceBranch
        The name of the remote branch to base the new local branch on. Defaults to 'main' if not specified.

    .EXAMPLE
        git_newbranch -l my_local_branch_name -r my_remote_source_branch
        Creates and pushes a new local branch 'my_local_branch_name' based on 'my_remote_source_branch'.

    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0, HelpMessage = "Enter the new local branch name.")]
        [Alias("l")]
        [string]$LocalBranch,

        [Parameter(Mandatory = $false, Position = 1, HelpMessage = "Enter the remote source branch name.")]
        [Alias("r")]
        [string]$RemoteSourceBranch = "main"
    )

    try {
        # Fetch the latest branches from remote
        Write-Host "Fetching latest branches from remote..." -ForegroundColor Cyan
        git fetch
        if ($LASTEXITCODE -ne 0) {
            throw "Error fetching from remote repository."
        }

        # Create new local branch from remote source branch
        Write-Host "Creating new local branch '$LocalBranch' from 'origin/$RemoteSourceBranch'..." -ForegroundColor Cyan
        git checkout -b $LocalBranch origin/$RemoteSourceBranch
        if ($LASTEXITCODE -ne 0) {
            throw "Error creating new local branch."
        }

        # Push the new local branch to remote
        Write-Host "Pushing new branch '$LocalBranch' to remote repository..." -ForegroundColor Cyan
        git push -u origin $LocalBranch
        if ($LASTEXITCODE -ne 0) {
            throw "Error pushing new branch to remote repository."
        }

        Write-Host "Successfully created and pushed new branch '$LocalBranch'." -ForegroundColor Green
    }
    catch {
        Write-Error $_
    }
}

function gitc {
    <#
    .SYNOPSIS
        Adds all changes, commits with the provided message, and pushes to the remote repository.

    .DESCRIPTION
        This function encapsulates the Git commit process by automating the addition of all changes,
        committing with a message, and pushing to the remote repository.

    .PARAMETER Message
        The commit message to use for the Git commit.

    .EXAMPLE
        gitc "Initial Commit"
        Commits all changes with the message 'Initial Commit' and pushes to the remote repository.

    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0, HelpMessage = "Enter the commit message.")]
        [string]$Message
    )

    try {
        # Add all changes
        Write-Host "Adding all changes..." -ForegroundColor Cyan
        git add -A
        if ($LASTEXITCODE -ne 0) {
            throw "Error adding changes."
        }

        # Commit with the message
        Write-Host "Committing changes with message: '$Message'" -ForegroundColor Cyan
        git commit -m "$Message"
        if ($LASTEXITCODE -ne 0) {
            throw "Error committing changes."
        }

        # Push to the remote
        Write-Host "Pushing to remote repository..." -ForegroundColor Cyan
        git push
        if ($LASTEXITCODE -ne 0) {
            throw "Error pushing to remote repository."
        }

        Write-Host "Successfully pushed to remote repository." -ForegroundColor Green
    }
    catch {
        Write-Error $_
    }
}

function gits {
    <#
    .SYNOPSIS
        Displays the status of the current Git repository.

    .DESCRIPTION
        The 'gits' function is a shortcut for the 'git status' command.
        It shows the working tree status, including staged, unstaged, and untracked files.

    .EXAMPLE
        gits
        Displays the current status of the Git repository.

    #>

    [CmdletBinding()]
    param()

    try {
        # Display Git status
        Write-Host "Displaying Git status..." -ForegroundColor Cyan
        git status
        if ($LASTEXITCODE -ne 0) {
            throw "Error retrieving Git status."
        }
    }
    catch {
        Write-Error $_
    }
}
