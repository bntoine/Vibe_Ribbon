#!/bin/sh

if [ $# -ne 2 ]; then
    printf "Usage:\n$0 \"Name of the album\" \"URL(s)\"\n"
    exit 2
fi

name=$1
url=$2

mkdir $name
cd $name

case $url in
https://*soundcloud.com/*)
  yt-dlp -q $url
  for i in *.mp3; do ffmpeg -v panic -i "$i" -ar 44100 -f s16le -acodec pcm_s16le "${i%.*}.wav"; done;;
https://*youtube.com/* | https://*.youtu.be/*)
  # Downloading the sound in the right format.
  yt-dlp -q -f 'bestaudio[ext=m4a]' -ciw -o '%(title)s.%(ext)s' --extract-audio --audio-quality 0 --audio-format wav $url;;
*)
  #cd .. && rm -rf $name # Uncomment to delete folder on failure (not activated by default because I don't want to accidentally delete things)
  echo "This isn't currently supported."
  exit 2;;
esac


# Making the cue file.
ls *.wav | awk '{printf "FILE \"%s\" BINARY\n  TRACK %02d AUDIO\n    INDEX 01 00:00:00\n",$0, NR}' > "$name.cue"

# Adding the cue file to the M3U list for RetroArch.
#echo "$name/$name.cue" >> ../Vibe.m3u

exit 0