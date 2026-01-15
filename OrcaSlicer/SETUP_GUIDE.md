# OrcaSlicer Setup Guide - Step by Step

This guide will walk you through importing and using the printer and material profiles for your CR-10S printers.

## Quick Setup: Use the Sync Script (Easiest!)

**🚀 Fastest Method**: Use the provided sync script to automatically copy all profiles:

### Windows (PowerShell):
```powershell
cd OrcaSlicer
.\sync-profiles.ps1
```

To overwrite existing profiles:
```powershell
.\sync-profiles.ps1 -Force
```

### Mac/Linux (Bash):
```bash
cd OrcaSlicer
chmod +x sync-profiles.sh
./sync-profiles.sh
```

To overwrite existing profiles:
```bash
./sync-profiles.sh --force
```

The script will:
- ✅ Automatically find your OrcaSlicer installation
- ✅ Copy all printer profiles
- ✅ Copy all material profiles  
- ✅ Copy all print settings
- ✅ Create directories if needed

**Then just restart OrcaSlicer and the profiles will be available!**

---

## Manual Setup (If you prefer)

## Step 1: Download the Profiles

1. Make sure you have the latest profiles from GitHub
2. The profiles are in the `OrcaSlicer` folder:
   - `Printer-1.json` - Machine profile for Printer 1
   - `Printer-2.json` - Machine profile for Printer 2
   - `0.8mm_Printer-1.json` - Print settings for Printer 1
   - `0.8mm_Printer-2.json` - Print settings for Printer 2
   - `CR-PETG_White.json` - White PETG material
   - `CR-PETG_Black.json` - Black PETG material
   - `CR-PETG_0.8mm_Print_Settings.json` - PETG print settings

## Step 2: Import Printer Profiles

### Method 1: Import via UI (Easiest)

1. **Open OrcaSlicer**
2. **Click the printer dropdown** at the top (usually says "Generic FFF printer" or similar)
3. **Click "Add Printer"** or the "+" button
4. **Click "Import"** button
5. **Navigate to the OrcaSlicer folder** in your repository
6. **Select `Printer-1.json`**
7. **Click "Open"**
8. **Repeat for Printer 2** - Select `Printer-2.json`

### Method 2: Manual Copy (If Import doesn't work)

1. **Close OrcaSlicer** if it's running
2. **Find OrcaSlicer config folder:**
   - **Windows**: Press `Win+R`, type `%APPDATA%\OrcaSlicer`, press Enter
   - **macOS**: `~/Library/Application Support/OrcaSlicer`
   - **Linux**: `~/.config/OrcaSlicer`
3. **Navigate to**: `resources\profiles\machine\` (or `resources/profiles/machine/` on Mac/Linux)
4. **Copy** `Printer-1.json` and `Printer-2.json` into this folder
5. **Restart OrcaSlicer**

## Step 3: Import Print Settings Profiles

1. **In OrcaSlicer**, go to the **Process** dropdown (next to printer dropdown)
2. **Click the "+" or "Add" button**
3. **Click "Import"**
4. **Select** `0.8mm_Printer-1.json` (for Printer 1) or `0.8mm_Printer-2.json` (for Printer 2)
5. **Click "Open"**

**Note**: You can also manually copy these to `resources\profiles\process\` folder

## Step 4: Import Material Profiles

1. **In OrcaSlicer**, click the **Filament** dropdown (usually shows "Generic PLA")
2. **Click "Add" or "+" button**
3. **Click "Import"**
4. **Select** `CR-PETG_White.json` or `CR-PETG_Black.json`
5. **Click "Open"**
6. **Repeat for the other color**

**Note**: You can also manually copy these to `resources\profiles\filament\` folder

## Step 5: Configure Mainsail Connection

For each printer:

1. **Select the printer** from the dropdown (Printer 1 or Printer 2)
2. **Click the printer icon** or go to **Printer → Printer Settings**
3. **Click the "Machine" tab**
4. **Scroll down to "Host" section**
5. **Set Host Type** to `Mainsail`
6. **Enter IP Address:**
   - Printer 1: `10.1.51.31`
   - Printer 2: `10.1.51.32`
7. **Port**: `7125` (default, usually auto-filled)
8. **Click "Test Connection"** to verify
9. **Click "OK"** to save

## Step 6: Select Profiles for Printing

When you're ready to print:

1. **Select Printer**: Choose "CR-10S Printer 1 (0.8mm)" or "CR-10S Printer 2 (0.8mm)"
2. **Select Process**: Choose "0.8mm @Printer-1" or "0.8mm @Printer-2"
3. **Select Filament**: Choose "Creality CR-PETG White @0.8mm" or "Creality CR-PETG Black @0.8mm"

## Step 7: Verify Settings

Before printing, verify these key settings:

1. **Nozzle Temperature**: Should show 232°C (or 235°C for first layer)
2. **Bed Temperature**: Should show 80°C (or 85°C for first layer)
3. **Layer Height**: Should be 0.4mm
4. **Line Width**: Should be 0.8mm
5. **Retraction**: Should be 1.2mm @ 70mm/s

## Troubleshooting

### Profiles Don't Appear After Import

1. **Restart OrcaSlicer** completely
2. **Check file locations** - make sure files are in correct folders
3. **Check file format** - ensure JSON files are valid (not corrupted)

### Can't Connect to Printer

1. **Verify Mainsail is running**: Open `http://10.1.51.31` or `http://10.1.51.32` in browser
2. **Check IP addresses** are correct
3. **Check firewall** - ensure port 7125 is not blocked
4. **Verify Moonraker** is running on the Pi

### Settings Don't Match

1. **Re-import profiles** - they may have been updated
2. **Check profile inheritance** - some settings inherit from base profiles
3. **Manually verify** key settings match what's in the JSON files

### Import Button Not Working

1. **Use manual copy method** (Method 2 above)
2. **Check file permissions** - ensure you can read the JSON files
3. **Try importing one at a time** instead of batch import

## Quick Reference

**Printer 1:**
- IP: `10.1.51.31`
- Profile: `Printer-1.json`
- Process: `0.8mm_Printer-1.json`

**Printer 2:**
- IP: `10.1.51.32`
- Profile: `Printer-2.json`
- Process: `0.8mm_Printer-2.json`

**Materials:**
- White PETG: `CR-PETG_White.json`
- Black PETG: `CR-PETG_Black.json`

## Next Steps

After setup:
1. **Load a test model** (like a calibration cube)
2. **Slice it** with your profiles
3. **Send to printer** via Mainsail
4. **Monitor in Mainsail** web interface

## Need More Help?

- Check OrcaSlicer documentation: https://github.com/SoftFever/OrcaSlicer
- Verify printer configs are synced from GitHub
- Check Mainsail is accessible in browser
