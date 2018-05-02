//import codeanticode.syphon.*;
import spout.*;
import oscP5.*;
import netP5.*;

ArrayList<JSONPointCloud> jsonPCs;
Animator animator;
color[] colors = {#ff00c1, #9600ff, #4900ff, #00b8ff, #00fff9};

//SyphonServer server;
Spout spout;
int cols, rows, cellWidth, cellHeight, cellDepth;

OscP5 oscP5;

void setup() {
  size(1200, 600, P3D);
  background(0);
  oscP5 = new OscP5(this, 12001);
  //ortho();
  setupGui();
  cols = 6;
  rows = 3;
  cellWidth = width/cols;
  cellHeight = height/rows;
  cellDepth = cellWidth;

  jsonPCs = new ArrayList();

  for (int i = 17; i < 18; i+=1) {
    jsonPCs.add(new JSONPointCloud((i % 5) + ".json", i, colors));
  }

  animator = new Animator();

  //server = new SyphonServer(this, "Processing Syphon");
  spout = new Spout(this);
  spout.createSender("Spout Processing");
}

void draw() {
  background(0);
  if (mapping) background(255);

  animator.updateNext();
  for (JSONPointCloud jsonPC : jsonPCs) {
    animator.applyAmimationTo(jsonPC);
    jsonPC.updateFrame();
    jsonPC.drawParticles();
  }

  if (guiToggle) drawGui();
  lights();

  //server.sendScreen();
  spout.sendTexture();
}

PVector ZERO = new PVector(0, 0, 0);


void oscEvent(OscMessage msg) {
  print("### received an osc message.");
  print(" addrpattern: "+msg.addrPattern());
  println(" typetag: "+msg.typetag());

  if (msg.addrPattern().equals("/wind")) {
    println("hello");
    PVector force = new PVector(
      msg.get(0).floatValue(), 
      msg.get(1).floatValue(), 
      msg.get(2).floatValue()
      );
    PVector[] pvs = { force, ZERO};
    animator.setLerpFactorAcc(.3).setTargetAcc(pvs);
  } 
}


void keyPressed() {
  if (key == ' ') guiToggle = !guiToggle;

  //test velocity
  if (keyCode == UP) {
    PVector[] pvs = {new PVector(0, -1, 0), ZERO};
    animator.setLerpFactorAcc(.1).setTargetAcc(pvs);
  }
  if (keyCode == DOWN) {
    PVector[] pvs = {new PVector(0, 1, 0), ZERO};
    animator.setLerpFactorAcc(.1).setTargetAcc(pvs);
  }
  if (keyCode == LEFT) {
    PVector[] pvs = { new PVector(-1, 0, 0), ZERO};
    animator.setLerpFactorAcc(.1).setTargetAcc(pvs);
  }
  if (keyCode == RIGHT) {
    PVector[] pvs = {new PVector(1, 0, 0), ZERO};
    animator.setLerpFactorAcc(.1).setTargetAcc(pvs);
  }

  //test offset
  if (key == 'w') {
    PVector[] pvs = {new PVector(0, -50, 0), ZERO};
    animator.setLerpFactorOffset(.1).setTargetOffset(pvs);
  }
  if (key == 's') {
    PVector[] pvs = {new PVector(0, 50, 0), ZERO};
    animator.setLerpFactorOffset(.1).setTargetOffset(pvs);
  }
  if (key == 'a') {
    PVector[] pvs = {new PVector(-50, 0, 0), ZERO};
    animator.setLerpFactorOffset(.1).setTargetOffset(pvs);
  }
  if (key == 'd') {
    PVector[] pvs = {new PVector(50, 0, 0), ZERO};
    animator.setLerpFactorOffset(.1).setTargetOffset(pvs);
  }
  if (key == 'q') {
    PVector[] pvs = {new PVector(random(100)-50, random(100)-50, random(100)-50), ZERO, new PVector(random(100)-50, random(100)-50, random(100)-50), ZERO, new PVector(random(100)-50, random(100)-50, random(100)-50), ZERO, new PVector(random(100)-50, random(100)-50, random(100)-50), ZERO, new PVector(random(100)-50, random(100)-50, random(100)-50), ZERO};
    animator.setLerpFactorOffset(.6).setTargetOffset(pvs);
  }

  //test rotation
  if (key == 'i') {
    PVector[] pvs = {new PVector(radians(60), 0, 0), ZERO};
    animator.setLerpFactorRotation(.05).setTargetRotation(pvs);
  }
  if (key == 'k') {
    PVector[] pvs = {new PVector(-radians(60), 0, 0), ZERO};
    animator.setLerpFactorRotation(.1).setTargetRotation(pvs);
  }
  if (key == 'j') {
    PVector[] pvs = {new PVector(0, -radians(60), 0), ZERO};
    animator.setLerpFactorRotation(.1).setTargetRotation(pvs);
  }
  if (key == 'l') {
    PVector[] pvs = {new PVector(0, radians(60), 0), ZERO};
    animator.setLerpFactorRotation(.1).setTargetRotation(pvs);
  }
  if (key == 'p') {
    PVector[] pvs = {new PVector(random(40)-20, random(40)-20, random(40)-20), ZERO};
    animator.setLerpFactorRotation(.1).setTargetRotation(pvs);
  }

  //test color
  if (key == 'c') {
    color[] newColor = new color[5];
    for (int i = 0; i < 5; i++) {
      newColor[i] = color(random(255), random(255), random(255));
    }
    animator.setColorPalette(newColor);
  }
}