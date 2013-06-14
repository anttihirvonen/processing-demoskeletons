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
int[] exampleSync = {2229, 3227, 4202, 5201, 6199, 7151, 8219, 9195, 10216, 11192, 12213, 13188, 14187, 15209};

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
  float intensity = 0;
  for (int i = 0; i < exampleSync.length; i++)
    if (time > exampleSync[i] - 20 && time < exampleSync[i] + 300)
      intensity = 1.0;
  
  // Drawing a flickerin rect field as an example
  for (float i = 0; i < 2*ASPECT_RATIO + 0.5; i += 0.1) {
    // Vary color based on intensity value
    fill(127 + 127*intensity, i*127, time/20.);
    rect(-ASPECT_RATIO+i, -0.8, 0.1, 1.6);
  }
}

/*
 * Draws coordinate axes (for reference).
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
  // Reset all transformations.
  resetMatrix();
  
  // The following line maps coordinates from our drawing space to 
  // processing screen space. By default, axes go from -width/2...width/2 
  // and -height/2...height/2. That's not very nice if you wan't to change 
  // resolution :)
  // 
  // THE IMPORTANT PART:
  // The coordinate space we draw in goes from -aspect_ratio...aspect_ratio
  // on x-axis and always -1...1 on y-axis, NEGATIVE Y ON BOTTOM. So
  // just like the coordinate you're probably used to.
  scale(CANVAS_WIDTH/2.0/ASPECT_RATIO, -CANVAS_HEIGHT/2.0);
  // Clear the screen after previous frame.
  // If you comment this, you always draw on top the last frame,
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
