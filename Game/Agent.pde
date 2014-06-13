public abstract class Agent{
  
    private Board myBoard;
    private Tile myTile, tempTile;
    private String myName;
    private int xcor;
    private int ycor;
    
    //Will Add Necessary Stuff Later

    public Agent(int x, int y){
      myTile = new Tile(x,y);
    }

    public void setBoard(Board b) {
        myBoard = b;
    }

    public void setTile(Tile t) {
        myTile = t; 
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

    public abstract String toString();
    public abstract void act();
}
