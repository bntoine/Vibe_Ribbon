## Vibe Ribbon, a simple music conversion script for the PS1 game Vib-Ribbon.
I wanted to play custom songs in Vib-Ribbon because I think it's a pretty cool game so I made [a quick one liner](#as-a-one-liner) to convert my music.
I based it on information I found in [this pastebin](https://pastebin.com/iFZKHbyH) and I thought that I might as well make a little script to do it for me and share it.

I have successfully tested this script with the game running on [DuckStation](https://github.com/stenzek/duckstation/) and [RetroArch](https://www.retroarch.com/). I was not able to use the output files of this script on PCSX2.

You need [ffmpeg](https://github.com/FFmpeg/FFmpeg), some music, and an emulator that accepts .cue files ([cue sheets](https://en.wikipedia.org/wiki/Cue_sheet_(computing))) as CDs.
You can get ffmpeg through your usual package manager.
And you can get both the japanese and PAL versions of the game on the internet archive (I have however not tested them).



## Usage.
### Download and setup

* #### Installing dependencies

     For debian based distros (Ubuntu and Pop!_OS for example).
    ```sh
    sudo apt install ffmpeg
    ```
    For most arch based distros.
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

mkdir $name && cd $name && cp "$sourcedir"*.$ext . && for i in *.$ext; do ffmpeg -v panic -i "$i" -ar 44100 -f s16le -acodec pcm_s16le "${i%%.*}.raw"; done && ls *.raw | awk '{printf "FILE \"%s\" BINARY\n  TRACK %02d AUDIO\n    INDEX 00 00:00:00\n    INDEX 01 00:00:00\n",$0, NR}' > "$name.cue" && rm *.$ext
```



## How it do?
You will get a folder with the name you specified when executing the script and one file per song plus one .cue file. I made the folders [Source\_Directory](Source_Directory/) and [Example](Example/) to show the output.

The script uses ffmpeg to convert your source music files to raw 16 bit signed pcm at 44100 Hz (CD audio) and creates a cue sheet using awk to tell the emulator how to read them. 

[The Example cue sheet](Example/Example.cue) look like this:

```c
FILE "1.raw" BINARY
  TRACK 01 AUDIO
    INDEX 00 00:00:00
    INDEX 01 00:00:00
FILE "2.raw" BINARY
  TRACK 02 AUDIO
    INDEX 00 00:00:00
    INDEX 01 00:00:00
FILE "3.raw" BINARY
  TRACK 03 AUDIO
    INDEX 00 00:00:00
    INDEX 01 00:00:00
FILE "4.raw" BINARY
  TRACK 04 AUDIO
    INDEX 00 00:00:00
    INDEX 01 00:00:00
FILE "5.raw" BINARY
  TRACK 05 AUDIO
    INDEX 00 00:00:00
    INDEX 01 00:00:00
```
You can see there are four lines per track. 

The first one points the the file and gives it's format. In our case it's a raw binary file.

The second line is the one that requires using awk instead of sed because we need to increment the number for each track. 

The two last lines I just copied from [the pastebin](https://pastebin.com/iFZKHbyH) and I have no idea how this works it's probably explained in [the wikipedia article](https://en.wikipedia.org/wiki/Cue_sheet_(computing)) if you're interested.