ArrayList<JSONPointCloud> jsonPCs;
ArrayList<Particle> particles;
color[] colors = {#ff00c1, #9600ff, #4900ff, #00b8ff, #00fff9};

int cols, rows, cellWidth, cellHeight;

void setup() {
  size(1200, 600, P3D);
  cols = 6;
  rows = 3;
  cellWidth = width/cols;
  cellHeight = height/rows;

  ortho();
  setupGui();
  jsonPCs = new ArrayList();
  
  particles = new ArrayList();
  
  for (int i = 0; i < 18; i+=1) {
    jsonPCs.add(new JSONPointCloud("02.json", i, particles, colors));
  }
  
}

void draw() {
  background(0);
  //PVector nextVel = Animator.nextVel();
  for (JSONPointCloud jsonPC : jsonPCs) {
    //jsonPC.setVelocity(nextVel);
    jsonPC.updateFrame();
    jsonPC.addFrameParticle();
  }

  drawParticles();
  if (guiToggle) drawGui();
}

void drawParticles() {
  strokeWeight(particleSize);
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
