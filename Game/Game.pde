import ddf.minim.*;
import java.awt.Frame;
PApplet self = this;
AudioPlayer music;
Board board = new Board();
Base base;
GraphicsTile[][] tiles;
GuiButton newWallButton;
InfoDisplay infoDisplay;
IntroState is;
PFrame f;
int state = 0;
int boardHeight, boardWidth;
final color defaultTileHoverColor = color(100, 100);
color tileHoverColor = defaultTileHoverColor;
final boolean preload = true;
boolean newWallButtonClicked = false;
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

    background(0); // Should be different from all other colors used so that the blank display glitch can be caught

    newWallButton = new GuiButton();
    newWallButton.setColor(color(100, 100, 200, 100));
    newWallButton.setHoverColor(color(150, 150, 250, 100));
    newWallButton.setClickedColor(color(255, 3, 16, 100));
    newWallButton.setX(boardWidth);
    newWallButton.setY(0);
    newWallButton.setWidth(Constants.SIDEBAR_WIDTH);
    newWallButton.setHeight(Constants.NEW_WALL_BUTTON_HEIGHT);
    newWallButton.setTextColor(color(240));
    newWallButton.setHoverTextColor(color(240));
    newWallButton.setClickedTextColor(color(180, 180, 180));
    newWallButton.setText("Place New Wall");
    newWallButton.setTextSize(20);

    infoDisplay = new InfoDisplay(this);

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
  base = board.getBase();
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
  for (int i = 0; i < board.getRows (); i++) {
    for (int u = 0; u < board.getCols (); u++) {
      tiles[i][u] = new GraphicsTile(u * Constants.PIXEL_TO_BOARD_INDEX_RATIO, i * Constants.PIXEL_TO_BOARD_INDEX_RATIO, board.get(i, u));
    }
  }
}

public void drawAll() {
  stroke(Constants.GAME_STROKE_COLOR);
  for (int i = 0; i < tiles.length; i++) {
    for (int u = 0; u < tiles[0].length; u++) {
      tiles[i][u].forceDisplay();
    }
  }
  fill(Constants.GAME_BACKGROUND_COLOR);
  rect(boardWidth, 0, Constants.SIDEBAR_WIDTH, boardHeight);
  if (newWallButton != null) {
    newWallButton.forceDisplay();
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
  color defaultColor = Constants.GAME_BACKGROUND_COLOR;
  color myColor;
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

  void setColor(color c) { 
    if (myColor != c) {
      myColor = c;
      fill(c);
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
      setColor(tileHoverColor);
    } else {
      setColor(tileHoverColor);
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
      if (!newWallButtonClicked) {
        newWallButton.display();
      }
    } else if (userX > boardWidth) {
      if (userY < Constants.NEW_WALL_BUTTON_HEIGHT) {
        if (!newWallButtonClicked) {
          newWallButton.hover();
        }
      } else if (userY < Constants.NEW_WALL_BUTTON_HEIGHT + Constants.INFO_DISPLAY_HEIGHT) {
        infoDisplay.hoverAction(userX, userY);
        if (!newWallButtonClicked) {
          newWallButton.display();
        }
      } else {
        if (!newWallButtonClicked) {
          newWallButton.display();
        }
      }
    }
    if (newWallButtonClicked) {
      newWallButton.clicked();
    }
  }
}

void mouseClicked() {
  if (mouseX < boardWidth && mouseY < boardHeight) {
    if (newWallButtonClicked) {
      int tileHereX = mouseX / Constants.PIXEL_TO_BOARD_INDEX_RATIO;
      int tileHereY = mouseY / Constants.PIXEL_TO_BOARD_INDEX_RATIO;
      tiles[tileHereY][tileHereX].getTile().addAgent(Constants.WALL); // TODO: Does not do any validation yet
      newWallButtonClicked = false;
      newWallButton.display();
      tileHoverColor = defaultTileHoverColor;
    } else {
      int tileHereX = mouseX / Constants.PIXEL_TO_BOARD_INDEX_RATIO;
      int tileHereY = mouseY / Constants.PIXEL_TO_BOARD_INDEX_RATIO;
      Agent a = tiles[tileHereY][tileHereX].getTile().getAgent();
      infoDisplay.showInfo(a);
    }
  } else if (mouseY < Constants.NEW_WALL_BUTTON_HEIGHT) {
    newWallButtonClicked = !newWallButtonClicked;
    if (newWallButtonClicked) {
      tileHoverColor = color(222, 22, 0, 100);
      newWallButton.clicked();
    } else {
      tileHoverColor = defaultTileHoverColor;
      newWallButton.display();
    }
  } else if (mouseY < Constants.NEW_WALL_BUTTON_HEIGHT + Constants.INFO_DISPLAY_HEIGHT) {
    infoDisplay.clickAction(mouseX, mouseY);
  }
}
