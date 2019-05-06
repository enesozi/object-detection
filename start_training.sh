cd "$PWD/darknet/build/darknet/x64/"
../../../darknet detector train data/thermal.data yolov3-spp-custom.cfg darknet53.conv.74 -gpus 3 -dont_show  -map >> /home/tra_results.txt
