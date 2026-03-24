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

# Ubuntu/Debian
sudo apt install headsetcontrol

# Fedora
sudo dnf install headsetcontrol

# Build from source: https://github.com/Sapd/HeadsetControl#building-from-source
```

## Installation

### Step 1: Install Plasmoid

```bash
# Create local plasmoid directory
mkdir -p ~/.local/share/plasma/plasmoids/org.kde.headsetbattery

# Clone or download this repository, then copy files
git clone https://github.com/ecuware/headset-battery-plasmoid.git
cp -r headset-battery-plasmoid/* ~/.local/share/plasma/plasmoids/org.kde.headsetbattery/

# Restart Plasma
systemctl --user restart plasma-plasmashell
```

### Step 2: Add to System Tray

**Option A: Automatic (first run)**
- Log out and log back in, or restart your computer
- The widget should appear automatically

**Option B: Manual**
1. Right-click on system tray → "System Tray Settings"
2. Go to "Entries" tab
3. Find "Headset Battery" in the list
4. Enable it

## Configuration

The plasmoid works out of the box. Default settings:
- Refresh interval: 15 seconds
- Command: `headsetcontrol -b -o json`

### To Customize

Edit `contents/ui/main.qml`:

```qml
// Change refresh interval (in milliseconds)
// Default: 15000 (15 seconds)
interval: 15000

// Change headsetcontrol command if needed
property string command: "headsetcontrol -b -o json"
```

## Supported Headsets

See [HeadsetControl device list](https://github.com/Sapd/HeadsetControl#supported-devices).

## Troubleshooting

### Icon not showing
1. Make sure headsetcontrol is installed: `headsetcontrol -b`
2. Check if your headset is connected and detected
3. Check system tray settings: Right-click tray → System Tray Settings → Entries

### Still not working
- Restart Plasma: `systemctl --user restart plasma-plasmashell`
- Check logs: `journalctl --user -u plasma-plasmashell | grep -i headset`

### Multiple headset users
If you have multiple headsets, you may need to specify the device. Check HeadsetControl documentation.

## Uninstall

```bash
rm -rf ~/.local/share/plasma/plasmoids/org.kde.headsetbattery
systemctl --user restart plasma-plasmashell
```

## License

MIT License
