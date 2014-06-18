import ddf.minim.*;
import java.awt.Frame;
import java.awt.event.ComponentAdapter;
import java.awt.event.ComponentEvent;
import java.text.NumberFormat;
import java.util.ArrayList;
PApplet self = this;
AudioPlayer music;
Board board = new Board(this);
Spawn mySpawn;
GraphicsTile[][] tiles;
GuiButton newWallButton, nextRoundButton;
InfoDisplay infoDisplay;
IntroState is;
PFrame f;
int state = 0;
int boardHeight, boardWidth;
final color defaultTileHoverColor = color(100, 100);
color tileHoverColor = defaultTileHoverColor;
GraphicsTile hovered;
final boolean preload = true;
boolean newWallButtonClicked = false;
boolean displayGlitchCorrected = false;
Node path;
ArrayList<Tile> pathTiles;
AStarSearch god;
int currency;
int shownCurrency;
boolean currencyLocked = false;
boolean roundInProgress = false;
int round = 1;
ArrayList<Enemy> enemiesSpawned; // Keeps track of how many enemies are still on the field
ArrayList<Tower> towersCreated;

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
    newWallButton.setColor(color(25, 25, 200, 150));
    newWallButton.setHoverColor(color(50, 50, 225, 100));
    newWallButton.setClickedColor(color(150, 0, 0, 200));
    newWallButton.setX(boardWidth);
    newWallButton.setY(0);
    newWallButton.setWidth(Constants.SIDEBAR_WIDTH);
    newWallButton.setHeight(Constants.NEW_WALL_BUTTON_HEIGHT);
    newWallButton.setBorders(0, 0, 0, 0);
    newWallButton.setTextColor(color(200));
    newWallButton.setHoverTextColor(color(240));
    newWallButton.setClickedTextColor(color(240));
    String newWallString = "Place New Wall\n($" + Constants.WALL_PRICE + ")";
    newWallButton.setText(newWallString);
    newWallButton.setTextSize(Constants.NEW_WALL_BUTTON_TEXT_SIZE);
    if (Constants.GAME_NO_STROKE) {
      newWallButton.setStroke(false);
    }

    nextRoundButton = new GuiButton();
    nextRoundButton.setColor(color(150, 0, 0, 200));
    nextRoundButton.setHoverColor(color(150, 0, 0, 125));
    nextRoundButton.setX(boardWidth);
    nextRoundButton.setY(boardHeight - Constants.NEXT_ROUND_BUTTON_HEIGHT_FROM_BOTTOM);
    nextRoundButton.setWidth(Constants.SIDEBAR_WIDTH);
    nextRoundButton.setHeight(Constants.NEXT_ROUND_BUTTON_HEIGHT);
    nextRoundButton.setBorders(0, 0, 0, 0);
    nextRoundButton.setTextColor(color(200));
    nextRoundButton.setHoverTextColor(color(240));
    nextRoundButton.setText("Next Round");
    nextRoundButton.setTextSize(Constants.NEXT_ROUND_BUTTON_TEXT_SIZE);
    if (Constants.GAME_NO_STROKE) {
      nextRoundButton.setStroke(false);
    }

    infoDisplay = new InfoDisplay(this);
    enemiesSpawned = new ArrayList<Enemy>();
    towersCreated = new ArrayList<Tower>();

    music = new Minim(this).loadFile("data/resources/Thor.mp3");
    music.play();
    music.loop();

    // Works with Oracle's JDK
    //frame.setResizable(false);

    frame.addComponentListener(new ResizeAdapter(this));

    path = god.search(mySpawn.getTile());

    while (path != null) {
      //Add the tiles in the pat into an ArrayList
      Tile travelPath = path.getTile();
      if (Constants.SHOW_PATH) {
        tiles[travelPath.getY()][travelPath.getX()].setDefaultColor(Constants.GAME_PATH_COLOR);
        tiles[travelPath.getY()][travelPath.getX()].forceDisplay();
      }
      pathTiles.add(path.getTile());
      path = path.getParent();
    }
    drawAll();
  }
}

