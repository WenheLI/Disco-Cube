class Animator {
  private PVector[] targetOffset;
  private int currentTargetOffset;
  private PVector prevOffset;
  private PVector nextOffset;
  private float lerpFactorOffset;


  private PVector[] targetVel;
  private int currentTargetVel;
  private PVector prevVel;
  private PVector nextVel;
  private float lerpFactorVel;

  private PVector[] targetRotation;
  private int currentTargetRotation;
  private PVector prevRotation;
  private PVector nextRotation;
  private float lerpFactorRotation;

  private PVector rotationOffset; //now controled by GUI

  private color[] colorPalette = {#ff00c1, #9600ff, #4900ff, #00b8ff, #00fff9};


  Animator() {
    this.lerpFactorVel = 1f;
    this.lerpFactorOffset = 1f;
    this.currentTargetVel = 0;
    this.currentTargetOffset = 0;
    this.nextOffset = new PVector(0, 0, 0);
    this.prevOffset = new PVector(0, 0, 0);
    this.nextVel = new PVector(0, 0, 0);
    this.prevVel = new PVector(0, 0, 0); 
    this.nextRotation = new PVector(0, 0, 0);
    this.prevRotation = new PVector(0, 0, 0);
    this.rotationOffset = new PVector(0, 0, 0);
  }

  Animator setLerpFactorOffset(float lerpFactor) {
    this.lerpFactorOffset = lerpFactor;
    return this;
  }
  Animator setLerpFactorVel(float lerpFactor) {
    this.lerpFactorVel = lerpFactor;
    return this;
  }
  Animator setLerpFactorRotation(float lerpFactor) {
    this.lerpFactorRotation = lerpFactor;
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
  Animator setTargetRotation(PVector[] target) {
    this.targetRotation = target;
    this.currentTargetRotation = 0;
    return this;
  }
  Animator setColorPalette(color[] colorPalette) {
    if (colorPalette != null) this.colorPalette = colorPalette;
    return this;
  }

  void updateNextOffset() {
    if (this.targetOffset != null && this.targetOffset.length > this.currentTargetOffset) {
      PVector calOffset = PVector.lerp(prevOffset, this.targetOffset[this.currentTargetOffset], this.lerpFactorOffset);
      if (calOffset.dist(prevOffset) < .001) this.currentTargetOffset += 1;
      this.prevOffset = calOffset;
      this.nextOffset = calOffset;
    } else {
      this.prevOffset.set(0, 0, 0);
      this.nextOffset.set(0, 0, 0);
    }
  }
  void updateNextVel() {
    if (this.targetVel != null && this.targetVel.length > this.currentTargetVel) {
      PVector calVel = PVector.lerp(prevVel, this.targetVel[this.currentTargetVel], this.lerpFactorVel);
      if (calVel.dist(prevVel) < .001) this.currentTargetVel += 1;
      this.prevVel = calVel;
      this.nextVel = calVel;
    } else {
      this.prevVel.set(0, 0, 0);
      this.nextVel.set(0, 0, 0);
    }
  }
  void updateNextRotation() {
    if (this.targetRotation != null && this.targetRotation.length > this.currentTargetRotation) {
      PVector calRotation = PVector.lerp(prevRotation, this.targetRotation[this.currentTargetRotation], this.lerpFactorRotation);
      if (calRotation.dist(prevRotation) < .001) this.currentTargetRotation += 1;
      this.prevRotation = calRotation;
      this.nextRotation = calRotation;
    } else {
      this.prevRotation.set(0, 0, 0);
      this.nextRotation.set(0, 0, 0);
    }
  }
  
  //void lerpToNext(PVector[] target, int currentTarget, float lerpFactor, PVector prev, PVector next) {
  //  if (target != null && target.length > currentTarget) {
  //    PVector cal = PVector.lerp(prev, target[currentTarget], lerpFactor);
  //    if (cal.dist(prev) < .001) currentTarget += 1;
  //    prev = cal;
  //    next = cal;
  //  } else {
  //    prev.set(0, 0, 0);
  //    next.set(0, 0, 0);
  //  }
  //}

  void updateNext() {
    //the line below bu work
    //this.lerpToNext(this.targetOffset, this.currentTargetOffset, this.lerpFactorOffset, this.prevOffset, this.nextOffset);
    
    this.updateNextOffset();
    this.updateNextVel();
    this.updateNextRotation();
    this.rotationOffset.set(rotationX, rotationY, 0);  //rotationX and rotationY are global variable controled by GUI
  }

  void applyAmimationTo(JSONPointCloud jsonPC) {
    jsonPC.setOffset(this.nextOffset);
    jsonPC.setVel(this.nextVel);
    jsonPC.setColorPalette(this.colorPalette);
    jsonPC.setRotation(nextRotation.copy().add(rotationOffset)); //rotationX and rotationY are global variable controled by GUI
  }
} 
