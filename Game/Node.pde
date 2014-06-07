import java.util.*;
import java.io.*;

//Made a Seperate Class in case we need it later
public class Node {  
  //Tile Agent is on
  private Tile tile;
  //You can actually have a path
  private Node parent;
  //The Base for Location
  //private Base base;  Better to be in Comparator
  //private int gCost, hCost  Going to be calculated in the Comparator

  public Node(Node n, Tile t) {
    //base = b;
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
}

