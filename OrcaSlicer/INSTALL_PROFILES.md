# Installing OrcaSlicer Profiles (Official Method)

Based on the [official OrcaSlicer documentation](https://github.com/OrcaSlicer/OrcaSlicer/wiki/How-to-create-profiles), profiles must follow a specific structure.

## The Problem

OrcaSlicer requires:
1. **Profiles in installation directory** (`resources\profiles\`), not user folder
2. **Vendor folder structure** with vendor meta file
3. **Filenames must match profile 'name' field exactly**

## Solution: Create Vendor Structure

### Step 1: Find OrcaSlicer Installation Directory

**Windows:**
```
C:\Program Files\OrcaSlicer\resources\profiles\
```

Or check:
- Help → Show Configuration Folder
- Navigate up to find installation directory

### Step 2: Create Vendor Structure

Create this folder structure in the installation directory:

```
resources\profiles\
    ├── Custom.json                    (vendor meta file)
    └── Custom\                        (vendor folder)
        ├── machine\
        │   ├── CR-10S Printer 1 (0.8mm).json
        │   └── CR-10S Printer 2 (0.8mm).json
        ├── filament\
        │   ├── Creality CR-PETG White @0.8mm.json
        │   └── Creality CR-PETG Black @0.8mm.json
        └── process\
            ├── 0.8mm @Printer-1.json
            ├── 0.8mm @Printer-2.json
            └── CR-PETG 0.8mm Print Settings.json
```

### Step 3: Copy Files

1. **Copy `Custom.json`** to:
   ```
   C:\Program Files\OrcaSlicer\resources\profiles\Custom.json
   ```

2. **Create vendor folder:**
   ```
   C:\Program Files\OrcaSlicer\resources\profiles\Custom\
   ```

3. **Copy machine profiles** to:
   ```
   C:\Program Files\OrcaSlicer\resources\profiles\Custom\machine\
   ```
   - `CR-10S Printer 1 (0.8mm).json`
   - `CR-10S Printer 2 (0.8mm).json`

4. **Copy filament profiles** to:
   ```
   C:\Program Files\OrcaSlicer\resources\profiles\Custom\filament\
   ```
   - `Creality CR-PETG White @0.8mm.json`
   - `Creality CR-PETG Black @0.8mm.json`

5. **Copy process profiles** to:
   ```
   C:\Program Files\OrcaSlicer\resources\profiles\Custom\process\
   ```
   - `0.8mm @Printer-1.json`
   - `0.8mm @Printer-2.json`
   - `CR-PETG 0.8mm Print Settings.json`

### Step 4: Restart OrcaSlicer

1. **Close OrcaSlicer completely**
2. **Reopen OrcaSlicer**
3. **Check printer dropdown** - your printers should appear!

## Important Notes

- **Filenames MUST match the 'name' field in JSON exactly** (without .json extension)
- **Vendor meta file (`Custom.json`) lists all profiles** - this is required
- **Profiles must be in installation directory**, not user folder
- **You may need administrator privileges** to write to Program Files

## Alternative: Use Import Function

If you can't write to Program Files, use the Import function:

1. **File → Import → Import Configs...**
2. **Select profile type** (Machine/Filament/Process)
3. **Select the correctly named JSON files**
4. **Click Import**

This will place them in the user folder, but OrcaSlicer should still recognize them.

## Files Ready

All files in this repository are now correctly named to match their 'name' fields:
- ✅ `CR-10S Printer 1 (0.8mm).json`
- ✅ `CR-10S Printer 2 (0.8mm).json`
- ✅ `Creality CR-PETG White @0.8mm.json`
- ✅ `Creality CR-PETG Black @0.8mm.json`
- ✅ `0.8mm @Printer-1.json`
- ✅ `0.8mm @Printer-2.json`
- ✅ `CR-PETG 0.8mm Print Settings.json`
- ✅ `Custom.json` (vendor meta file)
