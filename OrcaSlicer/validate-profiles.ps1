# OrcaSlicer Profile Validation Script
# Validates JSON syntax and structure against OrcaSlicer requirements

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Green
Write-Host "OrcaSlicer Profile Validator" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Green

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProfilesDir = $ScriptDir

# Find OrcaSlicer config
$OrcaConfig = "$env:APPDATA\OrcaSlicer"
$UserFolder = "$OrcaConfig\user\default"

Write-Host "OrcaSlicer Config: $OrcaConfig" -ForegroundColor Cyan
Write-Host "User Folder: $UserFolder`n" -ForegroundColor Cyan

# Required fields for machine profiles
$RequiredMachineFields = @(
    "type",
    "name",
    "from",
    "instantiation",
    "gcode_flavor",
    "printable_area",
    "printable_height"
)

# Required fields for filament profiles
$RequiredFilamentFields = @(
    "type",
    "name",
    "from",
    "instantiation",
    "filament_id",
    "compatible_printers"
)

# Validate machine profiles
Write-Host "Validating Machine Profiles..." -ForegroundColor Yellow
$machineFiles = @("Printer-1-Standalone.json", "Printer-2-Standalone.json", "Printer-1.json", "Printer-2.json")

foreach ($file in $machineFiles) {
    $filePath = Join-Path $ProfilesDir $file
    if (Test-Path $filePath) {
        Write-Host "`n  Checking: $file" -ForegroundColor Cyan
        try {
            $content = Get-Content $filePath -Raw | ConvertFrom-Json
            Write-Host "    ✓ Valid JSON" -ForegroundColor Green
            
            # Check required fields
            $missing = @()
            foreach ($field in $RequiredMachineFields) {
                if (-not $content.$field) {
                    $missing += $field
                }
            }
            
            if ($missing.Count -eq 0) {
                Write-Host "    ✓ All required fields present" -ForegroundColor Green
            } else {
                Write-Host "    ✗ Missing fields: $($missing -join ', ')" -ForegroundColor Red
            }
            
            # Check specific values
            if ($content.type -ne "machine") {
                Write-Host "    ✗ type should be 'machine', found: $($content.type)" -ForegroundColor Red
            } else {
                Write-Host "    ✓ type is correct" -ForegroundColor Green
            }
            
            if ($content.from -ne "user") {
                Write-Host "    ⚠ from is '$($content.from)', should be 'user' for custom profiles" -ForegroundColor Yellow
            } else {
                Write-Host "    ✓ from is correct" -ForegroundColor Green
            }
            
            if ($content.instantiation -ne "true") {
                Write-Host "    ⚠ instantiation should be 'true'" -ForegroundColor Yellow
            }
            
        } catch {
            Write-Host "    ✗ JSON Error: $_" -ForegroundColor Red
        }
    }
}

# Validate filament profiles
Write-Host "`nValidating Filament Profiles..." -ForegroundColor Yellow
$filamentFiles = @("CR-PETG_White-Standalone.json", "CR-PETG_Black-Standalone.json", "CR-PETG_White.json", "CR-PETG_Black.json")

foreach ($file in $filamentFiles) {
    $filePath = Join-Path $ProfilesDir $file
    if (Test-Path $filePath) {
        Write-Host "`n  Checking: $file" -ForegroundColor Cyan
        try {
            $content = Get-Content $filePath -Raw | ConvertFrom-Json
            Write-Host "    ✓ Valid JSON" -ForegroundColor Green
            
            # Check required fields
            $missing = @()
            foreach ($field in $RequiredFilamentFields) {
                if (-not $content.$field) {
                    $missing += $field
                }
            }
            
            if ($missing.Count -eq 0) {
                Write-Host "    ✓ All required fields present" -ForegroundColor Green
            } else {
                Write-Host "    ✗ Missing fields: $($missing -join ', ')" -ForegroundColor Red
            }
            
            # Check specific values
            if ($content.type -ne "filament") {
                Write-Host "    ✗ type should be 'filament', found: $($content.type)" -ForegroundColor Red
            } else {
                Write-Host "    ✓ type is correct" -ForegroundColor Green
            }
            
            if ($content.compatible_printers) {
                Write-Host "    ✓ compatible_printers: $($content.compatible_printers -join ', ')" -ForegroundColor Green
            } else {
                Write-Host "    ⚠ compatible_printers is missing or empty" -ForegroundColor Yellow
            }
            
        } catch {
            Write-Host "    ✗ JSON Error: $_" -ForegroundColor Red
        }
    }
}

# Check if files are in correct location
Write-Host "`nChecking File Locations..." -ForegroundColor Yellow
if (Test-Path $UserFolder) {
    Write-Host "  User folder exists: $UserFolder" -ForegroundColor Green
    
    $machineDir = Join-Path $UserFolder "machine"
    $filamentDir = Join-Path $UserFolder "filament"
    $processDir = Join-Path $UserFolder "process"
    
    Write-Host "`n  Machine folder:" -ForegroundColor Cyan
    if (Test-Path $machineDir) {
        $machineFiles = Get-ChildItem $machineDir -Filter "*.json"
        Write-Host "    Found $($machineFiles.Count) JSON files" -ForegroundColor White
        $machineFiles | ForEach-Object { Write-Host "      - $($_.Name)" -ForegroundColor Gray }
    } else {
        Write-Host "    ✗ Not found" -ForegroundColor Red
    }
    
    Write-Host "`n  Filament folder:" -ForegroundColor Cyan
    if (Test-Path $filamentDir) {
        $filamentFiles = Get-ChildItem $filamentDir -Filter "*.json"
        Write-Host "    Found $($filamentFiles.Count) JSON files" -ForegroundColor White
        $filamentFiles | ForEach-Object { Write-Host "      - $($_.Name)" -ForegroundColor Gray }
    } else {
        Write-Host "    ✗ Not found" -ForegroundColor Red
    }
} else {
    Write-Host "  ✗ User folder not found: $UserFolder" -ForegroundColor Red
}

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "Validation Complete" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Green
