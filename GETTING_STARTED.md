# Getting Started - Quick Start Guide

This is a quick-start guide to get your printers up and running. For detailed instructions, see the other documentation files.

## Step-by-Step Setup

### 1. Initial Setup (Do This First)

1. **Flash MainsailOS** to both Raspberry Pi SD cards
   - Download from: https://docs.mainsail.xyz/setup/mainsailos
   - Use Raspberry Pi Imager or Balena Etcher
   - Enable SSH by creating empty `ssh` file in boot partition
   - Configure WiFi (if needed) with `wpa_supplicant.conf`

2. **Boot Both Pis**
   - Insert SD cards and power on
   - Wait 2-3 minutes for first boot
   - Find IP addresses (check router or use `nmap`)

3. **Access Mainsail**
   - Open browser: `http://<pi-ip-address>`
   - Default login: no password required

### 2. Set Up GitHub Repository

1. **Create GitHub repository** (see [GITHUB_SETUP.md](GITHUB_SETUP.md))
2. **Push this repository to GitHub**
3. **Clone on each Pi:**
   ```bash
   ssh pi@<pi-ip>
   git clone <your-repo-url> ~/printer-config
   ```

### 3. Configure Each Printer

**For Printer 1:**
```bash
ssh pi@<printer1-ip>
cp ~/printer-config/Printer-1/printer.cfg ~/printer_data/config/
cp ~/printer-config/Printer-1/macros.cfg ~/printer_data/config/
```

**For Printer 2:**
```bash
ssh pi@<printer2-ip>
cp ~/printer-config/Printer-2/printer.cfg ~/printer_data/config/
cp ~/printer-config/Printer-2/macros.cfg ~/printer_data/config/
```

### 4. Update Configuration

**IMPORTANT:** You must update these values in `printer.cfg`:

1. **Serial Port** (`[mcu]` section):
   ```bash
   # Check available ports
   ls /dev/ttyUSB* /dev/ttyACM*
   # Update serial: /dev/ttyUSB0 (or whatever you find)
   ```

2. **Control Board Pins:**
   - If you have a different board than stock CR-10S, update all pin assignments
   - Check your board's documentation for pin mappings

3. **Filament Sensor Pin:**
   - Update `switch_pin` in `[filament_switch_sensor]` section
   - Common pins: `PA4`, `PA3`, or check your board docs

### 5. Restart Klipper

```bash
sudo systemctl restart klipper
sudo systemctl status klipper  # Check it's running
```

### 6. Initial Calibration

Follow [CALIBRATION.md](CALIBRATION.md) in this order:

1. ✅ Verify stepper directions (home all axes)
2. ✅ Calibrate E-steps (extruder rotation_distance)
3. ✅ Set Z-offset
4. ✅ Create bed mesh
5. ✅ PID tune hotend and bed
6. ✅ Test first layer
7. ✅ Fine-tune flow rate
8. ✅ Test print (calibration cube)

### 7. Set Up Camera

1. Connect USB camera to Pi
2. In Mainsail: **Settings** → **Webcams** → **Add Webcam**
3. URL: `/webcam/?action=stream`
4. Test camera feed

### 8. First Test Print

1. Slice a simple calibration cube with:
   - Nozzle: 0.8mm
   - Layer height: 0.4mm
   - Line width: 0.8mm
   - Speed: 50mm/s
2. Upload to Mainsail
3. Print and evaluate
4. Adjust settings as needed

## Common Issues and Quick Fixes

### Klipper Won't Connect
- Check USB cable
- Verify serial port: `ls /dev/ttyUSB*`
- Check baud rate (usually 250000)
- Restart Klipper: `sudo systemctl restart klipper`

### Configuration Errors
- Check logs: `tail -50 ~/printer_data/logs/klippy.log`
- Validate config in Mainsail: **Settings** → **Printer** → **Validate Config**

### Camera Not Working
- Check USB connection: `lsusb`
- Verify device: `ls /dev/video*`
- Restart webcam: `sudo systemctl restart webcamd`

## Next Steps

1. ✅ Complete all calibration steps
2. ✅ Document any printer-specific adjustments
3. ✅ Commit calibrated configs to git
4. ✅ Set up automatic backups (optional)
5. ✅ Start printing!

## Documentation Files

- **[README.md](README.md)** - Overview and repository structure
- **[SETUP.md](SETUP.md)** - Detailed setup instructions
- **[CALIBRATION.md](CALIBRATION.md)** - Complete calibration guide
- **[GITHUB_SETUP.md](GITHUB_SETUP.md)** - GitHub repository setup
- **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** - Quick command reference
- **[Printer-1/README.md](Printer-1/README.md)** - Printer 1 specific notes
- **[Printer-2/README.md](Printer-2/README.md)** - Printer 2 specific notes

## Support

If you encounter issues:
1. Check the relevant documentation file
2. Review Klipper logs: `~/printer_data/logs/klippy.log`
3. Check Mainsail documentation: https://docs.mainsail.xyz
4. Check Klipper documentation: https://www.klipper3d.org

## Tips

- **Always backup before making changes:** Use `scripts/backup-config.sh`
- **Test on one printer first:** Make changes, test, then apply to the other
- **Document everything:** Update README files with your specific settings
- **Commit often:** Save your calibrated configurations to git
- **Be patient:** Calibration takes time but is worth it for perfect prints!

Good luck with your setup! 🚀
