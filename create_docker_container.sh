nvidia-docker build --no-cache -t thermal:darknet .

# Comment out below command after dataset is moved to the given directory.
#docker run --runtime=nvidia -it --name darknet_thermal -v ~/Downloads/FLIR_ADAS_12_11_18:/home/Downloads thermal:darknet