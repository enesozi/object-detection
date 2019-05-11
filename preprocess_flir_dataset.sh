#!/bin/bash
train_images="$HOME/Downloads/FLIR_ADAS/training/PreviewData"
validation_images="$HOME/Downloads/FLIR_ADAS/validation/PreviewData"
video_images="$HOME/Downloads/FLIR_ADAS/video/PreviewData"
train_anns="$HOME/Downloads/FLIR_ADAS/training/Annotations"
validation_anns="$HOME/Downloads/FLIR_ADAS/validation/Annotations"
video_anns="$HOME/Downloads/FLIR_ADAS/video/Annotations"
train_file="thermal_train.txt"
valid_file="thermal_validation.txt"
cfg_file="yolov3-spp-custom.cfg"
data_file="thermal.data"
name_file="thermal.names"
image_dir="$PWD/darknet/build/darknet/x64/data/thermal"

[ -f "$train_file" ] && rm "$train_file"
[ -f "$valid_file" ] && rm "$valid_file"


for value in {1..8862}
do
printf "data/thermal/FLIR_%05d.jpeg\n" $value >> "$train_file"
done
for value in {1..4224}
do
printf "data/thermal/FLIR_video_%05d.jpeg\n" $value >> "$train_file"
done
for value in {8863..10228}
do
printf "data/thermal/FLIR_%05d.jpeg\n" $value >> "$valid_file"
done

# Copy images to the correct directory
rm -rf "$image_dir"
mkdir "$image_dir"
cp "$train_images/"* "$image_dir" 2>/dev/null
cp "$validation_images/"* "$image_dir" 2>/dev/null
cp "$video_images/"* "$image_dir" 2>/dev/null

# Convert anns from standard COCO format to darknet format
python convert_coco_yolo.py "$train_anns" "$image_dir"
python convert_coco_yolo.py "$validation_anns" "$image_dir"
python convert_coco_yolo.py "$video_anns" "$image_dir"

# Quick fix for imbalanced dataset
[ -f "bikes.txt" ] && rm "bikes.txt"

python convert_coco_yolo.py "$train_anns" . --debug
python convert_coco_yolo.py "$validation_anns" . --debug
python convert_coco_yolo.py "$video_anns" . --debug

for iter in {1..5}
do
	sed p "bikes.txt" >> "bikes_new.txt"
done

mv "bikes_new.txt" "bikes.txt"
cat "bikes.txt" >> "$train_file"
rm "bikes.txt"

# Shuffle train dataset
shuf "$train_file" > "train_file_shuffled.txt"
mv "train_file_shuffled.txt" "$train_file"

# Copy necessary files to the correct directories
cp "$cfg_file"   "$PWD/darknet/build/darknet/x64/"
cp "$train_file" "$PWD/darknet/build/darknet/x64/data/"
cp "$valid_file" "$PWD/darknet/build/darknet/x64/data/"
cp "$data_file"  "$PWD/darknet/build/darknet/x64/data/"
cp "$name_file"  "$PWD/darknet/build/darknet/x64/data/"
cp "run_all_iters.sh" "$PWD/darknet/build/darknet/x64/"

# Download pretrained weight
wget https://pjreddie.com/media/files/darknet53.conv.74 -O "$PWD/darknet/build/darknet/x64/darknet53.conv.74"