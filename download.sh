#
#   --------------------------------
#      music-quiz  
#      download.sh
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

youtube-dl --get-title -f "bestaudio" -o "delete-me.%(ext)s" "$1"

echo -en "Title:\t"
read TITLE
echo -en "Artist:\t"
read ARTIST

youtube-dl --extract-audio --audio-format mp3 -o "$TITLE-$ARTIST.%(ext)s" "$1"
id3v2 --artist "$ARTIST" --song "$TITLE" "$TITLE-$ARTIST.mp3"

