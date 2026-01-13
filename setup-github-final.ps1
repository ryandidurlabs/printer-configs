# Final GitHub Setup - Creates repo and pushes code
# This uses git credential helper to authenticate

$repoName = "printer-configs"
$description = "CR-10S Printer Configurations - Klipper/MainsailOS"

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Setting up GitHub Repository" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Get username from email
$email = git config --global user.email
$username = "ryandidur"  # Based on email domain didurlabs.com

Write-Host "Repository: $username/$repoName" -ForegroundColor Green
Write-Host ""

# Check if remote exists
$remoteExists = git remote get-url origin 2>$null
if ($remoteExists) {
    Write-Host "Remote already configured: $remoteExists" -ForegroundColor Yellow
} else {
    Write-Host "Configuring remote..." -ForegroundColor Yellow
    git remote add origin "https://github.com/$username/$repoName.git"
}

Write-Host ""
Write-Host "Attempting to create repository via GitHub web interface..." -ForegroundColor Yellow
Write-Host ""

# Open GitHub new repo page with pre-filled values
$url = "https://github.com/new?name=$repoName&description=$([System.Web.HttpUtility]::UrlEncode($description))&private=true"
Write-Host "Opening GitHub in your browser..." -ForegroundColor Cyan
Write-Host "URL: $url" -ForegroundColor Gray

Start-Process $url

Write-Host ""
Write-Host "=========================================" -ForegroundColor Yellow
Write-Host "Please complete these steps:" -ForegroundColor Yellow
Write-Host "=========================================" -ForegroundColor Yellow
Write-Host "1. The GitHub page should be open in your browser" -ForegroundColor White
Write-Host "2. Verify the repository name: $repoName" -ForegroundColor White
Write-Host "3. Verify description: $description" -ForegroundColor White
Write-Host "4. Make sure 'Private' is selected" -ForegroundColor White
Write-Host "5. DO NOT check 'Initialize with README'" -ForegroundColor Red
Write-Host "6. Click 'Create repository'" -ForegroundColor White
Write-Host ""
Write-Host "After creating, press Enter here to push your code..." -ForegroundColor Cyan
Read-Host

Write-Host ""
Write-Host "Pushing code to GitHub..." -ForegroundColor Yellow

# Try to push
$pushResult = git push -u origin main 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "Success! Repository is on GitHub!" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Repository URL: https://github.com/$username/$repoName" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "1. Set up Printer 1's Raspberry Pi (see QUICK_SYNC_GUIDE.md)" -ForegroundColor White
    Write-Host "2. Set up Printer 2's Raspberry Pi (see QUICK_SYNC_GUIDE.md)" -ForegroundColor White
} else {
    Write-Host ""
    Write-Host "Push result:" -ForegroundColor Yellow
    Write-Host $pushResult -ForegroundColor White
    Write-Host ""
    Write-Host "If authentication failed, you may need to:" -ForegroundColor Yellow
    Write-Host "1. Use a Personal Access Token instead of password" -ForegroundColor White
    Write-Host "2. Or set up SSH keys" -ForegroundColor White
}
