## Vibe Ribbon, a simple music conversion script for the PS1 game Vib Ribbon.
I wanted to play custom songs in Vib Ribbon ibecause I think it's a pretty cool game so I made a quick one liner to convert my music that I based on information I found in [this pastebin](https://pastebin.com/iFZKHbyH) and I thought that I might as well make a little script to do it for me and share it.

I have successfully tested this script with the game running on [DuckStation](https://github.com/stenzek/duckstation/). I was not able to use the output files of this script on PCSX2.

You need [ffmpeg](https://github.com/FFmpeg/FFmpeg), some music, and an emulator that accepts .cue files ([cue sheets](https://en.wikipedia.org/wiki/Cue_sheet_(computing))) as CDs.
You can get ffmpeg through your usual package manager.
And you can get both the japanese and PAL versions of the game on the internet archive (I have however not tested them).

## Usage.
**Dowload and setup**
```sh
git clone https://github.com/bntoine/Vibe_Ribbon.git
cd Vibe_Ribbon
chmod +x VibeRibbon
```

**Using the script:**
```
./VibeRibbon Path_To_The_Source_Directory Name Source_Extension
```
* The **Source Directory** should contain the songs you want to add to that "disk". Each file will be seen as a track by the game.
Beware, the format they will be converted to is quite a lot larger than most audio files so don't add too many.

* The **Name** is the name that will be given to the folder the tracks will be placed in and the name that will be given to the cue file.

* The **Source Extension** is the extention of the music files. It's required because I'm incomptetent and I don't want ffmpeg to try to convert non audio files. (This does mean you can only do one format at a time unless you modify the script slightly or do it manually)

## How it do?
The script will convert your source music files to raw 16 bit signed pcm at 44100 Hz and create a cue sheet to tell the emulator how to read them.
You will get a folder with the name you specified when executing the script and one file per song plus one .cue file.
I made the folders [Source\_Directory](Source_Directory/) and [Example](Example/) for illustration purposes.
