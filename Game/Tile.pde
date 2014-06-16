import java.util.ArrayList;
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
    agents.remove(myAgent);
    removeAgentOn(tmp);
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
