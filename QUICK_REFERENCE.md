# Quick Reference Guide

Quick commands and settings for daily printer operation.

## Common Klipper Commands

### Movement
```
G28                    # Home all axes
G28 X                  # Home X only
G28 Y                  # Home Y only
G28 Z                  # Home Z only
G1 X100 Y100 Z10       # Move to position
G1 E10 F100            # Extrude 10mm at 100mm/s
```

### Temperature
```
M104 S200              # Set hotend to 200°C
M140 S60               # Set bed to 60°C
M106 S255              # Turn on fan (0-255)
M106 S0                # Turn off fan
```

### Calibration
```
PID_CALIBRATE HEATER=extruder TARGET=240
PID_CALIBRATE HEATER=heater_bed TARGET=60
SAVE_CONFIG            # Save PID values
```

### Bed Leveling
```
BED_MESH_CALIBRATE     # Create new bed mesh
BED_MESH_PROFILE LOAD=default
BED_MESH_CLEAR         # Clear mesh
```

### Z-Offset
```
Z_OFFSET_APPLY_PROBE   # Apply current Z-offset
SET_GCODE_OFFSET Z_ADJUST=0.1  # Adjust Z-offset
```

## Custom Macros

### Preheat
```
PREHEAT_PLA            # Preheat for PLA
PREHEAT_ABS            # Preheat for ABS
PREHEAT_PETG           # Preheat for PETG
COOLDOWN               # Turn off heaters
```

### Maintenance
```
NOZZLE_CLEAN           # Clean nozzle routine
BED_MESH_CALIBRATE     # Calibrate bed mesh
```

## File Locations

### Configuration Files
- Main config: `~/printer_data/config/printer.cfg`
- Macros: `~/printer_data/config/macros.cfg`
- Git repo: `~/printer-config/`

### Logs
- Klipper log: `~/printer_data/logs/klippy.log`
- Moonraker log: `~/printer_data/logs/moonraker.log`

### G-Code Files
- Upload location: `~/printer_data/gcodes/`

## Service Management

```bash
# Restart services
sudo systemctl restart klipper
sudo systemctl restart moonraker
sudo systemctl restart mainsail

# Check status
sudo systemctl status klipper
sudo systemctl status moonraker

# View logs
journalctl -u klipper -f
journalctl -u moonraker -f
```

## Git Operations

```bash
# Pull latest config
cd ~/printer-config
git pull origin main

# Backup current config
~/printer-config/scripts/backup-config.sh

# Pull and update (interactive)
~/printer-config/scripts/pull-config.sh
```

## Calibration Values Reference

### Typical Values for 0.8mm Nozzle

**Layer Heights:**
- Draft: 0.5mm
- Standard: 0.4mm
- Quality: 0.3mm

**Line Width:**
- Standard: 0.8-1.0mm
- First Layer: 1.0mm (125% of nozzle)

**Print Speeds:**
- First Layer: 20-30mm/s
- Perimeters: 40-50mm/s
- Infill: 60-80mm/s
- Travel: 150-200mm/s

**Retraction (Direct Drive):**
- Distance: 0.5-2.0mm
- Speed: 25-45mm/s

**Temperatures (PLA):**
- Hotend: 200-220°C
- Bed: 50-60°C

**Temperatures (ABS):**
- Hotend: 240-260°C
- Bed: 80-100°C

**Temperatures (PETG):**
- Hotend: 230-250°C
- Bed: 70-80°C

## Troubleshooting Quick Fixes

### Printer Won't Connect
```bash
# Check USB connection
ls /dev/ttyUSB* /dev/ttyACM*

# Check Klipper status
sudo systemctl status klipper

# View error log
tail -50 ~/printer_data/logs/klippy.log
```

### First Layer Issues
- Too close: Increase Z-offset
- Too far: Decrease Z-offset
- Uneven: Recalibrate bed mesh

### Under Extrusion
- Check E-steps calibration
- Check nozzle for clogs
- Verify filament diameter in slicer
- Check flow rate (should be ~100%)

### Over Extrusion
- Recalibrate E-steps
- Reduce flow rate
- Check filament diameter setting

### Stringing
- Increase retraction distance
- Lower temperature
- Increase travel speed
- Enable coasting/wipe in slicer

### Layer Shifting
- Reduce acceleration
- Check belt tension
- Verify stepper current
- Check for mechanical binding

## Slicer Settings Quick Reference

### PrusaSlicer/SuperSlicer
- Nozzle: 0.8mm
- Layer Height: 0.3-0.5mm
- First Layer Height: 0.3mm
- Line Width: 0.8mm (100% of nozzle)
- First Layer Width: 1.0mm (125% of nozzle)
- Perimeters: 2-4 (depending on wall thickness needed)

### Cura
- Nozzle: 0.8mm
- Layer Height: 0.3-0.5mm
- Initial Layer Height: 0.3mm
- Line Width: 0.8mm
- Initial Line Width: 1.0mm
- Wall Line Count: 2-4

## Network Access

### Find Pi IP Address
```bash
# On Pi
hostname -I

# On another computer
nmap -sn 192.168.1.0/24 | grep -B 2 mainsail
```

### Access Mainsail
- Web interface: `http://<pi-ip-address>`
- Default port: 80 (HTTP) or 443 (HTTPS)

### SSH Access
```bash
ssh pi@<pi-ip-address>
# Default password: raspberry (change it!)
```

## Safety Commands

### Emergency Stop
- In Mainsail: Click emergency stop button
- Or send: `M112` (emergency stop)
- Or physically: Turn off printer power

### Disable Steppers
```
M84                    # Disable all steppers
```

### Turn Off Heaters
```
M104 S0                # Turn off hotend
M140 S0                # Turn off bed
```

## Maintenance Schedule

### Daily
- Check first layer adhesion
- Verify bed leveling
- Clean bed surface

### Weekly
- Recalibrate bed mesh
- Check Z-offset
- Clean nozzle
- Check belt tension

### Monthly
- PID tune hotend and bed
- Full calibration suite
- Check all mechanical components
- Update firmware/configs
