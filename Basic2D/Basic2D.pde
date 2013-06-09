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
int CANVAS_WIDTH = 1024;
int CANVAS_HEIGHT = 768;
int SONG_SKIP_MILLISECONDS = 2000;

// Audio
Minim minim;
AudioPlayer song;

// Syncdata
int[] bassSync = {46, 557, 766, 1486, 1950, 2716, 3204, 3970, 4481, 5317, 5781, 6524, 7012, 7314, 7476, 7639};

/*
 * Sets up audio playing: call this last in setup()
 * so that the song doesn't start to play too early
 */
void setupAudio() {
  minim = new Minim(this);
  song = minim.loadFile("soundtrack.mp3");
  song.play();
}

void setup() {
  size(CANVAS_WIDTH, CANVAS_HEIGHT, P2D);
  
  // Drawing options
  noStroke();
  frameRate(300);
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
  for (int i = 0; i < bassSync.length; i++) {
    if (time > bassSync[i] && time < bassSync[i] + 200)
      drum = (time-bassSync[i])/200.;
  }
  clear();
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
  // Remap coordinates to go from -1 to 1 on both
  // axis. TODO: mapping based on aspect ratio,
  // this currently gives wrong results
  //translate(canvasWidth/2.0, canvasHeight/2.0);
  scale(CANVAS_WIDTH/2.0, CANVAS_HEIGHT/2.0);

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
  // Enter: spit out position
  else if (key == ENTER) {
    print(song.position() + ", "); 
  }
}
