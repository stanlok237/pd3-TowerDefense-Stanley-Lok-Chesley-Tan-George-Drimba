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
