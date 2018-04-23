class JSONPointCloud {
  ArrayList<PVector> pointsInFrame;
  ArrayList<Particle> particles;
  String address;
  int jsonLength;
  JSONObject json;

  color[] colorPalette;
  int currentFrame;
  int [] rangeX, rangeY;

  PVector vel;

  int cellIndex, colIndex, rowIndex;

  JSONPointCloud(String address_, int cellIndex_, ArrayList particles_, color[] colorPalette_) {
    address = address_;
    json = loadJSONObject(address);
    jsonLength = json.getInt("length");
    pointsInFrame = new ArrayList();
    currentFrame = 0;
    rangeX = json.getJSONArray("rangeX").getIntArray();
    rangeY = json.getJSONArray("rangeY").getIntArray();

    cellIndex = cellIndex_;
    colIndex = cellIndex % cols;
    rowIndex = floor(cellIndex / cols);

    particles = particles_;
    colorPalette = colorPalette_;
    vel = new PVector(0, 0, 0);
  }

  void updateFrame() {
    pointsInFrame.clear();
    int[] currentArray = json.getJSONArray(""+currentFrame).getIntArray();
    for (int i = floor(random(resolution))*3; i < currentArray.length; i+=3*((resolution)+floor(random(resolution)))) {
      float x = map(currentArray[i], rangeX[0], rangeX[1], colIndex*cellWidth, (colIndex+1)*cellWidth);
      float y = map(currentArray[i+1], rangeY[0], rangeY[1], rowIndex*cellHeight, (rowIndex+1)*cellHeight);
      PVector point = new PVector(x, y, currentArray[i+2]);
      pointsInFrame.add(point);
    }
    if (play) currentFrame = (currentFrame + playBackSpeed) % jsonLength;
  }

  void addFrameParticle() {
    for (PVector p : pointsInFrame) {
      color clr = colorPalette[floor(random(colorPalette.length))];
      //color clr = color(255);
      particles.add(new Particle(p, vel, clr, lifeSpan, particleSize));
    }
  }

  void setVelocity(PVector vel_) {
    vel.set(vel_);
  }
  void setColorPalette(color[] colorPalette_){
    colorPalette = colorPalette_;
  }
}
