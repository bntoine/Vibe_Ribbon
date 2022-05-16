# Vibe Ribbon, a simple music conversion shell script for the PS1 game Vib-Ribbon.

<p align="center"><img alt="VibeRibbon Logo" src="VibeRibbonLogoLarge.png" height=200 width=200></p>

## Note for windows users.
This script is only compatible with Linux and Mac, unless you use [WSL](https://docs.microsoft.com/windows/wsl/install). It's based on information I found in [this pastebin](https://pastebin.com/iFZKHbyH) which, unlike my script, is applicable to windows. You can also use [this website](https://vibcue.github.io/) to generate cue files. If you find using audacity to convert the files too annoying you can get [a windows build of ffmpeg](https://ffmpeg.org/download.html#build-windows) and run `ffmpeg -v panic -i in.mp3 -ar 44100 -f s16le -acodec pcm_s16le out.wav"` to convert your audio files.

## General info.

**Vibe Ribbon**

Vibe Ribbon is a script that takes a folder with music files or URLs from supported platforms (currently Youtube, SoundCloud and Spotify) and gives you a folder of music files in the right format with the corresponding cue file.

### Why does this exist?

I wanted to play custom songs in Vib-Ribbon because I think it's a pretty cool game so I made [a quick one liner](#as-a-one-liner) to convert my music and I thought that I might as well make a little script to do it for me and share it.

You can get both the japanese and PAL versions of the game on the internet archive (I have however not tested the versions hosted there).

**What emulator does it work with?**

In theory this should work with any emulator that uses cue files for disks.

I have successfully tested this script with the game running on [DuckStation](https://github.com/stenzek/duckstation/) and [RetroArch](https://www.retroarch.com/). I was not able to use the output files of this script on PCSX2.





## Usage.
### Download and setup

* ### Installing dependencies

     For debian based distros (Ubuntu and Pop!_OS for example).
    ```sh
    sudo apt install ffmpeg
    ```
    For most arch based distros. (Manjaro, Garuda, and SteamOS for example)
    ```sh
    sudo pacman -S ffmpeg
    ```
    If you use something else you probably know how to use it.

* ### To download songs from Youtube, SoundCloud and spotify.
    ```sh
    # Check that you have python3 installed (If it's not installed just install it like you did ffmpeg)
    python3 --version
    ```
    **Install pip3 the same way you installed ffmpeg**
* For Spotify
    ```sh
    sudo pip3 install spotdl # Pip can work without sudo but the package will only be installed for your user.
    ```

* For SoundCloud and Youtube
    ```sh
    sudo pip3 install yt-dlp # Pip can work without sudo but the package will only be installed for your user.
    ```

   I recommend putting the script where the game files are especially if you want to [use m3u files with RetroArch](#optional-additional-steps-if-you-are-using-retroarch-untested-but-should-work).
* #### Downloading Vibe Ribbon and making it executable
   
    ```sh
    wget https://raw.githubusercontent.com/bntoine/Vibe_Ribbon/master/VibeRibbon.sh
    chmod +x VibeRibbon.sh
    ```

* #### Optional additional steps if you are using RetroArch (Untested but should work)
    
    M3U files are playlists and are used by retro arch to make it more convenient to switch between disks (usually for multi disk games). To use one follow the two steps bellow.

    Make a file named Vibe.m3u and put the filename of the game's cue file in it.
    ```sh
    ls *.cue > Vibe.m3u
   ```
   Uncomment  the line `echo "$name/$name.cue" >> ../Vibe.m3u` (by removing the #). It will add the new "disk" to the playlist after creating it.


### Running Vibe Ribbon

```sh
# While in the same directory as the script.
./VibeRibbon.sh Name "Path or URL(s)"
```
* The **Path** should be the path to the directory containing the songs you want to add to that "disk". Each file will be seen as a track by the game.
Beware, the format they will be converted to is quite a lot larger than most common codecs.

* The **Name** is the name that will be given to the folder the tracks will be placed in and the cue file.


## As a one liner.
The first three lines are where you define the variables. You can also just manually change the info in the command instead of using variables.
```sh
sourcedir=.Source_Directory
name=.Example
ext=mp3

mkdir $name && cd $name && cp "$sourcedir"*.$ext . && for i in *.$ext; do ffmpeg -v panic -i "$i" -ar 44100 -f s16le -acodec pcm_s16le "${i%%.*}.wav"; done && ls *.wav | awk '{printf "FILE \"%s\" BINARY\n  TRACK %02d AUDIO\n    INDEX 01 00:00:00\n",$0, NR}' > "$name.cue" && rm *.$ext
```
**Other useful one liner**

This second command will make a cue sheet for all the wav files with the name of the directory it's in.
```sh
ls *.wav | awk '{printf "FILE \"%s\" BINARY\n  TRACK %02d AUDIO\n    INDEX 01 00:00:00\n",$0, NR}' > "${PWD##*/}.cue"
```
This one will download the songs in the right format from Youtube. Links are put at the end and should be separated by a space.
```sh
yt-dlp -q -f 'bestaudio[ext=m4a]' -ciw -o '%(title)s.%(ext)s' --extract-audio --audio-quality 0 --audio-format wav $links
```


## How it do?
You will get a folder with the name you specified when executing the script and one file per song plus one .cue file. I made the folders [Source\_Directory](.Source_Directory/) and [Example](.Example/) to show the output.

The script uses ffmpeg to convert your source music files to 16 bit signed pcm at 44100 Hz wav files (CD audio) and creates a cue sheet using awk to tell the emulator how to read them. 

[The Example cue sheet](.Example/Example.cue) look like this:

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

The second line gives the number of the track and the type of data. In our case it's an audio file. (This is the one that requires using awk instead of sed because we need to increment the number for each track.) 

The last line says that the track starts at 00:00:00

###### Fond used in the logo originally created by NanaOn-Sha for the video game Vib-Ribbon in 1999. Recreated by Robert Tumbolisu Buch in 2017.