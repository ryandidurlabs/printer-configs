# Quick Import Guide for OrcaSlicer

## Method 1: File Menu Import (Easiest)

1. **Open OrcaSlicer**

2. **Go to File → Import → Import Configs...**

3. **Select profile type:**
   - Choose "Machine" for printer profiles
   - Choose "Filament" for material profiles
   - Choose "Process" for print settings

4. **Select the JSON file:**
   - Navigate to: `OrcaSlicer` folder in your repo
   - Select the file (e.g., `Printer-1.json`)
   - Click "Open"

5. **Repeat for each profile type**

## Method 2: Printer Dropdown

1. **Click the Printer dropdown** (top-left, shows current printer)

2. **Click "Create Printer"**

3. **In the dialog that opens:**
   - Look for an "Import" button or tab
   - OR click "Import from file"
   - Select `Printer-1.json` or `Printer-2.json`

## Method 3: Filament/Process Dropdowns

1. **Filament Profiles:**
   - Click Filament dropdown (next to printer)
   - Click "Add" or "+" button
   - Click "Import"
   - Select `CR-PETG_White.json` or `CR-PETG_Black.json`

2. **Process Profiles:**
   - Click Process dropdown (next to filament)
   - Click "Add" or "+" button
   - Click "Import"
   - Select `0.8mm_Printer-1.json` or `0.8mm_Printer-2.json`

## Files to Import

**Printer Profiles:**
- `Printer-1.json`
- `Printer-2.json`

**Filament Profiles:**
- `CR-PETG_White.json`
- `CR-PETG_Black.json`

**Process Profiles:**
- `0.8mm_Printer-1.json`
- `0.8mm_Printer-2.json`
- `CR-PETG_0.8mm_Print_Settings.json`

## Location

All files are in: `OrcaSlicer` folder in your repository

Full path: `C:\Users\RyanDidur\OneDrive - Home\Repos\3d Printing\Printer-1\OrcaSlicer\`

## After Import

1. Profiles should appear in the dropdowns
2. Select your printer, filament, and process
3. Configure Mainsail connection in Printer Settings
