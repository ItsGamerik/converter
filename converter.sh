#!/bin/bash

##################
# cmdline args + filenames
###################
print_help() {
    echo -e "command line flags: \ni: input file \no: output file"
}

while getopts i:o: flag; do 
    case "${flag}" in
        i) input=${OPTARG} ;;
        o) output=${OPTARG} ;;
        *) exit ;;
    esac
done
# echo "$input";
# echo "$output"


while true; do
if [[ -n "$input" && -f "$input" ]]; 
then
    break
else
    echo "input file not found."
    exit 1; # code for general errors
fi

echo "please enter video name:"
read input
if  [ -z "$input" ]; 
then
    echo "u need to pick an input file"
    exit; 
elif [[ -f "$input" ]]; 
then
    echo "file exists: $input"
    break;
else
    echo "file does not exist"
    exit;
fi
done

while [ -z "$output" ]; do
echo "specify output name:"
read output
if [ -z "$output" ]; then
    echo "no value entered, using output.mp4..."
    output="output.mp4"
else
    echo "output file name: $output"
fi
done



##################
# video processing
###################
mkdir temp

# video in audio und video splitten
ffmpeg -i $input -map 0:0 -c copy ./temp/video.mkv -map 0:1 ./temp/audio0.aac -map 0:2 ./temp/audio1.aac


# audio wieder kombinieren
ffmpeg -i ./temp/audio0.aac -i ./temp/audio1.aac -filter_complex "[0:a][1:a]amerge=inputs=2,pan=stereo|c0<c0+c2|c1<c1+c3[a]" -map "[a]" ./temp/audio_combo.wav

# video und audio kombinieren
ffmpeg -i ./temp/video.mkv -i ./temp/audio_combo.wav -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 $output

rm -rv ./temp

exit 0;