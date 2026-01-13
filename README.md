# CR-10S Printer Configuration Repository

This repository contains configuration files and setup instructions for two modified Creality CR-10S printers.

## Printer Specifications

Both printers have been modified with:
- **Direct Drive Extruder Upgrade**
- **Updated Control Board** (compatible with Klipper)
- **Filament Runout Sensor**
- **0.8mm Nozzle**
- **Raspberry Pi 4** running MainsailOS
- **USB Camera** for monitoring

## Repository Structure

```
.
├── README.md                    # This file
├── SETUP.md                     # Complete setup instructions
├── CALIBRATION.md               # Calibration procedures
├── Printer-1/                   # Configuration for first printer
│   ├── printer.cfg             # Main Klipper configuration
│   ├── macros.cfg              # Custom macros
│   └── README.md               # Printer-specific notes
├── Printer-2/                   # Configuration for second printer
│   ├── printer.cfg             # Main Klipper configuration
│   ├── macros.cfg              # Custom macros
│   └── README.md               # Printer-specific notes
└── scripts/                     # Setup and utility scripts
    ├── install-git.sh          # Git setup for Raspberry Pi
    ├── pull-config.sh          # Script to pull latest config
    └── backup-config.sh        # Backup current configuration
```

## Quick Start

1. **Clone this repository** on your Raspberry Pi:
   ```bash
   git clone <your-repo-url> ~/printer-config
   ```

2. **Follow the setup guide**: See [SETUP.md](SETUP.md) for detailed instructions

3. **Configure your printer**: Copy the appropriate config from `Printer-1/` or `Printer-2/` to your Klipper config directory

4. **Calibrate**: Follow the steps in [CALIBRATION.md](CALIBRATION.md)

## Git Setup on Raspberry Pi

Each Raspberry Pi should pull its respective configuration. See [SETUP.md](SETUP.md) for detailed git setup instructions.

## Maintenance

- Keep configurations in sync with this repository
- Document any printer-specific adjustments
- Update calibration values as needed

## Notes

- Configuration files are optimized for 0.8mm nozzle
- Direct drive settings may need fine-tuning based on your specific extruder
- Filament sensor configuration depends on your sensor type