void draw() {
  if (state == 0) {
    if (frame.getState() != Frame.ICONIFIED)
      frame.setState(Frame.ICONIFIED);
  } else if (state == 1) {
    if (frame.getState() != Frame.NORMAL)
      frame.setState(Frame.NORMAL);
    showCurrency();
    if (roundInProgress) {
      mySpawn.act();
      if (enemiesSpawned.size() == 0 && mySpawn.queueEmpty()) { // Round over
        roundInProgress = false;
        round += 1;
        showRound();
        addCurrency(round);
      } else {
        for (Iterator<Enemy> it = enemiesSpawned.iterator();it.hasNext();) {
          Enemy e = it.next();
          e.act();
          if (e.isDead()) {
            it.remove();
          }
        }
        for (Tower t : towersCreated) {
          t.shoot(enemiesSpawned);
        }
        for (int i = 0; i < tiles.length; i++) {
          for (int u = 0; u < tiles[0].length; u++) {
            tiles[i][u].clear();
          }
        }
        for (int i = 0; i < tiles.length; i++) {
          for (int u = 0; u < tiles[0].length; u++) {
            tiles[i][u].displayAgents();
          }
        }
      }
    }
  }
}

void setupBoard() {
  board.loadMap("data/resources/maps/Example.MAP");
  pathTiles = new ArrayList<Tile>();
  god = new AStarSearch(board);
  frame.setResizable(true);
  currency = 1000; //for testing
  boardHeight = board.getRows() * Constants.PIXEL_TO_BOARD_INDEX_RATIO;
  boardWidth = board.getCols() * Constants.PIXEL_TO_BOARD_INDEX_RATIO;
  frame.setSize(boardWidth + frame.getInsets().left + frame.getInsets().right + Constants.SIDEBAR_WIDTH, boardHeight + frame.getInsets().top + frame.getInsets().bottom);
  size(boardWidth + Constants.SIDEBAR_WIDTH, boardHeight);
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
  if (nextRoundButton != null) {
    nextRoundButton.forceDisplay();
  }
  forceShowCurrency();
  showRound();
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

public void gameOver() {
  background(Constants.GAME_BACKGROUND_COLOR);
  textSize(30);
  fill(#2D9303);
  text("Game Over", width / 2, height / 2);
  noLoop();
}

public int getRound() {
  return round;
}

public void showRound() {
  if (Constants.GAME_NO_STROKE) {
    noStroke();
  } else {
    stroke(Constants.GAME_STROKE_COLOR);
  }
  fill(Constants.GAME_BACKGROUND_COLOR);
  rect(boardWidth, boardHeight - Constants.CURRENCY_HEIGHT_FROM_BOTTOM - Constants.ROUND_HEIGHT_ABOVE_CURRENCY, Constants.SIDEBAR_WIDTH, Constants.ROUND_HEIGHT_ABOVE_CURRENCY);
  textSize(Constants.ROUND_TEXT_SIZE);
  textAlign(CENTER, CENTER);
  fill(#EEEEEE);
  text("Round: " + round, boardWidth + Constants.SIDEBAR_WIDTH / 2, boardHeight - Constants.CURRENCY_HEIGHT_FROM_BOTTOM - Constants.ROUND_HEIGHT_ABOVE_CURRENCY / 2 - textAscent() * 0.1);
}

public void startRound() {
  roundInProgress = true;
}

public void showCurrency() {
  if (currency != shownCurrency) {
    forceShowCurrency();
  }
}

public void forceShowCurrency() {
  if (Constants.GAME_NO_STROKE) {
    noStroke();
  } else {
    stroke(Constants.GAME_STROKE_COLOR);
  }
  fill(Constants.GAME_BACKGROUND_COLOR);
  rect(boardWidth, boardHeight - Constants.CURRENCY_HEIGHT_FROM_BOTTOM, Constants.SIDEBAR_WIDTH, Constants.CURRENCY_HEIGHT_FROM_BOTTOM);
  textSize(Constants.CURRENCY_TEXT_SIZE);
  textAlign(CENTER, CENTER);
  String s = "$" + NumberFormat.getInstance().format(currency);
  fill(#EEEEEE);
  text(s, boardWidth + Constants.SIDEBAR_WIDTH / 2, boardHeight - Constants.CURRENCY_HEIGHT_FROM_BOTTOM / 2 - textAscent() * 0.1);
  shownCurrency = currency;
}

public void addCurrency(int n) {
  currency += n;
  showCurrency();
}

public void removeCurrency(int n) {
  if (!currencyLocked) {
    currency -= n;
    showCurrency();
  }
}

public void setCurrency(int n) {
  currency = n;
  showCurrency();
}

public int getCurrency() {
  return currency;
}

public void lockCurrency() {
  currencyLocked = true;
}

public void unlockCurrency() {
  currencyLocked = false;
}

public void setSpawn(Spawn s) {
  mySpawn = s;
}

public Spawn getSpawn() {
  return mySpawn;
}

public void addToAlive(Enemy e) {
  enemiesSpawned.add(e);
}

public void removeFromAlive(Enemy e) {
  enemiesSpawned.remove(e);
}

public void addToTowers(Tower t) {
  towersCreated.add(t);
}

public void removeFromTowers(Tower t) {
  towersCreated.remove(t);
}

public boolean isCurrencyLocked() {
  return currencyLocked;
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

  color getDefaultColor() {
    return defaultColor;
  }

  void setDefaultColor(color c) {
    defaultColor = c;
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
    if (myTile.getAgentsOn().size() > 0) {
      forceRestoreColor();
      myTile.display();
    } else {
      restoreColor();
    }
  }

  void forceDisplay() {
    if (myTile.getAgentsOn().size() > 0) {
      forceRestoreColor();
      myTile.display();
    } else {
      forceRestoreColor();
    }
  }

  void displayAgents() {
    int numAgents = myTile.getAgentsOn().size();
    String agentName = myTile.getAgentName();
    if (numAgents > 0 && !(agentName.equals(Constants.WALL))) {
      if (!Constants.GAME_NO_STROKE) {
        stroke(Constants.GAME_STROKE_COLOR);
      } else {
        noStroke();
      }
      myTile.display();
    }
  }

  void hover() {
    setColor(tileHoverColor);
  }

  void clear() {
    //if (myTile.getAgent() == null || myTile.getAgentName().equals(Constants.SPAWN)) {
    if (pathTiles.contains(myTile) || myTile.getAgentName().equals(Constants.SPAWN)) {
      fill(myColor);
      rect(x, y, Constants.PIXEL_TO_BOARD_INDEX_RATIO, Constants.PIXEL_TO_BOARD_INDEX_RATIO);
    }
  }
}

void placeWall(int x, int y) {
  if (tiles[y][x].getTile().getAgent() == null && getCurrency() >= Constants.WALL_PRICE) {
    lockCurrency();
    tiles[y][x].getTile().addAgent(Constants.WALL);
    path = god.search(mySpawn.getTile());
    if (path == null) {
      tiles[y][x].getTile().removeAgent();
    } else {
      unlockCurrency();
      removeCurrency(Constants.WALL_PRICE);  
      for (int i = 0; i < tiles.length; i++) {
        for (int u = 0; u < tiles[0].length; u++) {
          if (Constants.SHOW_PATH) {
            if (tiles[i][u].defaultColor != Constants.GAME_BACKGROUND_COLOR) {
              tiles[i][u].setDefaultColor(Constants.GAME_BACKGROUND_COLOR);
              tiles[i][u].forceDisplay();
            }
          }
        }
      }
      pathTiles.clear();
      while (path.hasParent ()) {
        Tile travelPath = path.getTile();
        if (Constants.SHOW_PATH) {
          tiles[travelPath.getY()][travelPath.getX()].setDefaultColor(Constants.GAME_PATH_COLOR);
          tiles[travelPath.getY()][travelPath.getX()].forceDisplay();
        }
        pathTiles.add(path.getTile());
        path = path.getParent();
      }
    }
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
      if (tiles[tileHoveredY][tileHoveredX] != hovered) {
        tiles[tileHoveredY][tileHoveredX].hover();
        if (hovered != null) {
          hovered.display();
        }
        hovered = tiles[tileHoveredY][tileHoveredX];
      }
      if (!newWallButtonClicked) {
        newWallButton.display();
      }
      nextRoundButton.display();
    } else if (userX > boardWidth && userX < boardWidth + Constants.SIDEBAR_WIDTH) { // User within first sidebar
      if (userY < Constants.NEW_WALL_BUTTON_HEIGHT) { // User within new wall button
        if (!newWallButtonClicked) {
          newWallButton.hover();
        }
        nextRoundButton.display();
      } else if (userY < Constants.NEW_WALL_BUTTON_HEIGHT + Constants.INFO_DISPLAY_HEIGHT) { // User within info display
        infoDisplay.hoverAction(userX, userY);
        if (!newWallButtonClicked) {
          newWallButton.display();
        }
        nextRoundButton.display();
      } else if (userY > boardHeight - Constants.NEXT_ROUND_BUTTON_HEIGHT_FROM_BOTTOM && userY < boardHeight - Constants.CURRENCY_HEIGHT_FROM_BOTTOM - Constants.ROUND_HEIGHT_ABOVE_CURRENCY) { // User within next round button
        nextRoundButton.hover();
        if (!newWallButtonClicked) {
          newWallButton.display();
        }
      } else {
        if (!newWallButtonClicked) {
          newWallButton.display();
        }
        nextRoundButton.display();
      }
    } else if (userX > boardWidth + Constants.SIDEBAR_WIDTH) { // User outside first sidebar
      if (!newWallButtonClicked) {
        newWallButton.display();
      }
      nextRoundButton.display();
    }
    if (newWallButtonClicked) {
      newWallButton.clicked();
    }
  }
}

void mouseClicked() {
  if (mouseX < boardWidth && mouseY < boardHeight) { // User within board
    if (newWallButtonClicked && !roundInProgress) {
      int tileHereX = mouseX / Constants.PIXEL_TO_BOARD_INDEX_RATIO;
      int tileHereY = mouseY / Constants.PIXEL_TO_BOARD_INDEX_RATIO;
      placeWall(tileHereX, tileHereY);
      newWallButtonClicked = false;
      cursor(ARROW);
      newWallButton.display();
      tileHoverColor = defaultTileHoverColor;
      tiles[tileHereY][tileHereX].display();
    } else {
      int tileHereX = mouseX / Constants.PIXEL_TO_BOARD_INDEX_RATIO;
      int tileHereY = mouseY / Constants.PIXEL_TO_BOARD_INDEX_RATIO;
      tiles[tileHereY][tileHereX].getTile().clickAction(mouseX, mouseY, infoDisplay);
    }
  } else if (mouseY < Constants.NEW_WALL_BUTTON_HEIGHT && !roundInProgress) { // User within new wall button
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
  } else if (mouseY < Constants.NEW_WALL_BUTTON_HEIGHT + Constants.INFO_DISPLAY_HEIGHT) { // User within InfoDisplay
    infoDisplay.clickAction(mouseX, mouseY);
  } else if (mouseY < boardHeight && mouseY > boardHeight - Constants.NEXT_ROUND_BUTTON_HEIGHT_FROM_BOTTOM) { // User within next round button
    startRound();
  }
}
