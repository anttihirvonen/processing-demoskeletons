/*
 * This is basecode for 2D demo development.
 * TODO: write doc
 */
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

// All these you can change!
// If you want to change the screen size, modify these,
// but keep width > height so my buggy scaling code works :P
int CANVAS_WIDTH = 800;
int CANVAS_HEIGHT = 600;

// You can skip backwards/forwards in you demo by using the 
// arrow keys; this controls how many milliseconds you skip
// at one push.
int SONG_SKIP_MILLISECONDS = 2000;

// Don't change
float ASPECT_RATIO = (float)CANVAS_WIDTH/CANVAS_HEIGHT;

// Audio
Minim minim;
AudioPlayer song;

// Syncdata
int[] exampleSync = {};

/*
 * Sets up audio playing: call this last in setup()
 * so that the song doesn't start to play too early
 */
void setupAudio() {
  minim = new Minim(this);
  song = minim.loadFile("soundtrack.mp3");
  // Uncomment this if you want the demo to start instantly
  //song.play();
}

void setup() {
  // Set up the drawing area size and renderer (usually P2D or P3D,
  // respectively for accelerated 2D/3D graphics).
  size(CANVAS_WIDTH, CANVAS_HEIGHT, P2D);
  
  // Drawing options that don't change, modify as you wish
  noStroke();
  frameRate(30);
  fill(255);
  smooth();
  
  setupAudio();
}

/*
 * Your drawing code ends up in here!
 */
void drawDemo(int time) {
  rect(-1, -0.8, 2, 1.6);
  // "drum intensity" value, 0->1
  /*float drum = 0;
  for (int i = 0; i < exampleSync.length; i++) {
    if (time > exampleSync[i] && time < exampleSync[i] + 200)
      drum = (time-exampleSync[i])/200.;
  }
  rectMode(CENTER);
  
  for (int i = 0; i < 200; i++) {
    pushMatrix();
    fill(drum*127, 0, i/200.0*255);
    rotate(time*0.005+i/200.);
    
    rect(0, 0, 1+drum*0.2, 1+drum*0.2);
    popMatrix();
  }*/
  if (time < 2550) {
    //ellipse(0, 0, 0.1);
  }
}

/*
 * Draws coordinate axes in the drawing space.
 */
void drawAxes() {
  // Drawing options
  stroke(255);
  strokeWeight(0.003);
  fill(255);
  
  // X-axis
  line(-ASPECT_RATIO, 0, ASPECT_RATIO, 0); 
  pushMatrix();
  resetMatrix();
  text(Float.toString(-ASPECT_RATIO), -CANVAS_WIDTH/2, 12);
  text(Float.toString(ASPECT_RATIO), CANVAS_WIDTH/2-40, 12);
  popMatrix();
  // Y-axis
  line(0, -1, 0, 1);
  pushMatrix();
  resetMatrix();
  text("1", 12, -CANVAS_HEIGHT/2+12);
  text("-1", 12, CANVAS_HEIGHT/2);
  popMatrix();
}

void draw() {
  resetMatrix();
  // The following line maps coordinates from our drawing space to 
  // processing screen space. By default, axes go from -width/2...width/2 
  // and -height/2...height/2. That's not very nice if you wan't to change 
  // resolution :)
  // 
  // The coordinate space we draw in goes from -aspect_ratio...aspect_ratio
  // on x-axis and always -1...1 on y-axis, NEGATIVE Y ON BOTTOM. So
  // just like the coordinate system used normally.
  scale(1/ASPECT_RATIO*(CANVAS_WIDTH/2.0), -CANVAS_HEIGHT/2.0);
  // Clear the screen after previous frame.
  // If you remove this, you always draw on the last frame,
  // which can lead to something interesting.
  clear();
  
  // The following lines draw a full-screen quad.
  // rectMode(CORNER); 
  // Params for rect: x, y, width, height
  // rect(-ASPECT_RATIO, -1, 2*ASPECT_RATIO, 2);
  
  // Draw demo at the current song position.
  drawAxes();
  drawDemo(song.position());
}

void keyPressed() {
  if (key == CODED) {
    // Left/right arrow keys: seek song
    if (keyCode == LEFT) {
      song.skip(-SONG_SKIP_MILLISECONDS); 
    } else if (keyCode == RIGHT) {
      song.skip(SONG_SKIP_MILLISECONDS);
    }
  }
  // Space bar: play/payse
  else if (key == ' ') {
    if (song.isPlaying())
      song.pause();
    else
      song.play();
  }
  // Enter: spit out the current position
  else if (key == ENTER) {
    print(song.position() + ", "); 
  }
}
