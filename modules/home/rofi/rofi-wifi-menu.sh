#!/usr/bin/env bash
# Rofi WiFi Menu - Better than nm-applet

# Get list of available WiFi networks
wifi_list=$(nmcli --fields "SECURITY,SSID" device wifi list | sed 1d | sed 's/  */ /g' | sed -E "s/WPA*.?/🔒/g" | sed "s/^--/ /g" | sed "s/🔒/🔒 /g")

# Get current connection
connected=$(nmcli -fields WIFI g)
if [[ "$connected" =~ "enabled" ]]; then
    toggle="󰖪  Disable WiFi"
elif [[ "$connected" =~ "disabled" ]]; then
    toggle="  Enable WiFi"
fi

# Use rofi to select wifi network
chosen_network=$(echo -e "$toggle\n$wifi_list" | uniq -u | rofi -dmenu -i -selected-row 1 -p "WiFi" )

# Get name of connection
read -r chosen_id <<< "${chosen_network:3}"

if [ "$chosen_network" = "" ]; then
    exit
elif [ "$chosen_network" = "󰖪  Disable WiFi" ]; then
    nmcli radio wifi off
elif [ "$chosen_network" = "  Enable WiFi" ]; then
    nmcli radio wifi on
else
    # Check if network is secured
    if [[ "$chosen_network" =~ "🔒" ]]; then
        wifi_password=$(rofi -dmenu -p "Password" -password )
    fi

    # Connect to chosen network
    if [ -z "$wifi_password" ]; then
        nmcli device wifi connect "$chosen_id"
    else
        nmcli device wifi connect "$chosen_id" password "$wifi_password"
    fi
fi
