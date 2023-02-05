while true; do
echo "please enter video name:"
read vidname

if [ -z "$vidname" ]; then
    echo "u need to pick an input file"
    continue
else
    if test -e $vidname; then
    echo "video name:  $vidname"
    break
    else
    echo "file does not exist"
    fi
fi
done
echo "specify output name:"
read outname
if [ -z "$outname" ]; then
    echo "no value entered, using output.mp4..."
    outname="output.mp4"
else
    echo "output file name: $outname"
fi

mkdir temp

# video in audio und video splitten
ffmpeg -i $vidname -map 0:0 -c copy ./temp/video.mkv -map 0:1 ./temp/audio0.aac -map 0:2 ./temp/audio1.aac


# audio wieder kombinieren
ffmpeg -i ./temp/audio0.aac -i ./temp/audio1.aac -filter_complex "[0:a][1:a]amerge=inputs=2,pan=stereo|c0<c0+c2|c1<c1+c3[a]" -map "[a]" ./temp/audio_combo.wav

# video und audio kombinieren
ffmpeg -i ./temp/video.mkv -i ./temp/audio_combo.wav -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 $outname

rm -rv ./temp