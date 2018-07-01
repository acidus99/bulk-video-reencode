#
# Converts MKV into MP4.
# This assumes the video is H.264. Should probably check this first
# If the audio is already AAC, it will just remux MKV into MP4 container
# Otherwise will convert audio to AAC
#

for i in *.mkv;
  do
	  name=`echo $i | cut -d'.' -f1`;

	  aaa=`ffprobe -v error -select_streams a:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$i"`;
	  

	  if [ "$aaa" == "aac" ]; then
		  #Already AAC, just do a straight copy
		  ffmpeg -i "$i" -hide_banner -c:v copy -c:a copy -map_metadata -1 -metadata title="$name" "${name}.mp4";

	  else
		  #convert audio!
		  
		  ffmpeg -i "$i" -hide_banner -c:v copy -c:a aac -map_metadata -1 -metadata title="$name" "${name}.mp4";		  
	  fi

  #ffmpeg -i "$i" -c:v libx264 -c:a aac -crf 22 -map 0 "${name}.mp4";
done
