#!/bin/bash

IFS=$(echo -en "\n\b")
DIR="$HOME"
VOL=85

WD=$(date -R)
WD=${WD:0:3}

minLength=$(( 25*60 ))
maxLength=$(( 29*60 ))

case $WD in
    "Mon")
        WD_DIR="1-Mon"
        ;;
    "Tue")
        WD_DIR="2-Tue"
        ;;
    "Wed")
        WD_DIR="3-Wed"
        ;;
    "Thu")
        WD_DIR="4-Thu"
        ;;
    "Fri")
        WD_DIR="5-Fri"
        ;;
esac



WD_DIR=$DIR"/"$WD_DIR

PROGRAM=$(date +%F)".mp3"

cd $DIR;

if [ -f $PROGRAM ]; then
    /usr/bin/mplayer $PROGRAM
    exit 0
fi

cd $WD_DIR

if [ -e "pl" ]; then
    rm "pl"
fi

duration=0

get_length() {
    length=0

    length=`/usr/bin/mplayer -vo null -ao null -frames 0 -identify $1 2>/dev/null | grep ID_LENGTH | awk -v FS='=' '{print $2}' | awk -v FS='.' '{print $1}'`
}

for song in $(ls .); do
    get_length $song

    duration=$(( $duration + $length ))

    if [ $duration -lt $maxLength ]; then
        echo $song>>pl
    fi
done

/usr/bin/mplayer -volume $VOL -playlist pl
exit 0
