
public class RayGun extends Tower {

  public RayGun (Tile t) {
    super(t, 200, 1, 8, 1000, 500, "Ray Gun", Constants.RAYGUN_EFFECT);
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
    fill(25, 75, 125);
    //Pointy Isoceles Triangle
    triangle(xcor + .3 * Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor + Constants.PIXEL_TO_BOARD_INDEX_RATIO, xcor + .7 * Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor + Constants.PIXEL_TO_BOARD_INDEX_RATIO, xcor + .5 * Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor);
  }

  public void upgrade() {
    if (upgradePrice <= myBoard.getParent().getCurrency()) {
      myBoard.getParent().removeCurrency(upgradePrice);
      int lev = getLevel();
      upRange(defaultRange + round(1.5 * lev));
      upDamage(defaultDamage + 10 * lev);
      upSpeed(defaultSpeed + round(0.3*lev));
      upUpgradePrice(500 + 250 * lev);
      upSellPrice();
      upLevel();
    }
  }
}
