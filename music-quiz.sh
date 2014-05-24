
#How much of the song do you want to hear in seconds?
SAMPLE_LENGTH=16

SONG_DIR=songs

FINE_SCORE=0
SCORE=0
TOTAL=0

for i in {1..10}
do

    find songs -type f | shuf -n 1

    SONG_NAME=$(find $SONG_DIR -type f | shuf -n 1)

    ## Start at some point in the song avoiding the first and last 30s
    LENGTH=$(mplayer -ao null -identify -frames 0 "$SONG_NAME" 2>&1 | grep ID_LENGTH | grep -o '[0-9]*\.' | grep -o '[0-9]*')
    LENGTH_TO_USE=`expr $LENGTH - 60 - $SAMPLE_LENGTH`
    START_POINT=$(($RANDOM%$LENGTH_TO_USE+30))

    mplayer -ss $START_POINT -endpos $SAMPLE_LENGTH "$SONG_NAME"

    echo -en "Title:\t"
    read GUESS_TITLE
    echo -en "Artist:\t"
    read GUESS_ARTIST

    # Remove ext
    FOR_COMPARE=`echo "$SONG_NAME" | grep -o '.*\.'`
    FOR_COMPARE=`echo "${FOR_COMPARE%?}"`            ## Remove the . of the extention left over in the last line

    echo -e "You wrote:                  '$GUESS_TITLE-$GUESS_ARTIST'"
    if [ "$SONG_DIR/$GUESS_TITLE-$GUESS_ARTIST" == "$FOR_COMPARE" ];
    then
        echo "CORRECT!" 
        SCORE=`expr $SCORE + 1` 
        FINE_SCORE=`expr $FINE_SCORE + 100`    
    else 
        echo -e "Sorry the answer was: '$FOR_COMPARE'"
        SONG_TITLE=`echo "$FOR_COMPARE" | sed 's/.*\///' | cut -d'/' -f1 | cut -d'-' -f1`
        SONG_ARTIST=`echo "$FOR_COMPARE" | cut -d'-' -f2`
        #echo "song title '$SONG_TITLE'"
        #echo "song artist '$SONG_ARTIST'"
        if [ "$GUESS_TITLE" == "$SONG_TITLE" ];
        then
            echo "But the title was right"
            FINE_SCORE=`expr $FINE_SCORE + 50` 
        fi  
        if [ "$GUESS_ARTIST" == "$SONG_ARTIST" ];
        then
            echo "But the artist was right"
            FINE_SCORE=`expr $FINE_SCORE + 50` 
        fi

        REPLAY = "n"
        echo -en "Do you wan't to play the song again [y/N]: "
        read REPLAY
        if [ "$REPLAY" == "y" ];
        then
            mplayer -ss $START_POINT -endpos $SAMPLE_LENGTH "$SONG_NAME"
        fi
    fi
    TOTAL=`expr $TOTAL + 1` 

    read IGNORE

    echo -e "\n\n"

done

echo "You scored $SCORE out of $TOTAL"
echo "Fine score is $FINE_SCORE"

