# Printer Calibration Test Prints

This guide provides a systematic approach to dialing in both printers using test prints.

## Test Print Order

Follow these tests in order - each builds on the previous one:

1. **First Layer Test** - Bed leveling and Z-offset
2. **Temperature Tower** - Find optimal temperature
3. **Retraction Test** - Dial in retraction settings
4. **Flow Calibration** - Check extrusion multiplier
5. **Calibration Cube** - Dimensional accuracy
6. **Stringing Test** - Verify stringing fixes
7. **Overhang Test** - Cooling and overhang performance
8. **Benchy** - Overall print quality

## Test 1: First Layer Test

**Purpose**: Verify bed leveling and Z-offset

**Recommended Model**: 
- Search for "First Layer Test" on Printables/Thingiverse
- Or use a simple 200x200mm square, 0.2mm height

**What to Check**:
- ✓ All corners stick properly
- ✓ No gaps between lines
- ✓ No scraping/too close
- ✓ Smooth, even surface
- ✓ Lines are uniform width

**If Issues**:
- **Gaps between lines**: Z-offset too high → Lower Z-offset
- **Scraping/nozzle too close**: Z-offset too low → Raise Z-offset
- **Corners don't stick**: Bed not level → Re-level bed
- **Uneven first layer**: Bed mesh needs recalibration → Run BED_MESH_CALIBRATE

**Settings**:
- Layer height: 0.3mm (first layer)
- Speed: 25mm/s
- No infill, no top layers
- Brim: 5-8mm

## Test 2: Temperature Tower

**Purpose**: Find optimal nozzle temperature for CR-PETG

**Recommended Model**:
- Search "Temperature Tower PETG" on Printables
- Or use OrcaSlicer's built-in calibration tools

**Temperature Range**: 220°C to 250°C (test every 5°C)

**What to Check**:
- ✓ Best layer adhesion
- ✓ Least stringing
- ✓ Best surface quality
- ✓ No oozing/drooling

**How to Read**:
- **Too cold**: Poor layer adhesion, rough surface
- **Too hot**: Excessive stringing, oozing, poor detail
- **Just right**: Smooth surface, good adhesion, minimal stringing

