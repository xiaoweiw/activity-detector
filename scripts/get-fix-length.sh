num_frames=1000
num_videos=100
frame_res="171x128"
ad_root="/home/xiaoweiw/research/video/profiling/acd/activity-detector/"  # root directory of activity detector
video_dir="${ad_root}/data/vids"
video_file_set="v_83*.mp4"
#video_file_set="v_b7*.mp4"

cd ${video_dir}
for input_video in ${video_file_set}; do
  [ $((num_videos--)) = 0 ] && break
  video_name="${input_video%.*}"

  mkdir -p ${ad_root}/data/frames/${video_name}
  cd ${ad_root}/data/frames/${video_name}
  ffmpeg -i ${video_dir}/${input_video} -s ${frame_res} -vframes ${num_frames} %06d.jpg

done # for input_video in video_file_set

