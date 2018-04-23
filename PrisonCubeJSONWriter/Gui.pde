import controlP5.*;
import java.util.*;
import peasy.*;

PeasyCam cam;
ControlP5 cp5;

boolean guiToggle;

int resolution;
int thresholdMin;
int thresholdMax;
float monitorScale;
int opencvThreshold;

boolean pointCloud;
boolean pointCloudOfContours;
boolean registeredColor;
boolean displayStats;
boolean displayPoint;
boolean displayClosestPoint;

Slider2D offsetSlider2D;
float offsetX = 0;
float offsetZ = 0;

int lifeSpan;
int particleSize;
float blackHoleSpeed;

Slider2D directionSlider2D;
float directionX = 0;
float directionY = 0;
float directionZ = 0;

Slider2D blackHoleOffsetSlider2D;
float blackHoleX = 0;
float blackHoleY = 0;
float blackHoleZ = 0;

void setupPeasyCam() {
  cam = new PeasyCam(this, 100);
  cam.setMinimumDistance(600);
  cam.setMaximumDistance(1500);
  cam.setDistance(1000);
}
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
  cp5.addSlider("resolution")
    .setPosition(startX, startY+spacing*2)
    .setSize(sliderW, sliderH)
    .setRange(2, 10)
    .setValue(8)
    ;
  cp5.addSlider("opencvThreshold")
    .setPosition(startX+200, startY+spacing*2)
    .setSize(sliderW, sliderH)
    .setRange(0, 255)
    .setValue(50)
    ;
  cp5.addSlider("monitorScale")
    .setPosition(startX, startY+spacing*3)
    .setSize(sliderW, sliderH)
    .setRange(0.1, 1.0)
    .setValue(0.5)
    ;
  cp5.addToggle("pointCloud")
    .setPosition(startX, startY+spacing*4)
    .setSize(sliderW, sliderH)
    .setValue(true)
    ;
  cp5.addToggle("pointCloudOfContours")
    .setPosition(startX, startY+spacing*6)
    .setSize(sliderW, sliderH)
    .setValue(true)
    ;
  cp5.addToggle("registeredColor")
    .setPosition(startX, startY+spacing*8)
    .setSize(sliderW, sliderH)
    .setValue(false)
    ;
  cp5.addToggle("displayStats")
    .setPosition(startX + 200, startY+spacing*6)
    .setSize(sliderW, sliderH)
    .setValue(true)
    ;
  cp5.addToggle("displayClosestPoint")
    .setPosition(startX + 200, startY+spacing*4)
    .setSize(sliderW, sliderH)
    .setValue(true)
    ;
  offsetSlider2D = cp5.addSlider2D("offset")
    .setPosition(startX, startY+spacing*10)
    .setSize(sliderW, sliderW)
    .setMinMax(-1000, -1000, 1000, 1000)
    .setValue(0, 0)
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
    .setValue(2)
    ;
  cp5.addSlider("particleSize")
    .setPosition(startX, startY+spacing*20)
    .setSize(sliderW, sliderH)
    .setRange(1, 10)
    .setValue(2)
    ;
  blackHoleOffsetSlider2D = cp5.addSlider2D("blackHole position")
    .setPosition(startX, startY+spacing*23)
    .setSize(sliderW, sliderW)
    .setMinMax(-1000, -1000, 1000, 1000)
    .setValue(0, 0)
    ;
  cp5.addSlider("blackHoleY")
    .setPosition(startX + 120, startY+spacing*23)
    .setSize(sliderH, sliderW)
    .setRange(-1000, 1000)
    .setValue(0)
    ;

  cp5.addSlider("blackHoleSpeed")
    .setPosition(startX, startY+spacing*29)
    .setSize(sliderW, sliderH)
    .setRange(-20, 20)
    .setValue(0)
    ;

  directionSlider2D = cp5.addSlider2D("wind")
    .setPosition(startX, startY+spacing*32)
    .setSize(sliderW, sliderW)
    .setMinMax(-10, -10, 10, 10)
    .setValue(0, 0)
    ;
  cp5.addSlider("directionY")
    .setPosition(startX + 120, startY+spacing*32)
    .setSize(sliderH, sliderW)
    .setRange(-10, 10)
    .setValue(0)
    ;


  cp5.setAutoDraw(false);
}

void drawGui() {
  // updateGUI
  if (mouseX < 320) cam.setActive(false);
  else  cam.setActive(true);
  offsetX = offsetSlider2D.getArrayValue()[0];
  offsetZ = offsetSlider2D.getArrayValue()[1];
  blackHoleX = blackHoleOffsetSlider2D.getArrayValue()[0];
  blackHoleZ = blackHoleOffsetSlider2D.getArrayValue()[1];
  directionX = directionSlider2D.getArrayValue()[0];
  directionZ = directionSlider2D.getArrayValue()[1];


  // draw GUI and DepthImage
  hint(DISABLE_DEPTH_TEST);
  cam.beginHUD();

  pushStyle();
  fill(255);
  cp5.draw();
  text(frameRate, 10, 20);
  int startX = 10;
  int startY = 35;
  int spacing = 20;

  text("BLACKHOLE SUCKS PARTICLES", startX, startY+spacing*22);
  text("WIND BLOWS PARTICLES", startX, startY+spacing*31);
  drawDepthImage();
  popStyle();

  cam.endHUD();
  hint(ENABLE_DEPTH_TEST);
}

void drawDepthImage() {
  pushStyle();
  pushMatrix();
  translate(width, 0);
  scale(monitorScale);
  //image(kinect2.getDepthImage(), -kinect2.depthWidth, 0, kinect2.depthWidth, kinect2.depthHeight);
  image(depthImg, -2*kinect2.depthWidth, 0, kinect2.depthWidth, kinect2.depthHeight);
  image(opencv.getOutput(), -kinect2.depthWidth, 0, kinect2.depthWidth, kinect2.depthHeight);
  pushStyle();
  popMatrix();
}
