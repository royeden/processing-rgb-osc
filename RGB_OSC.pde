import processing.video.*;
import oscP5.*;
import netP5.*;

int resolution = 1; // Adjust resolution (the higher the number, the less resolution there is)
PImage pixels;
Capture video;

OscP5 oscP5;
NetAddress location;

float r, g, b;

void setup() {
  String[] cameras = Capture.list();
  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
  fullScreen();
  
  video = new Capture(this, width / resolution, height / resolution, cameras[1]);
  
  video.start();
  
  oscP5 = new OscP5(this, 3001);
  location = new NetAddress("127.0.0.1", 3000);
}

void draw() {
  r = g = b = 0;
  background(0);
  scale(resolution);
  translate(video.width,0);
  scale(-1, 1);  
  image(video, 0, 0);
  
  for (int i = 0; i < video.width * video.height; i++) {
    r += video.pixels[i] >> 16 & 0xFF;
    g += video.pixels[i] >> 8 & 0xFF;
    b += video.pixels[i] & 0xFF;
  }
  r /= video.width * video.height;
  g /= video.width * video.height;
  b /= video.width * video.height;
  r = map(r, 0, 255, 0, 1);
  g = map(g, 0, 255, 0, 1);
  b = map(b, 0, 255, 0, 1);
  println('r', r, 'g', g, 'b', b);
  
  OscMessage route = new OscMessage("/rgb");
  route.add(new float[] {r, g, b});
  oscP5.send(route, location);
}

void captureEvent(Capture c) {
  c.read();
}
