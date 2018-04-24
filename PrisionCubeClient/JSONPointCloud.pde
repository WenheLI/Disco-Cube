class JSONPointCloud {
  ArrayList<PVector> pointsInFrame;
  ArrayList<Particle> particles;
  String address;
  int jsonLength;
  JSONObject json;

  color[] colorPalette;
  int currentFrame;
  int [] rangeX, rangeY, rangeZ;

  PVector vel;

  int cellIndex, colIndex, rowIndex;

  JSONPointCloud(String address_, int cellIndex_, color[] colorPalette_) {
    address = address_;
    json = loadJSONObject(address);
    jsonLength = json.getInt("length");
    pointsInFrame = new ArrayList();
    currentFrame = 0;
    rangeX = json.getJSONArray("rangeX").getIntArray();
    rangeY = json.getJSONArray("rangeY").getIntArray();
    rangeZ = json.getJSONArray("rangeZ").getIntArray();

    cellIndex = cellIndex_;
    colIndex = cellIndex % cols;
    rowIndex = floor(cellIndex / cols);

    particles = new ArrayList();
    colorPalette = colorPalette_;
    vel = new PVector(0, 0, 0);
  }

  void updateFrame() {
    this.pointsInFrame.clear();
    int[] currentArray = json.getJSONArray(""+this.currentFrame).getIntArray();
    for (int i = floor(random(resolution))*3; i < currentArray.length; i+=3*((resolution)+floor(random(resolution)))) {
      float x = map(currentArray[i], rangeX[0], rangeX[1], -cellWidth/2*0.9, cellWidth/2*0.9);
      float y = map(currentArray[i+1], rangeY[0], rangeY[1], -cellHeight/2*0.9, cellHeight/2*0.9);
      float z = map(currentArray[i+2], rangeZ[0], rangeZ[1], -cellDepth/6, cellDepth/6);
      PVector point = new PVector(x, y, z);
      this.pointsInFrame.add(point);
    }
    if (play) this.currentFrame = (this.currentFrame + playBackSpeed) % this.jsonLength;
  }

  void addFrameParticles() {
    for (PVector p : pointsInFrame) {
      color clr = this.colorPalette[floor(random(colorPalette.length))];
      this.particles.add(new Particle(p, vel, clr, lifeSpan, particleSize));
    }
  }

  void drawParticles() {
    pushMatrix();
    translate(colIndex*cellWidth + cellWidth/2, rowIndex*cellHeight + cellHeight/2, -cellDepth/2);
    rotateX(rotationX);
    rotateY(radians(frameCount));
    
    noFill();
    //stroke(colorPalette[2]);
    strokeWeight(2);
    box(cellWidth*0.9);
    strokeWeight(particleSize);
    for (int i = 0; i < this.particles.size(); i++) {
      Particle p = this.particles.get(i);
      p.display();
      p.update();
      if (p.isDead) {
        this.particles.remove(p);
        i--;
      }
    }
    popMatrix();
  }
  
  void setPosOffset(PVector offset){
    for (PVector p : pointsInFrame) {
      println(p);
      p = p.add(offset);
      println(p);
    }
  }
  void setVelocity(PVector vel_) {
    this.vel.set(vel_);
  }
  void setColorPalette(color[] colorPalette_) {
    this.colorPalette = colorPalette_;
  }
}
