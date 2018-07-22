/**
 * Based on Pointillism by Daniel Shiffman. 
 * 
 * Mouse horizontal location controls size of dots. 
 * As mouse is clicked, it reates a simple pointillist 
 * effect using ellipses colored
 * according to pixels in an image. 
 *
 * The purpose is to visualise how the image converges
 * to the input with different rates as the size (resolution)
 * is varied.
 */

PImage data;
PGraphics model;
PGraphics errorGraph;

int smallPoint, largePoint;
int numPixels;
float[] errors;
float shift = 0.;

void setup() {
  size(640, 360);
  model = createGraphics(width, height);
  model.beginDraw();

  errorGraph = createGraphics(400, 100);
  errorGraph.beginDraw();

  data = loadImage("moonwalk.jpg");
  numPixels = width * height;
  data.resize(width, height);
  data.loadPixels();
  smallPoint = 2;
  largePoint = 100;
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
    float pointillize = map(mouseX, 0, width, smallPoint, largePoint);
    int x = int(random(data.width));
    int y = int(random(data.height));
    color pix = data.get(x, y);
    errorGraph.beginDraw();
  
    model.beginDraw();
    model.fill(pix, 128);
    model.ellipse(x, y, pointillize, pointillize);
    model.endDraw();
    
    image(model, width/2, height/2);
    updatePixels();
  
  
    stroke(0);
    fill(255);
    rect(width - 80, height - 60, 60, 25, 7);
    fill(0);
    float error = difference(model.pixels, data.pixels);
    print(error, "\n");
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