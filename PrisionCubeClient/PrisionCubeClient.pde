PVector blackHolePos;
ArrayList<JSONPointCloud> jsonPCs;
ArrayList<Particle> particles;
color[] colors = {#ff00c1, #9600ff, #4900ff, #00b8ff, #00fff9};
void setup() {
  size(1200, 800, P3D);
  setupPeasyCam();
  setupGui();
  jsonPCs = new ArrayList();
  jsonPCs.add(new JSONPointCloud("02.json"));
  //noSmooth();

  particles = new ArrayList();

  blackHolePos = new PVector(0, -212, 300);
}

void draw() {
  background(0);
  for (JSONPointCloud jsonPC : jsonPCs) {
    for (PVector p : jsonPC.update()) {
      p.x += offsetX;
      p.z += offsetZ;
      PVector vel = new PVector(directionX, -directionY, directionZ);
      color clr = colors[floor(random(colors.length))];
      //color clr = color(255);
      particles.add(new Particle(p, vel, clr, lifeSpan, particleSize));
    }
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

  //blackHole box
  pushMatrix();
  blackHolePos.set(0 + blackHoleX, -212 - blackHoleY, 300 + blackHoleZ);
  translate(blackHolePos.x, blackHolePos.y, blackHolePos.z);
  rotateX(radians(frameCount)*2);
  rotateY(radians(frameCount)*2);
  noFill();
  box(30);
  popMatrix();
  lights();
}

void keyPressed() {
  if (key == ' ') guiToggle = !guiToggle;
}
