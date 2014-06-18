
public class Cannon extends Tower {

  public Cannon (Tile t) {
    super(t, 25, 10, 1, 100, 65, "Cannon", Constants.TURRET_EFFECT);
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
    fill(40, 75, 150);
    //Isoceles Triangle Shaped
    triangle(xcor, ycor + Constants.PIXEL_TO_BOARD_INDEX_RATIO, xcor + Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor + Constants.PIXEL_TO_BOARD_INDEX_RATIO, xcor + .5 * Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor);
  }

  public void upgrade() {
    if (upgradePrice < myBoard.getParent().getCurrency()) {
      myBoard.getParent().removeCurrency(upgradePrice);
      int lev = getLevel();
      upRange(4 + 1 * lev);
      upDamage(13 + 2 * lev);
      upSpeed(2 + 1*lev);
      upUpgradePrice(50 + 25 * lev);
      upSellPrice();
      upLevel();
    }
  }
/*
public class Cannon extends Tower {
 PImage cannon;
 PVector pos;
  public Turret (int level){
   name = Turret;
   range = ;
   speed = ;
   expneed = ;
   upgradePrice = ;
   sellPrice = ;
   this.level = level;
 }
   //public act here --------------------
   public String toString(){
     String stat = "";
     return stat + name + " r =" + range + "s = "+ speed + "u= " + upgradePrice + "s= "+ sellPrice + "d=" + damage;
   }
 }
 public void Cannon (int xstart, int ystart){
   xcor = xstart;
   ycor = ystart;
   pos = new PVector(xcor, ycor);
   cannon = loadImage("imagename"); 
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
  }
  else {
    speed = speed + 5;
    expneed = expneed + 5 * (level - 1); 
  }
  maxhealth = strength;
  health = maxhealth; //health regeneration
  }
*/
}
