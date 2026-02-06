#!/usr/bin/env bash
# Rofi Bluetooth Menu - Better than blueman

# Check if bluetooth is powered on
power_on() {
    if bluetoothctl show | grep -q "Powered: yes"; then
        return 0
    else
        return 1
    fi
}

# Toggle bluetooth power
toggle_power() {
    if power_on; then
        bluetoothctl power off
        echo "Bluetooth disabled"
    else
        bluetoothctl power on
        echo "Bluetooth enabled"
    fi
}

# Get list of devices
get_devices() {
    bluetoothctl devices | while read -r device; do
        mac=$(echo "$device" | awk '{print $2}')
        name=$(echo "$device" | sed 's/^Device [^ ]* //')

        # Check if device is connected
        if bluetoothctl info "$mac" | grep -q "Connected: yes"; then
            echo "󰂱 $name | $mac"
        else
            echo "󰂯 $name | $mac"
        fi
    done
}

# Main menu
if power_on; then
    toggle="󰂲  Disable Bluetooth"
    devices=$(get_devices)
    scan="  Scan for Devices"
    menu="$toggle\n$scan\n$devices"
else
    toggle="󰂯  Enable Bluetooth"
    menu="$toggle"
fi

# Show rofi menu
chosen=$(echo -e "$menu" | rofi -dmenu -i -p "Bluetooth" -no-custom)

# Handle selection
if [ -z "$chosen" ]; then
    exit
elif [ "$chosen" = "󰂲  Disable Bluetooth" ]; then
    bluetoothctl power off
    notify-send "Bluetooth" "Disabled"
elif [ "$chosen" = "󰂯  Enable Bluetooth" ]; then
    bluetoothctl power on
    notify-send "Bluetooth" "Enabled"
elif [ "$chosen" = "  Scan for Devices" ]; then
    bluetoothctl scan on &
    sleep 5
    killall bluetoothctl
    notify-send "Bluetooth" "Scan complete"
    exec "$0"
else
    # Get MAC address from selection
    mac=$(echo "$chosen" | awk -F'|' '{print $2}' | xargs)

    # Toggle connection
    if echo "$chosen" | grep -q "󰂱"; then
        bluetoothctl disconnect "$mac"
        notify-send "Bluetooth" "Disconnected from $(echo $chosen | awk -F'|' '{print $1}')"
    else
        bluetoothctl connect "$mac"
        notify-send "Bluetooth" "Connected to $(echo $chosen | awk -F'|' '{print $1}')"
    fi
fi
