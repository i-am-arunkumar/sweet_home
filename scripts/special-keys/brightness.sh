
usage="usage: $0 -c {up|down|mute} [-i increment]"
command=
offset=5%
message="Brightness"

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
    echo "usage: $0 {up|down} [increment]"
    exit 0;
fi

brightness=0

if [ "$command" = "up" ]; then
    brightness=$(brightnessctl s $offset+ | grep -m 1 "%)" | cut -d "(" -f2|cut -d "%" -f1)
fi

if [ "$command" = "down" ]; then
        brightness=$(brightnessctl s $offset- | grep -m 1 "%)" | cut -d "(" -f2|cut -d "%" -f1)
fi

icon_name=""


if [ "$icon_name" = "" ]; then
        if [ "$brightness" -lt "30" ]; then
            icon_name="brightness-low"
        else
            if [ "$brightness" -lt "70" ]; then
                icon_name="brightness-medium"
            else
                icon_name="brightness-high"
            fi
        fi
fi
    
notify-send -i $icon_name $message -h int:value:$brightness -h string:synchronous:volume -t 1000

