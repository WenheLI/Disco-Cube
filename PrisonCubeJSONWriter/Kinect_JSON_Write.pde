import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;
import org.openkinect.processing.*;
import gab.opencv.*;

Kinect2 kinect2;
OpenCV opencv;

PImage depthImg;
PImage colorImg;
PVector blackHolePos;

ArrayList<Particle> particles;


int startPoint;
JSONObject json;
int jsonState = 0;

void setup() {
  size(1000, 800, P3D);
  setupPeasyCam();
  setupGui();
  particles = new ArrayList();
  kinect2 = new Kinect2(this);
  kinect2.initDepth();
  kinect2.initRegistered();
  kinect2.initDevice();

  blackHolePos = new PVector(0, -212, 300);

  depthImg = new PImage(kinect2.depthWidth, kinect2.depthHeight, ARGB);
  opencv = new OpenCV(this, depthImg);
  
  json = new JSONObject();
}

void draw() {
  background(0);

  int[] rawDepth = kinect2.getRawDepth();
  int w = kinect2.depthWidth;
  int h = kinect2.depthHeight;

  resetStats();

  if (registeredColor) {
    colorImg = kinect2.getRegisteredImage();
    colorImg.loadPixels();
  }

  //first iteration of depthImg based on rawDepth
  depthImg.loadPixels();
  ArrayList <Integer> indexes = new ArrayList(); //indexes within the threshold
  for (int i=0; i < rawDepth.length; i++) {
    depthImg.pixels[i] = color(0, 0);
    if (rawDepth[i] >= thresholdMin && rawDepth[i] <= thresholdMax && rawDepth[i] != 0) {
      float brightness = map(rawDepth[i], thresholdMin, thresholdMax, 255, 1);
      indexes.add(i);
      //float b = map(rawDepth[i], thresholdMin, thresholdMax, 0, 255);
      depthImg.pixels[i] = color(brightness);
    }
  }

  depthImg.updatePixels();
  processOpenCV();
  opencvTemp = opencv.getSnapshot();
  opencvTemp.loadPixels();


  ArrayList<PVector> pointsTemp = new ArrayList();
  //second iteration for point cloud based on opencv
  for (Integer i : indexes) {
    int x = i % kinect2.depthWidth;
    int y = floor(i / kinect2.depthWidth);
    if (pointCloud && x%resolution == 0 && y%resolution == 0 && opencvTemp.pixels[i] != color(0)) {
      float pX = map(x, 0, w, -w/2, w/2) + offsetX;
      float pY = map(y, 0, h, -h/2, h/2);
      float pZ = map(rawDepth[i], 0, 4499, 900, -900) + offsetZ;

      //stats
      if (pZ>closestPoint.z) closestPoint.set(pX, pY, pZ);
      sumPoint.add(pX, pY, pZ);
      numOfPoints++;

      PVector point = new PVector(pX, pY, pZ);
      color clr;
      // color
      if (registeredColor) clr = colorImg.pixels[i];
      else clr = color(255);

      //add particles
      PVector vel = new PVector(directionX, -directionY, directionZ);
      pointsTemp.add(point);
      particles.add(new Particle(point, vel, clr, lifeSpan, particleSize));
    }
  }

  if (keyPressed) {
    if (keyCode == ENTER && jsonState == 0) {
      jsonState = 1;
      startPoint = -1;
      println("start");
    } else if (keyCode == RIGHT && jsonState == 1) {
      stopJson(json, startPoint);
      startPoint = -1;
      jsonState = 0;
      println("stop");
    }
  }

  if (jsonState == 1) {
    startPoint += 1;
    StartSavePoint(json, pointsTemp, startPoint);
  }

  //contours point cloud
  if (pointCloudOfContours) {
    contours = opencv.findContours();
    for (Contour c : contours) {
      for ( PVector point : c.getPoints()) {
        int i = int(point.x + point.y * kinect2.depthWidth);
        if (rawDepth[i] >= thresholdMin && rawDepth[i] <= thresholdMax && rawDepth[i] != 0) {
          point.x = map(point.x, 0, w, -w/2, w/2) + offsetX;
          point.y = map(point.y, 0, h, -h/2, h/2);
          point.z = map(rawDepth[i], 0, 4499, 900, -900) + offsetZ;
          PVector vel = new PVector(directionX, -directionY, directionZ);
          particles.add(new Particle(point, vel, color(255, 0, 0), lifeSpan, particleSize));
        }
      }
    }
  }
  indexes.clear();

  processStats();
  drawParticles();
  drawBlackHole();

  lights();
  if (guiToggle) drawGui();
}



void keyPressed() {
  if (key == ' ') guiToggle = !guiToggle;
}


void StartSavePoint(JSONObject json, ArrayList<PVector> pointsTemp, int keyValue) {
  JSONArray points = new JSONArray();
  for (int i = 0; i < pointsTemp.size(); i++) {
    int j = i * 3;
    points.setFloat(j, pointsTemp.get(i).x);
    points.setFloat(j+1, pointsTemp.get(i).y);
    points.setFloat(j+2, pointsTemp.get(i).z);
  }

  json.setJSONArray(keyValue + "", points);
}

void stopJson(JSONObject json, int start) {
  json.setInt("length", start + 1);
  saveJSONObject(json, "data/data.json");
}
