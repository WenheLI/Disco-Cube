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

  private PVector[] targetAcc;
  private int currentTargetAcc;
  private PVector prevAcc;
  private PVector nextAcc;
  private float lerpFactorAcc;

  private PVector[] targetRotation;
  private int currentTargetRotation;
  private PVector prevRotation;
  private PVector nextRotation;
  private float lerpFactorRotation;

  private PVector rotationOffset; //now controled by GUI
  
  float xoff = 0.1;
  float yoff = 0.213;
  float step = 0.01;

  private color[] colorPalette = {#ff00c1, #9600ff, #4900ff, #00b8ff, #00fff9};


  Animator() {
    this.lerpFactorOffset = 1f;
    this.lerpFactorAcc = 1f;
    this.lerpFactorVel = 1f;
    this.lerpFactorRotation = 1f;
    
    this.currentTargetOffset = 0;
    this.currentTargetAcc = 0;
    this.currentTargetVel = 0;
    this.currentTargetRotation = 0;
    
    this.nextOffset = new PVector(0, 0, 0);
    this.prevOffset = new PVector(0, 0, 0);
    this.nextVel = new PVector(0, 0, 0);
    this.prevVel = new PVector(0, 0, 0);
    this.nextAcc = new PVector(0, 0, 0);
    this.prevAcc = new PVector(0, 0, 0); 
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
  Animator setLerpFactorAcc(float lerpFactor) {
    this.lerpFactorAcc = lerpFactor;
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
  Animator setTargetAcc(PVector[] target) {
    this.targetAcc = target;
    this.currentTargetAcc = 0;
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
  void updateNextAcc() {
    if (this.targetAcc != null && this.targetAcc.length > this.currentTargetAcc) {
      PVector calAcc = PVector.lerp(prevAcc, this.targetAcc[this.currentTargetAcc], this.lerpFactorAcc);
      if (calAcc.dist(prevAcc) < .001) this.currentTargetAcc += 1;
      this.prevAcc = calAcc;
      this.nextAcc = calAcc;
    } else {
      this.prevAcc.set(0, 0, 0);
      this.nextAcc.set(0, 0, 0);
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
    this.updateNextAcc();
    this.updateNextRotation();
    
    this.rotationOffset.set(map(noise(xoff),0,1,-PI/3,PI/3), map(noise(yoff),0,1,-PI/3,PI/3), 0);  //rotationX and rotationY are global variable controled by GUI
    xoff+=step;
    yoff+=step;
}

  void applyAmimationTo(JSONPointCloud jsonPC) {
    jsonPC.setOffset(this.nextOffset);
    jsonPC.setVel(this.nextVel);
    jsonPC.setAcc(this.nextAcc);
    jsonPC.setColorPalette(this.colorPalette);
    jsonPC.setRotation(nextRotation.copy().add(rotationOffset)); //rotationX and rotationY are global variable controled by GUI
  }
} 
