# Calibration Guide for CR-10S with 0.8mm Nozzle

This guide covers all calibration steps needed to get perfect prints with your modified CR-10S printers.

## Prerequisites

- Printer is assembled and wired correctly
- Klipper is installed and connected
- Mainsail interface is accessible
- Basic test filament loaded

## Step 1: Basic Motor Configuration

### Verify Stepper Directions

1. Home all axes: In Mainsail, click **Home All**
2. Check each axis moves in correct direction
3. If any axis moves wrong direction, add `dir_pin: !<pin>` (invert with `!`)

### Set Steps per Millimeter

For direct drive, typical values:
- **X/Y**: `80` (CR-10S default)
- **Z**: `400` (CR-10S default)
- **Extruder**: `~400-465` (depends on your direct drive gear ratio)

**To calibrate extruder:**
1. Mark filament 120mm from extruder entrance
2. Heat hotend to printing temperature
3. Extrude 100mm: `G1 E100 F100`
4. Measure actual distance moved
5. Calculate: `new_steps = (current_steps × 100) / actual_distance`
6. Update `rotation_distance` in `[extruder]` section

## Step 2: Bed Leveling and Z-Offset

### Manual Bed Leveling (First Time)

1. Home all axes
2. Move to each corner: `G1 X10 Y10 Z0`
3. Adjust bed screws until nozzle just touches bed (use paper test)
4. Repeat for all 4 corners
5. Check center of bed

### Configure Bed Mesh

1. In Mainsail, go to **Tuning** → **Bed Mesh**
2. Set mesh size (recommended: 5x5 or 7x7 for CR-10S)
3. Click **Calibrate**
4. Save profile: **Save Config**

### Set Z-Offset

1. Heat bed and hotend to printing temperatures
2. Home Z axis
3. Move to center: `G1 X150 Y150 Z0`
4. Use paper test (0.1mm feeler gauge is better)
5. Adjust Z-offset in Mainsail **Tuning** tab
6. Fine-tune until paper has slight resistance
7. Save: `Z_OFFSET_APPLY_PROBE`

## Step 3: PID Tuning

### Hotend PID Tuning

```bash
# SSH into Pi
cd ~/printer_data/config
```

In Mainsail console, run:
```
PID_CALIBRATE HEATER=extruder TARGET=240
```

Wait for completion, then:
```
SAVE_CONFIG
```

### Bed PID Tuning

```
PID_CALIBRATE HEATER=heater_bed TARGET=60
```

Wait for completion, then:
```
SAVE_CONFIG
```

## Step 4: Extruder Calibration (E-Steps)

1. Heat hotend to 240°C (or your printing temp)
2. Mark filament 120mm from extruder entrance
3. Extrude 100mm at slow speed:
   ```
   G1 E100 F100
   ```
4. Measure actual distance moved (e.g., 95mm)
5. Calculate new rotation_distance:
   ```
   new_rotation_distance = (current_rotation_distance × 100) / actual_distance
   ```
6. Update `[extruder]` section in `printer.cfg`
7. Restart Klipper and test again

## Step 5: Flow Rate Calibration

### Method 1: Single Wall Cube

1. Print a 20mm cube with:
   - 1 perimeter (0.8mm wall)
   - 0% infill
   - 0 top layers
   - 3 bottom layers
2. Measure wall thickness with calipers
3. Calculate flow multiplier:
   ```
   flow_multiplier = (target_width / actual_width) × 100
   ```
   For 0.8mm nozzle, target is typically 0.8-0.9mm
4. Update `[extruder]` section or slicer flow rate

### Method 2: Line Width Test

1. Print a single layer square
2. Measure line width at multiple points
3. Adjust flow rate until consistent 0.8-0.9mm width

## Step 6: Temperature Tuning

### Temperature Tower

1. Use a temperature tower STL (available on Thingiverse)
2. Print with temperature changes at each section
3. Visually inspect for:
   - Stringing (too hot)
   - Layer adhesion (too cold)
   - Surface quality
