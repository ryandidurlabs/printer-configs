# OrcaSlicer Configuration for CR-10S Printers

This directory contains OrcaSlicer printer profiles for both modified CR-10S printers.

## Printer Specifications

Both printers are modified Creality CR-10S with:
- **Direct Drive Extruder**: Creality Sprite Extruder Pro
- **Nozzle**: 0.8mm
- **Bed Size**: 300x300mm
- **Max Height**: 400mm
- **Firmware**: Klipper with MainsailOS
- **Max Speed**: 300mm/s
- **Max Acceleration**: 3000mm/s²

## Installation Instructions

**📖 For detailed step-by-step instructions, see [SETUP_GUIDE.md](SETUP_GUIDE.md)**

### Quick Start: Import via OrcaSlicer UI

1. Open OrcaSlicer
2. **Printer Profiles**: Click printer dropdown → **Add Printer** → **Import** → Select `Printer-1.json` or `Printer-2.json`
3. **Material Profiles**: Click filament dropdown → **Add** → **Import** → Select `CR-PETG_White.json` or `CR-PETG_Black.json`
4. **Print Settings**: Click process dropdown → **Add** → **Import** → Select `0.8mm_Printer-1.json` or `0.8mm_Printer-2.json`
5. **Configure Mainsail**: Printer Settings → Machine tab → Set Host Type to `Mainsail` → Enter IP (10.1.51.31 or 10.1.51.32)

### Method 2: Manual Copy (Advanced)

1. Close OrcaSlicer if it's running
2. Navigate to OrcaSlicer config directory:
   - **Windows**: `%APPDATA%\OrcaSlicer\resources\profiles\`
   - **macOS**: `~/Library/Application Support/OrcaSlicer/resources/profiles/`
   - **Linux**: `~/.config/OrcaSlicer/resources/profiles/`
3. Copy the JSON files to the appropriate subdirectories:
   - `Printer-1.json` → `machine/` folder
   - `Printer-2.json` → `machine/` folder
   - `0.8mm_Printer-1.json` → `process/` folder
   - `0.8mm_Printer-2.json` → `process/` folder
4. Restart OrcaSlicer

## Configuring Mainsail Connection

After importing the printer profiles:

1. In OrcaSlicer, select your printer
2. Go to **Printer** → **Printer Settings** → **Machine** tab
3. Scroll to **Host** section
4. Set **Host Type** to `Mainsail`
5. Enter the IP address:
   - **Printer 1**: `10.1.51.31`
   - **Printer 2**: `10.1.51.32`
6. Port should be `7125` (default Mainsail port)
7. Click **Test Connection** to verify

## Print Settings

The profiles are optimized for 0.8mm nozzle with:
- **Layer Height**: 0.4mm (can be adjusted 0.16-0.64mm)
- **Line Width**: 0.8mm
- **Wall Loops**: 2
- **Infill**: 15% (adjustable)
- **Print Speed**: 60-80mm/s (walls), 200mm/s (travel)
- **Acceleration**: 1000-3000mm/s²

## Custom G-code Macros

The profiles use your Klipper macros:
- **Start Print**: `START_PRINT` (with bed and extruder temp parameters)
- **End Print**: `END_PRINT`
- **Pause**: `PAUSE`
- **Resume**: `RESUME`

These macros handle:
- Bed mesh calibration/loading
- Preheating
- Safe parking
- Cooldown

## Tips

1. **First Print**: Start with a simple test cube to verify settings
2. **Temperature**: Adjust based on your filament (PLA: 200-220°C, PETG: 230-250°C)
3. **Bed Temperature**: PLA: 60°C, PETG: 80°C, ABS: 100°C
4. **Retraction**: Direct drive typically needs 0.5-1.5mm retraction at 40-60mm/s
5. **Layer Height**: For 0.8mm nozzle, use 0.3-0.5mm layer height for best results

## Troubleshooting

### Connection Issues
- Verify Mainsail is accessible in browser: `http://10.1.51.31` or `http://10.1.51.32`
- Check firewall settings
- Ensure Moonraker API is enabled

### Print Quality Issues
- Adjust layer height (try 0.3mm for finer detail)
- Reduce speed for better quality
- Increase infill for stronger parts
- Check bed leveling in Mainsail

### G-code Errors
- Verify macros exist in `printer.cfg`
- Check Mainsail console for error messages
- Ensure bed mesh is calibrated

## Material Profiles

### Creality CR-PETG Profiles

Optimized material profiles for Creality CR-PETG with 0.8mm nozzle:

- **CR-PETG_White.json** - White PETG filament profile
- **CR-PETG_Black.json** - Black PETG filament profile
- **CR-PETG_0.8mm_Print_Settings.json** - Print settings optimized for PETG

#### PETG Settings Summary:
- **Nozzle Temperature**: 240°C (245°C first layer)
- **Bed Temperature**: 80°C (85°C first layer)
- **Fan Speed**: 10-30% (lower for better layer adhesion)
- **Retraction**: 0.8mm @ 50mm/s (direct drive)
- **Print Speed**: 50-60mm/s (walls), 40mm/s (top surface)
- **Layer Height**: 0.4mm (0.3mm first layer)
- **Infill**: 20% (gyroid pattern recommended)
- **Brim**: 8mm (recommended for better adhesion)

#### Importing Material Profiles:

1. Open OrcaSlicer
2. Go to **Filament** → **Add Filament** → **Import**
3. Select `CR-PETG_White.json` or `CR-PETG_Black.json`
4. The print settings profile will be automatically linked

#### Tips for PETG:
- Use brim (8mm) for better bed adhesion
- Lower fan speeds (10-30%) improve layer bonding
- Higher bed temp (80-85°C) prevents warping
- Slower speeds (50-60mm/s) improve quality
- Gyroid infill works well with PETG
- Use ironing on top surfaces for smooth finish

## Files

- `Printer-1.json` - Machine profile for Printer 1
- `Printer-2.json` - Machine profile for Printer 2
- `0.8mm_Printer-1.json` - Print process profile for Printer 1
- `0.8mm_Printer-2.json` - Print process profile for Printer 2
- `CR-PETG_White.json` - White PETG material profile
- `CR-PETG_Black.json` - Black PETG material profile
- `CR-PETG_0.8mm_Print_Settings.json` - PETG print settings
