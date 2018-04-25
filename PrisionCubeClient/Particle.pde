class Particle {
  private PVector pos, vel, acc;
  private color clr;
  private int size;

  private int lifeSpan, life = 0;
  private boolean isDead;

  Particle(PVector pos, PVector vel, PVector acc, color clr, int lifeSpan, int size) {
    this.pos = pos;
    this.vel = vel.copy();
    this.acc = acc.copy();
    this.clr = clr;
    this.lifeSpan = lifeSpan;
    this.life = 0;
    this.size = size;
  }

  void update() {
    this.vel.add(this.acc);
    //println(this.vel, this.acc);
    this.pos.add(this.vel);
    this.life++;
    this.isDead = (this.life > this.lifeSpan);
    
  }

  void display() {
    if (displayPoint) this.displayPoint();
    else this.displayBox();
  }

  void displayPoint() {
    //pushStyle();
    stroke(this.clr,map(this.life, 0, this.lifeSpan, 255, 150));
    //strokeWeight(size);
    point(this.pos.x, this.pos.y, this.pos.z);
    //popStyle();
  }

  void displayBox() {
    pushStyle();
    pushMatrix();
    translate(this.pos.x, this.pos.y, this.pos.z);
    rotateX(radians(frameCount)*2);
    rotateY(radians(frameCount)*2);
    fill(this.clr, map(this.life, 0, this.lifeSpan, 255, 150));
    noStroke();
    box(map(this.life, 0, this.lifeSpan, this.size, 1));
    popStyle();
    popMatrix();
  }
}
