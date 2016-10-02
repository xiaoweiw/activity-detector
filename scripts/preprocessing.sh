## This script extracts frames from an input video file
## and scales them to the wanted size

ad_root="/home/xiaoweiw/research/video/profiling/acd/activity-detector/"  # root directory of activity detector
video_dir="/home/lvnguyen/ActivityNet/Crawler/vids/"
cd ${video_dir}
#for input_video in v_b7*.mp4; do
for input_video in v_9*.mp4; do

#input_video="v_yrPVjR4jbv0.mp4"
#input_video="v_zsw9WEsSowI.mp4"
#input_video="v_f0hh9bwVfV0.mp4"
#input_video="v_pZzTMUJG9Rk.mp4"

video_name="${input_video%.*}"

echo $video_name

mkdir -p ${ad_root}/data/frames/original/${video_name}

cd ${ad_root}/data/frames/original/${video_name}
ffmpeg -i ${video_dir}/${input_video} %06d.jpg
for img in *.jpg; do
  convert $img -resize 171x128\! $img
done
done
