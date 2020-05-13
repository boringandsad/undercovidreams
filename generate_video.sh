#!/bin/bash
IFS=$'\n'
colors=(123456 aadd43)
colors_num=${#colors[@]}

function generate_image()
{
    TITLE="$1"
    COLOR=$2
    ID=$3
echo -e "$TITLE"|convert -font ~/Library/Fonts/swiss\ 721\ narrow\ bold\ swa.ttf -background $COLOR -density 196 -resample 72 -fill white -page 1920x1080 -pointsize 330 text:- +repage images/$ID.png
}

function generate_video()
{
    TITLE="$1"
    AUDIO="$2"
    ID=$3
    ffmpeg -loop 1 -y -i images/$ID.png -i audio/$AUDIO -c:v libx264 -tune stillimage -filter:v fps=fps=30 -strict -2 -c:a aac -b:a 192k -pix_fmt yuv420p -shortest videos/${ID}.mp4
}

for i in $(cat info.cfg)
do
    AUDIO=$(echo $i|cut -d ":" -f 1)
    TITLE=$(echo $i|cut -d ":" -f 2)
    COLOR=${colors[$(expr $RANDOM % $colors_num)]}
    ID=$(basename $AUDIO .mp3)
    echo "********** Generating content for dream $ID *********"
#    echo "audio:$AUDIO"
    echo "title:$TITLE"
#    echo "color:$COLOR"
    echo "ID:$ID"
    echo -n "generating image... "
    generate_image "$TITLE" "#$COLOR" $ID
    if [ ! -f images/$ID.png ]
    then
        echo "Image $ID.png not found"
        exit 1
    fi
    echo "ok"

    echo -n "generating video... "    
    generate_video "$TITLE" "$AUDIO" $ID
    if [ ! -f videos/$ID.mp4 ]
    then
        echo "Video $ID.mp4 not found"
        exit 1
    fi
    echo -e "ok\n"
    echo ""
done
exit 1

ID=$(basename $AUDIO|cut -d '.' -f 1)
echo $ID

#To generate the image:

echo -e "$TITLE"|convert -font ~/Library/Fonts/swiss\ 721\ narrow\ bold\ swa.ttf -background $COLOR -density 196 -resample 72 -fill white -page 1920x1080 -pointsize 330 text:- +repage $ID.png

if [ ! -f $ID.png ]
then
    echo "Image $ID.png not found"
    exit 1
fi
#To generate the video:
ffmpeg -loop 1 -y -i $ID.png -i $AUDIO -c:v libx264 -tune stillimage -filter:v fps=fps=30 -strict -2 -c:a aac -b:a 192k -pix_fmt yuv420p -shortest ${ID}-HD.mp4
#ffmpeg -loop 1 -y -framerate 30 -i 04-11_4.png -i 04-11_4.ogg -codec copy -shortest output.mkv
#ffmpeg -loop 1 -y -i $ID.png -i $AUDIO -c:v libx264 -crf 18 -c:a copy $ID.mkv

