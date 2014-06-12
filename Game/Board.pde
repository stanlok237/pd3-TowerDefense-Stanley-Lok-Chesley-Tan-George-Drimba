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

  public Tile get(int r, int c) {
    return board[r][c];
  }

  public void set(int r, int c, Tile t) {
    board[r][c] = t;
  }

  public int getRows() {
    return numRows;
  }

  public int getCols() {
    return numCols;
  }

  public void loadMap(String file) {
    String[] d = loadStrings(file);
    numRows = Integer.parseInt(d[0].split(" ")[0]);
    numCols = Integer.parseInt(d[0].split(" ")[1]);
    board = new Tile[numRows][numCols];
    int row = 0;
    for (int i = 1; i < d.length; i++) {
      String[] objects = d[i].split(" ");
      for (int u = 0; u < objects.length; u++) {
        board[row][u] = new Tile();
        board[row][u].addAgent(objects[u]);
        // Add recognition for each different type of Agent here
      }
      row++;
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
    for (int r = 0; r < board.length; r++) {
      for (int c = 0; c < board[0].length; c++) {
        retStr += board[r][c] + " ";
      }
      retStr += "\n";
    }
    return retStr;
  }
}

