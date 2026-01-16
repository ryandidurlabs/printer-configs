# OrcaSlicer Profile Diagnostic Script
# Checks what OrcaSlicer can actually see

Write-Host "========================================" -ForegroundColor Green
Write-Host "OrcaSlicer Profile Diagnostics" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Green

# Check installation directory
$OrcaInstall = "C:\Program Files\OrcaSlicer"
$InstallProfiles = "$OrcaInstall\resources\profiles"

Write-Host "1. Installation Directory:" -ForegroundColor Cyan
if (Test-Path $InstallProfiles) {
    Write-Host "  ✓ Found: $InstallProfiles" -ForegroundColor Green
    
    $CustomDir = "$InstallProfiles\Custom"
    if (Test-Path $CustomDir) {
        Write-Host "  ✓ Custom vendor folder exists" -ForegroundColor Green
        
        $machineFiles = Get-ChildItem "$CustomDir\machine" -Filter "*.json" -ErrorAction SilentlyContinue
        $filamentFiles = Get-ChildItem "$CustomDir\filament" -Filter "*.json" -ErrorAction SilentlyContinue
        $processFiles = Get-ChildItem "$CustomDir\process" -Filter "*.json" -ErrorAction SilentlyContinue
        
        Write-Host "    Machine files: $($machineFiles.Count)" -ForegroundColor White
        $machineFiles | ForEach-Object { Write-Host "      - $($_.Name)" -ForegroundColor Gray }
        Write-Host "    Filament files: $($filamentFiles.Count)" -ForegroundColor White
        $filamentFiles | ForEach-Object { Write-Host "      - $($_.Name)" -ForegroundColor Gray }
        Write-Host "    Process files: $($processFiles.Count)" -ForegroundColor White
        $processFiles | ForEach-Object { Write-Host "      - $($_.Name)" -ForegroundColor Gray }
        
        # Check vendor meta file
        $vendorFile = "$InstallProfiles\Custom.json"
        if (Test-Path $vendorFile) {
            Write-Host "  ✓ Custom.json exists" -ForegroundColor Green
            try {
                $vendor = Get-Content $vendorFile -Raw | ConvertFrom-Json
                Write-Host "    name: $($vendor.name)" -ForegroundColor White
                Write-Host "    version: $($vendor.version)" -ForegroundColor White
                Write-Host "    machine_list: $($vendor.machine_list.Count) entries" -ForegroundColor White
                Write-Host "    filament_list: $($vendor.filament_list.Count) entries" -ForegroundColor White
                Write-Host "    process_list: $($vendor.process_list.Count) entries" -ForegroundColor White
            } catch {
                Write-Host "    ✗ Custom.json is invalid JSON!" -ForegroundColor Red
            }
        } else {
            Write-Host "  ✗ Custom.json NOT found!" -ForegroundColor Red
        }
    } else {
        Write-Host "  ✗ Custom vendor folder NOT found" -ForegroundColor Red
    }
} else {
    Write-Host "  ✗ Installation directory not found" -ForegroundColor Red
}

# Check user folder
Write-Host "`n2. User Folder:" -ForegroundColor Cyan
$UserConfig = "$env:APPDATA\OrcaSlicer"
$UserMachine = "$UserConfig\user\default\machine"
$UserFilament = "$UserConfig\user\default\filament"
$UserProcess = "$UserConfig\user\default\process"

if (Test-Path $UserMachine) {
    $machineFiles = Get-ChildItem $UserMachine -Filter "*.json" -ErrorAction SilentlyContinue
    Write-Host "  ✓ Machine folder exists: $($machineFiles.Count) files" -ForegroundColor Green
    $machineFiles | ForEach-Object { 
        Write-Host "    - $($_.Name)" -ForegroundColor Gray
        try {
            $content = Get-Content $_.FullName -Raw | ConvertFrom-Json
            Write-Host "      name: $($content.name)" -ForegroundColor DarkGray
        } catch {
            Write-Host "      ✗ Invalid JSON!" -ForegroundColor Red
        }
    }
} else {
    Write-Host "  ✗ Machine folder not found" -ForegroundColor Red
}

if (Test-Path $UserFilament) {
    $filamentFiles = Get-ChildItem $UserFilament -Filter "*.json" -ErrorAction SilentlyContinue
    Write-Host "  ✓ Filament folder exists: $($filamentFiles.Count) files" -ForegroundColor Green
    $filamentFiles | ForEach-Object { Write-Host "    - $($_.Name)" -ForegroundColor Gray }
} else {
    Write-Host "  ✗ Filament folder not found" -ForegroundColor Red
}

if (Test-Path $UserProcess) {
    $processFiles = Get-ChildItem $UserProcess -Filter "*.json" -ErrorAction SilentlyContinue
    Write-Host "  ✓ Process folder exists: $($processFiles.Count) files" -ForegroundColor Green
    $processFiles | ForEach-Object { Write-Host "    - $($_.Name)" -ForegroundColor Gray }
} else {
    Write-Host "  ✗ Process folder not found" -ForegroundColor Red
}

# Check for cache
Write-Host "`n3. Cache:" -ForegroundColor Cyan
$CacheDir = "$UserConfig\system"
if (Test-Path $CacheDir) {
    Write-Host "  Cache folder exists (may need clearing)" -ForegroundColor Yellow
    Write-Host "    Location: $CacheDir" -ForegroundColor Gray
} else {
    Write-Host "  ✓ No cache folder found" -ForegroundColor Green
}

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "Diagnostics Complete" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Green

Write-Host "Recommendations:" -ForegroundColor Yellow
Write-Host "  1. Run install-all-methods.ps1 to install to both locations" -ForegroundColor White
Write-Host "  2. Close OrcaSlicer completely" -ForegroundColor White
Write-Host "  3. Delete cache: Remove-Item '$CacheDir' -Recurse -Force" -ForegroundColor White
Write-Host "  4. Reopen OrcaSlicer" -ForegroundColor White
Write-Host "  5. Try Import function: File → Import → Import Configs...`n" -ForegroundColor White
