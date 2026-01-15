# Working Import Method for OrcaSlicer

I've created **standalone profiles** that don't rely on inheritance, which should work better.

## Files to Import (Standalone Versions)

These profiles don't inherit from system profiles, so they should import without issues:

**Printer Profiles:**
- `Printer-1-Standalone.json` - Use this instead of Printer-1.json
- `Printer-2-Standalone.json` - Use this instead of Printer-2.json

**Filament Profiles:**
- `CR-PETG_White-Standalone.json` - Use this instead of CR-PETG_White.json
- `CR-PETG_Black-Standalone.json` - Use this instead of CR-PETG_Black.json

## Step-by-Step Import

### 1. Import Printer Profiles

1. Open OrcaSlicer
2. **File → Import → Import Configs...**
3. In the dialog:
   - **Profile Type**: Select "Machine" or "Printer"
   - Click "Browse" or navigate to files
   - Select `Printer-1-Standalone.json`
   - Click "Open" or "Import"
4. Repeat for `Printer-2-Standalone.json`

### 2. Import Filament Profiles

1. **File → Import → Import Configs...**
2. **Profile Type**: Select "Filament"
3. Select `CR-PETG_White-Standalone.json`
4. Click "Open" or "Import"
5. Repeat for `CR-PETG_Black-Standalone.json`

### 3. Verify

After importing:
1. Click the **Printer dropdown** - you should see:
   - "CR-10S Printer 1 (0.8mm)"
   - "CR-10S Printer 2 (0.8mm)"

2. Click the **Filament dropdown** - you should see:
   - "Creality CR-PETG White @0.8mm"
   - "Creality CR-PETG Black @0.8mm"

## If Import Still Doesn't Work

Try this alternative:

1. **Create Printer manually:**
   - Printer dropdown → Create Printer
   - Fill in basic info (name, bed size, etc.)
   - Save it

2. **Then import/apply settings:**
   - Select your new printer
   - Go to Printer Settings
   - Look for "Import" or "Load from file"
   - Select the standalone JSON file

## What's Different in Standalone Profiles

- ✅ No `inherits` field (doesn't depend on system profiles)
- ✅ All settings included directly
- ✅ `from: "user"` (user profile, not system)
- ✅ `compatible_printers` matches printer names exactly

These should work even if system profiles are missing or different.
