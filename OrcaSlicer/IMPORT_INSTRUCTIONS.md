# How to Import Profiles in OrcaSlicer

If the sync script isn't working, use OrcaSlicer's built-in import function:

## Method 1: Import via UI (Recommended)

1. **Open OrcaSlicer**

2. **For Printer Profiles:**
   - Go to **File → Import → Import Configs...**
   - OR click the **Printer dropdown** → **Create Printer** → **Import** (or look for Import option)
   - Select `Printer-1.json` or `Printer-2.json`
   - Click **Open**

3. **For Filament Profiles:**
   - Click the **Filament dropdown** (next to printer)
   - Click **Add** or **+** button
   - Click **Import**
   - Select `CR-PETG_White.json` or `CR-PETG_Black.json`
   - Click **Open**

4. **For Process Profiles:**
   - Click the **Process dropdown** (next to filament)
   - Click **Add** or **+** button
   - Click **Import**
   - Select `0.8mm_Printer-1.json` or `0.8mm_Printer-2.json`
   - Click **Open**

## Method 2: Manual Copy to User Folder

If import doesn't work, manually copy files:

1. **Find your OrcaSlicer user folder:**
   - In OrcaSlicer: **Help → Show Configuration Folder**
   - Navigate to `user\default\` (or `user\<number>\`)

2. **Copy files to:**
   - Printer profiles → `user\default\machine\`
   - Filament profiles → `user\default\filament\`
   - Process profiles → `user\default\process\`

3. **Restart OrcaSlicer**

## Troubleshooting

### Profiles don't appear after import:

1. **Check compatible_printers field:**
   - Open the JSON file
   - Look for `"compatible_printers"` field
   - Make sure it lists your printer name exactly

2. **Check inherits field:**
   - The `inherits` field must point to an existing base profile
   - If the base doesn't exist, the profile won't load

3. **Clear cache:**
   - Close OrcaSlicer
   - Delete the `system` folder in your config directory
   - Restart OrcaSlicer

4. **Check file format:**
   - Make sure JSON files are valid (no syntax errors)
   - Use a JSON validator if needed

### Import says "0 configurations imported":

- The profile type might be wrong (machine vs filament vs process)
- The `compatible_printers` field doesn't match any printer
- The `inherits` field points to a non-existent profile
- JSON syntax error in the file

## Quick Test

Try importing just one profile first (like Printer-1.json) to see if it works. If that works, the others should too.
