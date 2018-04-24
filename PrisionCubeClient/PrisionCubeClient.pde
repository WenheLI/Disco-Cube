ArrayList<JSONPointCloud> jsonPCs;
Animator animator;
color[] colors = {#ff00c1, #9600ff, #4900ff, #00b8ff, #00fff9};

import codeanticode.syphon.*;

SyphonServer server;
int cols, rows, cellWidth, cellHeight, cellDepth;

void setup() {
  size(1200, 600, P3D);
  background(0);
  //ortho();
  setupGui();
  cols = 6;
  rows = 3;
  cellWidth = width/cols;
  cellHeight = height/rows;
  cellDepth = cellWidth;

  jsonPCs = new ArrayList();

  for (int i = 9; i < 18; i+=18) {
    jsonPCs.add(new JSONPointCloud((i % 5) + ".json", i, colors));
  }

  animator = new Animator();

  server = new SyphonServer(this, "Processing Syphon");
}

void draw() {
  background(0);
  animator.updateNext();
  for (JSONPointCloud jsonPC : jsonPCs) {
    animator.applyAmimationTo(jsonPC);
    jsonPC.updateFrame();
    jsonPC.drawParticles();
  }
  server.sendScreen();
  if (guiToggle) drawGui();
}


void keyPressed() {

  if (key == ' ') guiToggle = !guiToggle;

  PVector ZERO = new PVector(0, 0, 0);

  //test velocity
  if (keyCode == UP) {
    PVector[] pvs = {ZERO, new PVector(0, -10, 0), ZERO};
    animator.setLerpFactorVel(.1).setTargetVel(pvs);
  }
  if (keyCode == DOWN) {
    PVector[] pvs = {ZERO, new PVector(0, 10, 0), ZERO};
    animator.setLerpFactorVel(.1).setTargetVel(pvs);
  }

  if (keyCode == LEFT) {
    PVector[] pvs = {ZERO, new PVector(-10, 0, 0), ZERO};
    animator.setLerpFactorVel(.1).setTargetVel(pvs);
  }
  if (keyCode == RIGHT) {
    PVector[] pvs = {ZERO, new PVector(10, 0, 0), ZERO};
    animator.setLerpFactorVel(.1).setTargetVel(pvs);
  }

  //test offset
  if (key == 'w') {
    PVector[] pvs = {ZERO, new PVector(0, -50, 0), ZERO};
    animator.setLerpFactorOffset(.1).setTargetOffset(pvs);
  }
  if (key == 's') {
    PVector[] pvs = {ZERO, new PVector(0, 50, 0), ZERO};
    animator.setLerpFactorOffset(.1).setTargetOffset(pvs);
  }
  if (key == 'a') {
    PVector[] pvs = {ZERO, new PVector(-50, 0, 0), ZERO};
    animator.setLerpFactorOffset(.1).setTargetOffset(pvs);
  }
  if (key == 'd') {
    PVector[] pvs = {ZERO, new PVector(50, 0, 0), ZERO};
    animator.setLerpFactorOffset(.1).setTargetOffset(pvs);
  }
  
  //test rotation
  if (key == 'i') {
    PVector[] pvs = {ZERO, new PVector(radians(60), 0, 0), ZERO};
    animator.setLerpFactorRotation(.05).setTargetRotation(pvs);
  }
  if (key == 'k') {
    PVector[] pvs = {ZERO, new PVector(-radians(60), 0, 0), ZERO};
    animator.setLerpFactorRotation(.1).setTargetRotation(pvs);
  }
  if (key == 'j') {
    PVector[] pvs = {ZERO, new PVector(0, -radians(60), 0), ZERO};
    animator.setLerpFactorRotation(.1).setTargetRotation(pvs);
  }
  if (key == 'l') {
    PVector[] pvs = {ZERO, new PVector(0, radians(60), 0), ZERO};
    animator.setLerpFactorRotation(.1).setTargetRotation(pvs);
  }
  if (key == 'p') {
    PVector[] pvs = {ZERO, new PVector(random(40)-20,random(40)-20,random(40)-20), ZERO};
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
