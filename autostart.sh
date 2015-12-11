#!/bin/sh

setxkbmap -option ctrl:nocaps
xcape -e '#66=Escape;Control_L=Escape;Control_R=Escape'
xset r rate 180 40

xrdb -load ~/dotfiles/xresources/Xresources
xrdb -merge ~/dotfiles/xresources/luciusLight

if xrandr | grep -q 'HDMI1 connected'; then
    xrandr --output LVDS1 --off
fi
