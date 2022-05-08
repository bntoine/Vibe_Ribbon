#!/bin/sh

name=$1
url=$2
mkdir $name
cd $name

# Downloading the sound in the right format.
yt-dlp -q -f 'bestaudio[ext=m4a]' -ciw -o '%(title)s.%(ext)s' --extract-audio --audio-quality 0 --audio-format wav $url

# Making the cue file.
ls *.wav | awk '{printf "FILE \"%s\" BINARY\n  TRACK %02d AUDIO\n    INDEX 01 00:00:00\n",$0, NR}' > "$name.cue"
