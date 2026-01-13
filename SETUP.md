# Complete Setup Guide for CR-10S Printers

This guide will walk you through setting up both printers with MainsailOS and Klipper.

## Prerequisites

- 2x Raspberry Pi 4 (4GB or 8GB recommended)
- 2x MicroSD cards (32GB+ recommended, Class 10 or better)
- 2x USB cameras
- USB cables for connecting Pi to printer control boards
- Network connection (Ethernet or WiFi)

## Part 1: MainsailOS Installation

### Step 1: Flash MainsailOS to SD Cards

1. Download MainsailOS from: https://docs.mainsail.xyz/setup/mainsailos
2. Use Raspberry Pi Imager or Balena Etcher to flash the image to each SD card
3. **Before ejecting**, create a `wpa_supplicant.conf` file in the boot partition for WiFi setup (if using WiFi):

```ini
country=US
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={
    ssid="YOUR_WIFI_SSID"
    psk="YOUR_WIFI_PASSWORD"
}
```

4. Create an empty `ssh` file in the boot partition to enable SSH

### Step 2: First Boot

1. Insert SD card into Raspberry Pi 4
2. Connect Ethernet cable (or ensure WiFi is configured)
3. Power on the Pi
4. Wait 2-3 minutes for first boot
5. Find the Pi's IP address:
   - Check your router's admin panel, or
   - Use `nmap -sn 192.168.1.0/24` from another computer
   - Look for hostname `mainsailos` or `mainsail`

6. Access Mainsail interface: `http://<pi-ip-address>`

## Part 2: Klipper Installation and Configuration

### Step 3: SSH into Raspberry Pi

```bash
ssh pi@<pi-ip-address>
# Default password: raspberry (change it!)
```

### Step 4: Install Git and Clone Repository

Run the setup script:

```bash
cd ~
wget https://raw.githubusercontent.com/<your-username>/<repo-name>/main/scripts/install-git.sh
chmod +x install-git.sh
./install-git.sh
```

Or manually:

```bash
sudo apt update
sudo apt install -y git
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Step 5: Clone Your Configuration Repository

For Printer-1:
```bash
cd ~
git clone <your-repo-url> printer-config
cd printer-config
```

For Printer-2:
```bash
cd ~
git clone <your-repo-url> printer-config
cd printer-config
```

### Step 6: Copy Configuration Files

**For Printer-1:**
```bash
cp ~/printer-config/Printer-1/printer.cfg ~/printer_data/config/
cp ~/printer-config/Printer-1/macros.cfg ~/printer_data/config/
```

**For Printer-2:**
```bash
cp ~/printer-config/Printer-2/printer.cfg ~/printer_data/config/
cp ~/printer-config/Printer-2/macros.cfg ~/printer_data/config/
```

### Step 7: Update printer.cfg with Your Specific Settings

Edit the configuration file:
```bash
nano ~/printer_data/config/printer.cfg
```

**Important values to update:**
- `[mcu]` section: Update serial port if needed (usually `/dev/ttyUSB0` or `/dev/ttyACM0`)
- `[stepper_z]` section: Update `position_endstop` based on your bed leveling
- `[bed_mesh]` section: Adjust probe points for your bed size
- `[filament_switch_sensor]`: Update pin if your sensor uses a different pin

### Step 8: Restart Klipper

```bash
sudo systemctl restart klipper
```

Check status:
```bash
sudo systemctl status klipper
```

## Part 3: USB Camera Setup

### Step 9: Configure USB Camera

1. In Mainsail interface, go to **Settings** → **Webcams**
2. Add new webcam:
   - **Name**: `printer_camera`
   - **URL**: `/webcam/?action=stream`
   - **Snapshot URL**: `/webcam/?action=snapshot`
   - **Stream Ratio**: `16:9` or `4:3` (depending on your camera)
   - **Rotation**: `0` (or adjust if needed)
   - **Flip Horizontal/Vertical**: As needed

3. Or edit `~/printer_data/config/mainsail.cfg`:
```ini
[webcam printer_camera]
location: printer
enabled: true
stream_url: /webcam/?action=stream
snapshot_url: /webcam/?action=snapshot
rotation: 0
flip_horizontal: false
flip_vertical: false
```

### Step 10: Test Camera

1. Connect USB camera to Pi
2. Verify it's detected: `lsusb`
3. Check if it works: `ls /dev/video*`
4. Restart Mainsail: `sudo systemctl restart mainsail`

## Part 4: Git Auto-Pull Setup (Optional)

Set up automatic config updates:

```bash
cd ~/printer-config
git pull origin main
```

Create a cron job to auto-pull (be careful with this):
```bash
crontab -e
# Add this line (runs every hour):
0 * * * * cd ~/printer-config && git pull origin main
```

Or use the provided script:
```bash
cp ~/printer-config/scripts/pull-config.sh ~/
chmod +x ~/pull-config.sh
```

## Part 5: Initial Calibration

See [CALIBRATION.md](CALIBRATION.md) for detailed calibration procedures.

## Troubleshooting

### Klipper won't connect to MCU
- Check USB cable connection
- Verify serial port: `ls /dev/tty*`
- Check `[mcu]` serial path in `printer.cfg`
- Ensure correct baud rate (usually 250000)

### Camera not showing
- Check USB connection
- Verify camera is detected: `lsusb` and `ls /dev/video*`
- Check webcam service: `sudo systemctl status webcamd`
- Restart webcam: `sudo systemctl restart webcamd`

### Configuration errors
- Check Klipper logs: `~/printer_data/logs/klippy.log`
- Validate config: In Mainsail, go to **Settings** → **Printer** → **Validate Config**

## Next Steps

1. Complete initial calibration (see CALIBRATION.md)
2. Test print with a simple calibration cube
3. Fine-tune settings based on results
4. Document any printer-specific adjustments
