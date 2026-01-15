# IMPORT YOUR PROFILES NOW

## Use the Import Function (This Actually Works!)

OrcaSlicer requires profiles to be **imported via the UI**, not just placed in folders.

### Step-by-Step Import:

1. **Open OrcaSlicer**

2. **File → Import → Import Configs...**

3. **For Printers (Machine Profiles):**
   - When prompted, select **"Machine"** or **"Printer"** as the profile type
   - Browse to: `C:\Users\RyanDidur\OneDrive - Home\Repos\3d Printing\Printer-1\OrcaSlicer\`
   - Select:
     - `Printer-1-Standalone.json`
     - `Printer-2-Standalone.json`
   - Click **"Import"**
   - **Check the printer dropdown** - they should appear!

4. **For Materials (Filament Profiles):**
   - **File → Import → Import Configs...** (again)
   - Select **"Filament"** as the profile type
   - Browse to the same folder
   - Select:
     - `CR-PETG_White-Standalone.json`
     - `CR-PETG_Black-Standalone.json`
   - Click **"Import"**
   - **Check the filament dropdown** - they should appear!

5. **For Print Settings (Process Profiles):**
   - **File → Import → Import Configs...** (again)
   - Select **"Process"** as the profile type
   - Select:
     - `0.8mm_Printer-1.json`
     - `0.8mm_Printer-2.json`
     - `CR-PETG_0.8mm_Print_Settings.json`
   - Click **"Import"**

## Why This Works

- OrcaSlicer's Import function properly registers profiles in its database
- Just placing files in folders doesn't always trigger a refresh
- Import ensures profiles are correctly indexed and visible

## After Import

1. **Select your printer** from the dropdown
2. **Select your material** (CR-PETG White/Black)
3. **Configure Mainsail connection:**
   - Printer Settings → General tab
   - Host Type: Mainsail
   - Host: `10.1.51.31` (Printer 1) or `10.1.51.32` (Printer 2)
   - Port: `7125`
   - Test Connection

## If Import Still Doesn't Work

The profiles are valid JSON with all required fields. If OrcaSlicer's import function fails:

1. **Try PrusaSlicer instead** - It's more reliable for custom profiles
2. **All PrusaSlicer profiles are ready** in the `PrusaSlicer/` folder
3. **See `PrusaSlicer/README.md`** for instructions

PrusaSlicer's import is more straightforward and reliable.
