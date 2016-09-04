for img in baseball/*.jpg; do
#for img in wrest/*.jpg; do
#for img in pack/*.jpg; do
  convert $img -resize 171x128\! $img

done
