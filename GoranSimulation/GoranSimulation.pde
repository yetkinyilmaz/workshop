static int unit = 10;
static int maxBg = 32;

void setup() {
  size(500, 500, P3D);
  noStroke();
  frameRate(1);
}

void draw() {
  background(0);
  int w = width / unit;
  int h = height / unit;
  for (int y = 0; y < h; y++){
    for (int x = 0; x < w; x++){
      fill(random(maxBg) * sin(x * PI / w));
      // println(x, width);
      rect(x * unit, y * unit, unit, unit);
    }
  }

  // make clusters
  int num = 2 + (random(100) < 10 ? 1 : 0);

  for (int i = 0; i < num; i++) {
    int x = (int) random(w);
    int y = (int) random(h);
    // center
    fill(i == 0 ? 255 : random(64) + 64);
    rect(x * unit, y * unit, unit, unit);
    // around
    int d = (int) random(5);
    fill(255, 32);
    for (int j = 0; j < d; j++) {
      int xd = x + ((int) random(3) - 1);
      int yd = y + ((int) random(3) - 1);
      println(xd, yd);
      rect(xd * unit, yd * unit, unit, unit);
    }
  }
}