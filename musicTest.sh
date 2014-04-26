
SAMPLE_LENGTH=00:00:10
#START_POINT=00:01:00

SONG_DIR=songs

SCORE=0
TOTAL=0

for i in {1..5}
do

    find songs -type f | shuf -n 1

    SONG_NAME=$(find $SONG_DIR -type f | shuf -n 1)
#"my body-young the giant.mp3"
    START_POINT=$(($RANDOM%60+60))

    mplayer -ss $START_POINT -endpos $SAMPLE_LENGTH "$SONG_NAME"

    echo -en "Title:\t"
    read GUESS_TITLE
    echo -en "Artist:\t"
    read GUESS_ARTIST

    

    FOR_COMPARE=`echo "$SONG_NAME" | cut -d'.' -f1`
    #echo -e " \n'$SONG_DIR/$GUESS_TITLE-$GUESS_ARTIST' equal \n'$FOR_COMPARE'?"
       echo -e "You wrote:                  '$GUESS_TITLE-$GUESS_ARTIST'"
    if [ "$SONG_DIR/$GUESS_TITLE-$GUESS_ARTIST" == "$FOR_COMPARE" ];
    then
        echo "CORRECT!" 
        SCORE=`expr $SCORE + 1`     
    else 
        echo -e "Sorry the answer was: '$SONG_NAME'"
    fi
    TOTAL=`expr $TOTAL + 1` 

    read IGNORE

    echo -e "\n\n"

done

echo "You scored $SCORE out of $TOTAL"

#echo "You entered: $GUESS_TITLE-$GUESS_ARTIST"


