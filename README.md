# Headset Battery Plasmoid

A simple KDE Plasma system tray widget to display headset battery status using HeadsetControl.

## Features

- Shows battery percentage in system tray
- Uses HeadsetControl CLI for battery data
- Supports SteelSeries Arctis and other supported headsets
- Minimal popup-free design
- Auto-refreshes every 15 seconds
- Low battery notifications (when below 20%)
- Charging status indicator (different icon when charging)
- Auto-starts on login (once added to system tray)

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

### Find Your Device ID

If you have multiple headsets or need to specify a device:

```bash
# Run this command to see your connected device
headsetcontrol
```

Output example:
```
Found 1 supported device(s):
 SteelSeries Arctis 7+ [0x1038:0x220e]
```

The format is `vendorid:productid` = `0x1038:0x220e`

### Customize Settings

Edit `contents/ui/main.qml`:

#### Change Refresh Interval
```qml
// Line 18: Change refresh interval (in milliseconds)
// Default: 15000 (15 seconds)
interval: 15000
```

#### Change Low Battery Threshold
```qml
// Line 20: Change when to send notification (default: 20%)
lowBatteryThreshold: 20
```

#### Disable Low Battery Notifications
```qml
// Set to -1 to disable
lowBatteryThreshold: -1
```

#### Specify a Device
```qml
// Line 19: Add device ID if you have multiple headsets
// Format: headsetcontrol -d vendorid:productid -b -o json
property string command: "headsetcontrol -d 0x1038:0x220e -b -o json"
```

#### Common Device IDs

| Headset | Device ID |
|---------|-----------|
| SteelSeries Arctis 7+ | 0x1038:0x220e |
| SteelSeries Arctis 7 | 0x1038:0x12ad |
| SteelSeries Arctis Pro Wireless | 0x1038:0x12b6 |
| Logitech G533 | 0x046d:0x0a66 |
| Logitech G935 | 0x046d:0x0a9e |
| Corsair Virtuoso RGB | 0x1b1c:0x1b2c |

See [HeadsetControl supported devices](https://github.com/Sapd/HeadsetControl#supported-devices) for full list.

After editing:
```bash
systemctl --user restart plasma-plasmashell
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

### Multiple headsets
If you have multiple supported headsets, you must specify the device ID in the command. See "Specify a Device" section above.

## Uninstall

```bash
rm -rf ~/.local/share/plasma/plasmoids/org.kde.headsetbattery
systemctl --user restart plasma-plasmashell
```

## License

MIT License
