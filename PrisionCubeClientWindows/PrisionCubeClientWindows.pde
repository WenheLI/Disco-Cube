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

FileWatcher file;

int countForJSON;

void setup() {
  size(1200, 600, P3D);
  background(0);

  countForJSON = -1;

  oscP5 = new OscP5(this, 12001);
  //ortho();
  setupGui();
  cols = 6;
  rows = 3;
  cellWidth = width/cols;
  cellHeight = height/rows;
  cellDepth = cellWidth;

  jsonPCs = new ArrayList();

  for (int i = 0; i < 18; i+=1) {
    jsonPCs.add(new JSONPointCloud( i%6 + ".json", i, colors));
  }

  animator = new Animator();

  //file =  new FileWatcher("C:\\Users\\mars_\\Documents\\GitHub\\PrisionCube\\PrisonCubeServer\\data");
  //file.handleEvents();
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

  if (countForJSON > 0) {
    for (int i = 0; i < jsonPCs.size(); i++) {
      jsonPCs.get(i).cellIndex += 1;
      jsonPCs.get(i).notifyChange();
      if ( jsonPCs.get(i).cellIndex>17) {
        jsonPCs.remove(i);
        i--;
      }
    }
    jsonPCs.add(new JSONPointCloud((countForJSON-1) + ".json", 0, colors));
    countForJSON = -1;
    println(jsonPCs.size());
    for (int i = 0; i < jsonPCs.size(); i++) {
      print(jsonPCs.get(i).cellIndex+" ");
    }
    println();
  }
}

PVector ZERO = new PVector(0, 0, 0);


void oscEvent(OscMessage msg) {
  //print("### received an osc message.");
  //print(" addrpattern: "+msg.addrPattern());
  //println(" typetag: "+msg.typetag());

  if (msg.addrPattern().equals("/wind")) {
    PVector force = new PVector(
      msg.get(0).floatValue(), 
      msg.get(1).floatValue(), 
      msg.get(2).floatValue()
      );
    force.div(20);
    PVector[] pvs = {force, ZERO};
    animator.setLerpFactorAcc(.3).setTargetAcc(pvs);
  } else if (msg.addrPattern().equals("/offset")) {
    PVector arrow = new PVector(
      msg.get(0).floatValue(), 
      msg.get(1).floatValue(), 
      msg.get(2).floatValue()
      ); 
    //println(arrow);
    PVector[] pvs = { arrow };
    animator.setLerpFactorAcc(.1).setTargetOffset(pvs);
  } else if (msg.addrPattern().equals("/rotation")) {
    PVector arrow = new PVector(
      radians(msg.get(0).floatValue()), 
      radians(-msg.get(1).floatValue()), 
      radians(-msg.get(2).floatValue())
      ); 
    //println(arrow);
    PVector[] pvs = { arrow, ZERO };
    animator.setLerpFactorRotation(.05).setTargetRotation(pvs);
  } else if (msg.addrPattern().equals("/color")) {
    color[] newColor = new color[5];
    for (int i = 0; i < 5; i++) {
      newColor[i] = msg.get(i).intValue();
    }
    animator.setColorPalette(newColor);
  } else if (msg.addrPattern().equals("/finish")) {
    countForJSON = msg.get(0).intValue();
  } else if (msg.addrPattern().equals("/animatorState")) {
    animator.setAnimatorState(msg.get(0).intValue());
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