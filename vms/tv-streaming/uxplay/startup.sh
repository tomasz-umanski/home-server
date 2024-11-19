#!/bin/bash

# Wait for system to settle
sleep 2

# hide cursor and top panel
unclutter -idle 4 &
xset s off -dpms s noblank &

# Configure display settings
xfconf-query -c displays -p /Default/Autodetect -n -t bool -s false
xfconf-query -c xfce4-panel -p /panels -n -t int -s 0
xfce4-panel --quit

# Set audio output
pactl set-card-profile alsa_card.pci-0000_00_11.0 output:hdmi-stereo
pactl set-default-sink alsa_output.pci-0000_00_11.0.hdmi-stereo

# Start uxplay for AirPlay
uxplay -n 'SamsungTV (Salon)' -nh -ca /home/USER_PLACEHOLDER/UxPlay/cover.jpg -nohold -fs &

# Wait for uxplay to start
sleep 2

# Start feh in fullscreen displaying image
feh --borderless --fullscreen --hide-pointer --zoom 150 /home/USER_PLACEHOLDER/UxPlay/cover.jpg &
