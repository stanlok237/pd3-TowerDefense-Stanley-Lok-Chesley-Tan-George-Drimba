import ddf.minim.*;

Minim minim;
AudioPlayer music;
AudioInput song;

void setup(){
  size(800,600);
  minim = new Minim(this);
  music = minim.loadFile("Thor.mp3");
  song = minim.getLineIn();
  music.play();
  music.loop();
}

void draw(){
}
