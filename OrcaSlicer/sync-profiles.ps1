# OrcaSlicer Profile Sync Script (PowerShell)
# Syncs printer, material, and process profiles from repo to OrcaSlicer

param(
    [switch]$Force
)

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Green
Write-Host "OrcaSlicer Profile Sync" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Green

# Get script directory (where the profiles are)
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoProfilesDir = $ScriptDir

# Find OrcaSlicer config directory
$OrcaSlicerConfig = $null

# Windows paths
$WindowsPaths = @(
    "$env:APPDATA\OrcaSlicer",
    "$env:LOCALAPPDATA\OrcaSlicer"
)

# macOS paths
$MacPaths = @(
    "$env:HOME\Library\Application Support\OrcaSlicer",
    "$env:HOME\.config\OrcaSlicer"
)

# Linux paths
$LinuxPaths = @(
    "$env:HOME\.config\OrcaSlicer",
    "$env:HOME\.OrcaSlicer"
)

# Try to find OrcaSlicer config
$AllPaths = $WindowsPaths + $MacPaths + $LinuxPaths

foreach ($Path in $AllPaths) {
    if (Test-Path $Path) {
        $OrcaSlicerConfig = $Path
        Write-Host "Found OrcaSlicer config at: $OrcaSlicerConfig" -ForegroundColor Green
        break
    }
}

if (-not $OrcaSlicerConfig) {
    Write-Host "ERROR: Could not find OrcaSlicer config directory!" -ForegroundColor Red
    Write-Host "`nPlease ensure OrcaSlicer is installed and has been run at least once." -ForegroundColor Yellow
    Write-Host "`nTried these locations:" -ForegroundColor Yellow
    foreach ($Path in $AllPaths) {
        Write-Host "  - $Path" -ForegroundColor Gray
    }
    exit 1
}

# Define profile directories
$MachineDir = Join-Path $OrcaSlicerConfig "resources\profiles\machine"
$ProcessDir = Join-Path $OrcaSlicerConfig "resources\profiles\process"
$FilamentDir = Join-Path $OrcaSlicerConfig "resources\profiles\filament"

# Create directories if they don't exist
Write-Host "`nCreating profile directories if needed..." -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path $MachineDir | Out-Null
New-Item -ItemType Directory -Force -Path $ProcessDir | Out-Null
New-Item -ItemType Directory -Force -Path $FilamentDir | Out-Null

# Function to copy file with confirmation
function Copy-ProfileFile {
    param(
        [string]$Source,
        [string]$Destination,
        [string]$Type
    )
    
    if (-not (Test-Path $Source)) {
        Write-Host "  ⚠ Skipping $Type - Source not found: $Source" -ForegroundColor Yellow
        return $false
    }
    
    $DestFile = Join-Path $Destination (Split-Path -Leaf $Source)
    
    if ((Test-Path $DestFile) -and -not $Force) {
        Write-Host "  ⚠ $Type already exists: $DestFile" -ForegroundColor Yellow
        Write-Host "    Use -Force to overwrite" -ForegroundColor Gray
        return $false
    }
    
    try {
        Copy-Item -Path $Source -Destination $DestFile -Force
        Write-Host "  ✓ Copied $Type" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "  ✗ Failed to copy $Type : $_" -ForegroundColor Red
        return $false
    }
}

# Copy printer profiles (machine)
Write-Host "`nCopying Printer Profiles (Machine)..." -ForegroundColor Cyan
$MachineFiles = @(
    "Printer-1.json",
    "Printer-2.json"
)

$MachineCount = 0
foreach ($File in $MachineFiles) {
    $Source = Join-Path $RepoProfilesDir $File
    if (Copy-ProfileFile -Source $Source -Destination $MachineDir -Type $File) {
        $MachineCount++
    }
}

# Copy process profiles
Write-Host "`nCopying Print Settings (Process)..." -ForegroundColor Cyan
$ProcessFiles = @(
    "0.8mm_Printer-1.json",
    "0.8mm_Printer-2.json",
    "CR-PETG_0.8mm_Print_Settings.json"
)

$ProcessCount = 0
foreach ($File in $ProcessFiles) {
    $Source = Join-Path $RepoProfilesDir $File
    if (Copy-ProfileFile -Source $Source -Destination $ProcessDir -Type $File) {
        $ProcessCount++
    }
}

# Copy filament profiles
Write-Host "`nCopying Material Profiles (Filament)..." -ForegroundColor Cyan
$FilamentFiles = @(
    "CR-PETG_White.json",
    "CR-PETG_Black.json"
)

$FilamentCount = 0
foreach ($File in $FilamentFiles) {
    $Source = Join-Path $RepoProfilesDir $File
    if (Copy-ProfileFile -Source $Source -Destination $FilamentDir -Type $File) {
        $FilamentCount++
    }
}

# Summary
Write-Host "`n========================================" -ForegroundColor Green
Write-Host "Sync Complete" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Green

Write-Host "Copied:" -ForegroundColor Cyan
Write-Host "  • $MachineCount printer profile(s)" -ForegroundColor White
Write-Host "  • $ProcessCount print setting(s)" -ForegroundColor White
Write-Host "  • $FilamentCount material profile(s)`n" -ForegroundColor White

Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "  1. Restart OrcaSlicer if it's running" -ForegroundColor White
Write-Host "  2. Select your printer from the dropdown" -ForegroundColor White
Write-Host "  3. Select your material (CR-PETG White/Black)" -ForegroundColor White
Write-Host "  4. Configure Mainsail connection in Printer Settings`n" -ForegroundColor White

Write-Host "Profiles are now available in OrcaSlicer!`n" -ForegroundColor Green
