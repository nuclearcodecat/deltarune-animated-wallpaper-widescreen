the original movie is available on the front page of deltarune.com and as the save select screen of chapter 4.  
it is of course in a non-widescreen format so it looks out of place on widescreens.  
this repo contains animated wallpapers for the most popular desktop screen sizes and a script that generates them.  
wallpapers are by default available in webp, apng and gif formats.  
apng is kind of fucked because the delay was incorrect and frames were too long, so i had to set it to match the closest to the original gif file.  
i use the webp file with swww and it works perfectly.  

if your screen resolution isn't here: clone the repo, edit generate_walls.sh, add your res to the array; then execute (`./generate_walls.sh`)  

the script destructres the original gif into separate frames, clips off a 1px edge from the left, stretches that to the desired resolution and composites the original animation on top. then these composited frames are compiled into movies.
