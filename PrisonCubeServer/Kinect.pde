PVector pHandLeftPos;
PVector pHandRightPos;
PVector pLegLeftPos;
PVector pLegRightPos;
PVector pHeadPos;

PVector pHipPos;

int handHeadCounter = 0;

void setupKinect() {
  kinect = new KinectPV2(this);

  kinect.enableDepthMaskImg(true);
  kinect.enableSkeletonDepthMap(true);
  kinect.enableColorImg(true);
  kinect.enableDepthImg(true);

  //for face detection based on the color Img
  kinect.enableColorImg(true);

  //for face detection base on the infrared Img
  kinect.enableInfraredImg(true);

  //enable face detection
  kinect.enableFaceDetection(true);

  kinect.init();
}

void checkNull(KJoint[] joints) {
  if (pHandLeftPos == null) pHandLeftPos = joints[KinectPV2.JointType_HandLeft].getPosition().copy();
  if (pHandRightPos == null) pHandRightPos = joints[KinectPV2.JointType_HandRight].getPosition().copy();
  if (pLegLeftPos == null) pLegLeftPos = joints[KinectPV2.JointType_KneeLeft].getPosition().copy();
  if (pLegRightPos == null) pLegRightPos = joints[KinectPV2.JointType_KneeRight].getPosition().copy();
}

void checkSignal(KJoint[] joints) {
  float leftHandDist = pHandLeftPos.dist(joints[KinectPV2.JointType_HandLeft].getPosition());
  float rihgtHandDist = pHandRightPos.dist(joints[KinectPV2.JointType_HandRight].getPosition());
  float leftLegDist = pLegLeftPos.dist(joints[KinectPV2.JointType_KneeLeft].getPosition());
  float rightLegDist = pLegRightPos.dist(joints[KinectPV2.JointType_KneeRight].getPosition());

  PVector hipPos = PVector.add(joints[KinectPV2.JointType_HipLeft].getPosition(), 
    joints[KinectPV2.JointType_HipRight].getPosition()).div(2);

  OscMessage offsetMsg = new OscMessage("/offset");

  offsetMsg.add(hipPos.x - pHipPos.x);
  offsetMsg.add(hipPos.y - pHipPos.y); 
  offsetMsg.add(hipPos.z - pHipPos.z); 
  oscP5.send(offsetMsg, myTarget);

  if (leftHandDist > 20) {
    OscMessage myMessage = new OscMessage("/wind");
    PVector handMovement = joints[KinectPV2.JointType_HandLeft].getPosition().copy().sub(pHandLeftPos);
    for (float it : handMovement.array()) {
      myMessage.add(it);
    }
    myMessage.add(leftHandDist);

    oscP5.send(myMessage, myTarget);
  }
  if (rihgtHandDist > 20) {
    OscMessage myMessage = new OscMessage("/wind");
    PVector handMovement = joints[KinectPV2.JointType_HandRight].getPosition().copy().sub(pHandRightPos);
    for (float it : handMovement.array()) {
      myMessage.add(it);
    }
    oscP5.send(myMessage, myTarget);
  }

  //if (leftLegDist > 20) {
  //  OscMessage myMessage = new OscMessage("/wind");
  //  PVector legMovement = joints[KinectPV2.JointType_KneeLeft].getPosition().copy().sub(pLegLeftPos);
  //  for (float it : legMovement.array()) {
  //    myMessage.add(it);
  //  }
  //  oscP5.send(myMessage, myTarget);
  //  //println("kneeLeft") ;
  //}
  //if (rightLegDist > 20) {
  //  OscMessage myMessage = new OscMessage("/wind");
  //  PVector legMovement = joints[KinectPV2.JointType_KneeRight].getPosition().copy().sub(pLegRightPos);
  //  for (float it : legMovement.array()) {
  //    myMessage.add(it);
  //  }
  //  oscP5.send(myMessage, myTarget);
  //  //println("kneeRight") ;
  //}
  pHandLeftPos = joints[KinectPV2.JointType_HandLeft].getPosition().copy();
  pHandRightPos = joints[KinectPV2.JointType_HandRight].getPosition().copy();
  pLegLeftPos = joints[KinectPV2.JointType_KneeLeft].getPosition().copy();
  pLegRightPos = joints[KinectPV2.JointType_KneeRight].getPosition().copy();
}

void checkFace() {
  ArrayList<FaceData> faceData =  kinect.getFaceData();
  for (int i = 0; i < faceData.size(); i++) {
    FaceData faceD = faceData.get(i);
    if (faceD.isFaceTracked()) {
      pitch = faceD.getPitch();
      yaw   = faceD.getYaw();
      roll  = faceD.getRoll();
      if(pitch!=0&&yaw!=0&&roll!=0){
      OscMessage rotationMessage = new OscMessage("/rotation");
      rotationMessage.add(pitch);
      rotationMessage.add(yaw);
      rotationMessage.add(roll);
      oscP5.send(rotationMessage, myTarget);}
      
      if (jsonState==1) {
        if (abs(pitch)> 40 || abs(yaw)>40 ||abs(roll) > 30) {
          background(255);
          newColor = new color[5];
          for (int j = 0; j < 5; j++) {
            newColor[j] = color(random(255), random(255), random(255));
          }
          OscMessage myMessage = new OscMessage("/color");
          for (int it : newColor) {
            myMessage.add(it);
          }
          oscP5.send(myMessage, myTarget);
        }
      }
    }
  }
}