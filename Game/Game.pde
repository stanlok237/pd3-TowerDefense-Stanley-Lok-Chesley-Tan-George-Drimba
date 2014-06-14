import ddf.minim.*;
import java.awt.Frame;
AudioPlayer music;
GraphicsTile[][] tiles;
IntroState is;
PFrame f;
Board board = new Board();
int state = 1;
int boardHeight, boardWidth;
Base base = new Base();
AStarSearch god = new AStarSearch(board.getRows(), base, board);
PApplet self = this;
boolean preload = false;
//Spawning location
//Tile tmpTile = new Tile(0, 0);

void setup() {
  if (state == 0) {
    f = new PFrame();
    f.setTitle("Menu");
    if (preload) {
      setupBoard();
    }
  }
  if (state == 1) {
    if (!preload) {
      setupBoard();
    }
    //music = new Minim(this).loadFile("../resources/Thor.mp3");
    //music.play();
    //music.loop();

    //board.set(0, 0, tmpTile);
    //Node tmp = god.search(tmpTile);
    //System.out.println(tmp);
    /*
    while (tmp.hasParent ()) {
     Tile travelPath = tmp.getTile();
     tiles[travelPath.getX()][travelPath.getY()] = new GraphicsTile(travelPath.getX() * Constants.PIXEL_TO_BOARD_INDEX_RATIO, travelPath.getY() * Constants.PIXEL_TO_BOARD_INDEX_RATIO, travelPath);
     tiles[travelPath.getX()][travelPath.getY()].setColor(90);
     tmp = tmp.getParent();
     }
     */
    //god.search(new Tile(0,0));

    // Works with Oracle's JDK
    //frame.setResizable(false);
  }
}

void draw() {
  if (state == 0) {
    if (frame.getState() != Frame.ICONIFIED)
      frame.setState(Frame.ICONIFIED);
  } else if (state == 1) {
    if (frame.getState() != Frame.NORMAL)
      frame.setState(Frame.NORMAL);
  }
}

void setupBoard() {
  board.loadMap("../resources/maps/Example.MAP");
  frame.setResizable(true);
  boardHeight = board.getRows() * Constants.PIXEL_TO_BOARD_INDEX_RATIO;
  boardWidth = board.getCols() * Constants.PIXEL_TO_BOARD_INDEX_RATIO;
  frame.setSize(boardWidth + frame.getInsets().left + frame.getInsets().right + Constants.SIDEBAR_WIDTH, boardHeight + frame.getInsets().top + frame.getInsets().bottom);
  // Window size is inconsistent when frame resizeable is set to false immediately, so it is delayed
  size(boardWidth + Constants.SIDEBAR_WIDTH, boardHeight);
  if (height != boardHeight) {
    System.err.println("Sanity check failed: Resize consistency error. Exiting...");
    System.exit(1);
  }
  tiles = new GraphicsTile[board.getRows()][board.getCols()];
  background(255);
  fill(0);
  rect(boardWidth, 0, Constants.SIDEBAR_WIDTH, boardHeight);
  stroke(255);
  for (int i = 0; i < board.getRows (); i++) {
    for (int u = 0; u < board.getCols (); u++) {
      tiles[i][u] = new GraphicsTile(u * Constants.PIXEL_TO_BOARD_INDEX_RATIO, i * Constants.PIXEL_TO_BOARD_INDEX_RATIO, board.get(i, u));
    }
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
  f.dispose();
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
  int x, y;
  int defaultColor = 0;
  int myColor = defaultColor;
  Tile myTile;

  GraphicsTile(int x, int y) {
    this.x = x;
    this.y = y;
    fill(defaultColor);
    rect(x, y, Constants.PIXEL_TO_BOARD_INDEX_RATIO, Constants.PIXEL_TO_BOARD_INDEX_RATIO);
  }

  GraphicsTile(int x, int y, Tile t) {
    this.x = x;
    this.y = y;
    myTile = t;
    fill(defaultColor);
    rect(x, y, Constants.PIXEL_TO_BOARD_INDEX_RATIO, Constants.PIXEL_TO_BOARD_INDEX_RATIO);
    display();
  }

  void setColor(int c) { 
    if (myColor != c) {
      if (c == defaultColor) {
        fill(c);
      } else {
        fill(c, 200);
      }
      myColor = c;
      rect(x, y, Constants.PIXEL_TO_BOARD_INDEX_RATIO, Constants.PIXEL_TO_BOARD_INDEX_RATIO);
    }
  }

  int getColor() {
    return myColor;
  }

  void restoreColor() {
    //if (myColor != defaultColor) { // Causes a blank screen 20% of the time
    fill(defaultColor);
    myColor = defaultColor;
    rect(x, y, Constants.PIXEL_TO_BOARD_INDEX_RATIO, Constants.PIXEL_TO_BOARD_INDEX_RATIO);
    //}
  }

  void setTile(Tile t) {
    myTile = t;
  }

  Tile getTile() {
    return myTile;
  }

  void display() {
    if (myTile.getAgent() != null) {
      restoreColor();
      myTile.getAgent().display(); // Currently only displays one Agent per Tile
    } else {
      restoreColor();
    }
  }
}

void mouseMoved() {
  if (state == 1) {
    int userX = mouseX / Constants.PIXEL_TO_BOARD_INDEX_RATIO;
    int userY = mouseY / Constants.PIXEL_TO_BOARD_INDEX_RATIO;
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

void mouseClicked() {
  /*
  int userX = mouseX / Constants.PIXEL_TO_BOARD_INDEX_RATIO;
   int userY = mouseY / Constants.PIXEL_TO_BOARD_INDEX_RATIO;
   println(tiles[userY][userX].getColor());
   */
}
