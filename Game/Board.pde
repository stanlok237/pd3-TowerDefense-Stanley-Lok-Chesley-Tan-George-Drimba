import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
public class Board {
    Tile[][] board;
    int numRows, numCols;
    int defaultSize = 5;

    public Board() {
        numRows = defaultSize;
        numCols = defaultSize;
        board = new Tile[numRows][numCols];
    }

    public Board(int s) {
        numRows = numCols = s;
        board = new Tile[numRows][numCols];
    }

    public Board(int r, int c) {
        numRows = r;
        numCols = c;
        board = new Tile[numRows][numCols];
    }
    
    public void loadMap(String file) {
        try {
            BufferedReader mapFile = new BufferedReader(new FileReader(file));
            String nextLine = mapFile.readLine();
            board = new Tile[Integer.parseInt(nextLine.split(" ")[0])][Integer.parseInt(nextLine.split(" ")[1])];
            nextLine = mapFile.readLine();
            int row = 0;
            for (;nextLine != null;nextLine = mapFile.readLine()) {
                String[] objects = nextLine.split(" ");
                for (int i = 0;i < objects.length;i++) {
                    board[row][i].addAgent(new Agent(objects[i]));
                    // Add recognition for each different type of Agent here
                }
                row++;
            }
        } catch (IOException e) {
            System.err.println("Error reading map file. Exiting....");
            System.exit(1);
        }
    }

    public boolean tileInBounds(Tile t) {
        int otherX = t.getX();
        int otherY = t.getY();
        return !(otherX < 0 || otherX > numCols - 1 || otherY < 0 || otherY > numRows - 1); 
    }

    public boolean tileInBounds(int x, int y) {
        return !(x < 0 || x > numCols - 1 || y < 0 || y > numRows - 1);
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

    public String toString() {
        String retStr = "";
        for (int r = 0;r < board.length;r++) {
            for (int c = 0;c < board[0].length;c++) {
                retStr += board[r][c] + " ";
            }
            retStr += "\n";
        }
        return retStr;
    }
}
