
PImage data;
PGraphics model;
PGraphics errorGraph;

int numPixels;
float[] errors;
float shift = 0.;
int radius = 30;


int barWidth = 10;
int lastBar = -1;

void setup() {
  size(640, 360);
  model = createGraphics(width, height);
  model.colorMode(HSB, model.width, 100, model.width);
  model.beginDraw();

  errorGraph = createGraphics(400, 100);
  errorGraph.beginDraw();

  data = loadImage("sim_all_event_56.jpg");
  numPixels = width * height;
  data.resize(width, height);
  data.loadPixels();
  model.noStroke();
  errorGraph.noStroke();

  model.background(0);
  background(0);
  imageMode(CENTER);
  model.imageMode(CENTER);
  errorGraph.imageMode(CENTER);

//  image(img, width/2, height/2);
}

void draw(){
  if(mousePressed){
    background(0);
    int x = mouseX;
    int y = mouseY;
    int val = int((255 * (height-mouseY))/height);
    color bkg = color(val);
    print(val, "\n");
    errorGraph.beginDraw();

    model.beginDraw();

    int whichBar = mouseX / barWidth;
    int barX = whichBar * barWidth;
    model.fill(0, 0, 255*(model.height-mouseY)/model.height);
    model.rect(barX, 0, barWidth, model.height);
    lastBar = whichBar;
  
    model.endDraw();
    image(model, width/2, height/2);
    updatePixels();

    stroke(0);
    fill(255);
    rect(width - 80, height - 60, 60, 25, 7);
    fill(0);
    float error = difference(model.pixels, data.pixels);
    text(str(error), width - 75, height - 45);
    drawError(error, color(255,255,255));
  }

}


float difference(int[] pixels1, int[] pixels2){
    float scale = 5.E9;
    float movementSum = 0; // Amount of movement in the frame
    for (int i = 0; i < numPixels; i++) { // For each pixel in the video frame...
      color currColor = pixels1[i];
      color prevColor = pixels2[i];
      // Extract the red, green, and blue components from current pixel

      int currR = (currColor >> 16) & 0xFF; // Like red(), but faster
      int currG = (currColor >> 8) & 0xFF;
      int currB = currColor & 0xFF;
      // Extract red, green, and blue components from previous pixel
      int prevR = (prevColor >> 16) & 0xFF;
      int prevG = (prevColor >> 8) & 0xFF;
      int prevB = prevColor & 0xFF;
/*
      int currR = currColor.red(); // Like red(), but faster
      int currG = currColor.green();
      int currB = currColor.blue();
      // Extract red, green, and blue components from previous pixel
      int prevR = prevColor.red();
      int prevG = prevColor.green();
      int prevB = prevColor.blue();
*/
      // Compute the difference of the red, green, and blue values
      float diffR = pow(currR - prevR, 2);
      float diffG = pow(currG - prevG, 2);
      float diffB = pow(currB - prevB, 2);
      // Add these differences to the running tally
      movementSum += (diffR + diffG + diffB)/scale;
    }
  return movementSum;
}



void drawError(float error, color col) { 
  int point = 5;
  PImage img = errorGraph.get();
  errorGraph.background(0,0,0,255);
  errorGraph.image(img, errorGraph.width/2-shift, errorGraph.height/2);
  errorGraph.fill(col, 255);
  errorGraph.ellipse(errorGraph.width - 4*point, 
    errorGraph.height * (1. - error/1.) , 
    point, point);
  errorGraph.endDraw();
  image(errorGraph, 220, 300);
  shift = 0.01;
}

// Not used
void normalizeImage(int[] pixels){
  float sum = 0;
  for (int i = 0; i < numPixels; i++) {
    sum += (pixels[i] >> 16) & 0xFF;
  }

  sum /= numPixels;
  for (int i = 0; i < numPixels; i++) {
    if(sum > 0){
      int newcolor = int(((pixels[i] >> 16) & 0xFF) / sum);
      pixels[i] = color(newcolor);
    }
  }
}