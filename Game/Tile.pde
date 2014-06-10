public class Tile {
    private Agent myAgent;
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

    public Tile(Agent a) {
        myAgent = a;
        myAgentName = a.getName();
        myBoard = null;
    }

    public Tile(Agent a, int x, int y) {
        myAgent = a;
        myAgentName = a.getName();
        myBoard = null;
        xCoor = x;
        yCoor = y;
    }

    public void addAgent(Agent a) {
        myAgent = a;
        myAgentName = a.getName();
    }

    public void addAgent(String s) {
        myAgent = null;
        myBoard = null;
        myAgentName = s;
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
        return myAgent.toString();
    }

    public boolean equals(Tile t) {
        return (xCoor == t.getX() && yCoor == t.getY());
    }

}