4. Note optimal temperature for your filament

## Step 7: Retraction Tuning (Direct Drive)

For direct drive, retraction is typically:
- **Distance**: 0.5-2.0mm
- **Speed**: 25-45mm/s
- **Extra prime**: 0.1-0.2mm

### Retraction Test

1. Print a retraction test tower
2. Test different retraction distances:
   - Start: 0.5mm
   - Increment: 0.5mm
   - Max: 3.0mm
3. Find minimum distance with no stringing
4. Update slicer retraction settings

## Step 8: Filament Sensor Calibration

1. Load filament and verify sensor triggers correctly
2. Test runout detection:
   - Start a print
   - Manually trigger sensor (unplug or block)
   - Verify print pauses and shows notification
3. Adjust `[filament_switch_sensor]` settings if needed

## Step 9: First Layer Calibration

### Bed Adhesion Test

1. Print a large single-layer square (100mm × 100mm)
2. Check for:
   - **Too close**: Ripples, scraping, transparent lines
   - **Too far**: Gaps between lines, poor adhesion
   - **Just right**: Smooth, even lines with slight squish
3. Adjust Z-offset and reprint until perfect

## Step 10: Speed and Acceleration Tuning

### Recommended Starting Values for 0.8mm Nozzle

- **Print Speed**: 40-60mm/s (can go faster with 0.8mm)
- **First Layer**: 20-30mm/s
- **Perimeters**: 40-50mm/s
- **Infill**: 60-80mm/s
- **Travel**: 150-200mm/s
- **Acceleration**: 1000-2000mm/s²

### Test Print

1. Print a calibration cube at different speeds
2. Check for:
   - Layer shifting (acceleration too high)
   - Ringing/ghosting (speed too high)
   - Poor quality (need to slow down)
3. Find optimal speed/acceleration balance

## Step 11: Slicer Settings for 0.8mm Nozzle

### Key Settings

- **Nozzle Diameter**: 0.8mm
- **Layer Height**: 0.3-0.5mm (0.4mm is good starting point)
- **Line Width**: 0.8-1.0mm (typically 100-125% of nozzle)
- **First Layer Height**: 0.3mm
- **First Layer Width**: 120% of nozzle
- **Wall Thickness**: Multiple of 0.8mm (e.g., 1.6mm = 2 walls)

### Recommended Profiles

- **Fast Draft**: 0.5mm layers, 60mm/s, 2 perimeters
- **Standard**: 0.4mm layers, 50mm/s, 3 perimeters
- **Quality**: 0.3mm layers, 40mm/s, 4 perimeters

## Step 12: Final Test Print

Print a comprehensive test model:
- **Benchy** (3DBenchy) - Overall quality test
- **Calibration Cube** - Dimensional accuracy
- **Overhang Test** - Cooling performance
- **Bridging Test** - Extrusion consistency

## Maintenance Calibration

### Weekly Checks
- Bed leveling
- Z-offset verification
- Extruder steps (if changed hardware)

### Monthly Checks
- PID tuning (if temperature unstable)
- Bed mesh recalibration
- Full calibration suite

## Troubleshooting

### Poor First Layer
- Re-level bed
- Adjust Z-offset
- Check bed temperature
- Clean bed surface

### Under/Over Extrusion
- Recalibrate E-steps
- Check flow rate
- Verify filament diameter in slicer
- Check for nozzle clogs

### Stringing
- Increase retraction distance
- Lower temperature
- Increase travel speed
- Enable coasting/wipe

### Layer Shifting
- Reduce acceleration
- Check belt tension
- Verify stepper current
- Check for mechanical binding

## Recording Calibration Values

After calibration, update your `printer.cfg` with:
- E-steps/rotation_distance
- Z-offset
- PID values
- Bed mesh profile
- Any custom macros

Commit these to your git repository for future reference.
