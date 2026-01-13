# GitHub Setup Script for Printer Configurations
# This script helps set up your GitHub repository

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "GitHub Repository Setup" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Check if git is initialized
if (-not (Test-Path .git)) {
    Write-Host "Error: Git repository not initialized!" -ForegroundColor Red
    exit 1
}

# Check current status
Write-Host "Current git status:" -ForegroundColor Yellow
git status --short
Write-Host ""

# Get GitHub username
$username = Read-Host "Enter your GitHub username"
$repoName = Read-Host "Enter repository name (default: printer-configs)"

if ([string]::IsNullOrWhiteSpace($repoName)) {
    $repoName = "printer-configs"
}

$repoUrl = "https://github.com/$username/$repoName.git"
$sshUrl = "git@github.com:$username/$repoName.git"

Write-Host ""
Write-Host "Repository will be created at: $repoUrl" -ForegroundColor Green
Write-Host ""

# Ask for authentication method
Write-Host "Choose authentication method:" -ForegroundColor Yellow
Write-Host "1. HTTPS (Personal Access Token)"
Write-Host "2. SSH (Requires SSH key setup)"
$authChoice = Read-Host "Enter choice (1 or 2)"

if ($authChoice -eq "2") {
    $useSsh = $true
    $finalUrl = $sshUrl
} else {
    $useSsh = $false
    $finalUrl = $repoUrl
}

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Next Steps:" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Create the repository on GitHub:" -ForegroundColor Yellow
Write-Host "   Go to: https://github.com/new" -ForegroundColor White
Write-Host "   Repository name: $repoName" -ForegroundColor White
Write-Host "   Description: CR-10S Printer Configurations - Klipper/MainsailOS" -ForegroundColor White
Write-Host "   Visibility: Private (recommended)" -ForegroundColor White
Write-Host "   DO NOT check 'Initialize with README'" -ForegroundColor Red
Write-Host "   Click 'Create repository'" -ForegroundColor White
Write-Host ""

$continue = Read-Host "Have you created the repository on GitHub? (y/n)"

if ($continue -ne "y" -and $continue -ne "Y") {
    Write-Host ""
    Write-Host "Please create the repository first, then run this script again." -ForegroundColor Yellow
    exit 0
}

Write-Host ""
Write-Host "Adding remote and pushing..." -ForegroundColor Yellow

# Add remote
git remote add origin $finalUrl 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) {
    # Remote might already exist, try to set URL
    git remote set-url origin $finalUrl
}

Write-Host "Remote added: $finalUrl" -ForegroundColor Green

# Push to GitHub
Write-Host ""
Write-Host "Pushing to GitHub..." -ForegroundColor Yellow
Write-Host "You may be prompted for credentials." -ForegroundColor Yellow
Write-Host ""

if ($useSsh) {
    Write-Host "Using SSH authentication..." -ForegroundColor Cyan
    git push -u origin main
} else {
    Write-Host "Using HTTPS authentication..." -ForegroundColor Cyan
    Write-Host "When prompted for password, use a Personal Access Token:" -ForegroundColor Yellow
    Write-Host "  - GitHub → Settings → Developer settings → Personal access tokens" -ForegroundColor White
    Write-Host "  - Generate new token (classic) with 'repo' scope" -ForegroundColor White
    Write-Host ""
    git push -u origin main
}

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "Success! Repository is now on GitHub!" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Repository URL: $repoUrl" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "1. Set up Printer 1's Raspberry Pi (see QUICK_SYNC_GUIDE.md)" -ForegroundColor White
    Write-Host "2. Set up Printer 2's Raspberry Pi (see QUICK_SYNC_GUIDE.md)" -ForegroundColor White
} else {
    Write-Host ""
    Write-Host "=========================================" -ForegroundColor Red
    Write-Host "Push failed. Check the error above." -ForegroundColor Red
    Write-Host "=========================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "Common issues:" -ForegroundColor Yellow
    Write-Host "- Authentication failed: Check your token/SSH key" -ForegroundColor White
    Write-Host "- Repository not found: Make sure you created it on GitHub" -ForegroundColor White
    Write-Host "- Permission denied: Verify repository name and username" -ForegroundColor White
}
