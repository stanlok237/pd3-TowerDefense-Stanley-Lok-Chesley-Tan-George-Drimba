import ddf.minim.*;
import java.awt.Frame;
import java.awt.event.ComponentAdapter;
import java.awt.event.ComponentEvent;
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
Node path;
ArrayList<Tile> pathTiles;

//Base base = new Base();
//AStarSearch god = new AStarSearch(board.getRows(), base, board);
//Spawning location;
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
    strokeWeight(Constants.GAME_STROKE_WEIGHT);

    newWallButton = new GuiButton();
    newWallButton.setColor(color(25, 25, 200, 180));
    newWallButton.setHoverColor(color(50, 50, 225, 100));
    newWallButton.setClickedColor(color(50, 50, 225, 100));
    newWallButton.setX(boardWidth);
    newWallButton.setY(0);
    newWallButton.setWidth(Constants.SIDEBAR_WIDTH);
    newWallButton.setHeight(Constants.NEW_WALL_BUTTON_HEIGHT);
    newWallButton.setBorders(0, 0, 0, 0);
    newWallButton.setTextColor(color(200));
    newWallButton.setHoverTextColor(color(240));
    newWallButton.setClickedTextColor(color(255, 3, 32, 150));
    newWallButton.setText("Place New Wall");
    newWallButton.setTextSize(20);
    if (Constants.GAME_NO_STROKE) {
      newWallButton.setStroke(false);
    }

    infoDisplay = new InfoDisplay(this);

    drawAll();


    //ASTARSEARCH TEST AREA

    //music = new Minim(this).loadFile("../resources/Thor.mp3");
    //music.play();
    //music.loop();

    //println(board.getBase());

    AStarSearch god = new AStarSearch(base, board);
    Tile tmpTile = new Tile(0, 0);
    board.set(0, 0, tmpTile);
    path = god.search(tmpTile);
    //System.out.println(path);

    while (path.hasParent ()) {
      //Add the tiles in the pat into an ArrayList
      Tile travelPath = path.getTile();
      tiles[travelPath.getY()][travelPath.getX()].setDefaultColor(Constants.GAME_PATH_COLOR);
      //path = path.getParent();

      pathTiles.add(path.getTile());
      path = path.getParent();
    }

    // Works with Oracle's JDK
    //frame.setResizable(false);

    frame.addComponentListener(new ResizeAdapter(this));
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
  pathTiles = new ArrayList<Tile>();
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
  if (!Constants.GAME_NO_STROKE) {
    stroke(Constants.GAME_STROKE_COLOR);
  } else {
    noStroke();
  }
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
    setResizable(false);
    is = new IntroState(self);
    add(is);
    is.init();
    setVisible(true);
  }
}

public class ResizeAdapter extends ComponentAdapter {
  Game parent;
  public ResizeAdapter(Game p) {
    parent = p;
  }
  @Override
    public void componentResized(ComponentEvent e) {
    parent.displayGlitchCorrected = false;
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
      if (!Constants.GAME_NO_STROKE) {
        stroke(Constants.GAME_STROKE_COLOR);
      } else {
        noStroke();
      }
      myColor = c;
      fill(c);
      rect(x, y, Constants.PIXEL_TO_BOARD_INDEX_RATIO, Constants.PIXEL_TO_BOARD_INDEX_RATIO);
    }
  }

  void setDefaultColor(color c) {
    if (myColor != c) {
      if (!Constants.GAME_NO_STROKE) {
        stroke(Constants.GAME_STROKE_COLOR);
      } else {
        noStroke();
      }
      defaultColor = c;
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
      forceRestoreColor();
    }
  }

  void forceRestoreColor() {
    if (!Constants.GAME_NO_STROKE) {
      stroke(Constants.GAME_STROKE_COLOR);
    } else {
      noStroke();
    }
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
    } 
    else {
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
    if (get(0, 0) == g.backgroundColor || get(width, 0) == g.backgroundColor || get(0, height) == g.backgroundColor || get(width, height) == g.backgroundColor) {
      System.err.println("Something's wrong with display; Redrawing all..." + frameCount);
      drawAll();
    }
    displayGlitchCorrected = true;
  }
  if (state == 1) {
    int userX = mouseX;
    int userY = mouseY;
    if (userY < boardHeight && userX < boardWidth) { // User within board
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
    } else if (userX > boardWidth && userX < boardWidth + Constants.SIDEBAR_WIDTH) { // User within first sidebar
      if (userY < Constants.NEW_WALL_BUTTON_HEIGHT) { // User within new wall button
        if (!newWallButtonClicked) {
          newWallButton.hover();
        }
      } else if (userY < Constants.NEW_WALL_BUTTON_HEIGHT + Constants.INFO_DISPLAY_HEIGHT) { // User within info display
        infoDisplay.hoverAction(userX, userY);
        if (!newWallButtonClicked) {
          newWallButton.display();
        }
      } else {
        if (!newWallButtonClicked) {
          newWallButton.display();
        }
      }
    } else if (userX > boardWidth + Constants.SIDEBAR_WIDTH) { // User outside first sidebar
      if (!newWallButtonClicked) {
        newWallButton.display();
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
      if (tiles[tileHereY][tileHereX].getTile().getAgent() == null) {
        tiles[tileHereY][tileHereX].getTile().addAgent(Constants.WALL);
      } // TODO: Does not do any validation yet
      newWallButtonClicked = false;
      cursor(ARROW);
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
      cursor(MOVE);
    } else {
      tileHoverColor = defaultTileHoverColor;
      newWallButton.display();
      cursor(ARROW);
    }
  } else if (mouseY < Constants.NEW_WALL_BUTTON_HEIGHT + Constants.INFO_DISPLAY_HEIGHT) {
    infoDisplay.clickAction(mouseX, mouseY);
  }
}
