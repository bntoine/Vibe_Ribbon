# Vibe Ribbon, a simple music conversion shell script for the PS1 game Vib-Ribbon.
## Note for windows users.
This script is only compatible with Linux and Mac, unless you use [WSL](https://docs.microsoft.com/windows/wsl/install). It's based on information I found in [this pastebin](https://pastebin.com/iFZKHbyH) which, unlike my script, is applicable to windows. You can also use [this website](https://vibcue.github.io/) to generate cue files. If you find using audacity to convert the files too annoying you can get [a windows build of ffmpeg](https://ffmpeg.org/download.html#build-windows) and run `ffmpeg -v panic -i in.mp3 -ar 44100 -f s16le -acodec pcm_s16le out.wav"` to convert your audio files.

## General info.
**Why does this exist?**

I wanted to play custom songs in Vib-Ribbon because I think it's a pretty cool game so I made [a quick one liner](#as-a-one-liner) to convert my music and I thought that I might as well make a little script to do it for me and share it.

You can get both the japanese and PAL versions of the game on the internet archive (I have however not tested the versions hosted there).

**What emulator does it work with?**

In theory this should work with any emulator that uses cue files for disks.

I have successfully tested this script with the game running on [DuckStation](https://github.com/stenzek/duckstation/) and [RetroArch](https://www.retroarch.com/). I was not able to use the output files of this script on PCSX2.





## Usage.
### Download and setup

* #### Installing dependencies

     For debian based distros (Ubuntu and Pop!_OS for example).
    ```sh
    sudo apt install ffmpeg
    ```
    For most arch based distros. (Manjaro, Garuda, and SteamOS for example)
    ```sh
    sudo pacman -S ffmpeg
    ```
    If you use something else you probably know how to use it.


* #### Downloading the script and making it executable
   
   I recommend putting the script where the game files are especially if you want to [use m3u files with RetroArch](#optional-additional-steps-if-you-are-using-retroarch-untested-but-should-work).
    ```sh
    wget https://raw.githubusercontent.com/bntoine/Vibe_Ribbon/master/VibeRibbon.sh
    chmod +x VibeRibbon
    ```

* #### Optional additional steps if you are using RetroArch (Untested but should work)
    
    M3U files are playlists and are used by retro arch to make it easier to switch between disks (usually for multi disk games) using one is more convenient when switching disks. To use one follow the two steps bellow.

    Make a file named Vibe.m3u and put the filename of the game's cue file in it.
    ```sh
    ls *.cue > Vibe.m3u
   ```
   Uncomment  the line `echo "$name/$name.cue" >> ../Vibe.m3u` (by removing the #). It will add the new "disk" to the playlist after creating it.


### Running the script

```sh
# While in the same directory as the script.
./VibeRibbon Path_To_The_Source_Directory Name Source_Extension
```
* The **Source Directory** should contain the songs you want to add to that "disk". Each file will be seen as a track by the game.
Beware, the format they will be converted to is quite a lot larger than most audio files so don't add too many.

* The **Name** is the name that will be given to the folder the tracks will be placed in and the name that will be given to the cue file.

* The **Source Extension** is the extension of the music files. It's required because I'm incompetent and I don't want ffmpeg to try to convert non audio files. (This does mean you can only do one format at a time unless you modify the script slightly or do it manually)



## As a one liner
The first three lines are where you define the variables. You can also just manually change the info in the command instead of using variables.
```sh
sourcedir=Source_Directory
name=Example
ext=mp3

mkdir $name && cd $name && cp "$sourcedir"*.$ext . && for i in *.$ext; do ffmpeg -v panic -i "$i" -ar 44100 -f s16le -acodec pcm_s16le "${i%%.*}.wav"; done && ls *.wav | awk '{printf "FILE \"%s\" BINARY\n  TRACK %02d AUDIO\n    INDEX 01 00:00:00\n",$0, NR}' > "$name.cue" && rm *.$ext
```
**Other useful one liner**

This second command will make a cue sheet for all the wav files with the name of the directory it's in.
```sh
ls *.wav | awk '{printf "FILE \"%s\" BINARY\n  TRACK %02d AUDIO\n    INDEX 01 00:00:00\n",$0, NR}' > "${PWD##*/}.cue"
```

## How it do?
You will get a folder with the name you specified when executing the script and one file per song plus one .cue file. I made the folders [Source\_Directory](Source_Directory/) and [Example](Example/) to show the output.

The script uses ffmpeg to convert your source music files to 16 bit signed pcm at 44100 Hz wav files (CD audio) and creates a cue sheet using awk to tell the emulator how to read them. 

[The Example cue sheet](Example/Example.cue) look like this:

```c
FILE "1.wav" BINARY
  TRACK 01 AUDIO
    INDEX 01 00:00:00
FILE "2.wav" BINARY
  TRACK 02 AUDIO
    INDEX 01 00:00:00
FILE "3.wav" BINARY
  TRACK 03 AUDIO
    INDEX 01 00:00:00
FILE "4.wav" BINARY
  TRACK 04 AUDIO
    INDEX 01 00:00:00
FILE "5.wav" BINARY
  TRACK 05 AUDIO
    INDEX 01 00:00:00
```
You can see there are three lines per track. 

The first one points the the file and gives it's format. In our case it's a wav file.

The second line is the one that requires using awk instead of sed because we need to increment the number for each track. 

The last line says that the track starts at 00:00:00