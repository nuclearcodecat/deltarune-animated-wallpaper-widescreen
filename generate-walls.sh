#!/bin/bash
set -x

res=("1920x1080" "3840x2160" "1366x768" "1440x900" "1280x720" "2560x1440" "1024x768")

input_file="key-art.gif"
mkdir -p temp/frames/original

magick "$input_file" -coalesce "temp/frames/original/frame.png"

mkdir -p temp/edgefiles temp/stretchfiles

for nowres in "${res[@]}"; do
	h="${nowres#*x}"
	w="${nowres%x*}"
	combined="${w}x${h}"

	frame_dir="temp/frames/${combined}"
	comp_dir="${frame_dir}/composed"
	wall_dir="walls-${combined}"

	mkdir -p "$frame_dir" "$comp_dir" "$wall_dir"

	# resize frames
	for img in temp/frames/original/*.png; do
		magick "$img" -filter point -resize "x${h}" "${frame_dir}/$(basename "$img")"
	done

	# clip edge into edgefiles
	magick "${frame_dir}/frame-0.png" -crop "1x+0+0" "temp/edgefiles/${combined}.png"

	# make stretched background from edge
	magick "temp/edgefiles/${combined}.png" -resize "${w}x${h}!" "temp/stretchfiles/${combined}.png"
	
	# compose frames onto stretched background
	for img in "${frame_dir}"/*.png; do
		magick composite -gravity center "$img" "temp/stretchfiles/${combined}.png" "${comp_dir}/$(basename "$img")"
	done

	# export as movie
	magick -delay 20 -loop 0 -define webp:lossless=true "${comp_dir}"/*.png "${wall_dir}/${combined}.webp"
	# delay is incorrect...
	magick -delay 14 -loop 0 -quality 100 "${comp_dir}"/*.png "${wall_dir}/${combined}.apng"
	magick -delay 20 -loop 0 -quality 100 "${comp_dir}"/*.png +repage "${wall_dir}/${combined}.gif"
done

