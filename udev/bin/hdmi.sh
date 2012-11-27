#!/bin/sh

status="$(cat /sys/class/drm/card0-HDMI-A-1/status)"

export XAUTHORITY=/home/ja/.Xauthority
export DISPLAY=:0.0

if [ "${status}" = disconnected ]
then
 xrandr --output LVDS1 --auto --output HDMI1 --off
elif [ "${status}" = connected ]
then
 #xrandr --output LVDS1 --auto --output HDMI1 --auto --same-as LVDS1
 xrandr --output LVDS1 --off --output HDMI1 --auto 
fi
