# Manual OrcaSlicer Setup (No Import Needed)

Since importing isn't working, here's how to manually configure OrcaSlicer for your printers:

## Step 1: Create Printer Manually

1. **Open OrcaSlicer**
2. **Click Printer dropdown** → **Create Printer**
3. **Select "Custom Printer"** or "Generic FFF"
4. **Name it**: "CR-10S Printer 1 (0.8mm)"
5. **Fill in basic settings:**
   - **Bed Size**: 300 x 300 mm
   - **Height**: 400 mm
   - **Nozzle Diameter**: 0.8 mm
   - **G-code Flavor**: Klipper
6. **Click OK/Save**

## Step 2: Configure Printer Settings

1. **Select your printer** from dropdown
2. **Click Printer Settings** (printer icon or right-click)
3. **Machine tab** - Configure:
   - **Max Speed X/Y**: 300 mm/s
   - **Max Speed Z**: 5 mm/s
   - **Max Acceleration X/Y**: 3000 mm/s²
   - **Max Acceleration Z**: 200 mm/s²
   - **Max Jerk X/Y**: 8 mm/s
   - **Max Jerk Z**: 0.4 mm/s

4. **Custom G-code tab**:
   - **Start G-code**: 
     ```
     START_PRINT BED_TEMP=[first_layer_bed_temperature] EXTRUDER_TEMP=[first_layer_temperature]
     ```
   - **End G-code**: 
     ```
     END_PRINT
     ```
   - **Pause G-code**: `PAUSE`
   - **Resume G-code**: `RESUME`

5. **Host tab**:
   - **Host Type**: Mainsail
   - **IP Address**: `10.1.51.31` (Printer 1) or `10.1.51.32` (Printer 2)
   - **Port**: `7125`
   - **Test Connection**

## Step 3: Create Filament Profile

1. **Click Filament dropdown** → **Add** or **Create**
2. **Name**: "Creality CR-PETG White @0.8mm"
3. **Configure settings:**
   - **Nozzle Temperature**: 232°C
   - **First Layer Temperature**: 240°C
   - **Bed Temperature**: 80°C
   - **First Layer Bed**: 85°C
   - **Fan Speed**: 10-30%
   - **Flow Ratio**: 96%
   - **Retraction**: 1.2 mm @ 70 mm/s
   - **Z-hop**: 0.2 mm
   - **Wipe Distance**: 3 mm

4. **Save**

## Step 4: Create Process Profile

1. **Click Process dropdown** → **Add** or **Create**
2. **Name**: "0.8mm @Printer-1"
3. **Configure settings:**
   - **Layer Height**: 0.4 mm
   - **First Layer Height**: 0.3 mm
   - **Line Width**: 0.8 mm
   - **Wall Loops**: 3
   - **Infill**: 20%
   - **Print Speed**: 60-70 mm/s (walls), 40 mm/s (top)
   - **Travel Speed**: 250 mm/s
   - **Acceleration**: 800-1500 mm/s²

4. **Save**

## Alternative: Use PrusaSlicer

If OrcaSlicer continues to be problematic, **PrusaSlicer** is very similar and often easier to configure:

- ✅ Similar interface to OrcaSlicer
- ✅ Better profile management
- ✅ Easier to create custom printers
- ✅ Works great with Klipper/Mainsail
- ✅ Free and open source

I can create PrusaSlicer profiles if you'd like to try that instead.
