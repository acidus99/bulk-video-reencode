#Move all the video files
for i in Season*;
  do
	  mv "$i"/* .;
  done
  
#normalize m4v to mp4
rename 's/\.m4v/\.mp4/g' *.m4v;

#old .xvid files are just AVI containers
rename 's/\.xvid/\.avi/g' *.xvid;

#set permissions
chmod 644 *.*;

# set SxxExx number format
rename 's/ \[(\d\d)x(\d\d)\] / S$1E$2 /g' *.*;
