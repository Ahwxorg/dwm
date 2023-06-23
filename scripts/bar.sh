#!/bin/dash

# ^c$var^ = fg color
# ^b$var^ = bg color

interval=0

# load colors
. ~/.config/chadwm/scripts/bar_themes/catppuccin

cpu() {
  cpu_val=$(grep -o "^[^ ]*" /proc/loadavg)

  printf "^c$black^ ^b$green^ CPU"
  printf "^c$white^ ^b$grey^ $cpu_val"
}

vpn() {
  #updates=$({ timeout 20 doas xbps-install -un 2>/dev/null || true; } | wc -l) # void
  get_vpnstatus=$(ip a | grep tun0 &>/dev/null & echo a | wc -l)
  # updates=$({ timeout 20 aptitude search '~U' 2>/dev/null || true; } | wc -l)  # apt (ubuntu, debian etc)

  if [ "$get_vpnstatus" == "2" ]; then
    printf "  ^c$green^    VPN connected"
  else
    printf "  ^c$green^    VPN disconnected"
  fi
}

uptime() {
  get_uptime=$(dwm-upt)
  
  printf "  ^c$green^    $get_uptime"
}

battery() {
  get_capacity="$(cat /sys/class/power_supply/*/capacity)"
  printf "^c$blue^   $get_capacity"
}

brightness() {
  get_brightness="$(brightnessctl g -P)"
  printf "^c$red^   "
  printf "^c$red^%.0f\n" $get_brightness
#  printf "^c$red^%.0f\n" $(cat /sys/class/backlight/*/brightness)
}

mem() {
  printf "^c$blue^^b$black^  "
  printf "^c$blue^ $(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)"
}

wlan() {
	case "$(cat /sys/class/net/wl*/operstate 2>/dev/null)" in
	up) printf "^c$black^ ^b$blue^ 󰤨 ^d^%s" " ^c$blue^Connected" ;;
	down) printf "^c$black^ ^b$blue^ 󰤭 ^d^%s" " ^c$blue^Disconnected" ;;
	esac
}

clock() {
	printf "^c$black^ ^b$darkblue^ 󱑆 "
	printf "^c$black^^b$blue^ $(date '+%H:%M')  "
}

while true; do

  [ $interval = 0 ] || [ $(($interval % 3600)) = 0 ] && vpn_bar=$(vpn)
  interval=$((interval + 1))

  # sleep 5 && xsetroot -name "$updates $(battery) $(brightness) $(cpu) $(mem) $(wlan) $(clock)"
  sleep 5 && xsetroot -name "   $(uptime) $(battery) $(brightness) $(cpu) $(mem) $(wlan) $(clock)"
done
