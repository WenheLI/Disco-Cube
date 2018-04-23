class JSONPointCloud {
  String address;
  int jsonLength;
  JSONObject json;
  ArrayList<PVector> pointsInFrame;
  int currentFrame;
 

  JSONPointCloud(String address_) {
    address = address_;
    json = loadJSONObject(address);
    jsonLength = json.getInt("length");
    pointsInFrame = new ArrayList();
    
    currentFrame = 0;
  
  }

  ArrayList<PVector> update() {
    pointsInFrame.clear();
    int[] currentArray = json.getJSONArray(""+currentFrame).getIntArray();
    for (int i = floor(random(resolution))*3; i < currentArray.length; i+=3*((resolution)+floor(random(resolution)))) {
      PVector point = new PVector(currentArray[i], currentArray[i+1], currentArray[i+2]);
      pointsInFrame.add(point);
    }
    if (play) currentFrame = (currentFrame + playBackSpeed) % jsonLength;
    return pointsInFrame;
  }
}
