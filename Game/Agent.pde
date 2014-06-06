import java.util.*;
import java.io.*;

public abstract class Agent{
  
    private Board myBoard;
    private Tile myTile;
    
    //Will Add Necessary Stuff Later


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

    public abstract String toString();
}

