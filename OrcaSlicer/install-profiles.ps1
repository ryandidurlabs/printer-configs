# OrcaSlicer Profile Installation Script
# Installs profiles to OrcaSlicer installation directory following official structure

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Green
Write-Host "OrcaSlicer Profile Installer" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Green

# Find OrcaSlicer installation
$PossiblePaths = @(
    "C:\Program Files\OrcaSlicer",
    "C:\Program Files (x86)\OrcaSlicer",
    "$env:LOCALAPPDATA\Programs\OrcaSlicer"
)

$OrcaInstall = $null
foreach ($path in $PossiblePaths) {
    if (Test-Path $path) {
        $OrcaInstall = $path
        Write-Host "Found OrcaSlicer at: $OrcaInstall" -ForegroundColor Green
        break
    }
}

if (-not $OrcaInstall) {
    Write-Host "ERROR: Could not find OrcaSlicer installation!" -ForegroundColor Red
    Write-Host "`nPlease specify the installation path:" -ForegroundColor Yellow
    $OrcaInstall = Read-Host "Enter OrcaSlicer installation path"
    if (-not (Test-Path $OrcaInstall)) {
        Write-Host "ERROR: Path does not exist!" -ForegroundColor Red
        exit 1
    }
}

$ProfilesDir = Join-Path $OrcaInstall "resources\profiles"
$VendorDir = Join-Path $ProfilesDir "Custom"
$MachineDir = Join-Path $VendorDir "machine"
$FilamentDir = Join-Path $VendorDir "filament"
$ProcessDir = Join-Path $VendorDir "process"

# Get script directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "`nCreating directory structure..." -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path $VendorDir | Out-Null
New-Item -ItemType Directory -Force -Path $MachineDir | Out-Null
New-Item -ItemType Directory -Force -Path $FilamentDir | Out-Null
New-Item -ItemType Directory -Force -Path $ProcessDir | Out-Null
Write-Host "  ✓ Directories created" -ForegroundColor Green

Write-Host "`nCopying vendor meta file..." -ForegroundColor Cyan
$VendorFile = Join-Path $ScriptDir "Custom.json"
if (Test-Path $VendorFile) {
    Copy-Item $VendorFile $ProfilesDir -Force
    Write-Host "  ✓ Custom.json copied" -ForegroundColor Green
} else {
    Write-Host "  ✗ Custom.json not found!" -ForegroundColor Red
}

Write-Host "`nCopying machine profiles..." -ForegroundColor Cyan
$MachineFiles = @(
    "CR-10S Printer 1 (0.8mm).json",
    "CR-10S Printer 2 (0.8mm).json"
)
foreach ($file in $MachineFiles) {
    $src = Join-Path $ScriptDir $file
    if (Test-Path $src) {
        Copy-Item $src $MachineDir -Force
        Write-Host "  ✓ $file" -ForegroundColor Green
    } else {
        Write-Host "  ✗ $file not found!" -ForegroundColor Red
    }
}

Write-Host "`nCopying filament profiles..." -ForegroundColor Cyan
$FilamentFiles = @(
    "Creality CR-PETG White @0.8mm.json",
    "Creality CR-PETG Black @0.8mm.json"
)
foreach ($file in $FilamentFiles) {
    $src = Join-Path $ScriptDir $file
    if (Test-Path $src) {
        Copy-Item $src $FilamentDir -Force
        Write-Host "  ✓ $file" -ForegroundColor Green
    } else {
        Write-Host "  ✗ $file not found!" -ForegroundColor Red
    }
}

Write-Host "`nCopying process profiles..." -ForegroundColor Cyan
$ProcessFiles = @(
    "0.8mm @Printer-1.json",
    "0.8mm @Printer-2.json",
    "CR-PETG 0.8mm Print Settings.json"
)
foreach ($file in $ProcessFiles) {
    $src = Join-Path $ScriptDir $file
    if (Test-Path $src) {
        Copy-Item $src $ProcessDir -Force
        Write-Host "  ✓ $file" -ForegroundColor Green
    } else {
        Write-Host "  ✗ $file not found!" -ForegroundColor Red
    }
}

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "Installation Complete!" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Green

Write-Host "Profiles installed to:" -ForegroundColor Cyan
Write-Host "  $ProfilesDir\Custom\" -ForegroundColor White
Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "  1. Close OrcaSlicer if it's running" -ForegroundColor White
Write-Host "  2. Reopen OrcaSlicer" -ForegroundColor White
Write-Host "  3. Check printer dropdown - your printers should appear!`n" -ForegroundColor White

Write-Host "If you get permission errors, run PowerShell as Administrator.`n" -ForegroundColor Yellow
