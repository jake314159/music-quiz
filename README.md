music-quiz
==========

A simple comand line based music quiz.

Quick start guide
----------------

```bash
bash music-quiz.sh -d "~/music"
```

Where *"~/music"* is a direcory containing your songs. If not specified the current working directory will be used insted. The program will recursively search through the directory and so the music files can be in subdirectories.


Also avalible is a included is a simple script that uses *youtube-dl* to download music from youtube as set it up with the correct metadata. You can run this with the command:

```bash
bash download.sh https://www.youtube.com/watch?v=XXXX
```

Required software
------------

A few programs are required for music-quiz to work. They are:
+ mplayer
+ python

And for the download script:
+ youtube-dl
+ id3v2

Notice
---------

Please follow all local copyright laws. Please also ensure that you obtain the source music files legally and have permition to use it with this software.

