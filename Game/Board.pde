private Game parent;
public class Board {
  Tile[][] board;
  int numRows, numCols;
  int defaultSize = 20;
  Base base;

  public Board(Game p) {
    numRows = defaultSize;
    numCols = defaultSize;
    board = new Tile[numRows][numCols];
    for (int i = 0; i < numRows; i++) {
      for (int j = 0; j < numCols; j++) {
        board[i][j] = new Tile(i, j);
      }
    }
    parent = p;
  }

  public Board(int s, Game p) {
    numRows = numCols = s;
    board = new Tile[numRows][numCols];
    for (int i = 0; i < numRows; i++) {
      for (int j = 0; j < numCols; j++) {
        board[i][j] = new Tile(i, j);
      }
    }
    parent = p;
  }

  public Board(int r, int c, Game p) {
    numRows = r;
    numCols = c;
    board = new Tile[numRows][numCols];
    for (int i = 0; i < numRows; i++) {
      for (int j = 0; j < numCols; j++) {
        board[i][j] = new Tile(i, j);
      }
    }
    parent = p;
  }

  public Tile get(int r, int c) {
    return board[r][c];
  }

  public void set(int r, int c, Tile t) {
    board[r][c] = t;
  }
  
  public Base getBase() {
    return base;
  }

  public int getRows() {
    return numRows;
  }

  public int getCols() {
    return numCols;
  }
  
  public Game getParent() {
    return parent;
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
        board[row][u] = new Tile(u, row);
        board[row][u].addAgent(objects[u]);
        if (objects[u].equals(Constants.BASE)) {
          base = (Base)(board[row][u].getAgent());
        }
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
      return board[t.getY()][t.getX() - 1];
    }
    return null;
  }

  public Tile getRight(Tile t) {
    if (tileInBounds(t.getX() + 1, t.getY())) {
      return board[t.getY()][t.getX() + 1];
    }
    return null;
  }

  public Tile getUpper(Tile t) {
    if (tileInBounds(t.getX(), t.getY() - 1)) {
      return board[t.getY() - 1][t.getX()];
    }
    return null;
  }

  public Tile getLower(Tile t) {
    if (tileInBounds(t.getX(), t.getY() + 1)) {
      return board[t.getY() + 1][t.getX()];
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
