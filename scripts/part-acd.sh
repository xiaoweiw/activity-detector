## Test the partition of input video

ad_root="/home/xiaoweiw/research/video/profiling/acd/activity-detector/"  # root directory of activity detector
video_dir="/home/lvnguyen/ActivityNet/Crawler/vids/"

cd ${video_dir}
for input_video in v_b7*.mp4; do
  #for input_video in v_9*.mp4; do

  #input_video="v_yrPVjR4jbv0.mp4"
  #input_video="v_zsw9WEsSowI.mp4"
  #input_video="v_f0hh9bwVfV0.mp4"
  #input_video="v_pZzTMUJG9Rk.mp4"

  video_name="${input_video%.*}"
  #frame_dir="${ad_root}/data/frames/${video_name}/"
  #
  #cd ${ad_root}/C3D/examples/c3d_feature_extraction/prototxt
  #
  #rm -f videodb_input.txt
  #rm -f videodb_output.txt
  #
  #n_frames=$(ls -l ${frame_dir}/*.jpg | wc -l)
  #echo ${n_frames} >> ${ad_root}/timing/${video_name}.timelog
  #
  #for (( c=1; c<=${n_frames}; c++ )); do
  #  #echo ${n_videos}
  #  echo "${frame_dir} $((${c})) 0" >> videodb_input.txt
  #  echo "${ad_root}/output/c3d/${video_name}/$((${c}))" >> videodb_output.txt
  #done
  #
  #mkdir -p ${ad_root}/output/c3d/${video_name}
  #
  #c3d_batch_size=75
  #num_mini_batch=$((${n_frames}/${c3d_batch_size}-2))
  #echo ${num_mini_batch}
  #
  #extract_dir="${ad_root}/C3D/examples/c3d_feature_extraction/"
  #cd ${ad_root}/C3D/examples/c3d_feature_extraction/
  #GLOG_logtosterr=1 
  #c3d_feat_ext="../../build/tools/extract_image_features.bin prototxt/videodb_frm.prototxt conv3d_deepnetA_sport1m_iter_1900000 0 ${c3d_batch_size} ${num_mini_batch} prototxt/videodb_output.txt fc7-1"
  #$c3d_feat_ext
  #cat timelog >> ${ad_root}/timing/${video_name}.timelog
  #rm timelog

  n_extred_frames=$(ls -l ${ad_root}/output/c3d/${video_name}/*.fc7-1 | wc -l)
  echo $n_extred_frames

  cd ${ad_root}/sparseprop/pca
  pca="python pca.py $n_extred_frames ${ad_root}/output/c3d/${video_name}/"
  $pca
  ###cat timelog >> ${ad_root}/timing/${video_name}.timelog
  rm timelog

  #for id_tuple in 222,555 0,1000; do IFS=","; set -- $id_tuple;
    init=0
    dura=4800
    cd ${ad_root}/sparseprop
    rm data/videodb_input.csv
    echo "video-frames video-name" >> data/videodb_input.csv
    echo "${n_extred_frames}.0 test_video" >> data/videodb_input.csv
    part_video_id="${video_name}-i${init}-d${dura}"
    acd_infer="python retrieve_proposals.py data/videodb_input.csv pca/videodb_c3d.h5 data/class_induced_thumos14.pkl data/videodb_proposals.csv ${init} ${dura}"
    $acd_infer
    cat timelog >> ${ad_root}/timing/part/${part_video_id}.timelog
    rm timelog
    mv data/videodb_proposals.csv ${ad_root}/output/act/part/${part_video_id}.out
  #done
    init=0
    dura=2400
    cd ${ad_root}/sparseprop
    rm data/videodb_input.csv
    echo "video-frames video-name" >> data/videodb_input.csv
    echo "${n_extred_frames}.0 test_video" >> data/videodb_input.csv
    part_video_id="${video_name}-i${init}-d${dura}"
    acd_infer="python retrieve_proposals.py data/videodb_input.csv pca/videodb_c3d.h5 data/class_induced_thumos14.pkl data/videodb_proposals.csv ${init} ${dura}"
    $acd_infer
    cat timelog >> ${ad_root}/timing/part/${part_video_id}.timelog
    rm timelog
    mv data/videodb_proposals.csv ${ad_root}/output/act/part/${part_video_id}.out

    init=2400
    dura=2400
    cd ${ad_root}/sparseprop
    rm data/videodb_input.csv
    echo "video-frames video-name" >> data/videodb_input.csv
    echo "${n_extred_frames}.0 test_video" >> data/videodb_input.csv
    part_video_id="${video_name}-i${init}-d${dura}"
    acd_infer="python retrieve_proposals.py data/videodb_input.csv pca/videodb_c3d.h5 data/class_induced_thumos14.pkl data/videodb_proposals.csv ${init} ${dura}"
    $acd_infer
    cat timelog >> ${ad_root}/timing/part/${part_video_id}.timelog
    rm timelog
    mv data/videodb_proposals.csv ${ad_root}/output/act/part/${part_video_id}.out

    init=0
    dura=1600
    cd ${ad_root}/sparseprop
    rm data/videodb_input.csv
    echo "video-frames video-name" >> data/videodb_input.csv
    echo "${n_extred_frames}.0 test_video" >> data/videodb_input.csv
    part_video_id="${video_name}-i${init}-d${dura}"
    acd_infer="python retrieve_proposals.py data/videodb_input.csv pca/videodb_c3d.h5 data/class_induced_thumos14.pkl data/videodb_proposals.csv ${init} ${dura}"
    $acd_infer
    cat timelog >> ${ad_root}/timing/part/${part_video_id}.timelog
    rm timelog
    mv data/videodb_proposals.csv ${ad_root}/output/act/part/${part_video_id}.out

    init=1600
    dura=1600
    cd ${ad_root}/sparseprop
    rm data/videodb_input.csv
    echo "video-frames video-name" >> data/videodb_input.csv
    echo "${n_extred_frames}.0 test_video" >> data/videodb_input.csv
    part_video_id="${video_name}-i${init}-d${dura}"
    acd_infer="python retrieve_proposals.py data/videodb_input.csv pca/videodb_c3d.h5 data/class_induced_thumos14.pkl data/videodb_proposals.csv ${init} ${dura}"
    $acd_infer
    cat timelog >> ${ad_root}/timing/part/${part_video_id}.timelog
    rm timelog
    mv data/videodb_proposals.csv ${ad_root}/output/act/part/${part_video_id}.out

    init=3200
    dura=1600
    cd ${ad_root}/sparseprop
    rm data/videodb_input.csv
    echo "video-frames video-name" >> data/videodb_input.csv
    echo "${n_extred_frames}.0 test_video" >> data/videodb_input.csv
    part_video_id="${video_name}-i${init}-d${dura}"
    acd_infer="python retrieve_proposals.py data/videodb_input.csv pca/videodb_c3d.h5 data/class_induced_thumos14.pkl data/videodb_proposals.csv ${init} ${dura}"
    $acd_infer
    cat timelog >> ${ad_root}/timing/part/${part_video_id}.timelog
    rm timelog
    mv data/videodb_proposals.csv ${ad_root}/output/act/part/${part_video_id}.out

    init=0
    dura=1200
    cd ${ad_root}/sparseprop
    rm data/videodb_input.csv
    echo "video-frames video-name" >> data/videodb_input.csv
    echo "${n_extred_frames}.0 test_video" >> data/videodb_input.csv
    part_video_id="${video_name}-i${init}-d${dura}"
    acd_infer="python retrieve_proposals.py data/videodb_input.csv pca/videodb_c3d.h5 data/class_induced_thumos14.pkl data/videodb_proposals.csv ${init} ${dura}"
    $acd_infer
    cat timelog >> ${ad_root}/timing/part/${part_video_id}.timelog
    rm timelog
    mv data/videodb_proposals.csv ${ad_root}/output/act/part/${part_video_id}.out

    init=1200
    dura=1200
    cd ${ad_root}/sparseprop
    rm data/videodb_input.csv
    echo "video-frames video-name" >> data/videodb_input.csv
    echo "${n_extred_frames}.0 test_video" >> data/videodb_input.csv
    part_video_id="${video_name}-i${init}-d${dura}"
    acd_infer="python retrieve_proposals.py data/videodb_input.csv pca/videodb_c3d.h5 data/class_induced_thumos14.pkl data/videodb_proposals.csv ${init} ${dura}"
    $acd_infer
    cat timelog >> ${ad_root}/timing/part/${part_video_id}.timelog
    rm timelog
    mv data/videodb_proposals.csv ${ad_root}/output/act/part/${part_video_id}.out

    init=2400
    dura=1200
    cd ${ad_root}/sparseprop
    rm data/videodb_input.csv
    echo "video-frames video-name" >> data/videodb_input.csv
    echo "${n_extred_frames}.0 test_video" >> data/videodb_input.csv
    part_video_id="${video_name}-i${init}-d${dura}"
    acd_infer="python retrieve_proposals.py data/videodb_input.csv pca/videodb_c3d.h5 data/class_induced_thumos14.pkl data/videodb_proposals.csv ${init} ${dura}"
    $acd_infer
    cat timelog >> ${ad_root}/timing/part/${part_video_id}.timelog
    rm timelog
    mv data/videodb_proposals.csv ${ad_root}/output/act/part/${part_video_id}.out

    init=3600
    dura=1200
    cd ${ad_root}/sparseprop
    rm data/videodb_input.csv
    echo "video-frames video-name" >> data/videodb_input.csv
    echo "${n_extred_frames}.0 test_video" >> data/videodb_input.csv
    part_video_id="${video_name}-i${init}-d${dura}"
    acd_infer="python retrieve_proposals.py data/videodb_input.csv pca/videodb_c3d.h5 data/class_induced_thumos14.pkl data/videodb_proposals.csv ${init} ${dura}"
    $acd_infer
    cat timelog >> ${ad_root}/timing/part/${part_video_id}.timelog
    rm timelog
    mv data/videodb_proposals.csv ${ad_root}/output/act/part/${part_video_id}.out

done
