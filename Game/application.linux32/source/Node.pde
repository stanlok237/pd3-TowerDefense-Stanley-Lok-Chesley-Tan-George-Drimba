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
