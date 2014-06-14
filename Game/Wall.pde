public class Wall extends Agent {
  private Agent myAgent;
  
  public Wall() {
  }
  
  public Wall(Agent a) {
    myAgent = a;
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
}
