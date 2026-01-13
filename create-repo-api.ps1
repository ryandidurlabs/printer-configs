# Create GitHub repository using API with stored credentials
# This attempts to use git credential helper to get a token

$repoName = "printer-configs"
$description = "CR-10S Printer Configurations - Klipper/MainsailOS"
$username = "ryandidur"

Write-Host "Creating repository: $username/$repoName" -ForegroundColor Cyan

# Try to get credentials from git credential helper
$credInput = "protocol=https`nhost=github.com`npath=`n"
$credOutput = $credInput | git credential fill

$token = $null
if ($credOutput) {
    foreach ($line in $credOutput) {
        if ($line -match "^password=(.+)$") {
            $token = $matches[1]
            break
        }
    }
}

if (-not $token) {
    Write-Host "Could not retrieve token from credential helper." -ForegroundColor Yellow
    Write-Host "Attempting to create repository via API anyway..." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "If this fails, please:" -ForegroundColor Yellow
    Write-Host "1. Create repo manually at: https://github.com/new" -ForegroundColor White
    Write-Host "2. Then run: git push -u origin main" -ForegroundColor White
    Write-Host ""
}

# Create repository via API
$body = @{
    name = $repoName
    description = $description
    private = $true
    auto_init = $false
} | ConvertTo-Json

$headers = @{
    "Accept" = "application/vnd.github.v3+json"
    "Content-Type" = "application/json"
}

if ($token) {
    $headers["Authorization"] = "token $token"
    Write-Host "Using token for authentication..." -ForegroundColor Green
} else {
    Write-Host "Attempting without explicit token (may use stored credentials)..." -ForegroundColor Yellow
}

try {
    $response = Invoke-RestMethod -Uri "https://api.github.com/user/repos" -Method Post -Headers $headers -Body $body -ErrorAction Stop
    
    Write-Host ""
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "Repository created successfully!" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Repository URL: $($response.html_url)" -ForegroundColor Cyan
    Write-Host "Clone URL: $($response.clone_url)" -ForegroundColor Cyan
    Write-Host ""
    
    # Update remote if needed
    $currentRemote = git remote get-url origin 2>$null
    if ($currentRemote -ne $response.clone_url) {
        Write-Host "Updating remote URL..." -ForegroundColor Yellow
        git remote set-url origin $response.clone_url
    }
    
    # Push code
    Write-Host "Pushing code to repository..." -ForegroundColor Yellow
    git push -u origin main
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "=========================================" -ForegroundColor Green
        Write-Host "Success! Everything is set up!" -ForegroundColor Green
        Write-Host "=========================================" -ForegroundColor Green
        Write-Host ""
        Write-Host "Repository: $($response.html_url)" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Next: Set up your Raspberry Pis (see QUICK_SYNC_GUIDE.md)" -ForegroundColor Yellow
    }
    
} catch {
    Write-Host ""
    Write-Host "API Error: $($_.Exception.Message)" -ForegroundColor Red
    
    if ($_.Exception.Response.StatusCode -eq 401) {
        Write-Host ""
        Write-Host "Authentication failed. Please create the repository manually:" -ForegroundColor Yellow
        Write-Host "1. Go to: https://github.com/new" -ForegroundColor White
        Write-Host "2. Name: $repoName" -ForegroundColor White
        Write-Host "3. Description: $description" -ForegroundColor White
        Write-Host "4. Private: Yes" -ForegroundColor White
        Write-Host "5. DO NOT initialize with README" -ForegroundColor Red
        Write-Host "6. Click Create repository" -ForegroundColor White
        Write-Host ""
        Write-Host "Then run: git push -u origin main" -ForegroundColor Cyan
    } elseif ($_.Exception.Response.StatusCode -eq 422) {
        Write-Host ""
        Write-Host "Repository might already exist or name is invalid." -ForegroundColor Yellow
        Write-Host "Checking if we can push to existing repo..." -ForegroundColor Yellow
        git push -u origin main 2>&1
    } else {
        Write-Host ""
        Write-Host "Unexpected error. Status: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
    }
}
