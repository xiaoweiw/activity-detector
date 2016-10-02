## This script extracts c3d feature, performs PCA, and use features to generate hightes boundary proposals for actions in the video

ad_root="/home/xiaoweiw/research/video/profiling/acd/activity-detector/"  # root directory of activity detector
video_dir="/home/lvnguyen/ActivityNet/Crawler/vids/"
num_videos=100

cd ${video_dir}
#for input_video in v_b7*.mp4; do
for input_video in v_83*.mp4; do
#for input_video in v_*.mp4; do
  [ $((num_videos--)) = 0 ] && break
  echo "input_video${input_video}"

  video_name="${input_video%.*}"
  frame_dir="${ad_root}/data/frames/${video_name}/"

  cd ${ad_root}/C3D/examples/c3d_feature_extraction/prototxt

  rm -f videodb_input.txt
  rm -f videodb_output.txt

  sum_timelog="${ad_root}/timing/full/${video_name}.timelog"

  n_frames=$(ls -l ${frame_dir}/*.jpg | wc -l)
  #echo ${n_frames} >> ${ad_root}/timing/${video_name}.timelog
  echo ${n_frames} >> ${sum_timelog}
  echo ${frame_dir}

  for (( c=1; c<=${n_frames}; c++ )); do
    #echo ${n_videos}
    echo "${frame_dir} $((${c})) 0" >> videodb_input.txt
    echo "${ad_root}/output/c3d/${video_name}/$((${c}))" >> videodb_output.txt
  done

  mkdir -p ${ad_root}/output/c3d/${video_name}

  c3d_batch_size=50
  num_mini_batch=$((${n_frames}/${c3d_batch_size})) # if multiple of batch size, should not add 1
  #num_mini_batch=$((${n_frames}/${c3d_batch_size}))
  echo ${num_mini_batch}

  extract_dir="${ad_root}/C3D/examples/c3d_feature_extraction/"
  cd ${ad_root}/C3D/examples/c3d_feature_extraction/
  GLOG_logtosterr=1 
  c3d_feat_ext="../../build/tools/extract_image_features.bin prototxt/videodb_frm.prototxt conv3d_deepnetA_sport1m_iter_1900000 0 ${c3d_batch_size} ${num_mini_batch} prototxt/videodb_output.txt fc7-1"
  $c3d_feat_ext
  cat timelog >> ${sum_timelog}
  rm timelog

  n_extred_frames=$(ls -l ${ad_root}/output/c3d/${video_name}/*.fc7-1 | wc -l)
  echo $n_extred_frames

  cd ${ad_root}/sparseprop/pca
  pca="python pca.py $n_extred_frames ${ad_root}/output/c3d/${video_name}/"
  $pca
  cat timelog >> ${sum_timelog}
  rm timelog

  cd ${ad_root}/sparseprop
  rm data/videodb_input.csv
  echo "video-frames video-name" >> data/videodb_input.csv
  echo "${n_extred_frames}.0 test_video" >> data/videodb_input.csv
  acd_infer="python retrieve_proposals.py data/videodb_input.csv pca/videodb_c3d.h5 data/class_induced_thumos14.pkl data/videodb_proposals.csv"
  $acd_infer
  cat timelog >> ${sum_timelog}
  rm timelog
  mv data/videodb_proposals.csv ${ad_root}/output/act/full/${video_name}.out

done
