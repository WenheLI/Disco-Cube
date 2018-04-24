//class Animator {
//  private ArrayList<JSONPointCloud> jsonPCs;
//  private int flag;
//  private int attitude;
//  private int force;
//  private PVector[] target;
//  private color[] colorPalette;

//  Animator(ArrayList<JSONPointCloud> jsonPCs) {
//    this.jsonPCs = jsonPCs;
//  }

//  Animator(ArrayList<JSONPointCloud> jsonPCs, int flag) {
//    this.jsonPCs = jsonPCs; 
//    this.flag = flag;
//  }

//  Animator setAnimation(int flag) {
//    this.flag = flag;
//    return this;
//  }

//  Animator setTargets(PVector[] target) {
//    this.target = target;
//    return this;
//  }

//  Animator setcolorPalette(color[] colorPalette) {
//    this.colorPalette = colorPalette;
//    return this;
//  }

//  //flag 0
//  void normalAnima() {
//    if (particles.get(0).vel.mag() == 0) return;
//    for (Particle p : particles) {
//       p.vel.set(0, 0); 
//    }
//  }

//  //flag 1
//  void windAnima() {
    
//  }

//  //flag 2
//  void upAndDownAnima(int attitude, int force) {
//  }


//  void changeColorAnima(color[] colorPalette) {
    
//  }

//  void play() {
//    if (this.flag >0) {
//      switch (flag) {
//      }
//    }
//  }
//}
