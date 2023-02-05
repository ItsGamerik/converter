
echo "please enter video name:"
read vidname
echo "video name:  $vidname"


# video in audio und video splitten
ffmpeg -i $vidname -map 0:0 -c copy video.mkv -map 0:1 audio0.aac -map 0:2 audio1.aac


# audio wieder kombinieren
ffmpeg -i audio0.aac -i audio1.aac -filter_complex "[0:a][1:a]amerge=inputs=2,pan=stereo|c0<c0+c2|c1<c1+c3[a]" -map "[a]" audio_combo.wav

# video und audio kombinieren
ffmpeg -i video.mkv -i audio_combo.wav -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 output.mp4

rm *.aac
rm *.wav
rm video.mkv