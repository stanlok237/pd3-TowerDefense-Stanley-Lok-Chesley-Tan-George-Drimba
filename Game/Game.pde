import ddf.minim.*;
import java.awt.Frame;
AudioPlayer music;
GraphicsTile[][] tiles;
IntroState is;
PFrame f;
Board board = new Board();
int state = 0;
Base base = new Base();
AStarSearch god = new AStarSearch(board.getRows(), base, board);
PApplet self = this;
//Spawning location
Tile tmpTile = new Tile(0, 0);
//board.set(0,0,tmpTile)

//Node tmp = god.search(tmpTile);

void setup() {
  if (state == 0) {
    f = new PFrame();
    f.setTitle("Menu");
    frame.setTitle("Game");
  }
  if (state == 1) {
    board.loadMap("../resources/maps/Example.MAP");
    board.set(0, 0, tmpTile);
    Node tmp = god.search(tmpTile);
    System.out.println(tmp);
    frame.setResizable(true);
    frame.setSize(board.getCols() * 25 + frame.getInsets().left + frame.getInsets().right, board.getRows() * 25 + frame.getInsets().top + frame.getInsets().bottom);
    // Window size is inconsistent when frame resizeable is set to false immediately, so it is delayed
    size(board.getCols() * 25, board.getRows() * 25);
    if (height != board.getRows() * 25) {
      System.err.println("Sanity check failed: Resize consistency error. Exiting...");
      System.exit(1);
    }
    tiles = new GraphicsTile[board.getRows()][board.getCols()];
    background(255);
    fill(0);
    while (tmp.hasParent ()) {
      Tile travelPath = tmp.getTile();
      tiles[travelPath.getX()][travelPath.getY()] = new GraphicsTile(travelPath.getX() * 25, travelPath.getY() * 25, 25, 25, travelPath);
      tiles[travelPath.getX()][travelPath.getY()].setColor(90);
      tmp = tmp.getParent();
    }
    //god.search(new Tile(0,0));
    stroke(255);
    for (int i = 0; i < board.getRows (); i++) {
      for (int u = 0; u < board.getCols (); u++) {
        tiles[i][u] = new GraphicsTile(u * 25, i * 25, 25, 25, board.get(i, u));
      }
    }
    music = new Minim(this).loadFile("../resources/Thor.mp3");
    music.play();
    music.loop();

    // Works with Oracle's JDK
    frame.setResizable(false);
  }
}

void draw() {
  if (state == 0) {
  } else if (state == 1) {
  }
}

public void setState(int n) {
  state = n;
}

public int getState() {
  return state;
}

public void startGame() {
  state = 1;
  setup();
  f.setVisible(false);
}

public class PFrame extends Frame {
  public PFrame() {
    setBounds(0, 0, 500, 400);
    is = new IntroState(self);
    add(is);
    is.init();
    setVisible(true);
  }
}

class GraphicsTile {
  int x, y, width, height;
  Tile myTile;
  String myTileName;

  GraphicsTile(int x, int y, int width, int height) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    rect(x, y, width, height);
  }

  GraphicsTile(int x, int y, int width, int height, Tile t) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    myTile = t;
    myTileName = t.getAgentName();
    if (myTileName.equals("p")) {
      fill(50, 200, 0);
    } else {
      fill(0, 100);
    }
    rect(x, y, width, height);
  }

  void setColor(int c) {
    fill(c, 100);
    rect(x, y, width, height);
  }

  void setTile(Tile t) {
    myTile = t;
    myTileName = t.getAgentName();
  }

  Tile getTile() {
    return myTile;
  }

  void display() {
    if (myTileName.equals("p")) {
      fill(50, 200, 0, 100);
    } else {
      fill(0, 100);
    }
    rect(x, y, width, height);
  }
}

void mouseMoved() {
  if (state == 1) {
    int userX = mouseX / 25;
    int userY = mouseY / 25;
    if (userY < tiles.length && userX < tiles[0].length) {
      for (int i = 0; i < tiles.length; i++) {
        for (int u = 0; u < tiles[0].length; u++) {
          tiles[i][u].display();
        }
      }
      tiles[userY][userX].setColor(100);
    }
  }
}
