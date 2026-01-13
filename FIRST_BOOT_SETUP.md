# First Boot Setup - Raspberry Pi Checklist

Quick checklist for setting up each Raspberry Pi for the first time.

## Prerequisites
- ✅ MainsailOS flashed to SD card
- ✅ SD card inserted in Raspberry Pi
- ✅ Network connection (Ethernet or WiFi configured)
- ✅ Power connected

## Step 1: First Boot (Both Pis)

1. **Power on the Pi** and wait 2-3 minutes for first boot
2. **Find the Pi's IP address:**
   - Check your router's admin panel, OR
   - Use `nmap` from another computer:
     ```bash
     nmap -sn 192.168.1.0/24 | grep -B 2 mainsail
     ```
   - Look for hostname `mainsailos` or `mainsail`

3. **Access Mainsail:**
   - Open browser: `http://<pi-ip-address>`
   - Default: No password required

## Step 2: SSH into Each Pi

```bash
ssh pi@<pi-ip-address>
# Default password: raspberry (change it!)
```

## Step 3: Set Up Printer 1's Pi

```bash
# Install git
sudo apt update
sudo apt install -y git

# Configure git
git config --global user.name "Printer 1"
git config --global user.email "printer1@local"

# Clone your repository
cd ~
git clone https://github.com/ryandidurlabs/printer-configs.git printer-config

# Copy Printer-1 configuration files
cp ~/printer-config/Printer-1/printer.cfg ~/printer_data/config/
cp ~/printer-config/Printer-1/macros.cfg ~/printer_data/config/

# Install sync script
cp ~/printer-config/scripts/sync-printer1.sh ~/sync-printer-config.sh
chmod +x ~/sync-printer-config.sh

# Restart Klipper
sudo systemctl restart klipper

# Check status
sudo systemctl status klipper
```

## Step 4: Set Up Printer 2's Pi

```bash
# Install git
sudo apt update
sudo apt install -y git

# Configure git
git config --global user.name "Printer 2"
git config --global user.email "printer2@local"

# Clone your repository
cd ~
git clone https://github.com/ryandidurlabs/printer-configs.git printer-config

# Copy Printer-2 configuration files
cp ~/printer-config/Printer-2/printer.cfg ~/printer_data/config/
cp ~/printer-config/Printer-2/macros.cfg ~/printer_data/config/

# Install sync script
cp ~/printer-config/scripts/sync-printer2.sh ~/sync-printer-config.sh
chmod +x ~/sync-printer-config.sh

# Restart Klipper
sudo systemctl restart klipper

# Check status
sudo systemctl status klipper
```

## Step 5: Update Configuration Files

**IMPORTANT:** You need to update these in `printer.cfg` on each Pi:

1. **Serial Port** (`[mcu]` section):
   ```bash
   # Check available ports
   ls /dev/ttyUSB* /dev/ttyACM*
   # Update serial: /dev/ttyUSB0 (or whatever you find)
   ```

2. **Control Board Pins:**
   - If you have a different board than stock CR-10S, update pin assignments
   - Check your board's documentation

3. **Filament Sensor Pin:**
   - Update `switch_pin` in `[filament_switch_sensor]` section
   - Common pins: `PA4`, `PA3`, or check your board docs

Edit the config:
```bash
nano ~/printer_data/config/printer.cfg
```

After editing, restart Klipper:
```bash
sudo systemctl restart klipper
```

## Step 6: Set Up USB Camera (Each Pi)

1. **Connect USB camera** to Pi
2. **Verify it's detected:**
   ```bash
   lsusb
   ls /dev/video*
   ```

3. **Configure in Mainsail:**
   - Go to **Settings** → **Webcams**
   - Click **Add Webcam**
   - **Name**: `printer_camera`
   - **URL**: `/webcam/?action=stream`
   - **Snapshot URL**: `/webcam/?action=snapshot`
   - Click **Save**

4. **Restart webcam service:**
   ```bash
   sudo systemctl restart webcamd
   ```

## Step 7: Verify Everything Works

### Check Klipper Connection
- In Mainsail, go to **Settings** → **Printer**
- Check if MCU is connected
- If not, verify serial port in `printer.cfg`

### Test Movement
- In Mainsail console, try:
  ```
  G28
  ```
  (This homes all axes - make sure nothing is in the way!)

### Check Camera
- Camera feed should appear in Mainsail interface

## Step 8: Initial Calibration

See `CALIBRATION.md` for complete calibration procedures. Start with:

1. ✅ Verify stepper directions
2. ✅ Calibrate E-steps (extruder rotation_distance)
3. ✅ Set Z-offset
4. ✅ Create bed mesh
5. ✅ PID tune hotend and bed

## Quick Commands Reference

```bash
# Restart services
sudo systemctl restart klipper
sudo systemctl restart moonraker
sudo systemctl restart webcamd

# Check status
sudo systemctl status klipper

# View logs
tail -50 ~/printer_data/logs/klippy.log

# Sync latest config from GitHub
~/sync-printer-config.sh
```

## Troubleshooting

### Can't find Pi on network
- Wait longer (first boot takes 2-3 minutes)
- Check Ethernet cable connection
- Verify WiFi credentials in `wpa_supplicant.conf`

### Klipper won't connect
- Check USB cable between Pi and printer
- Verify serial port: `ls /dev/ttyUSB* /dev/ttyACM*`
- Check `printer.cfg` serial path
- Restart Klipper: `sudo systemctl restart klipper`

### Camera not working
- Check USB connection: `lsusb`
- Verify device: `ls /dev/video*`
- Restart webcam: `sudo systemctl restart webcamd`

### Configuration errors
- Check logs: `tail -50 ~/printer_data/logs/klippy.log`
- Validate config in Mainsail: **Settings** → **Printer** → **Validate Config**

## Next Steps

After both Pis are set up:
1. Complete calibration (see `CALIBRATION.md`)
2. Test print on each printer
3. Fine-tune settings
4. Document any printer-specific adjustments

You're all set! 🚀
