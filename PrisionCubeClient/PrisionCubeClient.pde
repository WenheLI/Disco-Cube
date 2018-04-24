ArrayList<JSONPointCloud> jsonPCs;
Animator animator;
color[] colors = {#ff00c1, #9600ff, #4900ff, #00b8ff, #00fff9};

import codeanticode.syphon.*;

SyphonServer server;
int cols, rows, cellWidth, cellHeight, cellDepth;

void setup() {
  size(1200, 600, P3D);
  cols = 6;
  rows = 3;
  cellWidth = width/cols;
  cellHeight = height/rows;
  cellDepth = cellWidth;

  ortho();
  setupGui();
  jsonPCs = new ArrayList();


  for (int i = 0; i < 18; i+=1) {
    jsonPCs.add(new JSONPointCloud((i % 5) + ".json", i, colors));
  }

  animator = new Animator(jsonPCs);

  server = new SyphonServer(this, "Processing Syphon");
}

void draw() {
  background(0);
  PVector nextVel = animator.applyForce();
  for (JSONPointCloud jsonPC : jsonPCs) {
    jsonPC.setVelocity(nextVel);
    jsonPC.updateFrame();
    jsonPC.addFrameParticles();
    jsonPC.drawParticles();
  }

  server.sendScreen();
  if (guiToggle) drawGui();
}


void keyPressed() {
  if (key == ' ') guiToggle = !guiToggle;

  if (keyCode == UP) {
    PVector[] pvs = {new PVector(0, 0, 0),new PVector(0, -10, 0), new PVector(0, 0, 0)};
    animator.setDuration(.1).setTargetVels(pvs);
  }

  if (keyCode == DOWN) {
    PVector[] pvs = {new PVector(0, 10, 0)};
    animator.setDuration(.1).setTargetVels(pvs);
  }
  
  if (keyCode == LEFT) {
    PVector[] pvs = {new PVector(10, 0, 0)};
    animator.setDuration(.1).setTargetVels(pvs);
  }
  if (keyCode == RIGHT) {
    PVector[] pvs = {new PVector(-10, 0, 0)};
    animator.setDuration(.1).setTargetVels(pvs);
  }
  
  if (key == 'w') {
    println('w');
     animator.setOffset(new PVector(0, 100, 0)).changeOffset(); 
  }
  
  if (key == 's') {
     animator.setOffset(new PVector(0, -1, 0)).changeOffset(); 
  }
  
  if (key == 'd') {
     animator.setOffset(new PVector(1, 0, 0)).changeOffset(); 
  }
  
  if (key == 'a') {
     animator.setOffset(new PVector(-1, 0, 0)).changeOffset(); 
  }
  
  if (key == 'c') {
    color[] newColor = new color[5];
    for (int i = 0; i < 5; i++) {
       newColor[i] = color(random(255), random(255), random(255)); 
    }
     animator.setcolorPalette(newColor).changeColorAnima();
  }
}
