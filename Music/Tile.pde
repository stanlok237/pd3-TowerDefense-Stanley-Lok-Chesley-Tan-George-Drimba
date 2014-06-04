public class Tile {
    private Agent myAgent;
    private Board myBoard;
    private int xCoor, yCoor;
    
    public Tile() {
        myAgent = null;
        myBoard = null;
    }

    public Tile(int x, int y) {
        xCoor = x;
        yCoor = y;
        myAgent = null;
        myBoard = null;
    }

    public Tile(Agent a) {
        myAgent = a;
        myBoard = null;
    }

    public Tile(Agent a, int x, int y) {
        myAgent = a;
        myBoard = null;
        xCoor = x;
        yCoor = y;
    }

    public Agent getAgent() {
        return myAgent;
    }

    public Agent removeAgent() {
        Agent tmp = myAgent;
        myAgent = null;
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

    public String toString() {
        return myAgent.toString();
    }

    public boolean equals(Tile t) {
        return (xCoor = t.getX() && yCoor = t.getY());
    }

}

