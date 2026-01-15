# PrusaSlicer Configuration

PrusaSlicer is an excellent alternative to OrcaSlicer with easier profile management.

## Why PrusaSlicer?

- ✅ **Easier profile setup** - More straightforward than OrcaSlicer
- ✅ **Better documentation** - Well-documented profile system
- ✅ **Klipper support** - Works great with Klipper/Mainsail
- ✅ **Similar interface** - Very similar to OrcaSlicer
- ✅ **Free and open source**

## Installation

1. Download PrusaSlicer: https://www.prusa3d.com/page/prusaslicer_424/
2. Install and open PrusaSlicer

## Importing Profiles

### Method 1: Import via UI (Easiest)

1. **For Printer:**
   - **File → Import → Import Config...**
   - Select `Printer-1.ini` or `Printer-2.ini`
   - Click "Open"

2. **For Filament:**
   - **File → Import → Import Config...**
   - Select `CR-PETG_White.ini` or `CR-PETG_Black.ini`
   - Click "Open"

3. **For Print Settings:**
   - **File → Import → Import Config...**
   - Select `0.8mm_Print_Settings.ini`
   - Click "Open"

### Method 2: Manual Copy

1. **Find PrusaSlicer config folder:**
   - **Windows**: `%APPDATA%\PrusaSlicer\`
   - **macOS**: `~/Library/Application Support/PrusaSlicer/`
   - **Linux**: `~/.config/PrusaSlicer/`

2. **Copy files to:**
   - Printer: `printer/` folder
   - Filament: `filament/` folder
   - Print Settings: `print/` folder

3. **Restart PrusaSlicer**

## Configure Mainsail Connection

1. **Select your printer**
2. **Printer Settings** → **General** tab
3. **Host Type**: Mainsail
4. **Host**: `10.1.51.31` (Printer 1) or `10.1.51.32` (Printer 2)
5. **Port**: `7125`
6. **Test Connection**

## Settings Summary

**Temperature:**
- Nozzle: 232°C (240°C first layer)
- Bed: 80°C (85°C first layer)

**Retraction:**
- Length: 1.2mm
- Speed: 70mm/s
- Z-hop: 0.2mm
- Wipe: 3mm

**Print Settings:**
- Layer Height: 0.4mm (0.3mm first layer)
- Speed: 50-60mm/s (walls), 40mm/s (top)
- Travel Speed: 250mm/s
- Infill: 20% (gyroid)

## Advantages Over OrcaSlicer

- ✅ Simpler profile import
- ✅ Better error messages
- ✅ More reliable profile loading
- ✅ Easier to troubleshoot
- ✅ Active community support

If OrcaSlicer continues to be problematic, PrusaSlicer is a great alternative!
