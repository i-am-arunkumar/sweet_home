
usage="usage: $0 -c {up|down|mute|mic} [-i increment] [-m mixer]"
command=
offset=5%
mixer=Master
message="Volume"

while getopts i:m:h o
do case "$o" in
    i) increment=$OPTARG;;
    m) mixer=$OPTARG;;
    h) echo "$usage"; exit 0;;
    ?) echo "$usage"; exit 0;;
esac
done

shift $(($OPTIND - 1))
command=$1

if [ "$command" = "" ]; then
    echo "usage: $0 {up|down|mute} [increment]"
    exit 0;
fi

display_volume=0
icon_name=""

if [ "$command" = "up" ]; then
    display_volume=$(amixer -D pulse set $mixer $offset+ unmute | grep -m 1 "%]" | cut -d "[" -f2|cut -d "%" -f1)
fi

if [ "$command" = "down" ]; then
    display_volume=$(amixer -D pulse set $mixer $offset- unmute | grep -m 1 "%]" | cut -d "[" -f2|cut -d "%" -f1)
fi


if [ "$command" = "mute" ]; then
	if amixer -D pulse set Master toggle | grep "\[off\]" ;then
		icon_name="audio-volume-muted"	
		message="Mute"
		display_volume=-1
	else
		display_volume=$(amixer -D pulse get $mixer | grep -m 1 "%]" | cut -d "[" -f2|cut -d "%" -f1)
        fi
  	
fi



if [ "$command" = "mic" ]; then
	if amixer set Capture toggle | grep "\[off\]" ;then
		icon_name="microphone-disabled"	
		message="Mic off"
		display_volume=-1
	else
		icon_name="microphone-enabled"	
		message="Mic on"
		display_volume=-1
        fi
  	
fi


if [ "$icon_name" = "" ]; then
    if [ "$display_volume" = "0" ]; then
    	message="Muted"
        icon_name="audio-volume-muted"
    else
        if [ "$display_volume" -lt "30" ]; then
            icon_name="audio-volume-low"
        else
            if [ "$display_volume" -lt "70" ]; then
                icon_name="audio-volume-medium"
            else
                icon_name="audio-volume-high"
            fi
        fi
    fi
fi
    
if [ $display_volume -lt 0 ]; then
	notify-send -i $icon_name "$message" -h string:synchronous:volume -t 1000
else 
	notify-send -i $icon_name "$message" -h int:value:$display_volume -h string:synchronous:volume -t 1000
fi

