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

// Constants
int CANVAS_WIDTH = 800;
int CANVAS_HEIGHT = 600;
// Assumed in the code to always be >1, meaning that width > height.
float ASPECT_RATIO = (float)CANVAS_WIDTH/CANVAS_HEIGHT;

// You can skip backwards/forwards in you demo by using the 
// arrow keys; this controls how many milliseconds you skip
// at one press.
int SONG_SKIP_MILLISECONDS = 2000;

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
  
  // Drawing options
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
  // "drum intensity" value, 0->1
  float drum = 0;
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
  }
}

void draw() {
  resetMatrix();
  // The following line maps coordinates from our drawing space to processing
  // screen space. By default, axes go from -width...width 
  // and -height...height, origo being in the center. 
  // That's not very nice if you wan't to change resolution :)
  // 
  // The coordinate space you draw in goes from -aspect_ratio...aspect_ratio
  // on x-axis and always -1...1 on y-axis.
  scale(1/ASPECT_RATIO*(CANVAS_WIDTH/2.0), CANVAS_HEIGHT/2.0);
  // Clear the screen after previous frame.
  clear();
  
  // The following lines draw a full-screen quad.
  // rectMode(CORNER); 
  // rect(-ASPECT_RATIO, -1, 2*ASPECT_RATIO, 2);
  
  // Draw demo at the current song position.
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
