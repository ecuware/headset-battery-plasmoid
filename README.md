# Headset Battery Plasmoid

A simple KDE Plasma system tray widget to display headset battery status using HeadsetControl.

## Features

- Shows battery percentage in system tray
- Uses HeadsetControl CLI for battery data
- Supports SteelSeries Arctis and other supported headsets
- Minimal popup-free design
- Auto-refreshes every 15 seconds

## Requirements

- KDE Plasma 6
- [HeadsetControl](https://github.com/Sapd/HeadsetControl) installed and working

### Install HeadsetControl

```bash
# Arch Linux
sudo pacman -S headsetcontrol

# Other distros: https://github.com/Sapd/HeadsetControl#installation
```

## Installation

### Option 1: Manual Install (Recommended)

```bash
# Create local plasmoid directory
mkdir -p ~/.local/share/plasma/plasmoids/com.cachy.headsetbattery

# Copy files
cp -r * ~/.local/share/plasma/plasmoids/com.cachy.headsetbattery/

# Restart Plasma
systemctl --user restart plasma-plasmashell
```

### Option 2: Add to System Tray

1. Right-click on system tray → "System Tray Settings"
2. Go to "Entries" tab
3. Find "Headset Battery" and enable it

## Configuration

The plasmoid works out of the box. Default settings:
- Refresh interval: 15 seconds
- Command: `headsetcontrol -b -o json`

### To Modify Settings

Edit `contents/ui/main.qml`:

```qml
// Change refresh interval (in milliseconds)
interval: 15000

// Change headsetcontrol command if needed
property string command: "headsetcontrol -b -o json"
```

## Supported Headsets

See [HeadsetControl device list](https://github.com/Sapd/HeadsetControl#supported-devices).

## Troubleshooting

### Icon not showing
- Make sure headsetcontrol is installed: `headsetcontrol -b`
- Check if your headset is connected and detected

### Still not working
- Restart Plasma: `systemctl --user restart plasma-plasmashell`
- Check logs: `journalctl --user -u plasma-plasmashell | grep headsetbattery`

## License

MIT License
