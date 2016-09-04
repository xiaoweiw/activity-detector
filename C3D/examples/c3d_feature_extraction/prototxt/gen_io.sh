#vidn="baseball"
#for i in {0..279}; do
#  echo $((16*${i}+1))
#  echo "videos/frames/$vidn/ $((16*${i}+1)) 0" >> tmp_input.txt 
#  echo "output/videodb/$vidn/$((16*${i}+1))" >> tmp_output.txt 
#done
vidn="pack"
for i in {1..1500}; do
  echo $((${i}))
  echo "videos/frames/$vidn/ $((${i})) 0" >> tmp_input.txt 
  echo "output/videodb/$vidn/$((${i}))" >> tmp_output.txt 
done
