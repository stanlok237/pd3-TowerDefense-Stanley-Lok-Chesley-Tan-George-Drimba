public class Wall extends Agent {
  private Agent myAgent;
  
  public Wall() {
    myName = Constants.WALL;
  }
  
  public Wall(Agent a) {
    myAgent = a;
    myName = Constants.WALL;
  }
  
  public Agent getAgent() {
    return myAgent;
  }
  
  public String getAgentName() {
    return myAgent.getName();
  }
  
  public void display() {
    fill(150, 0, 0);
    rect(xcor, ycor, Constants.PIXEL_TO_BOARD_INDEX_RATIO, Constants.PIXEL_TO_BOARD_INDEX_RATIO);
  }
  public void act() {
  }
  
  public String toString() {
    return "Wall: " + myAgent;
  }
  
  public boolean inBody(int x, int y) {
    return (x > xcor && x < xcor + Constants.PIXEL_TO_BOARD_INDEX_RATIO && y > ycor && y < ycor + Constants.PIXEL_TO_BOARD_INDEX_RATIO);
  }
}
