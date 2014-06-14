import ddf.minim.*;
import java.awt.Frame;
PApplet self = this;
AudioPlayer music;
Board board = new Board();
GraphicsTile[][] tiles;
GuiButton newWallButton;
IntroState is;
PFrame f;
int state = 1;
int boardHeight, boardWidth;
boolean preload = false;
boolean displayGlitchCorrected = false;
//Base base = new Base();
//AStarSearch god = new AStarSearch(board.getRows(), base, board);
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

    background(0);

    newWallButton = new GuiButton();
    newWallButton.setColor(color(100, 100, 200, 100));
    newWallButton.setHoverColor(color(150, 150, 250, 100));
    newWallButton.setX(boardWidth);
    newWallButton.setY(0);
    newWallButton.setWidth(Constants.SIDEBAR_WIDTH);
    newWallButton.setHeight(100);
    newWallButton.setTextColor(color(240));
    newWallButton.setHoverTextColor(color(240));
    newWallButton.setText("Place New Wall");
    newWallButton.setTextSize(20);

    drawAll();
    
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
  board.loadMap("data/resources/maps/Example.MAP");
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
  stroke(255);
  for (int i = 0; i < board.getRows (); i++) {
    for (int u = 0; u < board.getCols (); u++) {
      tiles[i][u] = new GraphicsTile(u * Constants.PIXEL_TO_BOARD_INDEX_RATIO, i * Constants.PIXEL_TO_BOARD_INDEX_RATIO, board.get(i, u));
    }
  }
}

public void drawAll() {
  for (int i = 0; i < tiles.length; i++) {
    for (int u = 0; u < tiles[0].length; u++) {
      tiles[i][u].forceDisplay();
    }
  }
  fill(10);
  rect(boardWidth, 0, Constants.SIDEBAR_WIDTH, boardHeight);
  newWallButton.forceDisplay();
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
  int defaultColor = 10;
  int myColor;
  Tile myTile;

  GraphicsTile(int x, int y) {
    this.x = x;
    this.y = y;
  }

  GraphicsTile(int x, int y, Tile t) {
    this.x = x;
    this.y = y;
    myTile = t;
  }

  void setColor(int c) { 
    if (myColor != c) {
      myColor = c;
      if (c == defaultColor) {
        fill(c);
      } else {
        fill(c, 200);
      }
      rect(x, y, Constants.PIXEL_TO_BOARD_INDEX_RATIO, Constants.PIXEL_TO_BOARD_INDEX_RATIO);
    }
  }

  int getColor() {
    return myColor;
  }

  void restoreColor() {
    if (myColor != defaultColor) { 
      fill(defaultColor);
      myColor = defaultColor;
      rect(x, y, Constants.PIXEL_TO_BOARD_INDEX_RATIO, Constants.PIXEL_TO_BOARD_INDEX_RATIO);
    }
  }

  void forceRestoreColor() {
    fill(defaultColor);
    myColor = defaultColor;
    rect(x, y, Constants.PIXEL_TO_BOARD_INDEX_RATIO, Constants.PIXEL_TO_BOARD_INDEX_RATIO);
  }

  void setTile(Tile t) {
    myTile = t;
  }

  Tile getTile() {
    return myTile;
  }

  void display() {
    if (myTile.getAgent() != null) {
      forceRestoreColor();
      myTile.getAgent().display(); // Currently only displays one Agent per Tile
    } else {
      restoreColor();
    }
  }

  void forceDisplay() {
    if (myTile.getAgent() != null) {
      forceRestoreColor();
      myTile.getAgent().display(); // Currently only displays one Agent per Tile
    } else {
      forceRestoreColor();
    }
  }

  void hover() {
    if (myTile.getAgent() != null) {
      setColor(100);
    } else {
      setColor(100);
    }
  }

  void clear() {
    fill(0);
    rect(x, y, Constants.PIXEL_TO_BOARD_INDEX_RATIO, Constants.PIXEL_TO_BOARD_INDEX_RATIO);
  }
}

void mouseMoved() {
  if (!displayGlitchCorrected) {
    if (get(0, 0) == g.backgroundColor) {
      System.err.println("Something's wrong with display; Redrawing all..." + frameCount);
      drawAll();
    }
    displayGlitchCorrected = true;
  }
  if (state == 1) {
    int userX = mouseX;
    int userY = mouseY;
    if (userY < boardHeight && userX < boardWidth) {
      int tileHoveredX = userX / Constants.PIXEL_TO_BOARD_INDEX_RATIO;
      int tileHoveredY = userY / Constants.PIXEL_TO_BOARD_INDEX_RATIO;
      for (int i = 0; i < tiles.length; i++) {
        for (int u = 0; u < tiles[0].length; u++) {
          if (i != tileHoveredY || u != tileHoveredX) {
            tiles[i][u].display();
          }
        }
      }
      tiles[tileHoveredY][tileHoveredX].hover();
      newWallButton.display();
    } else if (userX > boardWidth) {
      if (userY < newWallButton.getHeight()) {
        newWallButton.hover();
      } else {
        newWallButton.display();
      }
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
