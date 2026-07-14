#!/bin/bash
 
ip_address=$(/bin/cat /home/xoe/.config/bin/target | awk '{print $1}')
machine_name=$(/bin/cat /home/xoe/.config/bin/target | awk '{print $2}')
 
if [ $ip_address ] && [ $machine_name ]; then
    echo "%{F#00FF00}󰓾 %{F#ffffff}$ip_address%{u-} - $machine_name"
else
    echo "%{F#e51d0b}󰓾 %{u-}%{F#ffffff} No target"
fi
