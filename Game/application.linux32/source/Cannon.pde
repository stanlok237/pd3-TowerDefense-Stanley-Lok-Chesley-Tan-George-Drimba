public class Cannon extends Tower {

  public Cannon (Tile t) {
    super(t, 3, 5, 5, 100, 65, "Cannon", Constants.TURRET_EFFECT);
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
    fill(40, 75, 150);
    //Isoceles Triangle Shaped
    triangle(xcor, ycor + Constants.PIXEL_TO_BOARD_INDEX_RATIO, xcor + Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor + Constants.PIXEL_TO_BOARD_INDEX_RATIO, xcor + .5 * Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor);
  }

  public void upgrade() {
    if (upgradePrice <= myBoard.getParent().getCurrency()) {
      myBoard.getParent().removeCurrency(upgradePrice);
      int lev = getLevel();
      setRange(defaultRange + 1 * lev);
      setDamage(defaultDamage + 2 * lev);
      setSpeed(defaultSpeed + round(0.75*lev));
      upUpgradePrice(50 + 30 * lev);
      upSellPrice();
      upLevel();
    }
  }
}
