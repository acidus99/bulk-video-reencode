#
# Converts AVI to MP4. Blindly converts to H.264 and AAC
#

for i in *.avi;
  do
	  name=`echo $i | cut -d'.' -f1`;

	 
  ffmpeg -i "$i" -hide_banner -c:v libx264 -c:a aac -crf 22 -map_metadata -1 -metadata title="$name" "${name}.mp4";
done