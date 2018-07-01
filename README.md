# Bulk Video Encoding Scripts

Here is a set of bash scripts I wrote to rename, remux, and sometimes reencode a few thousand video files. While these might not do exactly what you need, they can serve as a good base for other video encoding projects.


## Background

I had around 2.5 TB of various movies and TV shows that had come from a variety of sources over the last decade or so. My goals were to:

- Standardize the naming of the movie and video files
- Remove extraneous meta data, and (re)set appropriate title meta data
- Remux the files into MP4 containers.
- Reencode videos using older codecs to H.264, and audio to AAC for easier copying to other devices or streaming from [Plex](https://www.plex.tv/) without transcoding.


## Prerequisites

I ran these scripts on Mac OS, but they should work on any *nix/POSIX system. They simply wrap a lot of great existing programs. You need to install these other programs ([homebrew](https://brew.sh/) has them all).

I used `ffmpeg` for all the reencoding and remuxing. Make sure to grab a version with a proper AAC encoder. I also used the related `ffprobe` to more easily pull out meta data and info on the streams inside the video files.

```
brew install libvpx ffmpeg --with-libvpx --with-libfaac --with-fdk-aac
```

I used the amazing [`tvnamer`](https://github.com/dbr/tvnamer) for renaming TV shows. This takes a file, queries [TVDB](https://www.thetvdb.com/) based on its filename, and renames the file with the episode name.

```
 brew install tvnamer
```

`rename` is a [great utility for renaming files](http://plasmasturm.org/code/rename/) by doing find/replace regex.

```
brew install rename
```

## Scripts

###convert-avi.sh

This converts all `*.avi` videos in a directory. For my video collection, all the `*.avi` files were using a collection of older video codecs (Divx, xvid, etc), and primarily MP3 as the audio codec. This script just blindly reencodes the videos in the directory into MP4 containers, with H.264 video and AAC audio, using `ffmpeg`. This also sets the title meta data of the MP4 file.

###convert-mkv.sh

This converts all `*.mkv` videos in a directory. For my collection, all the MKV files were using  H.264 as the video codec. They had AAC or MP3 as the audio codec. This script probes each video to determine the audio codec. If we are dealing with a MKV/H.264/AAC file, it simple remuxes those streams into an MP4 container since nothing needs to be reencoded, preserving quality. If we are dealing with a MKV/H.264/MP3 file, we copy the video but reencode the audio to generate a MP4/H.264/AAC file. This also sets the title meta data of the MP4 file.

###reset-meta.sh

This script loops over all the MP4 videos in a directory, removes all the meta data, and set the title meta data based on the filename. I used this to clear out the conflicting, incorrect, or non-standard meta data that often appears in videos from various sources.

###all-encodes.sh
This script is just a master script. It uses `reset-meta.sh`, `concert-avi.sh` and `convert-mkv.sh` to process an entire directory of videos.


###count-streams.sh

This script loops over all the video files in a directory, printing the filename, and the number of video and audio streams inside. I used this to quickly find any files with extra audio tracks that I might want to preserve or rip out to reduce size (for example, [the Harmy Despecialized Editions of Star Wars](https://en.wikipedia.org/wiki/Harmy%27s_Despecialized_Edition))


###ident-vid.sh

This script loops over all the video files in a directory, printing the filename, and the video and audio codecs used. I primarily used this to verify that the MKV files I was dealing with were all H.264, so I didn't have to reencode the video streams.

###rename-tv.sh

This script uses `tvnamer` and `rename` to rename video filenames into the format `Show Name - SxxExx - Title of Episode.mkv`.


## How I used this scripts

At a high level, the process I used was to first normalize the filenames of the videos into a common format. Then my convert scripts would do the proper remux or reencoding, strip out the old meta data, and set new meta data based on that normalized filename.

###Movies

Converting movies was very straight forward. With few exceptions each movie is in one file, so it was just a matter of making sure the file was named properly. Software life Plex uses the year the movie was release to help disambiguate files. I got everything into the format of `Movie Name (Release Year) [Resolution].mp4`, and used `[SD]` for Standard Def and DVD Rips, and either `[1080p]` or `[720p]` where appropriate for Blu Ray Rips.

All the movies were all in the same directory, so once everything was named properly, I simply used the `all-encodes.sh` script to kick everything off, and waited several days while `ffmpeg` did its thing.

###TV Shows

TV Shows were more complicated for 2 reasons. First, the filenames of the actual video files were so diverse and in some cases wrong. Second, unlike the Movies, the TV show collections was already organized into multiple folders that looks like this:

```
TV Shows/
	Show Name/
		Season 1/
		Season 2/
	Another Show Name/
		Season 1/
		Season 2/
		...
```

For each TV Show:

1. I would go into each `Season` directory and would manually normalize the filenames into the format of `Show Name - SxxExx.mkv` (or whatever video extension). I did this using the `rename` command and some regexs. Given the diversity of filenames there was no easy way to automate this, but it goes pretty quickly if you are good with regexs. `rename -n` **is a life saver!** It lets you preview how the filenames will change, which is fantastic since if you are doing this a few dozen or hundred times, you will typo a regex at some point and hose you filenames!

2. I used `rename-tv.sh` in each `Season `directory to rename all the filenames into the format `Show Name - SxxExx - Title of Episode.mkv` (or whatever video extension).

3. I used `prep-folder.sh` which pulled all files the TV shows for into the root `Show Name/` directory. Now you have a single folder for a show, with a ton of video files in it, all potentially different types and extensions.

4. I used the `all-convert.sh` on the main `Show Name/` folder. This converts all of the videos. When done you have a directory full of MP4/H.264/AAC files, with proper meta data.

5. I would finally a quick quality check. Every now and then I ended up with a corrupt file. A good way to spot these is to sort the directory by size. 0 byte or small files are the output of bad videos that didn't convert properly. If everything is good

6. I would delete the old video files, and `mv` the nice good videos back into the appropriate `Season/` folders.


## Contributing

Feel free to submit a pull request, but know I might not accept it.

## Authors

- **Billy Hoffman** - [Acidus99](https://github.com/Acidus99)

## License

This project is licensed under the BSD License - see the [LICENSE.txt](LICENSE.txt) file for details
