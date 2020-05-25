#!/bin/bash
IFS=$'\n'
#colors=(123456 aadd43)
#colors=(b08699 c9303e fff59e b85e00)
colors=(67ceab ff9dce bcb8d5 ffa500)
colors_num=${#colors[@]}
FONTSIZE=260
function generate_image()
{
    TITLE="$1"
    COLOR=$2
    ID=$3
    OUTFILE=images/$ID.png
    if [[ -f $OUTFILE ]]
    then
        echo "Skipping. File $OUTFILE already exists"
    else

    echo -e "$TITLE"|convert -font swa.ttf -background $COLOR -density 196 -resample 72 -fill white \
                             -page 1920x1080 -pointsize $FONTSIZE text:- +repage $OUTFILE
    fi
}

function generate_video()
{
    AUDIO="$1"
    ID=$2
    OUTFILE=videos/${ID}.mp4
#    echo $OUTFILE
    if [[ -f $OUTFILE ]]
    then
        echo "Skipping. File $OUTFILE already exists"
    else
        ffmpeg -loglevel 8 -loop 1 -y -i images/$ID.png -i audio/$AUDIO -c:v libx264 \
               -tune stillimage -filter:v fps=fps=30 -strict -2 -c:a aac \
               -b:a 192k -pix_fmt yuv420p -shortest $OUTFILE
    fi
}

# for i in $(cat info.cfg)
# do
#     AUDIO=$(echo $i|cut -d ":" -f 1)".mp3"
#     TITLE=$(echo $i|cut -d ":" -f 2)
#     COLOR=${colors[$(expr $RANDOM % $colors_num)]}
#     ID=$(basename $AUDIO .mp3)
#     echo "********** Generating content for dream $ID *********"
#     echo "title:$TITLE"
#     echo "color:$COLOR"
#     echo "ID:$ID"
#     echo -n "generating image... "
#     generate_image "$TITLE" "#$COLOR" $ID
#     if [ ! -f images/$ID.png ]
#     then
#         echo "Image $ID.png not found"
#         exit 1
#     fi
#     echo "ok. Image: images/$ID.png"
# done

#exit 2
for i in $(cat info.cfg)
do
    AUDIO=$(echo $i|cut -d ":" -f 1)".mp3"
    ID=$(basename $AUDIO .mp3)
    echo "********** Generating video for dream $ID *********"
    echo "ID:$ID"
    echo -n "generating video... "    
    generate_video "$AUDIO" $ID
    if [ ! -f videos/$ID.mp4 ]
    then
        echo "Video $ID.mp4 not found"
        exit 1
    fi
    echo -e "ok. Video: videos/$ID.mp4 \n"
    echo ""
done
