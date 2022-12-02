#!/usr/bin/env bash


style="$($HOME/.config/rofi/applets/applets/style.sh)"

dir="$HOME/.config/rofi/scripts/styles"
rofi_command="rofi -theme $dir/screenshot.rasi"

# Error msg
msg() {
	rofi -theme "$dir/message.rasi" -e "Please install 'scrot' first."
}

post_process() {
	if [[ -f $1 ]]; then
		xclip -selection clipboard -target image/png -i $1;			
		viewnior $1;
	fi
}

# Options
screen=""
area=""
window=""

# Variable passed to rofi
options="$screen\n$area\n$window" 
pic_file="$(xdg-user-dir PICTURES)/Screenshots/Screenshot_$(date +%Y-%m-%d-%s).png"
chosen="$(echo -e "$options" | $rofi_command -p 'maim' -dmenu -selected-row 1)"
case $chosen in
    $screen)
		if [[ -f /usr/bin/maim ]]; then
			maim $pic_file
			post_process $pic_file;
		else
			msg
		fi
        ;;
    $area)
		if [[ -f /usr/bin/maim ]]; then
			maim -s -o $pic_file ;
			post_process $pic_file;
		else
			msg
		fi
        ;;
    $window)
		if [[ -f /usr/bin/maim ]]; then
			maim -i $(xdotool getactivewindow) $pic_file;
			post_process $pic_file;
		else
			msg
		fi
        ;;
esac

