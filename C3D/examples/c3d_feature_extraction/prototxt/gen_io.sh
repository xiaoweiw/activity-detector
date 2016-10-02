#vidn="baseball"
#for i in {0..279}; do
#  echo $((16*${i}+1))
#  echo "videos/frames/$vidn/ $((16*${i}+1)) 0" >> tmp_input.txt 
#  echo "output/videodb/$vidn/$((16*${i}+1))" >> tmp_output.txt 
#done
vidn="wrest"
rm videodb_input.txt
rm videodb_output.txt
for ((i=1; i<=4368; i=i+1)); do
#for ((i=1; i<=4368; i=i+16)); do
#for i in {1..4377}; do
  echo $((${i}))
  echo "videos/frames/$vidn/ $((${i})) 0" >> videodb_input.txt 
  echo "output/videodb/$vidn/$((${i}))" >> videodb_output.txt 
done
mkdir ../output/videodb/$vidn
