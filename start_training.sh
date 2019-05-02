cd "$PWD/darknet/build/darknet/x64/"
../../../darknet detector train data/thermal.data yolov3-thermal.cfg darknet53.conv.74 -gpus 0 -dont_show -mjpeg_port 8090 -map >> /home/tra_results.txt
