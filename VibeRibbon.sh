#!/bin/sh


#I found the information on how to make something readable for the emulator in this pastebin: https://pastebin.com/iFZKHbyH

if [ $# -ne 3 ] || ! [ -d "$1" ]; then
    printf "Usage:\n$0 \"Path to the source directory\" \"Name of the album\" \"Extension of the source files (without the period)\"\n"
    exit 2
fi

sourcedir=$1
name=$2
ext=$3

mkdir "$name"

cd "$name"

cp "$sourcedir"*.$ext .

#Converting the source files to raw 16 bit signed pcm at 44100hz.
for i in *.$ext; do ffmpeg -v panic -i "$i" -ar 44100 -f s16le -acodec pcm_s16le "${i%%.*}.wav"; done

#Making the cue sheet to tell the emulator how to read the music.
#Aditional info on cue sheets: https://en.wikipedia.org/wiki/Cue_sheet_(computing)
ls *.wav | awk '{printf "FILE \"%s\" BINARY\n  TRACK %02d AUDIO\n    INDEX 01 00:00:00\n",$0, NR}' > "$name.cue"

#Adding the cue file to the M3U list for RetroArch.
#echo "$name/$name.cue" >> ../Vibe.m3u

#Cleanup
rm *.$ext
echo "Done!"
exit 0
