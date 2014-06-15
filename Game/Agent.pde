public abstract class Agent{
  
    protected Board myBoard;
    protected Tile myTile, tempTile;
    protected String myName;
    protected int xcor; // pixel coordinate
    protected int ycor; // pixel coordinate
    protected int direction; // angle between 0 and 360, counter-clockwise
    
    //Will Add Necessary Stuff Later

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
    
    public abstract boolean inBody(int x, int y);

    public abstract String toString();
    public abstract void display();
    public abstract void act();
}
