n_repeat=80
#./get-fix-length.sh
for ((i=0;i<${n_repeat};i++)); do
  ./acd.sh && ./fex-capt.sh
done
