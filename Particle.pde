class Particle {
  PVector pos;
  PVector vel;
  color clr;
  int size;

  int lifeSpan;
  int life = 0;
  boolean isDead;

  Particle(PVector pos_, PVector vel_, color clr_, int lifeSpan_, int size_) {
    pos = pos_;
    vel = vel_;
    vel.add(blackHolePos.copy().sub(pos).normalize().mult(blackHoleSpeed));

    clr = clr_;
    lifeSpan = lifeSpan_;
    size = size_;
  }

  void update() {
    pos.add(vel.copy().add(blackHolePos.copy().sub(pos).normalize().mult(blackHoleSpeed)));
    life++;
    isDead = (life > lifeSpan);
  }

  void display() {
    if (displayPoint) displayPoint();
    else displayBox();
  }
  
  void displayPoint() {
    //pushStyle();
    stroke(clr);
    //strokeWeight(size);
    point(pos.x, pos.y, pos.z);
    //popStyle();
  }
  
  void displayBox() {
    pushStyle();
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    rotateX(radians(frameCount)*2);
    rotateY(radians(frameCount)*2);
    fill(clr, map(life, 0, lifeSpan, 255, 0));
    noStroke();
    box(map(life, 0, lifeSpan, size, 1));
    popStyle();
    popMatrix();
  }
}
