public class Turret extends Tower {

  public Turret (Tile t) {
    super(t, 1, 10, 2, 100, 65, "Turret", Constants.TURRET_EFFECT);
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

  /* Old Code
   public void Turret (int xstart, int ystart) {
   xcor = xstart;
   ycor = ystart;
   pos = new PVector(xcor, ycor);
   turret = loadImage("imagename");
   }
   public void level(int exp) {
   experience = experience + exp;
   if (exp > expneed) {
   level = level + 1;
   
   Random r = new Random();
   int i = r.nextInt(2); 
   if (i == 1) {
   range = range + 5;
   expneed= expneed + 5 * (level - 1);
   }
   if (i == 2) {
   damage = damage + 5;
   expneed = expneed + 5 * (level - 1);
   } else {
   speed = speed + 5;
   expneed = expneed + 5 * (level - 1);
   }
   maxhealth = strength;
   health = maxhealth; //health regeneration
   }
   */
}
