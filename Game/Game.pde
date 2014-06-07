import ddf.minim.*;

Minim minim;
AudioPlayer music;
AudioInput song;
GraphicsTile[][] tiles = new GraphicsTile[20][20];

void setup(){
  size(500, 500);
  background(255);
  fill(0);
  stroke(255);
  for (int i = 0;i < height;i += 25) {
    for (int u = 0;u < width;u += 25) {
      tiles[i / 25][u / 25] = new GraphicsTile(u, i, 25, 25);
    }
  }
  minim = new Minim(this);
  music = minim.loadFile("../resources/Thor.mp3");
  song = minim.getLineIn();
  music.play();
  music.loop();
}

class GraphicsTile {
  int x, y, width, height;
  GraphicsTile(int x, int y, int width, int height) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    rect(x, y, width, height);
  }
  void setColor(int c) {
    fill(c, 100);
    rect(x, y, width, height);
  }
}

void draw(){
  for (int i = 0;i < tiles.length;i++) {
    for (int u = 0;u < tiles[0].length;u++) {
       tiles[i][u].setColor(0);  
    }
  }
  int userX = mouseX / 25;
  int userY = mouseY / 25;
  tiles[userY][userX].setColor(100);
}

void mouseClicked() {
}
 
void mousePressed() { 
}
 
void mouseReleased() {
}
 
void mouseMoved() {
}
 
void mouseDragged() {
}
