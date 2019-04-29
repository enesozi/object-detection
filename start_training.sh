cd "$PWD/darknet/build/darknet/x64/"
../../../darknet detector train data/thermal.data yolov3_5l.cfg darknet53.conv.74 -gpus 3 >> /home/tra_results.txt
