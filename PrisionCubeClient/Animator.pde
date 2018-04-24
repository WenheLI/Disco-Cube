class Animator {
  private ArrayList<JSONPointCloud> jsonPCs;

  private PVector[] targetOffset;
  private int currentTargetOffset;
  private PVector nextOffset;
  private float offsetLerpFactor;

  private PVector[] targetVel;
  private int currentTargetVel;
  private PVector nextVel;
  private float velLerpFactor;

  private color[] colorPalette = {#ff00c1, #9600ff, #4900ff, #00b8ff, #00fff9};


  Animator(ArrayList<JSONPointCloud> jsonPCs) {
    this.jsonPCs = jsonPCs;
    this.velLerpFactor = 1f;
    this.offsetLerpFactor = 1f;
    this.currentTargetVel = 0;
    this.currentTargetOffset = 0;
    this.nextOffset = new PVector(0, 0, 0);
    this.nextVel = new PVector(0, 0, 0);
  }

  Animator setOffsetLerpFactor(float lerpFactor) {
    this.offsetLerpFactor = lerpFactor;
    return this;
  }

  Animator setVelLerpFactor(float lerpFactor) {
    this.velLerpFactor = lerpFactor;
    return this;
  }

  Animator setTargetOffset(PVector[] target) {
    this.targetOffset = target;
    this.currentTargetOffset = 0;
    return this;
  }

  Animator setTargetVel(PVector[] target) {
    this.targetVel = target;
    this.currentTargetVel = 0;
    return this;
  }

  Animator setColorPalette(color[] colorPalette) {
    if (colorPalette != null) this.colorPalette = colorPalette;
    return this;
  }

  void updateNextOffset() {
    if (this.targetOffset != null && this.targetOffset.length > this.currentTargetOffset) {
      PVector prevOffset = this.jsonPCs.get(0).getOffset();
      PVector calOffset = PVector.lerp(prevOffset, this.targetOffset[this.currentTargetOffset], this.offsetLerpFactor);
      //println(calOffset.dist(prevOffset));
      if (calOffset.dist(prevOffset) < .01) this.currentTargetOffset += 1;
      this.nextOffset =  calOffset;
    } else this.nextOffset.set(0, 0, 0);
  }

  void updateNextVel() {
    if (this.targetVel != null && this.targetVel.length > this.currentTargetVel) {
      PVector prevVel = this.jsonPCs.get(0).getVel();
      PVector calVel = PVector.lerp(prevVel, this.targetVel[this.currentTargetVel], this.velLerpFactor);
      //println(calVel.dist(prevVel));
      if (calVel.dist(prevVel) < .01) this.currentTargetVel += 1;
      //println(prevVel, calVel, frameCount);
      this.nextVel = calVel;
    } else this.nextVel.set(0, 0, 0);
  }

  void updateNext() {
    this.updateNextOffset();
    this.updateNextVel();
  }

  void applyAmimationTo(JSONPointCloud jsonPC) {
    jsonPC.setOffset(this.nextOffset);
    jsonPC.setVel(this.nextVel);
    jsonPC.setColorPalette(this.colorPalette);
  }
} 
