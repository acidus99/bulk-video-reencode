chmod 644 *.*
tvnamer *.*
sleep 3
#renames " [01x01] " style show naming to " S01E01 "
rename 's/ \[(\d\d)x(\d\d)\] / S$1E$2 /g' *.*