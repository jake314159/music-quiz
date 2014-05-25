
youtube-dl --get-title -f "bestaudio" -o "delete-me.%(ext)s" "$1"

echo -en "Title:\t"
read TITLE
echo -en "Artist:\t"
read ARTIST

youtube-dl --extract-audio --audio-format mp3 -o "$TITLE-$ARTIST.%(ext)s" "$1"
id3v2 --artist "$ARTIST" --song "$TITLE" "$TITLE-$ARTIST.mp3"

