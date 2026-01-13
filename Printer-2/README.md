# Printer 2 Configuration

## Printer Details

- **Model**: Creality CR-10S
- **Nozzle**: 0.8mm
- **Extruder**: Direct Drive
- **Control Board**: [UPDATE WITH YOUR BOARD TYPE]
- **Filament Sensor**: [UPDATE WITH YOUR SENSOR TYPE]

## Configuration Notes

### Serial Port
- Current setting: `/dev/ttyUSB0`
- If this doesn't work, check with: `ls /dev/ttyUSB*` or `ls /dev/ttyACM*`
- Update `[mcu]` section with correct port

### Control Board Pins
The pin assignments in `printer.cfg` are for a typical CR-10S board. If you have a different board (e.g., SKR, BTT), you'll need to update:
- Stepper motor pins
- Heater pins
- Thermistor pins
- Endstop pins
- Fan pins

### Filament Sensor Pin
- Current setting: `PA4`
- Verify this matches your sensor connection
- Test with: `QUERY_FILAMENT_SENSOR`

### Calibration Values

After calibration, update these values:
- **Extruder rotation_distance**: Currently `22.678` - calibrate for your direct drive
- **Z position_endstop**: Currently `0.5` - adjust based on your bed leveling
- **Pressure advance**: Currently `0.05` - tune for your setup
- **PID values**: Tune with `PID_CALIBRATE` commands

### Bed Mesh
- Current mesh: 5x5 points
- Recalibrate after any bed adjustments
- Save profile after calibration

## Printer-Specific Adjustments

Document any unique settings or modifications here:

- [ ] Serial port verified
- [ ] Pin assignments verified
- [ ] E-steps calibrated
- [ ] Z-offset set
- [ ] Bed mesh calibrated
- [ ] PID tuned
- [ ] Pressure advance tuned
- [ ] Filament sensor tested

## Last Calibration Date
- Date: ___________
- Performed by: ___________

## Notes
Add any printer-specific notes or issues here.
