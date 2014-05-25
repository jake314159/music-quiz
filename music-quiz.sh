#
#   --------------------------------
#      music-quiz  
#      music-quiz.sh
#   -------------------------------- 
#
#        Author: Jacob Causon            
#                April 2014 
#
#   Licensed under the Apache License, Version 2.0 (the "License"); 
#    you may not use this file except in compliance with the License. 
#    You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#   Unless required by applicable law or agreed to in writing, software distributed
#    under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
#    CONDITIONS OF ANY KIND, either express or implied. See the License for the
#    specific language governing permissions and limitations under the License.
#
#


#How much of the song do you want to hear in seconds?
SAMPLE_LENGTH=12

SONG_DIR=.

FINE_SCORE=0
SCORE=0
TOTAL=0

while test $# -gt 0; do
    case "$1" in
        -h|--help)
            echo "Music quiz application"
            echo ""
            echo "Options:"
            echo "    -d --music-directory"
            echo "        Specifies the location of the music files used in the quiz. The default "
            echo "        is the current working directory"
            echo "    -l --sample-length"
            echo "        Specifies the length of the sample you get to hear. The default is 12"
            echo "        seconds"

            exit 0
        ;;
        -d|--music-directory)
            shift
            if test $# -gt 0; then
                export SONG_DIR=$1
            fi
            shift
        ;;
        -l|--sample-length)
            shift
            if test $# -gt 0; then
                export SAMPLE_LENGTH=$1
            fi
            shift
    esac
done


for i in {1..10}
do

    errCount=20
    SONG_NAME=""
    SONG_ARTIST=""
    SONG_TITLE=""

    #Find a music file which has the required meta data
    while [[ "$errCount" -gt 0 && ( "$SONG_ARTIST" == "" || "$SONG_TITLE" == "" )]]; do
        SONG_NAME=$(find "$SONG_DIR" -type f | grep '.*\.\(mp3\|m4a\|flac\|ogg\|m4p\|ra\|wma\)' | shuf -n 1)
        #echo "Song: $SONG_NAME"
        SONG_ARTIST=`avprobe "$SONG_NAME" 3>&1 1>&2- 2>&3- > /dev/null | grep 'artist' | head -n 1 | sed 's/.*:[ ]*//'`
        SONG_TITLE=`avprobe "$SONG_NAME" 3>&1 1>&2- 2>&3- > /dev/null | grep 'title' | head -n 1 | sed 's/.*:[ ]*//'`
        errCount=`expr $errCount - 1`
    done

    # We couldn't find a valid music file so display an error and exit
    if [ "$errCount" -le 0 ]; then
        echo "Error finding a music file with the meta data filled"
        exit 1
    fi

    ## Start at some point in the song avoiding the first and last 30s
    LENGTH=$(mplayer -ao null -identify -frames 0 "$SONG_NAME" 2>&1 | grep ID_LENGTH | grep -o '[0-9]*\.' | grep -o '[0-9]*')
    LENGTH_TO_USE=`expr $LENGTH - 60 - $SAMPLE_LENGTH`
    START_POINT=$(($RANDOM%$LENGTH_TO_USE+30))

    echo -n "Song playing "
    # Note the output is sent to /dev/null because it contains the answer
    mplayer -ss $START_POINT -endpos $SAMPLE_LENGTH "$SONG_NAME" > /dev/null 2> /dev/null
    echo -ne "\n"

    read -t 1 IGNORE

    echo -en "Title:\t"
    read GUESS_TITLE
    echo -en "Artist:\t"
    read GUESS_ARTIST

    TITLE_SCORE=`python scoreCalculator.py "$SONG_TITLE" "$GUESS_TITLE"`
    ARTIST_SCORE=`python scoreCalculator.py "$SONG_ARTIST" "$GUESS_ARTIST"`
    TOTAL_SCORE=`expr $TITLE_SCORE + $ARTIST_SCORE`
    FINE_SCORE=`expr $FINE_SCORE + $TOTAL_SCORE`

    echo -e "You wrote:\t'$GUESS_TITLE - $GUESS_ARTIST'"
    if [ $TOTAL_SCORE == 200 ];
    then
        echo "CORRECT!" 
        SCORE=`expr $SCORE + 1`  
    else 
        echo -e "Answer:   \t'$SONG_TITLE - $SONG_ARTIST'"
    
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

