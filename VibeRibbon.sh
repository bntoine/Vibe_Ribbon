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

case $2 in

# SoundCloud
https://*soundcloud.com/*)
    yt-dlp -q -o "tmp/%(title)s-%(id)s.mp3" $2
    for i in tmp/*.mp3; do ffmpeg -v panic -i "$i" -ar 44100 -f s16le -acodec pcm_s16le "$(basename "${i%.*}").wav"; done;;

# Youtube
https://*youtube.com/* | https://*youtu.be/*)
    # Downloading the sound in the right format.
    yt-dlp -q -f 'bestaudio[ext=m4a]' -ciw -o '%(title)s.%(ext)s' --extract-audio --audio-quality 0 --audio-format wav $2;;

https://*spotify.com/*)
    spotdl --output-format wav $2;;

# Matching for other urls (other url paterns should be added above)
http://* | https://*)
    #cd .. && rm -rf $name # Uncomment to delete folder on failure (not activated by default because I don't want to accidentally delete things)
    echo "This isn't currently supported."
    exit 2;;

# Anything else should be a local path
*)
    mkdir tmp
    # Copying anything with a "supported extension" (common extensions associated with ffmpeg demuxers)
    cp "${2%/}"/*.{str,aa,aac,ac3,acm,adf,adp,dtk,ads,ss2,adx,aea,afc,aix,al,ape,apl,mac,aptx,aptxhd,aqt,ast,avi,avs,avr,avs,avs2,bfstm,bcstm,bit,bmv,brstm,cdg,cdxl,xl,c2,302,daud,str,dav,dss,dts,dtshd,dv,dif,cdata,eac3,paf,fap,flm,flac,flv,fsb,g722,722,tco,rco,g723_1,g729,genh,gsm,h261,h26l,h264,264,avc,hevc,h265,265,idf,ifv,cgi,sf,ircam,ivr,kux,669,amf,ams,dbm,digi,dmf,dsm,dtm,far,gdm,ice,imf,it,j2b,m15,mdl,med,mmcmp,mms,mo3,mod,mptm,mt2,mtm,nst,okt,plm,ppm,psm,pt36,ptm,s3m,sfx,sfx2,st26,stk,stm,stp,ult,umx,wow,xm,xpk,flv,lvf,m4v,mkv,mk3d,mka,mks,mjpg,mjpeg,mpo,j2k,mlp,mov,mp4,m4a,3gp,3g2,mj2,mp2,mp3,m2a,mpa,mpc,mjpg,txt,mpl2,sub,msf,mtaf,ul,musx,mvi,mxg,v,nist,sph,nsp,nut,ogg,oma,omg,aa3,pjs,pvf,yuv,cif,qcif,rgb,rt,rsd,rsd,rso,sw,sb,smi,sami,sbc,msbc,sbg,scc,sdr2,sds,sdx,ser,shn,vb,son,sln,mjpg,stl,sub,sub,sup,svag,tak,thd,tta,ans,art,asc,diz,ice,nfo,txt,vt,ty,ty+,uw,ub,v210,yuv10,vag,vc1,rcv,viv,idx,vpk,txt,vqf,vql,vqe,vtt,wsd,xmv,xvag,yop,y4m} tmp/ 2>>/dev/null
    for i in tmp/*; do ffmpeg -v panic -i "$i" -ar 44100 -f s16le -acodec pcm_s16le "$(basename "${i%.*}").wav"; done;;

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