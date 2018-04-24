ArrayList<JSONPointCloud> jsonPCs;
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
  server = new SyphonServer(this, "Processing Syphon");
}

void draw() {
  background(0);
  //PVector nextVel = Animator.nextVel();
  for (JSONPointCloud jsonPC : jsonPCs) {
    //jsonPC.setVelocity(nextVel);
    jsonPC.updateFrame();
    jsonPC.addFrameParticles();
    jsonPC.drawParticles();
  }

  server.sendScreen();
  if (guiToggle) drawGui();
}


void keyPressed() {
  if (key == ' ') guiToggle = !guiToggle;
}
