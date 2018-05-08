import KinectPV2.*;
import KinectPV2.KJoint;
import gab.opencv.*;
import java.util.ArrayList;
import oscP5.*;
import netP5.*;
import spout.*;

Spout spout;
KinectPV2 kinect;
OpenCV opencv;

FaceData [] faceData;

PImage depthImg;
PImage colorImg;

ArrayList<Particle> particles;
int absentCount = 0;

int startPoint;
JSONObject json;
int jsonState = 0;
int jsonCount = 0;

int w;
int h;

float pitch;
float yaw;
float roll;

float maxDist = -1;

OscP5 oscP5;
NetAddress myTarget;

color[] newColor = {#ff00c1, #9600ff, #4900ff, #00b8ff, #00fff9};

boolean isClick = false;


void setup() {
  size(1000, 800, P3D);
  spout = new Spout(this);
  spout.createSender("Server");
  setupGui();
  setupKinect();

  particles = new ArrayList();

  w = 512;
  h = 424;

  depthImg = new PImage(w, h, ARGB);
  opencv = new OpenCV(this, depthImg);
  skeletonGraphics = createGraphics(w, h, P3D);

  json = new JSONObject();

  oscP5 = new OscP5(this, 12000);
  myTarget = new NetAddress("127.0.0.1", 12001);
  resetStats();
  soundSetup();
}
void draw() {
  if (mapping)background(255);
  else background(0);

  kinect.generateFaceData();

  int[] rawDepth = kinect.getRawDepthData();

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
      clr = newColor[(int)random(newColor.length)];

      //add particles
      PVector vel = new PVector(0, 0, 0);
      pointsTemp.add(point);
      if (random(1)<0.5) {
        PVector particlePos = point.copy().add(width/2 + offsetX, height/2, -500 + offsetZ).add(PVector.random3D().mult(2));
        ;
        particles.add(new Particle(particlePos, vel, clr, lifeSpan, particleSize));
      }
    }
  }

  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonDepthMap();
  ArrayList<Float> dists = new ArrayList();
  maxDist = -1;
  int skeletonIndex = -1;
  for (int i = 0; i < skeletonArray.size(); i++) {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    if (skeleton.isTracked()) {
      KJoint[] joints = skeleton.getJoints();
      PVector hip = PVector.add(joints[KinectPV2.JointType_HipLeft].getPosition(), 
        joints[KinectPV2.JointType_HipRight].getPosition()).div(2);
      float dis = PVector.dist(joints[KinectPV2.JointType_Neck].getPosition(), hip);
      if (dis > maxDist) {
        maxDist = dis;
        skeletonIndex = i;
      }
      dists.add(dis);
    }
  }
  //println(maxDist + " " + skeletonIndex);
  //maxDisyt < 120 omit
  if (maxDist < jointThreshold) skeletonIndex = -1;
  
  //TODO: boundary of skeleton in Kinect?
  
  //else {
  //  for (int m = 0; m < dists.size(); m++) {
  //    if (m != skeletonIndex) {
  //      if (abs(dists.get(m) - maxDist) < .0001) {
          
  //      }
  //    }
  //  }
  //}

  if (skeletonIndex >= 0) {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(skeletonIndex);
    //if the skeleton is being tracked compute the skleton joints
    if (skeleton.isTracked()) {
      absentCount = 0;
      KJoint[] joints = skeleton.getJoints();

      PVector leftHand = joints[KinectPV2.JointType_HandLeft].getPosition().copy();
      PVector rightHand = joints[KinectPV2.JointType_HandRight].getPosition().copy();
      PVector head = joints[KinectPV2.JointType_Head].getPosition().copy();
      float leftHeadDist = head.y - leftHand.y;
      float rightHeadDist = head.y - rightHand.y;
      text(handHeadCounter, 300, 200);
      if ( (leftHeadDist < 40)&& (leftHeadDist > 1) ||(rightHeadDist > 1) && (rightHeadDist < 40)) {
        handHeadCounter ++;
        if (handHeadCounter > 50) {
          background(255, 255, 0);
          if (isClick && startPoint > 300) {
            isClick = !isClick;
          } else if (!isClick) {
            isClick = !isClick;
            pHipPos = PVector.add(joints[KinectPV2.JointType_HipLeft].getPosition(), 
              joints[KinectPV2.JointType_HipRight].getPosition());
            pHipPos.div(2);
          }
          handHeadCounter = 0;
        }
      } else {
        handHeadCounter = 0;
      }

      //text(jsonState, 300, 500);

      drawBody(joints);
      drawHandState(joints[KinectPV2.JointType_HandRight]);
      drawHandState(joints[KinectPV2.JointType_HandLeft]);
      if (jsonState == 1) {
        checkNull(joints);
        checkSignal(joints);
      }
    }
  } else if (jsonState == 1) {
    absentCount ++;
    if (absentCount>60) isClick = !isClick;
  }
  //text(absentCount, 500, 500);
  checkFace();

  //json recording
  if (isClick && jsonState == 0) {
    jsonState = 1;
    startPoint = -1;
    println("start");
  } else if (!isClick && jsonState == 1 && startPoint > 300) {
    stopJson(json, startPoint);
    startPoint = -1;
    jsonState = 0;
    println("stop");
  }
  if (jsonState == 1) {
    startPoint += 1;
    startSavePoint(json, pointsTemp, startPoint);
  }

  OscMessage stateMsg = new OscMessage("/animatorState");
  if (jsonState==1)stateMsg.add(2);
  else if (skeletonIndex == -1) stateMsg.add(0);
  else stateMsg.add(1);
  oscP5.send(stateMsg, myTarget);

  indexes.clear();
  addSoundParticle();
  drawParticles();

  if (guiToggle) drawGui();
  spout.sendTexture();
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


void startSavePoint(JSONObject json, ArrayList<PVector> pointsTemp, int keyValue) {
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
  zs.setInt(0, floor(farthestPoint.z));
  zs.setInt(1, floor(closestPoint.z));

  json.setJSONArray("rangeX", xs);
  json.setJSONArray("rangeY", ys);
  json.setJSONArray("rangeZ", zs);
  saveJSONObject(json, "C:\\Users\\mars_\\Documents\\GitHub\\PrisionCube\\PrisionCubeClientWindows\\data\\" + jsonCount + ".json");
  jsonCount ++;

  OscMessage offsetMsg = new OscMessage("/finish");
  offsetMsg.add(jsonCount);
  oscP5.send(offsetMsg, myTarget);
}