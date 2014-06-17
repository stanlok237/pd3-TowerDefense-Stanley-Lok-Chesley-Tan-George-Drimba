public class Grunt extends Enemy {

  public Grunt (int level, Tile t) {
    super(t, 25 * level, 10, 0, 1 * level, 5, "Grunt" );
  }

  //public act here -----------------------
  public String toString() {
    //String stat = "";
    String n = super.getName();
    int h = super.getHealth();
    int mh = super.getMaxHealth();
    int s = super.getSpeed();
    int a = super.getArmor();
    return n + ": " + h + " / " + mh + "\nSpeed: "  + s + "\nArmor: " + a;
  }

  public void act() {
    //If within range of turret, take damage
  }

  public void display() {
    fill(20, 150, 175);
    triangle(xcor, ycor, xcor + 0.5 * Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor, xcor + 0.25 * Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor + 0.5 * Constants.PIXEL_TO_BOARD_INDEX_RATIO);
    generateHealthBar();
  }

  public boolean inBody(int x, int y) {
    return (x > xcor && x < xcor + Constants.PIXEL_TO_BOARD_INDEX_RATIO * .5 && y > ycor && y < ycor + Constants.PIXEL_TO_BOARD_INDEX_RATIO * .5);
  }
}
