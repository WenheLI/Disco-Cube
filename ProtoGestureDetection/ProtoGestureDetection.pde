import java.util.ArrayList;
import KinectPV2.KJoint;
import KinectPV2.*;
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myTarget;

KinectPV2 kinect;
PVector pHandLeftPos;
PVector pHandRightPos;
PVector pLegLeftPos;
PVector pLegRightPos;

void setup() {
  size(512, 424, P3D);

  kinect = new KinectPV2(this);

  //Enables depth and Body tracking (mask image)
  kinect.enableDepthMaskImg(true);
  kinect.enableSkeletonDepthMap(true);

  kinect.init();

  oscP5 = new OscP5(this, 12000);
  myTarget = new NetAddress("127.0.0.1", 12001);
}

void draw() {
  background(0);

  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonDepthMap();

  //individual joints

  for (int i = 0; i < skeletonArray.size(); i++) {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    //if the skeleton is being tracked compute the skleton joints
    if (skeleton.isTracked()) {
      KJoint[] joints = skeleton.getJoints();
      checkNull(joints);
      checkSignal(joints);


      color col  = skeleton.getIndexColor();
      fill(col);
      stroke(col);

      drawBody(joints);
    }
  }
}

void checkNull(KJoint[] joints) {
  if (pHandLeftPos == null) pHandLeftPos = joints[KinectPV2.JointType_HandLeft].getPosition().copy();
  if (pHandRightPos == null) pHandRightPos = joints[KinectPV2.JointType_HandRight].getPosition().copy();
  if (pLegLeftPos == null) pLegLeftPos = joints[KinectPV2.JointType_KneeLeft].getPosition().copy();
  if (pLegRightPos == null) pLegRightPos = joints[KinectPV2.JointType_KneeRight].getPosition().copy();
}

void checkSignal(KJoint[] joints) {
  if (pHandLeftPos.dist(joints[KinectPV2.JointType_HandLeft].getPosition()) > 10) {
    OscMessage myMessage = new OscMessage("/test");
    myMessage.add(1);
    oscP5.send(myMessage, myTarget);
  }
  if (pHandRightPos.dist(joints[KinectPV2.JointType_HandRight].getPosition()) > 10) {
    OscMessage myMessage = new OscMessage("/test");
    myMessage.add(2);
    oscP5.send(myMessage, myTarget);
  }
  if (pLegLeftPos.dist(joints[KinectPV2.JointType_KneeLeft].getPosition()) > 10) {
    OscMessage myMessage = new OscMessage("/test");
    myMessage.add(3);
    oscP5.send(myMessage, myTarget);
    println("kneeLeft") ;
  }
  if (pLegRightPos.dist(joints[KinectPV2.JointType_KneeRight].getPosition()) > 10) {
    OscMessage myMessage = new OscMessage("/test");
    myMessage.add(4);
    oscP5.send(myMessage, myTarget);
    println("kneeRight") ;
  }
  pHandLeftPos = joints[KinectPV2.JointType_HandLeft].getPosition().copy();
  pHandRightPos = joints[KinectPV2.JointType_HandRight].getPosition().copy();
  pLegLeftPos = joints[KinectPV2.JointType_KneeLeft].getPosition().copy();
  pLegRightPos = joints[KinectPV2.JointType_KneeRight].getPosition().copy();
}

void drawBody(KJoint[] joints) {
  drawBone(joints, KinectPV2.JointType_Head, KinectPV2.JointType_Neck);
  drawBone(joints, KinectPV2.JointType_Neck, KinectPV2.JointType_SpineShoulder);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_SpineMid);
  drawBone(joints, KinectPV2.JointType_SpineMid, KinectPV2.JointType_SpineBase);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderRight);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderLeft);
  drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipRight);
  drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipLeft);

  // Right Arm
  drawBone(joints, KinectPV2.JointType_ShoulderRight, KinectPV2.JointType_ElbowRight);
  drawBone(joints, KinectPV2.JointType_ElbowRight, KinectPV2.JointType_WristRight);
  drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_HandRight);
  drawBone(joints, KinectPV2.JointType_HandRight, KinectPV2.JointType_HandTipRight);
  drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_ThumbRight);

  // Left Arm
  drawBone(joints, KinectPV2.JointType_ShoulderLeft, KinectPV2.JointType_ElbowLeft);
  drawBone(joints, KinectPV2.JointType_ElbowLeft, KinectPV2.JointType_WristLeft);
  drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_HandLeft);
  drawBone(joints, KinectPV2.JointType_HandLeft, KinectPV2.JointType_HandTipLeft);
  drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_ThumbLeft);

  // Right Leg
  drawBone(joints, KinectPV2.JointType_HipRight, KinectPV2.JointType_KneeRight);
  drawBone(joints, KinectPV2.JointType_KneeRight, KinectPV2.JointType_AnkleRight);
  drawBone(joints, KinectPV2.JointType_AnkleRight, KinectPV2.JointType_FootRight);

  // Left Leg
  drawBone(joints, KinectPV2.JointType_HipLeft, KinectPV2.JointType_KneeLeft);
  drawBone(joints, KinectPV2.JointType_KneeLeft, KinectPV2.JointType_AnkleLeft);
  drawBone(joints, KinectPV2.JointType_AnkleLeft, KinectPV2.JointType_FootLeft);

  //Single joints
  drawJoint(joints, KinectPV2.JointType_HandTipLeft);
  drawJoint(joints, KinectPV2.JointType_HandTipRight);
  drawJoint(joints, KinectPV2.JointType_FootLeft);
  drawJoint(joints, KinectPV2.JointType_FootRight);

  drawJoint(joints, KinectPV2.JointType_ThumbLeft);
  drawJoint(joints, KinectPV2.JointType_ThumbRight);

  drawJoint(joints, KinectPV2.JointType_Head);
}

//draw a single joint
void drawJoint(KJoint[] joints, int jointType) {
  pushMatrix();
  translate(joints[jointType].getX(), joints[jointType].getY(), joints[jointType].getZ());
  ellipse(0, 0, 25, 25);
  popMatrix();
}

//draw a bone from two joints
void drawBone(KJoint[] joints, int jointType1, int jointType2) {
  pushMatrix();
  translate(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ());
  ellipse(0, 0, 25, 25);
  popMatrix();
  line(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ(), joints[jointType2].getX(), joints[jointType2].getY(), joints[jointType2].getZ());
}
