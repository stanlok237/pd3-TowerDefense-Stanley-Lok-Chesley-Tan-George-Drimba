import ddf.minim.*;

Minim minim;
AudioPlayer music;
AudioInput song;
GraphicsTile[][] tiles;
IntroState is = new IntroState();
Board board = new Board();
color introBgColor = #EEEEEE;
color introHoverColor = #FF8300;
boolean introHovered = false;
int state = 0;

void setup() {
  if (state == 0) {
    setupIntroScreen();
  }
  if (state == 1) {
    board.loadMap("../resources/maps/Example.MAP");
    frame.setResizable(true);
    frame.setSize(board.getCols() * 25, board.getRows() * 25 + frame.getInsets().top);
    // lower-level java resize causes inconsistency in window size, so we need another method to load different states
    frame.setResizable(false);
    tiles = new GraphicsTile[board.getRows()][board.getCols()];
    background(255);
    fill(0);
    stroke(255);
    for (int i = 0; i < board.getRows (); i++) {
      for (int u = 0; u < board.getCols (); u++) {
        tiles[i][u] = new GraphicsTile(u * 25, i * 25, 25, 25);
      }
    }
    //minim = new Minim(this);
    //music = minim.loadFile("../resources/Thor.mp3");
    //song = minim.getLineIn();
    //music.play();
    //music.loop();
  }
}

void draw() {
  if (state == 0) {
  } 
  else if (state == 1) {
  }
}

class GraphicsTile {
  int x, y, width, height;
  Tile myTile;

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

  void setTile(Tile t) {
    myTile = t;
  }

  Tile getTile() {
    return myTile;
  }
}

class IntroState extends State {

  IntroState() {
  }

  void drawBackground() {
    background(introBgColor);
    textAlign(CENTER, TOP);
    fill(0);
    textSize(40);
    text("Tower Defense", width / 2, 70);
    fill(0);
    textSize(20);
    text("How to Play", width / 2, 170);

    textSize(20);
    text("About", width / 2, 220);

    textSize(38);
    text("Play!", width / 2, 270);
  }

  void redraw1() {
    fill(introBgColor);
    noStroke();
    textSize(20);
    rect(0, 170, width, textAscent() + textDescent());
    fill(introHoverColor);
    text("How to Play", width / 2, 170);
  }

  void redraw2() {
    fill(introBgColor);
    noStroke();
    textSize(20);
    rect(0, 220, width, textAscent() + textDescent());
    fill(introHoverColor);
    text("About", width / 2, 220);
  }

  void redraw3() {
    fill(introBgColor);
    noStroke();
    textSize(38);
    rect(0, 270, width, textAscent() + textDescent());
    fill(introHoverColor);
    text("Play!", width / 2, 270);
  }
}

void setupIntroScreen() {
  size(500, 400);
  is.drawBackground();
}

void drawIntroScreen() {
  int threshold = 30;
  if (get(mouseX, mouseY) != introBgColor) {
    if (abs(mouseY - 170) < 20) {
      is.redraw1();
      introHovered = true;
    } else if (abs(mouseY - 220) < 20) {
      is.redraw2();
      introHovered = true;
    } else if (abs(mouseY - 270) < 38) {
      is.redraw3();
      introHovered = true;
    }
  } else if (introHovered == true && get(mouseX, mouseY) == introBgColor) {
    is.drawBackground();
    introHovered = false;
  }
}

void mouseMoved() {
  if (state == 0) {
    drawIntroScreen();
  }
  if (state == 1) {
    int userX = mouseX / 25;
    int userY = mouseY / 25;
    if (userY < tiles.length && userX < tiles[0].length) {
      for (int i = 0; i < tiles.length; i++) {
        for (int u = 0; u < tiles[0].length; u++) {
          tiles[i][u].setColor(0);
        }
      }
      tiles[userY][userX].setColor(100);
    }
  }
}

void mouseClicked() { // event to start state 1 (the actual game) will be changed
  if (state == 0) {
    state = 1;
    setup();
  }
}

