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
        myAgent = null;
        myBoard = null;
        // Add recognition for different types here
        if (s.equals(Constants.WALL)) {
          myAgent = new Wall();
          myAgent.setBoard(board);
          myAgent.setTile(this);
          myAgentName = myAgent.getName();
        }
        else if (s.equals(Constants.BASE)) {
          myAgent = new Base(500);
          myAgent.setBoard(board);
          myAgent.setTile(this);
          myAgentName = myAgent.getName();
        }
    }

    public Agent getAgent() {
        return myAgent;
    }

    public Agent removeAgent() {
        Agent tmp = myAgent;
        myAgent = null;
        myAgentName = "";
        return tmp;
    }
    
    public ArrayList<Agent> getAgentsOn() {
      return agents;
    }
    
    public void addAgentOn(Agent a) {
      agents.add(a);
    }
    
    public void removeAgentOn(Agent agent) {
      for (int i = 0;i < agents.size();i++) {
        if (agents.get(i) == agent) {
          agents.remove(i);
        }
      }
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

}
