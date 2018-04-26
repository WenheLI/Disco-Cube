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
