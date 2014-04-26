
#How much of the song do you want to hear in seconds?
SAMPLE_LENGTH=10

SONG_DIR=songs

SCORE=0
TOTAL=0

for i in {1..5}
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
    FOR_COMPARE=`echo "$SONG_NAME" | cut -d'.' -f1`

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

