pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasma5support as Plasma5Support
import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents

PlasmoidItem {
    id: root

    property int batteryLevel: -3
    property string batteryStatus: "unknown"
    property string deviceLabel: "Headset"
    property string lastRaw: ""
    property string lastUpdated: "--:--"
    property string command: "headsetcontrol -b -o json"

    function parseOutput(text) {
        var now = new Date();
        lastUpdated = now.toLocaleTimeString(Qt.locale(), "hh:mm");
        var trimmed = text.trim();
        lastRaw = trimmed;
        batteryLevel = -3;
        batteryStatus = "unknown";
        deviceLabel = "Headset";

        if (!trimmed) {
            return;
        }

        var parsed = null;
        try {
            parsed = JSON.parse(trimmed);
        } catch (e) {
            return;
        }

        if (!parsed || !parsed.devices || parsed.devices.length === 0) {
            batteryStatus = "unavailable";
            return;
        }

        var dev = parsed.devices[0];
        if (dev.device) {
            deviceLabel = dev.device;
        } else if (dev.product) {
            deviceLabel = dev.product;
        }

        if (!dev.battery) {
            batteryStatus = "unavailable";
            return;
        }

        var status = dev.battery.status || "";
        var level = dev.battery.level;

        if (status.indexOf("CHARGING") !== -1) {
            batteryStatus = "charging";
        } else if (status.indexOf("UNAVAILABLE") !== -1) {
            batteryStatus = "unavailable";
        } else if (status.indexOf("AVAILABLE") !== -1) {
            batteryStatus = "available";
        }

        if (typeof level === "number") {
            batteryLevel = Math.max(0, Math.min(100, level));
        }
    }

    function batteryIconName() {
        if (batteryStatus === "charging") {
            return "battery-charging";
        }
        if (batteryStatus === "unavailable") {
            return "battery-missing";
        }
        if (batteryStatus === "unknown") {
            return "battery-unknown";
        }
        if (batteryLevel <= 10) {
            return "battery-empty";
        }
        if (batteryLevel <= 25) {
            return "battery-caution";
        }
        if (batteryLevel <= 50) {
            return "battery-low";
        }
        if (batteryLevel <= 75) {
            return "battery-medium";
        }
        if (batteryLevel <= 90) {
            return "battery-high";
        }
        return "battery-full";
    }

    function displayText() {
        if (batteryStatus === "unavailable") {
            return "n/a";
        }
        if (batteryStatus === "unknown") {
            return "...";
        }
        if (batteryLevel < 0) {
            return batteryStatus === "charging" ? "chg" : "?";
        }
        return batteryLevel + "%";
    }

    function statusText() {
        if (batteryStatus === "charging") {
            return "Charging";
        }
        if (batteryStatus === "available") {
            return "On battery";
        }
        if (batteryStatus === "unavailable") {
            return "Unavailable";
        }
        return "Unknown";
    }

    Plasma5Support.DataSource {
        id: commandSource
        engine: "executable"
        interval: 15000
        connectedSources: [root.command]

        onNewData: (sourceName, data) => {
            var stdout = "";
            if (data && data["stdout"] !== undefined) {
                stdout = data["stdout"];
            }
            root.parseOutput(stdout);
        }
    }

    Plasmoid.icon: batteryIconName()
    Plasmoid.status: PlasmaCore.Types.ActiveStatus

    compactRepresentation: Item {
        implicitWidth: label.implicitWidth + PlasmaCore.Units.smallSpacing
        implicitHeight: PlasmaCore.Units.iconSizes.small

        PlasmaComponents.Label {
            id: label
            anchors.centerIn: parent
            text: root.displayText()
            verticalAlignment: Text.AlignVCenter
        }
    }

    fullRepresentation: Item {
        implicitWidth: 0
        implicitHeight: 0
    }
}
