cd "$PWD/darknet/build/darknet/x64/"
../../../darknet detector train data/thermal.data yolov3-thermal.cfg darknet53.conv.74 -gpus 0,1,3 -map