**Settings**:
- Use your CR-PETG profile
- Modify temperature at specific layers (use OrcaSlicer's modifier)
- Current setting: 232°C - test ±10°C

## Test 3: Retraction Test

**Purpose**: Dial in retraction distance and speed

**Recommended Model**:
- Search "Retraction Test" on Printables
- Look for models with towers or gaps

**What to Test**:
- Current: 1.2mm @ 70mm/s
- Test range: 0.8mm to 1.5mm @ 50-80mm/s

**What to Check**:
- ✓ Minimal stringing between parts
- ✓ No gaps at layer start
- ✓ Clean retraction points

**If Issues**:
- **Still stringing**: Increase retraction distance (try 1.5mm)
- **Gaps at start**: Reduce retraction or increase prime
- **Blobs at retraction**: Adjust retraction speed

## Test 4: Flow Calibration

**Purpose**: Verify extrusion multiplier (currently 96%)

**Recommended Model**:
- Search "Flow Calibration" or "Extrusion Multiplier Test"
- Or print a 20mm cube with 2 walls, no infill, no top

**How to Test**:
1. Print a single-wall cube (20x20mm, 2 walls)
2. Measure wall thickness with calipers
3. Should be: 2 × 0.8mm = 1.6mm
4. Calculate: New Flow = (1.6 / measured) × current_flow

**What to Check**:
- ✓ Wall thickness matches expected (1.6mm for 2 walls)
- ✓ No gaps or over-extrusion

**If Issues**:
- **Too thin**: Increase flow (try 98-100%)
- **Too thick**: Decrease flow (try 94-96%)

## Test 5: Calibration Cube

**Purpose**: Check dimensional accuracy

**Recommended Model**:
- Search "Calibration Cube" on Printables
- Standard 20x20x20mm cube

**What to Check**:
- ✓ X, Y, Z dimensions are accurate (20mm ±0.1mm)
- ✓ Corners are square
- ✓ No elephant's foot
- ✓ Smooth surfaces

**If Issues**:
- **Dimensions off**: Check steps/mm (rotation_distance) in printer.cfg
- **Elephant's foot**: Adjust elefant_foot_compensation
- **Warped corners**: Bed adhesion/temperature issue

**Settings**:
- Use your standard CR-PETG profile
- 0.4mm layer height
- 3 walls, 20% infill

## Test 6: Stringing Test

**Purpose**: Verify stringing fixes are working

**Recommended Model**:
- Search "Stringing Test" or "Oozing Test"
- Models with multiple towers or gaps

**What to Check**:
- ✓ Minimal to no strings between parts
- ✓ Clean travel moves
- ✓ No blobs at start points

**If Still Stringing**:
- Lower temperature further (try 230°C)
- Increase retraction (try 1.5mm)
- Increase travel speed (try 300mm/s)
- Enable "Avoid crossing walls" in OrcaSlicer

## Test 7: Overhang Test

**Purpose**: Test cooling and overhang performance

**Recommended Model**:
- Search "Overhang Test" on Printables
- Tests angles from 30° to 90°

**What to Check**:
- ✓ Clean overhangs up to 45-60°
- ✓ Minimal drooping
- ✓ Good bridging

**If Issues**:
- **Drooping overhangs**: Increase part cooling fan (try 40-50% for PETG)
- **Poor bridging**: Increase bridge fan speed
- **Layer separation**: Reduce cooling or increase temperature

**Settings**:
- Current fan: 10-30% (low for PETG)
- May need to increase for overhangs

## Test 8: Benchy (Overall Quality)

**Purpose**: Final overall quality check

**Recommended Model**:
- Search "3DBenchy" on Printables
- Standard 3D printing benchmark

**What to Check**:
- ✓ Smooth surfaces
- ✓ Clean details (text, windows)
- ✓ Good overhangs
- ✓ Minimal stringing
- ✓ Proper dimensions

**This is your final test** - if Benchy looks good, your printer is dialed in!

## Quick Test Checklist

Print these in order and check off as you go:

- [ ] **First Layer Test** - Bed leveling and Z-offset correct
- [ ] **Temperature Tower** - Optimal temperature found (currently 232°C)
- [ ] **Retraction Test** - Stringing minimized (currently 1.2mm @ 70mm/s)
- [ ] **Flow Calibration** - Extrusion accurate (currently 96%)
- [ ] **Calibration Cube** - Dimensions correct
- [ ] **Stringing Test** - No strings between parts
- [ ] **Overhang Test** - Good overhang performance
- [ ] **Benchy** - Overall quality acceptable

## Where to Find Test Models

**Recommended Sites**:
- **Printables**: https://www.printables.com
- **Thingiverse**: https://www.thingiverse.com
- **OrcaSlicer**: Built-in calibration tools (Calibration → Add Calibration Object)

**Search Terms**:
- "First Layer Test"
- "Temperature Tower PETG"
- "Retraction Test"
- "Flow Calibration"
- "Calibration Cube"
- "Stringing Test"
- "Overhang Test"
- "3DBenchy"

## Current Settings Summary

**Temperature**: 232°C (first layer: 240°C)
**Bed**: 80°C (first layer: 85°C)
**Flow**: 96%
**Retraction**: 1.2mm @ 70mm/s
**Z-hop**: 0.2mm
**Travel Speed**: 250mm/s
**Layer Height**: 0.4mm
**Fan Speed**: 10-30%

## Tips

1. **Test one thing at a time** - Don't change multiple settings
2. **Document results** - Note what works and what doesn't
3. **Start with defaults** - Use current profiles as baseline
4. **Small adjustments** - Make incremental changes
5. **Print both printers** - Compare results between printers

## After Calibration

Once all tests pass:
1. Update material profiles with optimal settings
2. Save as new profile names (e.g., "CR-PETG White - Tuned")
3. Document final settings in this file
4. Commit updated profiles to GitHub
