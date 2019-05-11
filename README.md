# Object Detection
Object detection thermal images

### Steps to follow:
* **./build_docker_container.sh** (To build an nvidia-docker)
* **./run_docker_container.sh** (To run the built nvidia-docker by name "darknet_thermal" and with mounted dataset.
* Make sure that your gpu arch is included in [Makefile](https://github.com/enesozi/object-detection/blob/master/Makefile#L16)
  * If it's not, then add your gpu arch and run **make clean** and **make** commands in darknet directory.
* **./preprocess_flir_dataset.sh** (Make sure that image directories are consistent with yours.)
* Exit the container by using "**Ctrl+P and Q**". This leaves the container still running.
* Start training in detached mode by using the following command:
  * **nvidia-docker exec -d darknet_thermal bash -c "cd /home/object-detection/ ; ./preprocess_flir_dataset.sh ; ./start_training.sh"**
  * In **start_training.sh** script gpu id is 3 by default. You might need to adjust this according to yours.

#### PyCoco Results for IoU=0.50, area=all, maxDets=100
   Average Precision  (AP) @[ IoU=0.50:0.50 | area=   all | maxDets=100 ] = **0.714**  
   Average Precision  (AP) @[ IoU=0.50      | area=   all | maxDets=100 ] = -1.000  
   Average Precision  (AP) @[ IoU=0.75      | area=   all | maxDets=100 ] = -1.000  
   Average Precision  (AP) @[ IoU=0.50:0.50 | area= small | maxDets=100 ] = 0.576  
   Average Precision  (AP) @[ IoU=0.50:0.50 | area=medium | maxDets=100 ] = 0.819  
   Average Precision  (AP) @[ IoU=0.50:0.50 | area= large | maxDets=100 ] = 0.906  
   Average Recall     (AR) @[ IoU=0.50:0.50 | area=   all | maxDets=  1 ] = 0.348  
   Average Recall     (AR) @[ IoU=0.50:0.50 | area=   all | maxDets= 10 ] = 0.781  
   Average Recall     (AR) @[ IoU=0.50:0.50 | area=   all | maxDets=100 ] = **0.787**  
   Average Recall     (AR) @[ IoU=0.50:0.50 | area= small | maxDets=100 ] = 0.719  
   Average Recall     (AR) @[ IoU=0.50:0.50 | area=medium | maxDets=100 ] = 0.834  
   Average Recall     (AR) @[ IoU=0.50:0.50 | area= large | maxDets=100 ] = 0.918  

Baseline result: mAP IoU(0.5) of 0.587
