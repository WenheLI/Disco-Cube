

void drawParticles() {
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

void drawBlackHole() {
  //blackHole box
  pushMatrix();
  blackHolePos.set(0 + blackHoleX, -212 - blackHoleY, 300 + blackHoleZ);
  translate(blackHolePos.x, blackHolePos.y, blackHolePos.z);
  rotateX(radians(frameCount)*2);
  rotateY(radians(frameCount)*2);
  fill(128);
  box(30);
  popMatrix();
}
