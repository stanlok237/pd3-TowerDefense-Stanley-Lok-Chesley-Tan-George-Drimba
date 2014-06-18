import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.*; 
import java.awt.Frame; 
import java.awt.event.ComponentAdapter; 
import java.awt.event.ComponentEvent; 
import java.text.NumberFormat; 
import java.util.ArrayList; 
import java.util.*; 
import java.util.ArrayList; 
import java.util.ArrayList; 

import controlP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Game extends PApplet {







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
final int defaultTileHoverColor = color(100, 100);
int tileHoverColor = defaultTileHoverColor;
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

public void setup() {
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

public void draw() {
  if (state == 0) {
    if (frame.getState() != Frame.ICONIFIED)
      frame.setState(Frame.ICONIFIED);
  } else if (state == 1) {
    if (frame.getState() != Frame.NORMAL)
      frame.setState(Frame.NORMAL);
    showCurrency();
    if (roundInProgress) {
      mySpawn.act();
      if (enemiesSpawned.size() == 0) { // Round over
        roundInProgress = false;
        round += 1;
        showRound();
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

public void setupBoard() {
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
  println("GAME OVER");
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
  fill(0xffEEEEEE);
  text("Round: " + round, boardWidth + Constants.SIDEBAR_WIDTH / 2, boardHeight - Constants.CURRENCY_HEIGHT_FROM_BOTTOM - Constants.ROUND_HEIGHT_ABOVE_CURRENCY / 2 - textAscent() * 0.1f);
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
  fill(0xffEEEEEE);
  text(s, boardWidth + Constants.SIDEBAR_WIDTH / 2, boardHeight - Constants.CURRENCY_HEIGHT_FROM_BOTTOM / 2 - textAscent() * 0.1f);
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
  int defaultColor = Constants.GAME_BACKGROUND_COLOR;
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

  public void setColor(int c) {
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

  public int getDefaultColor() {
    return defaultColor;
  }

  public void setDefaultColor(int c) {
    defaultColor = c;
  }

  public int getColor() {
    return myColor;
  }

  public void restoreColor() {
    if (myColor != defaultColor) { 
      forceRestoreColor();
    }
  }

  public void forceRestoreColor() {
    if (!Constants.GAME_NO_STROKE) {
      stroke(Constants.GAME_STROKE_COLOR);
    } else {
      noStroke();
    }
    fill(defaultColor);
    myColor = defaultColor;
    rect(x, y, Constants.PIXEL_TO_BOARD_INDEX_RATIO, Constants.PIXEL_TO_BOARD_INDEX_RATIO);
  }

  public void setTile(Tile t) {
    myTile = t;
  }

  public Tile getTile() {
    return myTile;
  }

  public void display() {
    if (myTile.getAgentsOn().size() > 0) {
      forceRestoreColor();
      myTile.display();
    } else {
      restoreColor();
    }
  }

  public void forceDisplay() {
    if (myTile.getAgentsOn().size() > 0) {
      forceRestoreColor();
      myTile.display();
    } else {
      forceRestoreColor();
    }
  }

  public void displayAgents() {
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

  public void hover() {
    setColor(tileHoverColor);
  }

  public void clear() {
    //if (myTile.getAgent() == null || myTile.getAgentName().equals(Constants.SPAWN)) {
    if (pathTiles.contains(myTile) || myTile.getAgentName().equals(Constants.SPAWN)) {
      fill(myColor);
      rect(x, y, Constants.PIXEL_TO_BOARD_INDEX_RATIO, Constants.PIXEL_TO_BOARD_INDEX_RATIO);
    }
  }
}

public void placeWall(int x, int y) {
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

public void mouseMoved() {
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

public void mouseClicked() {
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


public class AStarSearch {

  private Board board;
  private PriorityQueue<Node> frontier;
  private Base base;
  private Comparator<Node> comparator;
  private ArrayList<Tile> checkedNodes;

  public class Distance implements Comparator<Node> {

    private Base base;

    public Distance(Base b) {
      base = b;
    }

    public int compare(Node a, Node b) {
      int hDistanceA = Math.abs(a.getTile().getX() - base.getTile().getX()) + Math.abs(a.getTile().getY() - base.getTile().getY()); //Tile A Heuristic Distance
      int hDistanceB = Math.abs(b.getTile().getX() - base.getTile().getX()) + Math.abs(b.getTile().getY() - base.getTile().getY()); //Tile B Heuristic Distance
      //Get Start Location
      Node tmpa = a;
      Node tmpb = b;
      while (tmpa.hasParent ()) {
        hDistanceA++;
        tmpa = tmpa.getParent();
      }
      while (tmpb.hasParent ()) {
        hDistanceB++;
        tmpb = tmpb.getParent();
      }

      if (hDistanceA > hDistanceB) {
        return 1;
      } else if (hDistanceA == hDistanceB) {
        return 0;
      } else {
        return -1;
      }
    }
  }


  public AStarSearch(Board board) {
    this.board = board;
    base = board.getBase();
    comparator = new Distance(base);
    frontier = new PriorityQueue<Node>(10, comparator);
    checkedNodes = new ArrayList<Tile>();
  }

  public Node search(Tile start) {
    frontier.clear();
    checkedNodes.clear();
    Node s = new Node(start);
    frontier.add(s);//Initial Frontier
    while (frontier.size () > 0) {
      Node current = frontier.remove();
      if (current.getTile().equals(board.getBase().getTile())) {
        return current;
      }
      checkedNodes.add(current.getTile());
      //Making Nearby Nodes
      Node up = new Node(current, board.getUpper(current.getTile()));
      Node down = new Node(current, board.getLower(current.getTile()));
      Node left = new Node(current, board.getLeft(current.getTile()));
      Node right = new Node(current, board.getRight(current.getTile()));
      if (up.getTile() != null && !checkedNodes.contains(up.getTile()) && (up.getTile().getAgent() == null || up.getTile().getAgent().getName() == Constants.BASE))  {
        frontier.add(up);
      }
      if (down.getTile() != null && !checkedNodes.contains(down.getTile()) && (down.getTile().getAgent() == null || down.getTile().getAgent().getName() == Constants.BASE)) {
        frontier.add(down);
      }
      if (left.getTile() != null && !checkedNodes.contains(left.getTile()) && (left.getTile().getAgent() == null || left.getTile().getAgent().getName() == Constants.BASE)) {
        frontier.add(left);
      }
      if (right.getTile() != null && !checkedNodes.contains(right.getTile()) && (right.getTile().getAgent() == null || right.getTile().getAgent().getName() == Constants.BASE)) {
        frontier.add(right);
      }
    }
    return null;
  }
}
public abstract class Agent{
  
    protected Board myBoard;
    protected Tile myTile, tempTile;
    protected String myName;
    protected int xcor; // pixel coordinate
    protected int ycor; // pixel coordinate
    protected int direction; // angle between 0 and 360, counter-clockwise

    public Agent() {
      myBoard = null;
      myName = "";
    }
    
    public Agent(int x, int y){
      myTile = new Tile(x,y);
      xcor = x * Constants.PIXEL_TO_BOARD_INDEX_RATIO;
      ycor = y * Constants.PIXEL_TO_BOARD_INDEX_RATIO;
    }

    public void setBoard(Board b) {
        myBoard = b;
    }

    public void setTile(Tile t) {
        myTile = t;
        xcor = t.getX() * Constants.PIXEL_TO_BOARD_INDEX_RATIO;
        ycor = t.getY() * Constants.PIXEL_TO_BOARD_INDEX_RATIO;
    }

    public Board getBoard() {
        return myBoard;
    }
  
    public Tile getTile(){
        return myTile;
    }
    
    public Tile getTempTile(){
         return tempTile;
    }
    
    public String getName() {
      return myName;
    }
    
    public int getX() {
      return xcor;
    }
    
    public int getY() {
      return ycor;
    }
    
    public int getTileX() {
      return myTile.getX();
    }
    
    public int getTileY() {
      return myTile.getY();
    }
    
    public void setX(int x) {
      xcor = x;
    }
    
    public void setY(int y) {
      ycor = y;
    }
    
    public int getDirection() {
      return direction;
    }
    
    public void setDirection(int angle) {
      angle = angle % 360;
      direction = angle;
    }
    
    public void updateTile(String in){
      if(in.equals("u")){
        myTile.removeAgentOn(this);
        myTile = myBoard.getUpper(myTile);
        myTile.addAgentOn(this);
      }
      else if(in.equals("d")){
        myTile.removeAgentOn(this);
        myTile = myBoard.getLower(myTile);
        myTile.addAgentOn(this);
      }
      else if(in.equals("l")){
        myTile.removeAgentOn(this);
        myTile = myBoard.getLeft(myTile);
        myTile.addAgentOn(this);
      }
      else if(in.equals("r")){
        myTile.removeAgentOn(this);
        myTile = myBoard.getRight(myTile);
        myTile.addAgentOn(this);
      }
    }
    
    public abstract boolean inBody(int x, int y);

    public abstract String toString();
    public abstract void display();
    public abstract void act();
}
public class Alien extends Enemy {
  //tank
  public Alien(int level, Tile t, Board b) {
    super(t, b , 400 + 100 * level, 2, 10 + 1 * level, 50 * level, 7 * level, "Alien" );
  }

  public boolean inBody(int x, int y) {
    return (x > xcor && x < xcor + Constants.PIXEL_TO_BOARD_INDEX_RATIO * .5f && y > ycor && y < ycor + Constants.PIXEL_TO_BOARD_INDEX_RATIO * .5f);
  }

  public void display() {
    fill(0, 7, 77);
    quad(xcor + .75f * Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor + .25f * Constants.PIXEL_TO_BOARD_INDEX_RATIO, xcor + .25f * Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor + .75f * Constants.PIXEL_TO_BOARD_INDEX_RATIO, xcor + .75f * Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor + Constants.PIXEL_TO_BOARD_INDEX_RATIO, xcor + Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor + .75f * Constants.PIXEL_TO_BOARD_INDEX_RATIO);
    generateHealthBar();
  }

  public String toString() {
    String n = super.getName();
    int h = super.getHealth();
    int mh = super.getMaxHealth();
    int s = super.getSpeed();
    int a = super.getArmor();
    return n + ": " + h + " / " + mh + "\nSpeed: "  + s + "\nArmor: " + a;
  }
}
public class Base extends Agent {

  private int maxHealth, currentHealth, level;

  public Base(int health) {
    myName = Constants.BASE;
    maxHealth = health;
    currentHealth = health;
    level = 1;
  }

  public int getHealth() {
    return currentHealth;
  }

  public int getMaximumHealth() {
    return maxHealth;
  }

  public int getLevel() {
    return level;
  }

  public int takeDamage(int change) {
    currentHealth -= change;
    display();
    if (currentHealth <= 0) {
      myBoard.getParent().gameOver();
    }
    return -1;
  }

  public int getUpgradePrice() {
    return level * 1000;
  }

  public void upgrade(String type) {
    if (type.equals("Health")) {
      int upgradePrice = getUpgradePrice();
      if (myBoard.getParent().getCurrency() >= upgradePrice) {
        myBoard.getParent().removeCurrency(upgradePrice);
        maxHealth += 100 + level * 10;
        level++;
        currentHealth = maxHealth;
      }
    }
  }


  public void replenishHealth() {
    currentHealth = maxHealth;
  }

  public String toString() {
    return "Base: " + currentHealth + " / " + maxHealth;
  }

  public int getManDistance(Agent other) {
    Tile baseTile = getTile();
    Tile otherTile = other.getTile();
    return Math.abs(baseTile.getY() - otherTile.getY()) + Math.abs(baseTile.getX() + otherTile.getX());
  }

  public void act() {
  }

  public void generateHealthBar() {
    float perc = 1.0f * currentHealth / maxHealth;
    int length = round(perc * Constants.PIXEL_TO_BOARD_INDEX_RATIO);
    fill(50, 200, 0, 100);
    rect(xcor, ycor, length, round(Constants.PIXEL_TO_BOARD_INDEX_RATIO * Constants.BASE_HEALTH_BAR_HEIGHT_PERCENTAGE));
  }

  public void display() {
    if (Constants.GAME_NO_STROKE) {
      noStroke();
    }
    else {
      stroke(Constants.GAME_STROKE_COLOR);
    }
    fill(0, 0, 200, 100);
    rect(xcor, ycor, Constants.PIXEL_TO_BOARD_INDEX_RATIO, Constants.PIXEL_TO_BOARD_INDEX_RATIO);
    generateHealthBar();
  }

  public boolean inBody(int x, int y) {
    return (x > xcor && x < xcor + Constants.PIXEL_TO_BOARD_INDEX_RATIO && y > ycor && y < ycor + Constants.PIXEL_TO_BOARD_INDEX_RATIO);
  }
}
public class Bat extends Enemy {

  public Bat(int level, Tile t, Board b) {
    super(t, b, 60 + 10 * level, 4, 0, 3 * level, 5 * level, "Bat" );
  }

  public boolean inBody(int x, int y) {
    return (x > xcor && x < xcor + Constants.PIXEL_TO_BOARD_INDEX_RATIO * .5f && y > ycor && y < ycor + Constants.PIXEL_TO_BOARD_INDEX_RATIO * .5f);
  }

  public void display() {
    fill(139, 69, 19);
    quad(xcor + .5f * Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor + .25f*Constants.PIXEL_TO_BOARD_INDEX_RATIO, xcor + .25f * Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor + .5f * Constants.PIXEL_TO_BOARD_INDEX_RATIO, xcor + .75f * Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor + .5f * Constants.PIXEL_TO_BOARD_INDEX_RATIO, xcor + .5f * Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor + .75f * Constants.PIXEL_TO_BOARD_INDEX_RATIO);
    generateHealthBar();
  }

  public String toString() {
    String n = super.getName();
    int h = super.getHealth();
    int mh = super.getMaxHealth();
    int s = super.getSpeed();
    int a = super.getArmor();
    return n + ": " + h + " / " + mh + "\nSpeed: "  + s + "\nArmor: " + a;
  }
}
private Game parent;
public class Board {
  Tile[][] board;
  int numRows, numCols;
  int defaultSize = 20;
  Base base;

  public Board(Game p) {
    parent = p;
  }

  public Board(int s, Game p) {
    numRows = numCols = s;
    board = new Tile[numRows][numCols];
    for (int i = 0; i < numRows; i++) {
      for (int j = 0; j < numCols; j++) {
        board[i][j] = new Tile(i, j);
        board[i][j].setBoard(this);
      }
    }
    parent = p;
  }

  public Board(int r, int c, Game p) {
    numRows = r;
    numCols = c;
    board = new Tile[numRows][numCols];
    for (int i = 0; i < numRows; i++) {
      for (int j = 0; j < numCols; j++) {
        board[i][j] = new Tile(i, j);
        board[i][j].setBoard(this);
      }
    }
    parent = p;
  }

  public Tile get(int r, int c) {
    return board[r][c];
  }

  public void set(int r, int c, Tile t) {
    board[r][c] = t;
  }
  
  public Base getBase() {
    return base;
  }

  public int getRows() {
    return numRows;
  }

  public int getCols() {
    return numCols;
  }
  
  public Game getParent() {
    return parent;
  }

  public void loadMap(String file) {
    String[] d = loadStrings(file);
    numRows = Integer.parseInt(d[0].split(" ")[0]);
    numCols = Integer.parseInt(d[0].split(" ")[1]);
    board = new Tile[numRows][numCols];
    int row = 0;
    for (int i = 1; i < d.length; i++) {
      String[] objects = d[i].split(" ");
      for (int u = 0; u < objects.length; u++) {
        board[row][u] = new Tile(u, row);
        board[row][u].setBoard(this);
        board[row][u].addAgent(objects[u]);
        if (objects[u].equals(Constants.BASE)) {
          base = (Base)(board[row][u].getAgent());
        }
      }
      row++;
    }
  }

  public boolean tileInBounds(Tile t) {
    int otherX = t.getX();
    int otherY = t.getY();
    return !(otherX < 0 || otherX > numCols - 1 || otherY < 0 || otherY > numRows - 1);
  }

  public boolean tileInBounds(int x, int y) {
    return !(x < 0 || x > numCols - 1 || y < 0 || y > numRows - 1);
  }

  public Tile getLeft(Tile t) {
    if (tileInBounds(t.getX() - 1, t.getY())) {
      return board[t.getY()][t.getX() - 1];
    }
    return null;
  }

  public Tile getRight(Tile t) {
    if (tileInBounds(t.getX() + 1, t.getY())) {
      return board[t.getY()][t.getX() + 1];
    }
    return null;
  }

  public Tile getUpper(Tile t) {
    if (tileInBounds(t.getX(), t.getY() - 1)) {
      return board[t.getY() - 1][t.getX()];
    }
    return null;
  }

  public Tile getLower(Tile t) {
    if (tileInBounds(t.getX(), t.getY() + 1)) {
      return board[t.getY() + 1][t.getX()];
    }
    return null;
  }

  public boolean isValidTile(Tile t) {
    if (tileInBounds(t)) {
      return (board[t.getY()][t.getX()].equals(t));
    }
    return false;
  }

  public String toString() {
    String retStr = "";
    for (int r = 0; r < board.length; r++) {
      for (int c = 0; c < board[0].length; c++) {
        retStr += board[r][c] + " ";
      }
      retStr += "\n";
    }
    return retStr;
  }
}
public class Cannon extends Tower {

  public Cannon (Tile t) {
    super(t, 3, 5, 5, 100, 65, "Cannon", Constants.TURRET_EFFECT);
  }

  public String toString() {
    String n = getName();
    String e = getEffect();
    int d = getDamage();
    int s = getSpeed();
    int r = getRange();
    return n + "\nDamage: " + d + "\nSpeed: " + s + "\nRange: " + r + "\nEffect: " + e;
  }

  public void act() {

  }

  public boolean inBody(int x, int y) {
    return true;
  }

  public void display() {
    fill(40, 75, 150);
    //Isoceles Triangle Shaped
    triangle(xcor, ycor + Constants.PIXEL_TO_BOARD_INDEX_RATIO, xcor + Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor + Constants.PIXEL_TO_BOARD_INDEX_RATIO, xcor + .5f * Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor);
  }

  public void upgrade() {
    if (upgradePrice < myBoard.getParent().getCurrency()) {
      myBoard.getParent().removeCurrency(upgradePrice);
      int lev = getLevel();
      upRange(4 + 1 * lev);
      upDamage(13 + 2 * lev);
      upSpeed(2 + 1*lev);
      upUpgradePrice(50 + 25 * lev);
      upSellPrice();
      upLevel();
    }
  }
}
public static class Constants {
  public static int PIXEL_TO_BOARD_INDEX_RATIO = 40;
  public static int GAME_BACKGROUND_COLOR = 20;
  public static int GAME_STROKE_COLOR = 1;
  public static int GAME_PATH_COLOR = 90;
  public static int GAME_STROKE_WEIGHT = 1;
  public static boolean GAME_NO_STROKE = true;
  public static boolean SHOW_PATH = true;
  public static int SIDEBAR_WIDTH = 200;
  public static int NEW_WALL_BUTTON_HEIGHT = 100;
  public static int NEW_WALL_BUTTON_TEXT_SIZE = 20;
  public static int INFO_DISPLAY_HEIGHT = 300;
  public static int INFO_TEXT_SIZE = 16;
  public static int CURRENCY_HEIGHT_FROM_BOTTOM = 50;
  public static int CURRENCY_TEXT_SIZE = 14;
  public static int ROUND_HEIGHT_ABOVE_CURRENCY = 50;
  public static int ROUND_TEXT_SIZE = 14;
  public static int NEXT_ROUND_BUTTON_HEIGHT_FROM_BOTTOM = 150;
  public static int NEXT_ROUND_BUTTON_HEIGHT = 50;
  public static int NEXT_ROUND_BUTTON_TEXT_SIZE = 16;
  public static int WALL_PRICE = 100;
  public static int TURRET_PRICE = 100;
  public static int CANNON_PRICE = 200;
  public static int RAY_GUN_PRICE = 1000;
  public static float BASE_HEALTH_BAR_HEIGHT_PERCENTAGE = 0.3f;
  public static float HEALTH_BAR_HEIGHT_PERCENTAGE = 0.1f;
  public static String SPAWN = "s";
  public static String WALL = "w";
  public static String PATH = "p";
  public static String BASE = "b";
  public static String TURRET = "t";
  public static String CANNON = "c";
  public static String RAY_GUN = "r";
  public static String TURRET_EFFECT = "none";
  public static String RAYGUN_EFFECT = "shred/slow";
  public static String CANNON_EFFECT = "shred";
  public static String ICE_EFFECT = "slow";
  public static String POISON_EFFECT = "poison";
  public static String TESLA_EFFECT = "stop";
}
public abstract class Enemy extends Agent {

  protected int currentHealth, maxHealth, currentSpeed, maxSpeed, currentArmor, maxArmor, damage, reward;
  protected AStarSearch search;
  protected Stack<Tile> path;
  protected boolean isDead = false;

  public Enemy(Tile t, Board b, int health, int speed, int armor, int damage, int value, String name) {
    setTile(t);
    setBoard(b);
    maxHealth = health;
    currentHealth = maxHealth;
    maxSpeed = speed;
    currentSpeed = maxSpeed;
    maxArmor = armor;
    currentArmor = maxArmor;
    this.damage = damage;
    reward = value;
    myName = name;
    search = new AStarSearch(myBoard);
    Node tmp =  search.search(myTile);
    path = new Stack<Tile>();
    while (tmp != null) {
      //println(tmp);
      path.add(tmp.getTile());
      tmp = tmp.getParent();
    }
    path.pop();
  }
  public int getHealth() {
    return currentHealth;
  }

  public int getSpeed() {
    return currentSpeed;
  }

  public int getArmor() {
    return currentArmor;
  }

  public int getDamage() {
    return damage;
  }

  public int getMaxHealth() {
    return maxHealth;
  }

  public int getMaxSpeed() {
    return maxSpeed;
  }

  public int getMaxArmor() {
    return maxArmor;
  }

  public int getReward() {
    return reward;
  }

  public void takeDamage(int d) {
    if (currentHealth - d <= 0) {
      currentHealth = currentHealth - d;
      die();
    } else {
      currentHealth = currentHealth - d;
      println(currentHealth);
    }
  }

  public void die() {
    getTile().removeAgentOn(this);
    //myBoard.getParent().removeFromAlive(this); This is done in the Tower's shoot() method to prevent a concurrent modification error
    myBoard.getParent().addCurrency(reward);
    isDead = true;
  }

  public boolean isDead() {
    return isDead;
  }

  public void slow(int s) {
    if (currentSpeed - s < 5) {
      currentSpeed = 5;
    } else {
      currentSpeed = currentSpeed - s;
    }
  }
  public void shredArmor(int a) {
    if (currentArmor - a < 0) {
      currentArmor = 0;
    } else {
      currentArmor = currentArmor - a;
    }
  }

  public void generateHealthBar() {
    float perc = 1.0f * currentHealth / maxHealth;
    int length = round(perc * Constants.PIXEL_TO_BOARD_INDEX_RATIO / 2);
    fill(50, 200, 0, 100);
    rect(xcor + .25f * Constants.PIXEL_TO_BOARD_INDEX_RATIO , ycor + .25f * Constants.PIXEL_TO_BOARD_INDEX_RATIO, length, round(Constants.PIXEL_TO_BOARD_INDEX_RATIO * Constants.HEALTH_BAR_HEIGHT_PERCENTAGE));
  }

  public Stack<Tile> getPath() {
    return path;
  }

  public void act() {
    if (!path.empty()) {
      if (currentHealth <= 0) {
        die();
      } else {
        move();
      }
    } else {
      myBoard.getBase().takeDamage(damage);
      getTile().removeAgentOn(this);
      isDead = true;
    }
  }

  public void move() {
    Tile next = path.peek();
    if (next.getY() < myTile.getY()) {
      if (ycor - currentSpeed < (myTile.getY() - 1)* (Constants.PIXEL_TO_BOARD_INDEX_RATIO)) {
        path.pop();
        updateTile("u");
      }
      ycor -= currentSpeed;
    } else if (next.getY() > myTile.getY()) {
      if (ycor + currentSpeed > (myTile.getY() + 1) * (Constants.PIXEL_TO_BOARD_INDEX_RATIO)) {
        path.pop();
        updateTile("d");
      }
      ycor += currentSpeed;
    } else if (next.getX() < myTile.getX()) {
      if (xcor - currentSpeed < (myTile.getX() - 1) * (Constants.PIXEL_TO_BOARD_INDEX_RATIO)) {
        path.pop();
        updateTile("l");
      }
      xcor -= currentSpeed;
    } else if (next.getX() > myTile.getX()) {
      if (xcor + currentSpeed > (myTile.getX() + 1) * (Constants.PIXEL_TO_BOARD_INDEX_RATIO)) {
        path.pop();
        updateTile("r");
      }
      xcor += currentSpeed;
    }
  }
}
public class Giant extends Enemy {

  public Giant(int level, Tile t, Board b) {
    super(t, b , 400 + 300 * level, 1, 10 + 1 * level, 50 * level, level * 10, "Giant" );
  }

  public boolean inBody(int x, int y) {
    return (x > xcor && x < xcor + Constants.PIXEL_TO_BOARD_INDEX_RATIO && y > ycor && y < ycor + Constants.PIXEL_TO_BOARD_INDEX_RATIO);
  }

  public void display() {
    fill(0, 7, 77);
    quad(xcor + .5f * Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor, xcor, ycor + .5f * Constants.PIXEL_TO_BOARD_INDEX_RATIO, xcor + .5f * Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor + Constants.PIXEL_TO_BOARD_INDEX_RATIO, xcor + Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor + .5f * Constants.PIXEL_TO_BOARD_INDEX_RATIO);
    generateHealthBar();
  }

  public String toString() {
    String n = super.getName();
    int h = super.getHealth();
    int mh = super.getMaxHealth();
    int s = super.getSpeed();
    int a = super.getArmor();
    return n + ": " + h + " / " + mh + "\nSpeed: "  + s + "\nArmor: " + a;
  }

  public void generateHealthBar() {
    int current = super.getHealth();
    int max = super.getMaxHealth();
    float perc = 1.0f * current / max;
    int length = round(perc * Constants.PIXEL_TO_BOARD_INDEX_RATIO);
    fill(50, 200, 0, 100);
    rect(xcor, ycor, length, round(Constants.PIXEL_TO_BOARD_INDEX_RATIO * Constants.HEALTH_BAR_HEIGHT_PERCENTAGE));
  }
  
}
public class Grunt extends Enemy {

  public Grunt (int level, Tile t, Board b) {
    super(t, b, 100 + 50 * level, 1, 0, 10 * level, 15 + 5 * level, "Grunt" );
  }

  public String toString() {
    String n = super.getName();
    int h = super.getHealth();
    int mh = super.getMaxHealth();
    int s = super.getSpeed();
    int a = super.getArmor();
    return n + ": " + h + " / " + mh + "\nSpeed: "  + s + "\nArmor: " + a;
  }

  public void generateHealthBar() {
    float perc = 1.0f * currentHealth / maxHealth;
    int length = round(perc * Constants.PIXEL_TO_BOARD_INDEX_RATIO / 2);
    fill(50, 200, 0, 100);
    rect(xcor + .25f * Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor + .25f* Constants.PIXEL_TO_BOARD_INDEX_RATIO, length, round(Constants.PIXEL_TO_BOARD_INDEX_RATIO * Constants.HEALTH_BAR_HEIGHT_PERCENTAGE));
  }

  public void display() {
    fill(20, 150, 175);
    triangle(xcor + 0.25f * Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor + 0.25f * Constants.PIXEL_TO_BOARD_INDEX_RATIO, xcor + 0.75f * Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor + .25f * Constants.PIXEL_TO_BOARD_INDEX_RATIO, xcor + 0.5f * Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor + 0.75f * Constants.PIXEL_TO_BOARD_INDEX_RATIO);
    generateHealthBar();
  }

  public boolean inBody(int x, int y) {
    return (x > xcor && x < xcor + Constants.PIXEL_TO_BOARD_INDEX_RATIO * .5f && y > ycor && y < ycor + Constants.PIXEL_TO_BOARD_INDEX_RATIO * .5f);
  }
}
public class GuiButton {
  String myText;
  int x, y, myHeight, myWidth, borderTopLeft, borderTopRight, borderBottomRight, borderBottomLeft;
  int myColor, myTextColor, myHoverColor, myHoverTextColor, myClickedColor, myClickedTextColor, currentColor, currentTextColor;
  int myTextSize;
  boolean noStroke = true;
  Agent myAgent;
  InfoDisplay idParent;

  public GuiButton() {
  
  }
  
  public GuiButton(InfoDisplay id) {
    idParent = id;
  }

  public void setText(String s) {
    myText = s;
  }

  public String getText() {
    return myText;
  }

  public void setX(int n) {
    x = n;
  }

  public void setY(int n) {
    y = n;
  }

  public int getX() {
    return x;
  }

  public int getY() {
    return y;
  }

  public void setColor(int c) {
    myColor = c;
  }

  public int getColor() {
    return myColor;
  }

  public void setHoverColor(int c) {
    myHoverColor = c;
  }

  public int getHoverColor() {
    return myHoverColor;
  }

  public void setClickedColor(int c) {
    myClickedColor = c;
  }

  public int getClickedColor() {
    return myClickedColor;
  }

  public void setTextColor(int c) {
    myTextColor = c;
  }

  public int getTextColor() {
    return myTextColor;
  }

  public void setHoverTextColor(int c) {
    myHoverTextColor = c;
  }

  public int getHoverTextColor() {
    return myHoverTextColor;
  }

  public void setClickedTextColor(int c) {
    myClickedTextColor = c;
  }

  public int getClickedTextColor() {
    return myClickedTextColor;
  }

  public void setHeight(int n) {
    myHeight = n;
  }

  public int getHeight() {
    return myHeight;
  }

  public void setWidth(int n) {
    myWidth = n;
  }

  public int getWidth() {
    return myWidth;
  }
  
  public void setBorders(int tl, int tr, int br, int bl) {
    borderTopLeft = tl;
    borderTopRight = tr;
    borderBottomRight = br;
    borderBottomLeft = bl;
  }

  public void setTextSize(int n) {
    myTextSize = n;
  }

  public int getTextSize() {
    return myTextSize;
  }

  public void setStroke(boolean b) {
    noStroke = !b;
  }
  
  public void attachAgent(Agent a) {
    myAgent = a;
  }
  
  public Agent getAttachedAgent() {
    return myAgent;
  }

  public void hover() {
    if (currentColor != myHoverColor || currentTextColor != myHoverTextColor) {
      if (noStroke) {
        noStroke();
      }
      else {
        stroke(Constants.GAME_STROKE_COLOR);
      }
      clear();
      fill(myHoverColor);
      currentColor = myHoverColor;
      rect(x, y, myWidth, myHeight, borderTopLeft, borderTopRight, borderBottomRight, borderBottomLeft);
      textAlign(CENTER, CENTER);
      fill(myHoverTextColor);
      currentTextColor = myHoverTextColor;
      textSize(myTextSize);
      text(myText, x + myWidth / 2, y + myHeight / 2 - textAscent() * 0.1f); //hacky fix for inaccurate default centering
    }
    cursor(HAND);
  }

  public void clicked() {
    if (currentColor != myClickedColor || currentTextColor != myClickedTextColor) {
      if (noStroke) {
        noStroke();
      }
      else {
        stroke(Constants.GAME_STROKE_COLOR);
      }
      clear();
      fill(myClickedColor);
      currentColor = myClickedColor;
      rect(x, y, myWidth, myHeight, borderTopLeft, borderTopRight, borderBottomRight, borderBottomLeft);
      textAlign(CENTER, CENTER);
      fill(myClickedTextColor);
      currentTextColor = myClickedTextColor;
      textSize(myTextSize);
      text(myText, x + myWidth / 2, y + myHeight / 2 - textAscent() * 0.1f);
    }
  }

  public void display() {
    if (currentColor != myColor || currentTextColor != myTextColor) {
      forceDisplay();
    }
  }

  public void forceDisplay() {
    if (noStroke) {
      noStroke();
    }
    else {
        stroke(Constants.GAME_STROKE_COLOR);
      }
    clear();
    fill(myColor);
    currentColor = myColor;
    rect(x, y, myWidth, myHeight, borderTopLeft, borderTopRight, borderBottomRight, borderBottomLeft);
    textAlign(CENTER, CENTER);
    fill(myTextColor);
    currentTextColor = myTextColor;
    textSize(myTextSize);
    text(myText, x + myWidth / 2, y + myHeight / 2 - textAscent() * 0.1f);
    cursor(ARROW);
  }

  public void clear() {
    fill(0);
    rect(x, y, myWidth, myHeight, borderTopLeft, borderTopRight, borderBottomRight, borderBottomLeft);
  }

  public void clickAction() {
  }
}

public class InfoDisplay {
  Game parent;
  int INFO_TEXT_COLOR = color(50, 220, 0, 250);
  ArrayList<GuiButton> myButtons;

  public InfoDisplay(Game p) {
    parent = p;
    myButtons = new ArrayList<GuiButton>();
  }
  public void showInfo(Agent a) {
    myButtons = new ArrayList<GuiButton>();
    noStroke();
    if (a == null) {
      clear();
    } else {
      String name = a.getClass().getName();
      name = name.substring(name.indexOf("$") + 1);
      String id = a.getName();
      clear();
      fill(INFO_TEXT_COLOR);
      textSize(Constants.INFO_TEXT_SIZE + 6);
      textAlign(CENTER, CENTER);
      if (id.equals(Constants.BASE)) {
        text(name, parent.boardWidth + Constants.SIDEBAR_WIDTH / 2, Constants.NEW_WALL_BUTTON_HEIGHT + Constants.INFO_DISPLAY_HEIGHT / 6);
        textSize(Constants.INFO_TEXT_SIZE);
        Base b = (Base)a;
        text("Health: " + b.getHealth(), parent.boardWidth + Constants.SIDEBAR_WIDTH / 2, Constants.NEW_WALL_BUTTON_HEIGHT + 2 * Constants.INFO_DISPLAY_HEIGHT / 6);
        text("Level: " + b.getLevel(), parent.boardWidth + Constants.SIDEBAR_WIDTH / 2, Constants.NEW_WALL_BUTTON_HEIGHT + 3 * Constants.INFO_DISPLAY_HEIGHT / 6);
        GuiButton upgradeButton = new GuiButton(this) {
          @Override
            public void clickAction() {
            ((Base)myAgent).upgrade("Health");
            idParent.showInfo(myAgent);
            idParent.getButtons().get(0).hover(); // hover effect on the new button created
          }
        };
        myButtons.add(upgradeButton);
        upgradeButton.attachAgent(b);
        upgradeButton.setStroke(false);
        upgradeButton.setColor(color(25, 25, 200, 180));
        upgradeButton.setHoverColor(color(50, 50, 225, 100));
        upgradeButton.setY(Constants.NEW_WALL_BUTTON_HEIGHT + 4 * Constants.INFO_DISPLAY_HEIGHT / 6);
        upgradeButton.setHeight(Constants.INFO_DISPLAY_HEIGHT / 8);
        upgradeButton.setBorders(7, 7, 7, 7);
        upgradeButton.setTextColor(color(200));
        upgradeButton.setHoverTextColor(color(240));
        String upgradeString = "Upgrade ($" + b.getUpgradePrice() + ")";
        upgradeButton.setText(upgradeString);
        upgradeButton.setWidth(ceil(textWidth(upgradeString)) + 10);
        upgradeButton.setX(parent.boardWidth + (Constants.SIDEBAR_WIDTH - upgradeButton.getWidth()) / 2);
        upgradeButton.setTextSize(14);
        upgradeButton.forceDisplay();
      } else if (id.equals(Constants.WALL)) {
        Wall w = (Wall)a;
        Tower t = w.getTower();
        if (t != null) {
          showInfo(t);
        } else { 
          text(name, parent.boardWidth + Constants.SIDEBAR_WIDTH / 2, Constants.NEW_WALL_BUTTON_HEIGHT + Constants.INFO_DISPLAY_HEIGHT / 6);
          textSize(Constants.INFO_TEXT_SIZE);
          GuiButton turretButton = new GuiButton(this) {
            @Override
              public void clickAction() {
              if (!idParent.getParent().isCurrencyLocked() && idParent.getParent().getCurrency() >= Constants.TURRET_PRICE) {
                idParent.getParent().removeCurrency(Constants.TURRET_PRICE);
                Wall w = (Wall)myAgent;
                myAgent.getTile().addAgent(Constants.TURRET);
                idParent.getParent().addToTowers(w.getTower());
                idParent.showInfo(w.getTower());
                int x = myAgent.getTile().getX();
                int y= myAgent.getTile().getY();
                idParent.getParent().tiles[y][x].forceDisplay();
                idParent.getButtons().get(0).hover(); // hover effect on the new button created
              }
            }
          };
          myButtons.add(turretButton);
          turretButton.attachAgent(w);
          turretButton.setStroke(false);
          turretButton.setColor(color(25, 25, 200, 180));
          turretButton.setHoverColor(color(50, 50, 225, 100));
          turretButton.setY(Constants.NEW_WALL_BUTTON_HEIGHT + 2 * Constants.INFO_DISPLAY_HEIGHT / 6);
          turretButton.setHeight(Constants.INFO_DISPLAY_HEIGHT / 8);
          turretButton.setBorders(7, 7, 7, 7);
          turretButton.setTextColor(color(200));
          turretButton.setHoverTextColor(color(240));
          String turretString = "Turret ($" + Constants.TURRET_PRICE + ")";
          turretButton.setText(turretString);
          turretButton.setWidth(ceil(textWidth(turretString)) + 10);
          turretButton.setX(parent.boardWidth + (Constants.SIDEBAR_WIDTH - turretButton.getWidth()) / 2);
          turretButton.setTextSize(14);
          turretButton.forceDisplay();
          GuiButton cannonButton = new GuiButton(this) {
            @Override
              public void clickAction() {
              if (!idParent.getParent().isCurrencyLocked() && idParent.getParent().getCurrency() >= Constants.CANNON_PRICE) {
                idParent.getParent().removeCurrency(Constants.CANNON_PRICE);
                Wall w = (Wall)myAgent;
                myAgent.getTile().addAgent(Constants.CANNON);
                idParent.getParent().addToTowers(w.getTower());
                idParent.showInfo(w.getTower());
                int x = myAgent.getTile().getX();
                int y= myAgent.getTile().getY();
                idParent.getParent().tiles[y][x].forceDisplay();
                idParent.getButtons().get(0).hover(); // hover effect on the new button created
              }
            }
          };
          myButtons.add(cannonButton);
          cannonButton.attachAgent(w);
          cannonButton.setStroke(false);
          cannonButton.setColor(color(25, 25, 200, 180));
          cannonButton.setHoverColor(color(50, 50, 225, 100));
          cannonButton.setY(Constants.NEW_WALL_BUTTON_HEIGHT + 3 * Constants.INFO_DISPLAY_HEIGHT / 6);
          cannonButton.setHeight(Constants.INFO_DISPLAY_HEIGHT / 8);
          cannonButton.setBorders(7, 7, 7, 7);
          cannonButton.setTextColor(color(200));
          cannonButton.setHoverTextColor(color(240));
          String cannonString = "Cannon ($" + Constants.CANNON_PRICE + ")";
          cannonButton.setText(cannonString);
          cannonButton.setWidth(ceil(textWidth(cannonString)) + 10);
          cannonButton.setX(parent.boardWidth + (Constants.SIDEBAR_WIDTH - cannonButton.getWidth()) / 2);
          cannonButton.setTextSize(14);
          cannonButton.forceDisplay();
          GuiButton rayButton = new GuiButton(this) {
            @Override
              public void clickAction() {
              if (!idParent.getParent().isCurrencyLocked() && idParent.getParent().getCurrency() >= Constants.RAY_GUN_PRICE) {
                idParent.getParent().removeCurrency(Constants.RAY_GUN_PRICE);
                Wall w = (Wall)myAgent;
                myAgent.getTile().addAgent(Constants.RAY_GUN);
                idParent.getParent().addToTowers(w.getTower());
                idParent.showInfo(w.getTower());
                int x = myAgent.getTile().getX();
                int y= myAgent.getTile().getY();
                idParent.getParent().tiles[y][x].forceDisplay();
                idParent.getButtons().get(0).hover(); // hover effect on the new button created
              }
            }
          };
          myButtons.add(rayButton);
          rayButton.attachAgent(w);
          rayButton.setStroke(false);
          rayButton.setColor(color(25, 25, 200, 180));
          rayButton.setHoverColor(color(50, 50, 225, 100));
          rayButton.setY(Constants.NEW_WALL_BUTTON_HEIGHT + 4 * Constants.INFO_DISPLAY_HEIGHT / 6);
          rayButton.setHeight(Constants.INFO_DISPLAY_HEIGHT / 8);
          rayButton.setBorders(7, 7, 7, 7);
          rayButton.setTextColor(color(200));
          rayButton.setHoverTextColor(color(240));
          String rayString = "Ray Gun ($" + Constants.RAY_GUN_PRICE + ")";
          rayButton.setText(rayString);
          rayButton.setWidth(ceil(textWidth(rayString)) + 10);
          rayButton.setX(parent.boardWidth + (Constants.SIDEBAR_WIDTH - rayButton.getWidth()) / 2);
          rayButton.setTextSize(14);
          rayButton.forceDisplay();
        }
      } else if (a instanceof Enemy) {
        text(name, parent.boardWidth + Constants.SIDEBAR_WIDTH / 2, Constants.NEW_WALL_BUTTON_HEIGHT + Constants.INFO_DISPLAY_HEIGHT / 6);
        textSize(Constants.INFO_TEXT_SIZE);
        Enemy e = (Enemy)a;
        text("Health: " + e.getHealth(), parent.boardWidth + Constants.SIDEBAR_WIDTH / 2, Constants.NEW_WALL_BUTTON_HEIGHT + 2 * Constants.INFO_DISPLAY_HEIGHT / 6);
        text("Speed: " + e.getSpeed(), parent.boardWidth + Constants.SIDEBAR_WIDTH / 2, Constants.NEW_WALL_BUTTON_HEIGHT + 3 * Constants.INFO_DISPLAY_HEIGHT / 6);
        text("Armor: " + e.getArmor(), parent.boardWidth + Constants.SIDEBAR_WIDTH / 2, Constants.NEW_WALL_BUTTON_HEIGHT + 4 * Constants.INFO_DISPLAY_HEIGHT / 6);
        text("Damage: " + e.getDamage(), parent.boardWidth + Constants.SIDEBAR_WIDTH / 2, Constants.NEW_WALL_BUTTON_HEIGHT + 5 * Constants.INFO_DISPLAY_HEIGHT / 6);
      } else if (a instanceof Tower) {
        text(name, parent.boardWidth + Constants.SIDEBAR_WIDTH / 2, Constants.NEW_WALL_BUTTON_HEIGHT + Constants.INFO_DISPLAY_HEIGHT / 8);
        textSize(Constants.INFO_TEXT_SIZE);
        Tower t = (Tower)a;
        text("Damage: " + t.getDamage(), parent.boardWidth + Constants.SIDEBAR_WIDTH / 2, Constants.NEW_WALL_BUTTON_HEIGHT + 2 * Constants.INFO_DISPLAY_HEIGHT / 8);
        text("Range: " + t.getRange(), parent.boardWidth + Constants.SIDEBAR_WIDTH / 2, Constants.NEW_WALL_BUTTON_HEIGHT + 3 * Constants.INFO_DISPLAY_HEIGHT / 8);
        text("Speed: " + t.getSpeed(), parent.boardWidth + Constants.SIDEBAR_WIDTH / 2, Constants.NEW_WALL_BUTTON_HEIGHT + 4 * Constants.INFO_DISPLAY_HEIGHT / 8);
        text("Level: " + t.getLevel(), parent.boardWidth + Constants.SIDEBAR_WIDTH / 2, Constants.NEW_WALL_BUTTON_HEIGHT + 5 * Constants.INFO_DISPLAY_HEIGHT / 8);
        GuiButton upgradeButton = new GuiButton(this) {
          @Override
            public void clickAction() {
            ((Tower)myAgent).upgrade();
            idParent.showInfo(myAgent);
            idParent.getButtons().get(0).hover(); // hover effect on the new button created
          }
        };
        myButtons.add(upgradeButton);
        upgradeButton.attachAgent(t);
        upgradeButton.setStroke(false);
        upgradeButton.setColor(color(25, 25, 200, 180));
        upgradeButton.setHoverColor(color(50, 50, 225, 100));
        upgradeButton.setY(Constants.NEW_WALL_BUTTON_HEIGHT + 6 * Constants.INFO_DISPLAY_HEIGHT / 8);
        upgradeButton.setHeight(Constants.INFO_DISPLAY_HEIGHT / 9);
        upgradeButton.setBorders(7, 7, 7, 7);
        upgradeButton.setTextColor(color(200));
        upgradeButton.setHoverTextColor(color(240));
        String upgradeString = "Upgrade ($" + t.getUpgradePrice() + ")";
        upgradeButton.setText(upgradeString);
        textSize(14);
        upgradeButton.setWidth(ceil(textWidth(upgradeString)) + 10);
        upgradeButton.setX(parent.boardWidth + (Constants.SIDEBAR_WIDTH - upgradeButton.getWidth()) / 2);
        upgradeButton.setTextSize(14);
        upgradeButton.forceDisplay();

        GuiButton sellButton = new GuiButton(this) {
          @Override
            public void clickAction() {
            ((Tower)myAgent).sell();
            int agentX = myAgent.getTile().getX();
            int agentY = myAgent.getTile().getY();
            idParent.getParent().tiles[agentY][agentX].forceDisplay();
            idParent.showInfo(null);
          }
        };
        myButtons.add(sellButton);
        sellButton.attachAgent(t);
        sellButton.setStroke(false);
        sellButton.setColor(color(25, 25, 200, 180));
        sellButton.setHoverColor(color(50, 50, 225, 100));
        sellButton.setY(Constants.NEW_WALL_BUTTON_HEIGHT + 7 * Constants.INFO_DISPLAY_HEIGHT / 8);
        sellButton.setHeight(Constants.INFO_DISPLAY_HEIGHT / 9);
        sellButton.setBorders(7, 7, 7, 7);
        sellButton.setTextColor(color(200));
        sellButton.setHoverTextColor(color(240));
        String sellString = "Sell ($" + t.getSellPrice() + ")";
        sellButton.setText(sellString);
        textSize(14);
        sellButton.setWidth(ceil(textWidth(sellString)) + 10);
        sellButton.setX(parent.boardWidth + (Constants.SIDEBAR_WIDTH - sellButton.getWidth()) / 2);
        sellButton.setTextSize(14);
        sellButton.forceDisplay();
      }
    }
  }
  public ArrayList<GuiButton> getButtons() {
    return myButtons;
  }
  public void clear() {
    fill(Constants.GAME_BACKGROUND_COLOR);
    rect(parent.boardWidth + g.strokeWeight, Constants.NEW_WALL_BUTTON_HEIGHT + g.strokeWeight, Constants.SIDEBAR_WIDTH - g.strokeWeight, Constants.INFO_DISPLAY_HEIGHT - g.strokeWeight);
  }
  public Game getParent() {
    return parent;
  }
  public void clickAction(int x, int y) {
    for (GuiButton gb : myButtons) {
      if (x > gb.getX() && y > gb.getY() && x < gb.getX() + gb.getWidth() && y < gb.getY() + gb.getHeight()) {
        gb.clickAction();
      }
    }
  }
  public void hoverAction(int x, int y) {
    for (GuiButton gb : myButtons) {
      if (x > gb.getX() && y > gb.getY() && x < gb.getX() + gb.getWidth() && y < gb.getY() + gb.getHeight()) {
        gb.hover();
      } else {
        gb.display();
      }
    }
  }
}
public class IntroState extends PApplet {
  int introBgColor = 0xffEEEEEE;
  boolean introHovered = false;
  String screen = "menu";
  int howTo_buttonSize = 30;
  int about_buttonSize = 30;
  int play_buttonSize = 48;
  int back_buttonSize = 30;
  boolean blankMenuGlitchCorrected = false;
  PApplet parent;
  Game parentGame;

  public IntroState(PApplet parent) {
    this.parent = parent;
    parentGame = (Game) parent;
  }

  public void setup() {
    cursor(WAIT);
    size(500, 400);
    drawMenu();
    cursor(ARROW);
  }

  public void drawMenu() {
    background(introBgColor);
    textAlign(CENTER, TOP);
    fill(50);
    textSize(50);
    text("Tower Defense", width / 2, 40);
    fill(50);
    textSize(howTo_buttonSize);
    text("How to Play", width / 2, 170);

    textSize(about_buttonSize);
    text("About", width / 2, 220);

    textSize(play_buttonSize);
    text("Play!", width / 2, 270);
  }

  public void drawHowToScreen() {
    background(introBgColor);
    fill(color(255, 64, 0));
    textSize(16);
    text("The goal is to defend your base by placing down new walls\n" + 
    "strategically in order to impede the path of the invading\n" + 
    "enemies, who must find the shortest path to your base.\n\n" + 
    "You can place towers on the walls to attack the enemies,\n" + 
    "preventing them from reaching your base and destroying it."
    , width / 2 , 70);
    drawBack();
  }
  
  public void drawAboutScreen() {
    background(introBgColor);
    fill(color(25, 25, 200, 150));
    textSize(20);
    text("This game was written by:", width / 2, 70);
    fill(color(25,25,200,200));
    text(
    "Chesley Tan\n" +
    "Stanley Lok\n" +
    "George Drimba\n"
    , width / 2, 130);
    textSize(16);
    fill(color(50,50,200,100));
    text("Written in Processing/Java", width / 2, 270);
    drawBack();
  }

  public void draw() {
    if (screen.equals("menu")) {
      if (!blankMenuGlitchCorrected && get(87, 78) == introBgColor) { // hard-coded blank menu fix
        drawMenu();
        blankMenuGlitchCorrected = true;
      }
      else if (!blankMenuGlitchCorrected) {
        blankMenuGlitchCorrected = true;
      }
      if (!introHovered && get(mouseX, mouseY) != introBgColor) {
        if (abs(mouseY - 170) < howTo_buttonSize) {
          redrawHowTo();
          cursor(HAND);
          introHovered = true;
        } else if (abs(mouseY - 220) < about_buttonSize) {
          redrawAbout();
          cursor(HAND);
          introHovered = true;
        } else if (abs(mouseY - 270) < play_buttonSize) {
          redrawPlay();
          cursor(HAND);
          introHovered = true;
        }
      } else if (introHovered && get(mouseX, mouseY) == introBgColor) {
        drawMenu();
        cursor(ARROW);
        introHovered = false;
      }
    } else if (screen.equals("howto")) {
      if (!introHovered && get(mouseX, mouseY) != introBgColor) {
        if (abs(mouseY - 340) < back_buttonSize) {
          redrawHowToBack();
          cursor(HAND);
          introHovered = true;
        }
      } else if (introHovered && get(mouseX, mouseY) == introBgColor) {
        drawBack();
        cursor(ARROW);
        introHovered = false;
      }
    } else if (screen.equals("about")) {
      if (!introHovered && get(mouseX, mouseY) != introBgColor) {
        if (abs(mouseY - 340) < back_buttonSize) {
          redrawAboutBack();
          cursor(HAND);
          introHovered = true;
        }
      } else if (introHovered && get(mouseX, mouseY) == introBgColor) {
        drawBack();
        cursor(ARROW);
        introHovered = false;
      }
    }
  }

  public void redrawHowTo() {
    fill(introBgColor);
    noStroke();
    textSize(howTo_buttonSize);
    rect(0, 170, width, textAscent() + textDescent());
    fill(0xffFF8300);
    text("How to Play", width / 2, 170);
  }

  public void redrawAbout() {
    fill(introBgColor);
    noStroke();
    textSize(about_buttonSize);
    rect(0, 220, width, textAscent() + textDescent());
    fill(25, 25, 200, 200);
    text("About", width / 2, 220);
  }

  public void redrawPlay() {
    fill(introBgColor);
    noStroke();
    textSize(play_buttonSize);
    rect(0, 270, width, textAscent() + textDescent());
    fill(0xffFF4346);
    text("Play!", width / 2, 270);
  }

  public void drawBack() {
    fill(introBgColor);
    noStroke();
    rect(0, 340, width, textAscent() + textDescent());
    fill(50);
    textSize(back_buttonSize);
    text("Back", width / 2, 340);
  }

  public void redrawHowToBack() {
    fill(introBgColor);
    noStroke();
    rect(0, 340, width, textAscent() + textDescent());
    fill(0xffFF8300);
    textSize(back_buttonSize);
    text("Back", width / 2, 340);
  }
  
  public void redrawAboutBack() {
    fill(introBgColor);
    noStroke();
    rect(0, 340, width, textAscent() + textDescent());
    fill(color(25, 25, 200, 200));
    textSize(back_buttonSize);
    text("Back", width / 2, 340);
  }

  public void mouseClicked() {
    if (get(mouseX, mouseY) != introBgColor) {
      if (screen.equals("menu")) {
        if (abs(mouseY - 170) < howTo_buttonSize) {
          screen = "howto";
          drawHowToScreen();
        } else if (abs(mouseY - 220) < about_buttonSize) {
          screen = "about";
          drawAboutScreen();
        } else if (abs(mouseY - 270) < play_buttonSize) {
          parentGame.startGame();
          noLoop();
        }
      } else if (screen.equals("howto") || screen.equals("about")) {
        if (abs(mouseY - 340) < back_buttonSize) {
          screen = "menu";
          drawMenu();
        }
      }
    }
  }
}
public class Node {  
  private Tile tile;
  private Node parent;

  public Node(Node n, Tile t) {
    tile = t;
    parent = n;
  }   

  public Node(Tile t) {
    tile = t;
    parent = null;
  }

  public Node getParent() {
    return parent;
  }

  public boolean hasParent() {
    return parent != null;
  }

  public Tile getTile() {
    return tile;
  }

  public void setTile(Tile t) {
    tile = t;
  }
  public String toString(){
    return "" + tile.getX() + " " + tile.getY();
  }
}

public class RayGun extends Tower {

  public RayGun (Tile t) {
    super(t, 200, 1, 8, 1000, 500, "Ray Gun", Constants.RAYGUN_EFFECT);
  }

  public String toString() {
    String n = getName();
    String e = getEffect();
    int d = getDamage();
    int s = getSpeed();
    int r = getRange();
    return n + "\nDamage: " + d + "\nSpeed: " + s + "\nRange: " + r + "\nEffect: " + e;
  }

  public void act() {
  }

  public boolean inBody(int x, int y) {
    return true;
  }

  public void display() {
    fill(25, 75, 125);
    //Pointy Isoceles Triangle
    triangle(xcor + .3f * Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor + Constants.PIXEL_TO_BOARD_INDEX_RATIO, xcor + .7f * Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor + Constants.PIXEL_TO_BOARD_INDEX_RATIO, xcor + .5f * Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor);
  }

  public void upgrade() {
    int lev = getLevel();
    upRange(4 + 1 * lev);
    upDamage(65 + 10 * lev);
    upSpeed(1 + 1*lev);
    upUpgradePrice(500 + 250 * lev);
    upSellPrice();
    upLevel();
  }
}
public class Spawn extends Agent {
  private LinkedList<Enemy> spawnQueue = new LinkedList<Enemy>();
  private Game myGame;
  private int roundLoaded;
  private long lastSpawn;
  private long coolDown = 1000; // milliseconds

  public Spawn(Game g) {
    myName = Constants.SPAWN;
    myGame = g;
  }

  public void act() {
    if (spawnQueue.isEmpty()) {
      int round = myGame.getRound();
      if (roundLoaded != round) {
        if (round < 3) {
          for (int i = 0; i < round; i++)
            spawnQueue.add(new Grunt(round, myTile, myBoard));
        } else if (round < 5) {
          for (int i = 0; i < round; i++)
            spawnQueue.add(new Grunt(round, myTile, myBoard));
          for (int i = 0; i < round; i++)
            spawnQueue.add(new Bat(round, myTile, myBoard));
        } else if (round < 7) {
          for (int i = 0; i < 2 * round; i++)
            spawnQueue.add(new Bat(round, myTile, myBoard));
        } else if (round < 9) {
          for (int i = 0; i < round; i++)
            spawnQueue.add(new Alien(round, myTile, myBoard));
        } else if (round < 11) {
          for (int i = 0; i < round; i++)
            spawnQueue.add(new Alien(round, myTile, myBoard));
          for (int i = 0; i < round; i++)
            spawnQueue.add(new Giant(round, myTile, myBoard));
        } else if (round < 13) {
          for (int i = 0; i < round; i++)
            spawnQueue.add(new Alien(round, myTile, myBoard));
          for (int i = 0; i < round; i++)
            spawnQueue.add(new Bat(round, myTile, myBoard));
        } else if (round < 15) {
          for (int i = 0; i < round; i++)
            spawnQueue.add(new Grunt(round, myTile, myBoard));
          for (int i = 0; i < round; i++)
            spawnQueue.add(new Grunt(round, myTile, myBoard));
        } else if (round >= 15) {
          for (int i = 0; i < round; i++)
            spawnQueue.add(new Grunt(round, myTile, myBoard));
          for (int i = 0; i < round; i++)
            spawnQueue.add(new Bat(round, myTile, myBoard));
          for (int i = 0; i < round; i++)
            spawnQueue.add(new Alien(round, myTile, myBoard));
          for (int i = 0; i < round; i++)
            spawnQueue.add(new Giant(round, myTile, myBoard));
        }
        roundLoaded = round;
      }
    }
    if (!spawnQueue.isEmpty() && System.currentTimeMillis() - lastSpawn > coolDown) {
      lastSpawn = System.currentTimeMillis();
      Enemy e = spawnQueue.remove();
      myGame.addToAlive(e);
      myTile.addAgentOn(e);
    }
  }

  public String toString() {
    return "Spawn: " + spawnQueue.toString();
  }

  public void display() {
  }
  public boolean inBody(int x, int y) {
    return false;
  }
}

public class Tile {
  private Agent myAgent;
  private ArrayList<Agent> agents = new ArrayList<Agent>();
  private Board myBoard;
  private String myAgentName;
  private int xCoor, yCoor;

  public Tile() {
    myAgent = null;
    myBoard = null;
  }

  public Tile(int x, int y) {
    xCoor = x;
    yCoor = y;
    myAgent = null;
    myAgentName = "";
    myBoard = null;
  }

  public void addAgent(String s) {
    Agent a = null;
    // Add recognition for different types here
    if (s.equals(Constants.WALL)) {
      myAgent = new Wall();
      myAgent.setBoard(board);
      myAgent.setTile(this);
      myAgentName = myAgent.getName();
      a = myAgent;
    } else if (s.equals(Constants.BASE)) {
      myAgent = new Base(500);
      myAgent.setBoard(board);
      myAgent.setTile(this);
      myAgentName = myAgent.getName();
      a = myAgent;
    } else if (s.equals(Constants.TURRET)) {
      if (myAgent instanceof Wall) {
        a = new Turret(this);
        Turret t = (Turret)a;
        Wall w = (Wall)myAgent;
        t.setWall(w);
        w.setTower(t);
        a.setBoard(board);
        a.setTile(this);
      }
    } else if (s.equals(Constants.CANNON)) {
      if (myAgent instanceof Wall) {
        a = new Cannon(this);
        Cannon c = (Cannon)a;
        Wall w = (Wall)myAgent;
        c.setWall(w);
        w.setTower(c);
        a.setBoard(board);
        a.setTile(this);
      }
    } else if (s.equals(Constants.RAY_GUN)) {
      if (myAgent instanceof Wall) {
        a = new RayGun(this);
        RayGun r = (RayGun)a;
        Wall w = (Wall)myAgent;
        r.setWall(w);
        w.setTower(r);
        a.setBoard(board);
        a.setTile(this);
      }
    } else if (s.equals(Constants.SPAWN)) {
      myAgent = new Spawn(myBoard.getParent());
      myAgent.setBoard(board);
      myAgent.setTile(this);
      myAgentName = myAgent.getName();
      a = myAgent;
      myBoard.getParent().setSpawn((Spawn)myAgent);
    }
    if (a != null) {
      agents.add(a);
    }
  }

  public Agent getAgent() {
    return myAgent;
  }

  public Agent removeAgent() {
    Agent tmp = myAgent;
    myAgent = null;
    myAgentName = "";
    agents.remove(tmp);
    return tmp;
  }

  public ArrayList<Agent> getAgentsOn() {
    return agents;
  }

  public void addAgentOn(Agent a) {
    agents.add(a);
  }

  public void removeAgentOn(Agent agent) {
    agents.remove(agent);
  }

  public void setBoard(Board b) {
    myBoard = b;
  }

  public Board getBoard() {
    return myBoard;
  }

  public Board removeBoard() {
    Board tmp = myBoard;
    myBoard = null;
    return tmp;
  }

  public int getX() {
    return xCoor;
  }

  public int getY() {
    return yCoor;
  }

  public int getDistance(Tile t) {
    return Math.abs(t.getX() - xCoor) + Math.abs(t.getY() - yCoor);
  }

  public String getAgentName() {
    return myAgentName;
  }

  public String toString() {
    return xCoor + " " + yCoor;
  }

  public boolean equals(Tile t) {
    return (xCoor == t.getX() && yCoor == t.getY());
  }

  public void display() { 
    if (myAgent != null) { 
      myAgent.display();
    } 
    for (Agent a : agents) { 
      a.display();
    }
  }

  public void clickAction(int x, int y, InfoDisplay infoDisplay) {
    for (int i = agents.size () - 1; i > -1; i--) {
      if (agents.get(i).inBody(x, y)) {
        infoDisplay.showInfo(agents.get(i));
        return;
      }
    }
    infoDisplay.showInfo(null);
  }
}
public abstract class Tower extends Agent {

  protected Wall myWall;
  protected int range, damage, speed, upgradePrice, sellPrice, level;
  protected String name, effect;
  protected long lastShot;

  public Tower(Tile t, int damage, int speed, int range, int upPrice, int sellPrice, String name, String effect) {
    setTile(t);
    this.damage = damage;
    this.speed = speed;
    this.range = range;
    upgradePrice = upPrice;
    this.sellPrice = sellPrice;
    this.name = name;
    this.effect = effect;
    level = 1;
  }

  public int getLevel() {
    return level;
  }

  public String getEffect() {
    return effect;
  }

  public int getRange() {
    return range;
  }

  public int getDamage() {
    return damage;
  }

  public int getSpeed() {
    return speed;
  }

  public int getUpgradePrice() {
    return upgradePrice;
  }

  public int getSellPrice() {
    return sellPrice;
  }

  public void upRange(int r) {
    range += r;
  }

  public void upDamage(int d) {
    damage += d;
  }

  public void upSpeed(int s) {
    speed += s;
  }

  public void upUpgradePrice(int p) {
    upgradePrice += p;
  }

  public void upSellPrice() {
    sellPrice = upgradePrice / 2;
  }

  public void upLevel() {
    level++;
  }

  public Wall getWall() {
    return myWall;
  }

  public void setWall(Wall w) {
    myWall = w;
  }

  //Generic Shooting
  public void shoot(ArrayList<Enemy> enemiesSpawned) {
    if (System.currentTimeMillis() - lastShot > (float)(1000 / speed)) {
      for (Iterator<Enemy> it = enemiesSpawned.iterator (); it.hasNext(); ) {
        Enemy t = it.next();
        float d = dist(myTile.getX(), myTile.getY(), t.getTile().getX(), t.getTile().getY());
        if (d <= range) {
          println("t");
          t.takeDamage(damage);
          if (t.getHealth() <= 0) {
            it.remove(); // Remove the enemy from Game's enemiesSpawned
          }
          lastShot = System.currentTimeMillis();
          break;
        }
      }
    }
  }

  public abstract void upgrade();

  public void sell() {
    myBoard.getParent().removeFromTowers(this);
    myWall.removeTower();
    myTile.removeAgentOn(this);
    myBoard.getParent().addCurrency(sellPrice);
  }
}
public class Turret extends Tower {

  public Turret (Tile t) {
    super(t, 1, 10, 2, 100, 65, "Turret", Constants.TURRET_EFFECT);
  }

  public String toString() {
    String n = getName();
    String e = getEffect();
    int d = getDamage();
    int s = getSpeed();
    int r = getRange();
    return n + "\nDamage: " + d + "\nSpeed: " + s + "\nRange: " + r + "\nEffect: " + e;
  }

  public void act() {

  }

  public boolean inBody(int x, int y) {
    return true;
  }

  public void display() {
    fill(25, 100, 100);
    //Isoceles Triangle Shaped
    triangle(xcor, ycor + Constants.PIXEL_TO_BOARD_INDEX_RATIO, xcor + Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor + Constants.PIXEL_TO_BOARD_INDEX_RATIO, xcor + .5f * Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor);
  }

  public void upgrade() {
    if (upgradePrice < myBoard.getParent().getCurrency()) {
      myBoard.getParent().removeCurrency(upgradePrice);
      int lev = getLevel();
      upRange(1);
      upDamage(2);
      upSpeed(1);
      upUpgradePrice(50 + 25 * lev);
      upSellPrice();
      upLevel();
    }
  }
}
public class Wall extends Agent {
  private Tower myTower;
  
  public Wall() {
    myName = Constants.WALL;
  }
  
  public Wall(Tower t) {
    myTower = t;
    myName = Constants.WALL;
  }
  
  public Tower getTower() {
    return myTower;
  }
  
  public String getTowerName() {
    return myTower.getName();
  }
  
  public void setTower(Tower t) {
    myTower = t;
  }
  
  public void removeTower() {
    myTower = null;
  }
  
  public void display() {
    if (Constants.GAME_NO_STROKE) {
      noStroke();
    }
    else {
      stroke(Constants.GAME_STROKE_COLOR);
    }
    fill(150, 0, 0);
    rect(xcor, ycor, Constants.PIXEL_TO_BOARD_INDEX_RATIO, Constants.PIXEL_TO_BOARD_INDEX_RATIO);
  }
  public void act() {
  }
  
  public String toString() {
    return "Wall: " + myTower;
  }
  
  public boolean inBody(int x, int y) {
    return (x > xcor && x < xcor + Constants.PIXEL_TO_BOARD_INDEX_RATIO && y > ycor && y < ycor + Constants.PIXEL_TO_BOARD_INDEX_RATIO);
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Game" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
