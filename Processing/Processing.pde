import ddf.minim.*;

Minim minim;
AudioPlayer music;
AudioInput song;

void setup(){
  size(100,100);
  minim = new Minim(this);
  music = minim.loadFile("05_Gentle Jena.mp3");
  song = minim.getLineIn();
  music.play();
  music.loop();
}

void draw(){
}
