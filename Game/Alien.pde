public class Alien extends Enemy {
  //tank
  public Alien(int level, Tile t, Board b) {
    super(t, b , 400 + 100 * level, 2, 10 + 1 * level, 50 * level, 5, "Alien" );
  }

  public boolean inBody(int x, int y) {
    return (x > xcor && x < xcor + Constants.PIXEL_TO_BOARD_INDEX_RATIO * .5 && y > ycor && y < ycor + Constants.PIXEL_TO_BOARD_INDEX_RATIO * .5);
  }

  public void display() {
    fill(0, 7, 77);
    quad(xcor + .75 * Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor + .25 * Constants.PIXEL_TO_BOARD_INDEX_RATIO, xcor + .25 * Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor + .75 * Constants.PIXEL_TO_BOARD_INDEX_RATIO, xcor + .75 * Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor + Constants.PIXEL_TO_BOARD_INDEX_RATIO, xcor + Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor + .75 * Constants.PIXEL_TO_BOARD_INDEX_RATIO);
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
