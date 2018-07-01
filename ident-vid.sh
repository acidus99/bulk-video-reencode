#
# prints the first video and first audio codec in the file, and the dims of the video
#

for i in *;
  do
	  vid=`ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$i"`;
  echo $i;
  echo $vid;
  aaa=`ffprobe -v error -select_streams a:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$i"`;
  echo $aaa;
  dim=`ffprobe -v error -show_entries stream=width,height -of default=noprint_wrappers=1:nokey=1 "$i"`;
  echo $dim;
  #ffmpeg -i "$i" -c:v libx264 -c:a aac -crf 22 -map 0 "${name}.mp4";
done
