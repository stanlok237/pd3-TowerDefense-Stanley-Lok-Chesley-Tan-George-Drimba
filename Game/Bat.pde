public class Bat extends Enemy {

  public Bat(int level, Tile t) {
    super(t, 60 + 10 * level, 20, 0, 3 * level, "Bat" );
  }

  public void act() {
    //To be Implemented when Turrets are done
  }

  public boolean inBody(int x, int y) {
    return (x > xcor && x < xcor + Constants.PIXEL_TO_BOARD_INDEX_RATIO * .5 && y > ycor && y < ycor + Constants.PIXEL_TO_BOARD_INDEX_RATIO * .5);
  }

  public void display() {
    fill(139, 69, 19);
    quad(xcor + .25 * Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor, xcor, ycor + .25 * Constants.PIXEL_TO_BOARD_INDEX_RATIO, xcor + .5 * Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor + .25 * Constants.PIXEL_TO_BOARD_INDEX_RATIO, xcor + .25 * Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor + 0.5 * Constants.PIXEL_TO_BOARD_INDEX_RATIO);
    generateHealthBar();
  }

  public String toString() {
    String n = super.getName();
    int h = super.getHealth();
    int mh = super.getMaxHealth();
    int s = super.getSpeed();
    int a = super.getArmor();
    return n + ": " + h + " / " + mh + "\nSpeed: "  + s + "\nArmor: " + a;
  }
}
