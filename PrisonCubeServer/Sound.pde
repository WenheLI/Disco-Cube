import processing.sound.*;

PVector ZERO = new PVector(0, 5, 0);
SoundFile song;

FFT fft;
int bands = 512;

int rangeX = 2000;
int rangeY = 1000;

void soundSetup() {
  song = new SoundFile(this, "test.wav");
  song.loop();

  fft = new FFT(this, bands);
  fft.input(song);
}


void addSoundParticle() {
  if (frameCount>100) {
    fft.analyze();
    //println(fft.size());
    float [] rangeR = {random(300, 350), random(500, 1000)};
    for (int i = 0; i < bands/2; i++) {
      PVector ampPos = new PVector(0, 0, 0);
      float r = map(fft.spectrum[i]*10, 0, 1, rangeR[0], rangeR[1]);
      float radians = radians(map(i, 0, bands/2, 0, 180)+frameCount*2);
      ampPos.x = r * cos(radians);

      ampPos.y = r * sin(radians);
      ampPos.z = 0;
      
      if (jsonState==1) {
        ampPos.x+=200*cos(radians(frameCount*5));
        ampPos.z += 500*sin(radians(frameCount*5));
      }

      PVector vel = ampPos.copy().normalize().mult(random(0, ampPos.mag())/10);
      color clr = newColor[(int)random(newColor.length)];
      particles.add(new Particle(ampPos.copy().add(width/2 + offsetX, height/2, -500 + offsetZ), vel, clr, 10, 3));
      ampPos.x *= -1;
      ampPos.y *= -1;
      vel = ampPos.copy().normalize().mult(random(0, ampPos.mag())/10);
      particles.add(new Particle(ampPos.copy().add(width/2 + offsetX, height/2, -500 + offsetZ), vel, clr, 10, 3));
    }
  }
}