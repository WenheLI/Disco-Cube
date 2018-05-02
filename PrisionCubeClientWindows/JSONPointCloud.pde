class JSONPointCloud {
  private ArrayList<Particle> particles;

  private String address;
  private int jsonLength;
  private JSONObject json;
  private int [] rangeX, rangeY, rangeZ;
  private int currentFrame;

  private int cellIndex, colIndex, rowIndex;


  private color[] colorPalette;
  private PVector vel, acc, offset, rotation;

  JSONPointCloud(String address, int cellIndex, color[] colorPalette) {
    this.address = address;
    this.json = loadJSONObject(address);
    this.jsonLength = json.getInt("length");
    this.currentFrame = 0;
    this.rangeX = json.getJSONArray("rangeX").getIntArray();
    this.rangeY = json.getJSONArray("rangeY").getIntArray();
    this.rangeZ = json.getJSONArray("rangeZ").getIntArray();

    this.cellIndex = cellIndex;
    this.colIndex = cellIndex % cols;
    this.rowIndex = floor(cellIndex / cols);

    this.particles = new ArrayList();
    this.colorPalette = colorPalette;
    this.vel = new PVector(0, 0, 0);
    this.acc = new PVector(0, 0, 0);
    this.offset = new PVector(0, 0, 0);
    this.rotation = new PVector(0, 0, 0);
  }

  void updateFrame() {
    int[] currentArray = json.getJSONArray(""+this.currentFrame).getIntArray();
    for (int i = floor(random(resolution))*3; i < currentArray.length; i+=3*((resolution)+floor(random(resolution)))) {
      float x = map(currentArray[i], rangeX[0], rangeX[1], -cellWidth/2*0.9, cellWidth/2*0.9);
      float y = map(currentArray[i+1], rangeY[0], rangeY[1], -cellHeight/2*0.9, cellHeight/2*0.9);
      float z = map(currentArray[i+2], rangeZ[0], rangeZ[1], -cellDepth/6, cellDepth/6);
      PVector point = new PVector(x, y, z).add(PVector.random3D().mult(2));
      this.addParticle(point);
    }
    //println(this.vel, this.acc);
    this.currentFrame = (this.currentFrame + playBackSpeed) % this.jsonLength;
  }

  private void addParticle(PVector point) {
    color clr = this.colorPalette[floor(random(this.colorPalette.length))];
    point.add(this.offset);
    this.particles.add(new Particle(point, this.vel, this.acc, clr, lifeSpan, particleSize));
  }

  void drawParticles() {

    pushMatrix();
    translate(colIndex*cellWidth + cellWidth/2, rowIndex*cellHeight + cellHeight/2, -cellDepth/2);
    rotateX(rotation.x);
    rotateY(rotation.y);
    rotateZ(rotation.z); 

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

  void setOffset(PVector offset) {
    this.offset.set(offset);
  }
  void setVel(PVector vel) {
    this.vel.set(vel);
  }
  void setAcc(PVector acc) {
    this.acc.set(acc);
  }
  void setRotation(PVector rotation) {
    this.rotation.set(rotation);
  }
  void setColorPalette(color[] colorPalette) {
    this.colorPalette = colorPalette;
  }
}