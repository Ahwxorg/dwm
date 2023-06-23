#!/bin/sh

# setbg $(find ~/pix/wall/ultrawide-collection/ | grep -E 'png|jpg|jpeg' | uniq | shuf -n1)
picom &
sxhkd &
kitty &

~/.config/chadwm/scripts/bar.sh &
while type dwm >/dev/null; do dwm && continue || break; done
