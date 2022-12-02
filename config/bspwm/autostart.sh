#Startup apps/scripts

#1 - command name
#2 - is daemon process
#3 - command argument

start(){
	if  ! pgrep -x "$1" > /dev/null;
	then
		if [[ "${2:-true}" == "true" ]];
		then
			echo "$1"
			if [ -n "$3" ]; then "$1" "$3" & 
			else
			 "$1" & 
			fi
		else
			if [ -n "$3" ]; then "$1" "$3" 
			else
			 "$1" 
			fi
		fi
	fi
} 

start mpd false #music player daemon
start sxhkd #hotKey daemon
start dunst #Notification daemon
start plank #dock
start touchegg #touchpad gesture frontend
start picom true --experimental-backends #compositor 
start udiskie true --no-notify #drive automounting
$HOME/.config/polybar/launch.sh & #polybar
nitrogen --restore #wallpaper

unset start
#applets
#blueman-applet &
#nm-applet &

#system tray
#$HOME/.config/trayer/trayer.sh &




