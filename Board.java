public class Board {
    Agent[][] board;
    int numRows, numColumns;
    int defaultSize = 5;

    public Board() {
         numRows = defaultSize;
         numCols = defaultSize;
         board = new Agent[numRows][numCols];
    }

    public Board(int s) {
        numRows = numCols = s;
        board = new Agent[numRows][numCols];
    }

    public Board(int r, int c) {
        numRows = r;
        numCols = c;
        board = new Agent[numRows][numCols];
    }

    public boolean tileInBounds(Tile t) {
        int otherX = t.getX();
        int otherY = t.getY();
        return !(otherX < 0 || otherX > numColumns - 1 || otherY < 0 || otherY > numRows - 1); 
    }
    
    public boolean tileInBounds(int x, int y) {
        return !(x < 0 || x > numColumns - 1 || y < 0 || y > numRows - 1);
    }

    public Tile getLeft(Tile t) {
        if (tileInBounds(t.getX() - 1, t.getY())) {
            return board[t.getX() - 1][t.getY()]; 
        }
        return null;
    }

    public Tile getRight(Tile t) {
        if (tileInBounds(t.getX() + 1, t.getY())) {
            return board[t.getX() + 1][t.getY()]; 
        }
        return null;
    }

    public Tile getUpper(Tile t) {
        if (tileInBounds(t.getX(), t.getY() - 1)) {
            return board[t.getX()][t.getY() - 1]; 
        }
        return null;
    }

    public Tile getLower(Tile t) {
        if (tileInBounds(t.getX(), t.getY() + 1)) {
            return board[t.getX()][t.getY() + 1]; 
        }
        return null;
    }

    public boolean isValidTile(Tile t) {
        if (tileInBounds(t)) {
            return (board[t.getY()][t.getX()].equals(t));
        }
        return false;
    }
}
