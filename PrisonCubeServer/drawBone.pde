PGraphics skeletonGraphics;
void drawBody(KJoint[] joints) {
  skeletonGraphics.beginDraw();
  skeletonGraphics.background(0);
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
  skeletonGraphics.endDraw();
}

//draw a single joint
void drawJoint(KJoint[] joints, int jointType) {
  skeletonGraphics.pushMatrix();
  skeletonGraphics.translate(joints[jointType].getX(), joints[jointType].getY(), joints[jointType].getZ());
  skeletonGraphics.ellipse(0, 0, 25, 25);
  skeletonGraphics.popMatrix();
}

//draw a bone from two joints
void drawBone(KJoint[] joints, int jointType1, int jointType2) {

  skeletonGraphics.pushMatrix();
  skeletonGraphics.translate(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ());
  skeletonGraphics.ellipse(0, 0, 25, 25);
  skeletonGraphics.popMatrix();
  skeletonGraphics.line(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ(), joints[jointType2].getX(), joints[jointType2].getY(), joints[jointType2].getZ());
}

//draw a ellipse depending on the hand state
void drawHandState(KJoint joint) {
  skeletonGraphics.noStroke();
  handState(joint.getState());
  skeletonGraphics.pushMatrix();
  skeletonGraphics.translate(joint.getX(), joint.getY(), joint.getZ());
  skeletonGraphics.ellipse(0, 0, 70, 70);
  skeletonGraphics.popMatrix();
}

/*
Different hand state
 KinectPV2.HandState_Open
 KinectPV2.HandState_Closed
 KinectPV2.HandState_Lasso
 KinectPV2.HandState_NotTracked
 */

//Depending on the hand state change the color
void handState(int handState) {
  switch(handState) {
  case KinectPV2.HandState_Open:
    skeletonGraphics.fill(0, 255, 0);
    break;
  case KinectPV2.HandState_Closed:
    skeletonGraphics.fill(255, 0, 0);
    break;
  case KinectPV2.HandState_Lasso:
    skeletonGraphics.fill(0, 0, 255);
    break;
  case KinectPV2.HandState_NotTracked:
    skeletonGraphics.fill(100, 100, 100);
    break;
  }
}