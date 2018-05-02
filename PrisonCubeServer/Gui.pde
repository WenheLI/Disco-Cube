import controlP5.*;
import java.util.*;

ControlP5 cp5;

boolean guiToggle;

int resolution;
int thresholdMin;
int thresholdMax;
float monitorScale;
int jointThreshold;


boolean pointCloud;
boolean registeredColor;
boolean displayPoint;

Slider2D offsetSlider2D;
float offsetX;
float offsetZ;

int lifeSpan;
int particleSize;

void setupGui() {
  guiToggle = true;

  int sliderW = 100;
  int sliderH = 15;
  int startX = 10;
  int startY = 35;
  int spacing = 20;

  cp5 = new ControlP5( this );
  cp5.addSlider("thresholdMin")
    .setPosition(startX, startY+spacing*0)
    .setSize(sliderW, sliderH)
    .setRange(0, 4499)
    .setValue(1000)
    ;    
  cp5.addSlider("thresholdMax")
    .setPosition(startX, startY+spacing*1)
    .setSize(sliderW, sliderH)
    .setRange(0, 4499)
    .setValue(2000)
    ;
  cp5.addSlider("jointThreshold")
    .setPosition(startX, startY+spacing*2)
    .setSize(sliderW, sliderH)
    .setRange(0, 255)
    .setValue(90)
    ;
  cp5.addSlider("resolution")
    .setPosition(startX, startY+spacing*3)
    .setSize(sliderW, sliderH)
    .setRange(2, 10)
    .setValue(8)
    ;
  cp5.addSlider("monitorScale")
    .setPosition(startX, startY+spacing*4)
    .setSize(sliderW, sliderH)
    .setRange(0.1, 1.0)
    .setValue(0.5)
    ;
  cp5.addToggle("pointCloud")
    .setPosition(startX, startY+spacing*5)
    .setSize(sliderW, sliderH)
    .setValue(true)
    ;

  cp5.addToggle("registeredColor")
    .setPosition(startX, startY+spacing*7)
    .setSize(sliderW, sliderH)
    .setValue(false)
    ;
  offsetSlider2D = cp5.addSlider2D("offset")
    .setPosition(startX, startY + spacing*9)
    .setSize(sliderW, sliderW)
    .setMinMax(-1000,-1000,1000,1000)
    .setValue(0,0);
    ;

  cp5.addToggle("displayPoint")
    .setPosition(startX, startY+spacing*17)
    .setSize(sliderW, sliderH)
    .setValue(true)
    ;
  cp5.addSlider("lifeSpan")
    .setPosition(startX, startY+spacing*19)
    .setSize(sliderW, sliderH)
    .setRange(2, 20)
    .setValue(10)
    ;
  cp5.addSlider("particleSize")
    .setPosition(startX, startY+spacing*20)
    .setSize(sliderW, sliderH)
    .setRange(1, 10)
    .setValue(6)
    ;

  cp5.setAutoDraw(false);
}

void drawGui() {
  // draw GUI and DepthImage
  hint(DISABLE_DEPTH_TEST);
  
  offsetX = offsetSlider2D.getArrayValue()[0];
  offsetZ = offsetSlider2D.getArrayValue()[1];

  pushStyle();
  fill(255);
  cp5.draw();
  text(frameRate, 10, 20);

  drawDepthImage();
  popStyle();

  hint(ENABLE_DEPTH_TEST);
}

void drawDepthImage() {
  pushStyle();
  pushMatrix();
  translate(width, 0);
  scale(monitorScale);
  //image(kinect2.getDepthImage(), -kinect2.depthWidth, 0, kinect2.depthWidth, kinect2.depthHeight);
  image(skeletonGraphics, -2*w, 0, w, h);
  image(opencv.getOutput(), -w, 0, w, h);
  pushStyle();
  popMatrix();
}