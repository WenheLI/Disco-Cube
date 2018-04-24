class Animator {
  private ArrayList<JSONPointCloud> jsonPCs;

  private PVector offset;
  private PVector[] targetVel;
  private color[] colorPalette = {#ff00c1, #9600ff, #4900ff, #00b8ff, #00fff9};
  private float duration;

  private int currentTarget;

  Animator(ArrayList<JSONPointCloud> jsonPCs) {
    this.jsonPCs = jsonPCs;
    this.duration = 1f;
    this.currentTarget = 0;
    this.offset = new PVector(0, 0, 0);
  }

  Animator setDuration(float duration) {
    this.duration = duration;
    return this;
  }

  Animator setTargetVels(PVector[] target) {
    this.targetVel = target;
    this.currentTarget = 0;
    return this;
  }

  Animator setcolorPalette(color[] colorPalette) {
    if (colorPalette != null) this.colorPalette = colorPalette;
    return this;
  }
  
  Animator setOffset(PVector offset) {
    if (colorPalette != null) this.offset = offset;
    return this;
  }

  PVector applyForce() {
    if (this.targetVel != null && this.targetVel.length > this.currentTarget) {
      PVector pvel = this.jsonPCs.get(0).vel;
      PVector calVel = PVector.lerp(pvel, this.targetVel[this.currentTarget], this.duration);
      println(calVel.dist(pvel));
      if (calVel.dist(pvel) < .01) this.currentTarget += 1;
      return calVel;
    }
    return new PVector(0, 0, 0);
  }

  void changeOffset() {
    println(this.offset);
    for (JSONPointCloud pc : jsonPCs) {
      pc.setPosOffset(this.offset);
    }
  }

  void changeColorAnima() {
    for (JSONPointCloud pc : jsonPCs) {
      pc.setColorPalette(this.colorPalette);
    }
  }
} 
