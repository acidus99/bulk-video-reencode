#
# Resets all the meta data in an MP4.
# Sets the title meta data to be everything in the filename before the first "."
#

for i in *.mp4;
  do
	  
	  name=`echo $i | cut -d'.' -f1`;
	  ffmpeg -i "$i" -hide_banner -map 0 -c copy -map_metadata -1 -metadata title="$name" tmp.mp4
	  
	  mv tmp.mp4 "$i"
  done
 