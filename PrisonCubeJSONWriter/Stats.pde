PVector sumPoint = new PVector(0, 0, 0);
float numOfPoints;
PVector closestPoint;
PVector farthestPoint;
PVector averagePoint = new PVector(0, 0, 0);

void resetStats() {
  sumPoint.set(0, 0, 0);
  closestPoint = new PVector(0, 0, -1000);
  farthestPoint = new PVector(0, 0, 1000);
  numOfPoints = 0;
}

void processStats() {
  if (numOfPoints!=0) {
    //averagePoint = sumPoint.div(numOfPoints);

    //if (displayStats) {
    //  drawFrameAtDepth(averagePoint.z);
    //  drawBoxAtPos(averagePoint, color(0, 255, 0));
    //  drawBoxAtPos(closestPoint, color(255, 0, 0));
    //}
    //if (displayClosestPoint) {
    //PVector vel = new PVector(directionX, -directionY, directionZ);
    //particles.add(new Particle(closestPoint, vel, color(random(255), random(255), random(255)), 10, (int)random(10, 30)));
    //}
  }
}

void drawFrameAtDepth(float depth) {
  pushStyle();
  beginShape();
  noFill();
  stroke(255);
  strokeWeight(5);
  vertex(-256, -212, depth);
  vertex(-256, 212, depth);
  vertex(256, 212, depth);
  vertex(256, -212, depth);
  vertex(-256, -212, depth);
  endShape();
  popStyle();

  ////draw contours
  //contours = opencv.findContours();
  //pushStyle();
  //stroke(255, 0, 0);
  //noFill();
  //for (Contour c : contours) {
  //  beginShape();
  //  for (PVector point : c.getPoints()) {
  //    vertex(point.x-256, point.y-212, depth);
  //  }
  //  endShape();
  //}
  //popStyle();
}

void drawBoxAtPos(PVector pos, color clr) {
  pushMatrix();
  translate(pos.x, pos.y, pos.z);
  rotateX(radians(frameCount)*2);
  rotateY(radians(frameCount)*2);
  fill(clr);
  box(30);
  popMatrix();
}
