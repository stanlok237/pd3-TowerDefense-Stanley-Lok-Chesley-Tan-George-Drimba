public class Turret extends Tower {

  public Turret (Tile t) {
    super(t, 1, 10, 2, 100, 65, "Turret", Constants.TURRET_EFFECT);
  }

  public String toString() {
    String n = getName();
    String e = getEffect();
    int d = getDamage();
    int s = getSpeed();
    int r = getRange();
    return n + "\nDamage: " + d + "\nSpeed: " + s + "\nRange: " + r + "\nEffect: " + e;
  }

  public void act() {

  }

  public boolean inBody(int x, int y) {
    return true;
  }

  public void display() {
    fill(25, 100, 100);
    //Isoceles Triangle Shaped
    triangle(xcor, ycor + Constants.PIXEL_TO_BOARD_INDEX_RATIO, xcor + Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor + Constants.PIXEL_TO_BOARD_INDEX_RATIO, xcor + .5 * Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor);
  }

  public void upgrade() {
    if (upgradePrice < myBoard.getParent().getCurrency()) {
      myBoard.getParent().removeCurrency(upgradePrice);
      int lev = getLevel();
      upRange(1);
      upDamage(2);
      upSpeed(1);
      upUpgradePrice(50 + 25 * lev);
      upSellPrice();
      upLevel();
    }
  }
}
