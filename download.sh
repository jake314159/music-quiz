
youtube-dl --get-title -f "bestaudio" -o "delete-me.%(ext)s" "$1"


echo -en "Title:\t"
read TITLE
echo -en "Artist:\t"
read ARTIST

youtube-dl -f "bestaudio" -o "songs/$TITLE-$ARTIST.%(ext)s" "$1"
