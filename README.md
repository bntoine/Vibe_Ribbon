# Vibe Ribbon, a simple music conversion bash script for the PS1 game Vib-Ribbon.

<p align="center"><img alt="VibeRibbon Logo" src="VibeRibbonLogoLarge.png" height=200 width=200></p>

## Note for Windows users.
This script is natively compatible with Linux and MacOS, and should be usable on Windows with [WSL](https://docs.microsoft.com/windows/wsl/install). It's based on information I found in [this pastebin](https://pastebin.com/iFZKHbyH) which is directly applicable to Windows. You can also use [this website](https://vibcue.github.io/) to generate cue files.

## General info.

**Vibe Ribbon**

Vibe Ribbon is a script that takes a folder with music files or URLs from supported platforms (currently Youtube, SoundCloud, bandcamp and Spotify) and gives you a folder of music files in the right format with the corresponding cue file.

### Why does this exist?

I wanted to play custom songs in Vib-Ribbon because I think it's a pretty cool game so I made [a quick one liner](#as-a-one-liner) to convert my music and I thought that I might as well make a little script to do it for me and share it.

You can get both the japanese and PAL versions of the game on the internet archive (I have however not tested the versions hosted there).
### How it do?
You will get a folder with the name you specified when executing the script containing one file per song plus one .cue file. For more precise information on what the files are converted to and the format of the .cue file refer to [the pastebin](https://pastebin.com/iFZKHbyH).

**What emulator does it work with?**

In theory this should work with any emulator that uses cue files for disks.

I have successfully tested this script with the game running on [DuckStation](https://github.com/stenzek/duckstation/) and [RetroArch](https://www.retroarch.com/). I was not able to use the output files of this script on PCSX2.





## Usage.
### Download and setup

* ## Installing dependencies

    For debian based distros (Ubuntu and Pop!_OS for example).
    ```sh
    sudo apt install ffmpeg python3 python3-pip
    ```
    For most arch based distros. (Manjaro, Garuda, and SteamOS for example)
    ```sh
    sudo pacman -S ffmpeg python3 python3-pip
    ```
    If you use something else you probably know how to use it.

* ### To download songs from Youtube, SoundCloud, bandcamp and spotify.
    ```sh
    sudo pip3 install yt-dlp spotdl # Pip can work without sudo but the package will only be installed for your user.
    ```
* ## Downloading Vibe Ribbon
   Either download [VibeRibbon.sh](https://raw.githubusercontent.com/bntoine/Vibe_Ribbon/master/VibeRibbon.sh) manually or clone the repository with 
   ```sh
   git clone https://github.com/bntoine/Vibe_Ribbon.git
   ```
    
   I recommend putting the script where the game files are especially if you want to [use m3u files with RetroArch](#optional-additional-steps-if-you-are-using-retroarch-untested-but-should-work).

* ## Optional additional steps if you are using RetroArch (Untested but should work)
    
    M3U files are playlists and are used by retro arch to make it more convenient to switch between disks (usually for multi disk games). To use one follow the two steps bellow.

    Make a file named Vibe.m3u and put the filename of the game's cue file in it.
    ```sh
    ls *.cue > Vibe.m3u
   ```
   Uncomment  the line `echo "$name/$name.cue" >> ../Vibe.m3u` (by removing the #). It will add the new "disk" to the playlist after creating it.


## Running Vibe Ribbon
  * ### With Graphical Interface.
    ```sh
    # While in the same directory as the script
    ./VibeRibbon.sh Name --gui
    ```
    The --gui argument will make your file browser pop up for you to select your music files.
  * ### With TUI
  
    With the TUI you specify the path to the music folder or link(s) after the name. 
  
    If you put multiple links they should be separated by spaces between one set of quotes.
    ```sh
    # While in the same directory as the script.
    ./VibeRibbon.sh Name "Path or URL(s)"
    ```
    * The **Path** should be the path to the directory containing the songs you want to add to that "disk". Each file will be seen as a track by the game.
    * The **Name** is the name that will be given to the folder the tracks will be placed in and the cue file.

  * To play the custom songs you have to select the cue file when asked to insert a music CD. (Or use the keys you bound to changing disk if you are [using an m3u file](#optional-additional-steps-if-you-are-using-retroarch-untested-but-should-work))


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



##### Logo by DeathByAutoscroll#7617 . The font used in the logo was originally created by NanaOn-Sha for the video game Vib-Ribbon in 1999. Recreated by Robert Tumbolisu Buch in 2017.