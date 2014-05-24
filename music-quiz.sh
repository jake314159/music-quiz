
#How much of the song do you want to hear in seconds?
SAMPLE_LENGTH=12

SONG_DIR=songs

FINE_SCORE=0
SCORE=0
TOTAL=0

for i in {1..10}
do

    SONG_NAME=$(find $SONG_DIR -type f | shuf -n 1)

    ## Start at some point in the song avoiding the first and last 30s
    LENGTH=$(mplayer -ao null -identify -frames 0 "$SONG_NAME" 2>&1 | grep ID_LENGTH | grep -o '[0-9]*\.' | grep -o '[0-9]*')
    LENGTH_TO_USE=`expr $LENGTH - 60 - $SAMPLE_LENGTH`
    START_POINT=$(($RANDOM%$LENGTH_TO_USE+30))

    echo -n "Song playing "
    mplayer -ss $START_POINT -endpos $SAMPLE_LENGTH "$SONG_NAME" > /dev/null 2> /dev/null
    echo -ne "\n"

    read IGNORE

    echo -en "Title:\t"
    read GUESS_TITLE
    echo -en "Artist:\t"
    read GUESS_ARTIST

    # Remove ext
    FOR_COMPARE=`echo "$SONG_NAME" | grep -o '.*\.'`
    FOR_COMPARE=`echo "${FOR_COMPARE%?}"`            ## Remove the . of the extention left over in the last line

    SONG_TITLE=`echo "$FOR_COMPARE" | sed 's/.*\///' | cut -d'/' -f1 | cut -d'-' -f1`
    SONG_ARTIST=`echo "$FOR_COMPARE" | cut -d'-' -f2`

    TITLE_SCORE=`python scoreCalculator.py "$SONG_TITLE" "$GUESS_TITLE"`
    ARTIST_SCORE=`python scoreCalculator.py "$SONG_ARTIST" "$GUESS_ARTIST"`
    TOTAL_SCORE=`expr $TITLE_SCORE + $ARTIST_SCORE`
    FINE_SCORE=`expr $FINE_SCORE + $TOTAL_SCORE`

    echo -e "You wrote:                  '$GUESS_TITLE-$GUESS_ARTIST'"
    if [ "$SONG_DIR/$GUESS_TITLE-$GUESS_ARTIST" == "$FOR_COMPARE" ];
    then
        echo "CORRECT!" 
        SCORE=`expr $SCORE + 1` 
        FINE_SCORE=`expr $FINE_SCORE + 100`    
    else 
        echo -e "Sorry the answer was: '$FOR_COMPARE'"
    
        echo "You got $TOTAL_SCORE points"
 
    fi
    TOTAL=`expr $TOTAL + 1` 

    REPLAY="n"
    echo -en "Do you wan't to play the song again [y/N]: "
    read REPLAY
    if [ "$REPLAY" == "y" ];
    then
        mplayer -ss $START_POINT -endpos $SAMPLE_LENGTH "$SONG_NAME"
    fi

    echo -e "\n\n"

done

echo "You correctly answered $SCORE question out of $TOTAL"
echo "Your score is $FINE_SCORE"

