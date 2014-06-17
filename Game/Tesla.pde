
public class Tesla extends Tower {
//short range electric field thingy
  public Tesla (Tile t) {
    super(t, 200, 1, 500, 1000, 500, "Tesla", Constants.TESLA_EFFECT);
  }

  //public act here --------------------
  public String toString() {
    String n = getName();
    String e = getEffect();
    int d = getDamage();
    int s = getSpeed();
    int r = getRange();
    return n + "\nDamage: " + d + "\nSpeed: " + s + "\nRange: " + r + "\nEffect: " + e;
  }

  public void act() {
    //shoot
  }

  public boolean inBody(int x, int y) {
    return false; //Temporary
  }

  public void display() {
    fill(25, 75, 125);
    //We need a slightly different shape but this should be alright for now
    triangle(xcor + .3 * Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor + Constants.PIXEL_TO_BOARD_INDEX_RATIO, xcor + .2 * Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor + Constants.PIXEL_TO_BOARD_INDEX_RATIO, xcor + .1 * Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor);
  }

  public void upgrade() {
    //Subtract Gold Cost Here
    int lev = getLevel();
    upRange(4 + 1 * lev);
    upDamage(65 + 10 * lev);
    upSpeed(1 + 1*lev);
    upUpgradePrice(500 + 250 * lev);
    upSellPrice();
    upLevel();
  }
}
