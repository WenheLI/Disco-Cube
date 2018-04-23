class Animator {
  private ArrayList<Particle> particles;
  private int flag;
  
  Animator(ArrayList<Particle> particles) {
     this.particles = particles; 
  }
  
  Animator(ArrayList<Particle> particles, int flag) {
     this.particles = particles; 
     this.flag = flag;
  }
  
  void setAnimation(int flag) {
    this.flag = flag;
  }
  
  void play() {
     if (this.flag >0) {
       switch (flag) {
         
       }
     }
  }
  
}
