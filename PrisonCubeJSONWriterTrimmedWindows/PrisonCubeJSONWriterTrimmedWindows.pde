import KinectPV2.*;
import KinectPV2.KJoint;
import gab.opencv.*;

KinectPV2 kinect;
OpenCV opencv;

PImage depthImg;
PImage colorImg;

ArrayList<Particle> particles;

int count = 0;

int startPoint;
JSONObject json;
int jsonState = 0;

int w;
int h;

void setup() {
  size(1000, 800, P3D);
  //setupPeasyCam();
  setupGui();
  particles = new ArrayList();
  kinect = new KinectPV2(this);
  kinect.enableColorImg(true);
  kinect.enableDepthImg(true);
  kinect.init();

  w = 512;
  h = 424;
  depthImg = new PImage(w, h, ARGB);
  opencv = new OpenCV(this, depthImg);

  json = new JSONObject();


  resetStats();
}

void draw() {
  background(0);

  int[] rawDepth = kinect.getRawDepthData();


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
    int x = i % w;
    int y = floor(i / w);
    if (pointCloud && x%resolution == 0 && y%resolution == 0 && opencvTemp.pixels[i] != color(0)) {
      float pX = map(x, 0, w, -w/2, w/2);
      float pY = map(y, 0, h, -h/2, h/2);
      float pZ = map(rawDepth[i], 0, 4499, 900, -900);

      //stats
      if (pZ > closestPoint.z) closestPoint.set(pX, pY, pZ);
      if (pZ < farthestPoint.z) farthestPoint.z = pZ;
      sumPoint.add(pX, pY, pZ);
      numOfPoints++;

      PVector point = new PVector(pX, pY, pZ);
      color clr;
      // color 
      if (registeredColor) clr = colorImg.pixels[i];
      else clr = color(255);

      //add particles
      PVector vel = new PVector(0, 0, 0);
      pointsTemp.add(point);
      PVector particlePos = point.copy().add(width/2 + offsetX, height/2, -500 + offsetZ);
      particles.add(new Particle(particlePos, vel, clr, lifeSpan, particleSize));
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

  indexes.clear();

  drawParticles();

  lights();
  if (guiToggle) drawGui();
}

void drawParticles() {
  for (int i = 0; i < particles.size(); i++) {
    Particle p = particles.get(i);
    p.display();
    p.update();

    if (p.isDead) {
      particles.remove(p);
      i--;
    }
  }
}

void keyPressed() {
  if (key == ' ') guiToggle = !guiToggle;
}


void StartSavePoint(JSONObject json, ArrayList<PVector> pointsTemp, int keyValue) {
  JSONArray points = new JSONArray();
  resetStats();
  for (int i = 0; i < pointsTemp.size(); i++) {
    int j = i * 3;
    points.setInt(j, floor(pointsTemp.get(i).x));
    points.setInt(j+1, floor(pointsTemp.get(i).y));
    points.setInt(j+2, floor(pointsTemp.get(i).z));
  }
  json.setJSONArray(keyValue + "", points);
}

void stopJson(JSONObject json, int start) {
  json.setInt("length", start + 1);
  JSONArray xs = new JSONArray();
  xs.setInt(0, -w/2);
  xs.setInt(1, w/2);

  JSONArray ys = new JSONArray();
  ys.setInt(0, -h/2);
  ys.setInt(1, h/2);

  JSONArray zs = new JSONArray();
  println(farthestPoint, closestPoint);
  zs.setInt(0, floor(farthestPoint.z));
  zs.setInt(1, floor(closestPoint.z));

  json.setJSONArray("rangeX", xs);
  json.setJSONArray("rangeY", ys);
  json.setJSONArray("rangeZ", zs);
  saveJSONObject(json, "data/" + count + ".json");
  count ++;
}