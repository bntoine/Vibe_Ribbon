#!/bin/bash

# I need bash arrays when copying the music from a local directory

# I found the information on how to make something readable for the emulator in this pastebin: https://pastebin.com/iFZKHbyH

if [ $# -ne 2 ]; then
    printf "Usage:\n$0 \"Name of the album\" \"path or URL(s)\"\n"
    exit 2
fi


name=$1
mkdir $name
cd $name
source=$2
case $source in
# SoundCloud
https://*soundcloud.com/*)
    yt-dlp -q --progress -o "tmp/%(title)s-%(id)s.mp3" $source
    for i in tmp/*.mp3; do ffmpeg -v error -i "$i" -ar 44100 -f s16le -acodec pcm_s16le "$(basename "${i%.*}").wav"; done;;

# Youtube
https://*youtube.com/* | https://*youtu.be/*)
    # Downloading the sound in the right format.
    yt-dlp -q --progress -f 'bestaudio[ext=m4a]' -ciw -o '%(title)s.%(ext)s' --extract-audio --audio-quality 0 --audio-format wav $source;;

https://*spotify.com/*)
    spotdl --output-format wav $source;;

# Matching for other urls (other url paterns should be added above)
http://* | https://*)
    #cd .. && rm -rf $name # Uncomment to delete folder on failure (not activated by default because I don't want to accidentally delete things)
    echo "This isn't currently supported."
    exit 2;;

# Anything else should be a local path
*)
    mkdir tmp
    if [ "$source" = "--gui" ] 2>>/dev/null;
    then
        source=$(zenity --file-selection --multiple --title="VibeRibbon") 
        [ -z "$source" ] && echo "Exited before making a selection" && exit 2 2>>/dev/null # Exiting if no file is selected
        IFS="|" read -ra files <<< "$source" # Formatting the output of zenity for cp
        for i in "${files[@]}"; do cp "$i" tmp; done
    else
        cp "${source%/}"/* tmp
    fi
    for i in tmp/*; do ffmpeg -v panic -i "$i" -ar 44100 -f s16le -acodec pcm_s16le "$(basename "${i%.*}").wav" && echo "done with $(basename "$i")"; done;;

esac

# Making the cue sheet to tell the emulator how to read the music.
# Aditional info on cue sheets: https://en.wikipedia.org/wiki/Cue_sheet_(computing)
ls *.wav | awk '{printf "FILE \"%s\" BINARY\n  TRACK %02d AUDIO\n    INDEX 01 00:00:00\n",$0, NR}' > "$name.cue"

# Adding the cue file to the M3U list for RetroArch.
#echo "$name/$name.cue" >> ../Vibe.m3u

# Cleanup
rm -rf tmp/
echo "Done!"
exit 0