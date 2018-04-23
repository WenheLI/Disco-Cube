PImage opencvTemp;
ArrayList <Contour> contours;
void processOpenCV() {
  opencv.loadImage(depthImg);
  opencv.gray();
  //opencv.threshold(opencvThreshold);

  opencv.dilate();
  opencv.erode();
  opencv.erode();
  opencv.erode();
  opencv.erode();
  opencv.dilate();

}
