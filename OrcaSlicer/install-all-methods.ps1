# Install OrcaSlicer Profiles - Try All Methods
# This script tries multiple installation methods to ensure profiles work

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Green
Write-Host "OrcaSlicer Profile Installer (All Methods)" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Green

# Get script directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

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
    Write-Host "WARNING: Could not find OrcaSlicer installation!" -ForegroundColor Yellow
    Write-Host "Will only install to user folder.`n" -ForegroundColor Yellow
}

# Method 1: Installation Directory (Official Method)
if ($OrcaInstall) {
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host "Method 1: Installation Directory" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    
    $ProfilesDir = Join-Path $OrcaInstall "resources\profiles"
    $VendorDir = Join-Path $ProfilesDir "Custom"
    $MachineDir = Join-Path $VendorDir "machine"
    $FilamentDir = Join-Path $VendorDir "filament"
    $ProcessDir = Join-Path $VendorDir "process"
    
    try {
        Write-Host "Creating directory structure..." -ForegroundColor Yellow
        New-Item -ItemType Directory -Force -Path $VendorDir | Out-Null
        New-Item -ItemType Directory -Force -Path $MachineDir | Out-Null
        New-Item -ItemType Directory -Force -Path $FilamentDir | Out-Null
        New-Item -ItemType Directory -Force -Path $ProcessDir | Out-Null
        
        Write-Host "Copying vendor meta file..." -ForegroundColor Yellow
        Copy-Item (Join-Path $ScriptDir "Custom.json") $ProfilesDir -Force -ErrorAction Stop
        Write-Host "  ✓ Custom.json" -ForegroundColor Green
        
        Write-Host "Copying machine profiles..." -ForegroundColor Yellow
        $MachineFiles = @("CR-10S Printer 1 (0.8mm).json", "CR-10S Printer 2 (0.8mm).json")
        foreach ($file in $MachineFiles) {
            $src = Join-Path $ScriptDir $file
            if (Test-Path $src) {
                Copy-Item $src $MachineDir -Force -ErrorAction Stop
                Write-Host "  ✓ $file" -ForegroundColor Green
            }
        }
        
        Write-Host "Copying filament profiles..." -ForegroundColor Yellow
        $FilamentFiles = @("Creality CR-PETG White @0.8mm.json", "Creality CR-PETG Black @0.8mm.json")
        foreach ($file in $FilamentFiles) {
            $src = Join-Path $ScriptDir $file
            if (Test-Path $src) {
                Copy-Item $src $FilamentDir -Force -ErrorAction Stop
                Write-Host "  ✓ $file" -ForegroundColor Green
            }
        }
        
        Write-Host "Copying process profiles..." -ForegroundColor Yellow
        $ProcessFiles = @("0.8mm @Printer-1.json", "0.8mm @Printer-2.json", "CR-PETG @0.8mm.json")
        foreach ($file in $ProcessFiles) {
            $src = Join-Path $ScriptDir $file
            if (Test-Path $src) {
                Copy-Item $src $ProcessDir -Force -ErrorAction Stop
                Write-Host "  ✓ $file" -ForegroundColor Green
            }
        }
        
        Write-Host "`n✓ Method 1: Installation directory - SUCCESS" -ForegroundColor Green
    } catch {
        Write-Host "`n✗ Method 1: Installation directory - FAILED" -ForegroundColor Red
        Write-Host "  Error: $_" -ForegroundColor Red
        Write-Host "  (May need Administrator privileges)" -ForegroundColor Yellow
    }
}

# Method 2: User Folder (Alternative Method)
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Method 2: User Folder" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

$UserConfig = "$env:APPDATA\OrcaSlicer"
$UserMachine = Join-Path $UserConfig "user\default\machine"
$UserFilament = Join-Path $UserConfig "user\default\filament"
$UserProcess = Join-Path $UserConfig "user\default\process"

try {
    Write-Host "Creating user directories if needed..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Force -Path $UserMachine | Out-Null
    New-Item -ItemType Directory -Force -Path $UserFilament | Out-Null
    New-Item -ItemType Directory -Force -Path $UserProcess | Out-Null
    
    Write-Host "Copying machine profiles..." -ForegroundColor Yellow
    $MachineFiles = @("CR-10S Printer 1 (0.8mm).json", "CR-10S Printer 2 (0.8mm).json")
    foreach ($file in $MachineFiles) {
        $src = Join-Path $ScriptDir $file
        if (Test-Path $src) {
            Copy-Item $src $UserMachine -Force -ErrorAction Stop
            Write-Host "  ✓ $file" -ForegroundColor Green
        }
    }
    
    Write-Host "Copying filament profiles..." -ForegroundColor Yellow
    $FilamentFiles = @("Creality CR-PETG White @0.8mm.json", "Creality CR-PETG Black @0.8mm.json")
    foreach ($file in $FilamentFiles) {
        $src = Join-Path $ScriptDir $file
        if (Test-Path $src) {
            Copy-Item $src $UserFilament -Force -ErrorAction Stop
            Write-Host "  ✓ $file" -ForegroundColor Green
        }
    }
    
    Write-Host "Copying process profiles..." -ForegroundColor Yellow
    $ProcessFiles = @("0.8mm @Printer-1.json", "0.8mm @Printer-2.json", "CR-PETG @0.8mm.json")
    foreach ($file in $ProcessFiles) {
        $src = Join-Path $ScriptDir $file
        if (Test-Path $src) {
            Copy-Item $src $UserProcess -Force -ErrorAction Stop
            Write-Host "  ✓ $file" -ForegroundColor Green
        }
    }
    
    Write-Host "`n✓ Method 2: User folder - SUCCESS" -ForegroundColor Green
} catch {
    Write-Host "`n✗ Method 2: User folder - FAILED" -ForegroundColor Red
    Write-Host "  Error: $_" -ForegroundColor Red
}

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "Installation Complete!" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Green

Write-Host "Profiles installed to:" -ForegroundColor Cyan
if ($OrcaInstall) {
    Write-Host "  Installation: $OrcaInstall\resources\profiles\Custom\" -ForegroundColor White
}
Write-Host "  User folder: $UserConfig\user\default\" -ForegroundColor White

Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "  1. Close OrcaSlicer completely" -ForegroundColor White
Write-Host "  2. Delete cache: $UserConfig\system (optional)" -ForegroundColor White
Write-Host "  3. Reopen OrcaSlicer" -ForegroundColor White
Write-Host "  4. Check printer dropdown" -ForegroundColor White
Write-Host "  5. If still not visible, try:" -ForegroundColor White
Write-Host "     File → Import → Import Configs..." -ForegroundColor Cyan
Write-Host "     Select profile type and browse to:" -ForegroundColor Cyan
Write-Host "     $ScriptDir" -ForegroundColor Gray
Write-Host "     Select the JSON files and click Import`n" -ForegroundColor Cyan
