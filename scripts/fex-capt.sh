n_proposal=5 # number of proposals to be retrieved
num_videos=100

caffe_dir="/home/xiaoweiw/tools/caffe"
ad_root="/home/xiaoweiw/research/video/profiling/acd/activity-detector/"  # root directory of activity detector

video_dir="/home/lvnguyen/ActivityNet/Crawler/vids/"
cd ${video_dir}
#for input_video in v_b7*.mp4; do
for input_video in v_83*.mp4; do
#for input_video in v_*.mp4; do
  [ $((num_videos--)) = 0 ] && break
  video_name="${input_video%.*}"
  frame_dir="${ad_root}/data/frames/${video_name}/"
  act_out="${ad_root}/output/act/full/${video_name}.out"
  sum_timelog="${ad_root}/timing/full/${video_name}.timelog"
  tmp_timelog="tmp.timelog"
  tmpout_timelog="tmpout.timelog"
  fex_output="fex.output"

  for ((ip=1;ip<=n_proposal;ip++)); do
    iline=$((ip+1))
    line=`sed "${iline}q;d" ${act_out}`
    starray=($line)
    end_frame=$((${starray[0]}+1))
    start_frame=$((${starray[1]}+1))
    echo "end: ${end_frame}; start: ${start_frame}"
    cd ${caffe_dir}

    export OMP_NUM_THREADS=1

    fex="${caffe_dir}/build/examples/cpp_fex/fex.bin ${caffe_dir}/models/bvlc_reference_caffenet/deploy.prototxt ${caffe_dir}/models/bvlc_reference_caffenet/bvlc_reference_caffenet.caffemodel ${caffe_dir}/data/ilsvrc12/imagenet_mean.binaryproto ${caffe_dir}/data/ilsvrc12/synset_words.txt ${fex_output}"

    for ((fr=${start_frame};fr<=${end_frame};fr++)); do
      printf -v fr_p "%06d" $fr
      fr_file="${frame_dir}/${fr_p}.jpg"
      fex="${fex} ${fr_file}"
    done
    $fex

    ## timing
    cat fex.timelog >> ${tmp_timelog}
    rm fex.timelog
    
    ## captioner
    capt="${caffe_dir}/build/examples/cpp_cap/s2vt.bin ${fex_output}"
    $capt
    cat cap.timelog >> ${tmp_timelog}
    rm cap.timelog

  done # iterate action proposals
  
  # merge outputs of all proposals
  python merge-time.py ${tmp_timelog} ${tmpout_timelog}
  cat ${tmpout_timelog} >> ${sum_timelog}
  rm ${tmp_timelog} ${tmpout_timelog}

done # iterate input_video
