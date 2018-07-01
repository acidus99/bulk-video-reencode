#
# Displays the filename and number of streams in the file
#

for i in *; do
    echo "$i"
	ffprobe "$i" -show_entries format=nb_streams -v 0 -of compact=p=0:nk=1
done