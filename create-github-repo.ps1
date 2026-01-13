# Create GitHub Repository using API
# This script creates the repository on GitHub and then pushes the code

$repoName = "printer-configs"
$description = "CR-10S Printer Configurations - Klipper/MainsailOS"
$isPrivate = $true

Write-Host "Creating GitHub repository: $repoName" -ForegroundColor Cyan

# Try to get GitHub username from git config or common patterns
$email = git config --global user.email
$possibleUsernames = @("ryandidur", "ryandidur", ($email -replace '@.*', ''))

# Try to create repo - will prompt for credentials if needed
$username = "ryandidur"  # Based on email domain

Write-Host "Attempting to create repository for user: $username" -ForegroundColor Yellow
Write-Host ""

# Create repository via GitHub API
$body = @{
    name = $repoName
    description = $description
    private = $isPrivate
    auto_init = $false
} | ConvertTo-Json

Write-Host "Repository will be created at: https://github.com/$username/$repoName" -ForegroundColor Green
Write-Host ""
Write-Host "Note: This requires GitHub authentication." -ForegroundColor Yellow
Write-Host "If this fails, you can create it manually at: https://github.com/new" -ForegroundColor Yellow
Write-Host ""

try {
    # Try to create via API (requires authentication)
    $headers = @{
        "Accept" = "application/vnd.github.v3+json"
        "Content-Type" = "application/json"
    }
    
    $response = Invoke-RestMethod -Uri "https://api.github.com/user/repos" -Method Post -Headers $headers -Body $body -ErrorAction Stop
    
    Write-Host "Repository created successfully!" -ForegroundColor Green
    Write-Host "URL: $($response.html_url)" -ForegroundColor Cyan
    
    # Update remote URL with actual username
    git remote set-url origin $response.clone_url
    
    # Push code
    Write-Host ""
    Write-Host "Pushing code to repository..." -ForegroundColor Yellow
    git push -u origin main
    
    Write-Host ""
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "Success! Repository is ready!" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "Repository: $($response.html_url)" -ForegroundColor Cyan
    
} catch {
    Write-Host ""
    Write-Host "API creation failed (authentication required)." -ForegroundColor Yellow
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please create the repository manually:" -ForegroundColor Yellow
    Write-Host "1. Go to: https://github.com/new" -ForegroundColor White
    Write-Host "2. Repository name: $repoName" -ForegroundColor White
    Write-Host "3. Description: $description" -ForegroundColor White
    Write-Host "4. Visibility: Private" -ForegroundColor White
    Write-Host "5. DO NOT check 'Initialize with README'" -ForegroundColor Red
    Write-Host "6. Click 'Create repository'" -ForegroundColor White
    Write-Host ""
    Write-Host "Then run:" -ForegroundColor Yellow
    Write-Host "  git push -u origin main" -ForegroundColor White
}
