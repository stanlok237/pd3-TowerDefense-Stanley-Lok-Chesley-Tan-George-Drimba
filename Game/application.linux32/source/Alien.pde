public class Alien extends Enemy {
  //tank
  public Alien(int level, Tile t, Board b) {
    super(t, b , 200 + 20 * level, 2, 10 + 1 * level, 20 * level, 7 * level, "Alien" );
  }

  public boolean inBody(int x, int y) {
    return (x > xcor + 0.2 * Constants.PIXEL_TO_BOARD_INDEX_RATIO && x < xcor + .8 * Constants.PIXEL_TO_BOARD_INDEX_RATIO && y > ycor + .2 * Constants.PIXEL_TO_BOARD_INDEX_RATIO && y < ycor + Constants.PIXEL_TO_BOARD_INDEX_RATIO * .8);
  }

  public void display() {
    fill(0, 7, 77);
    quad(xcor + 0.5 * Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor + 0.2 * Constants.PIXEL_TO_BOARD_INDEX_RATIO, xcor + 0.8 * Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor + 0.7 * Constants.PIXEL_TO_BOARD_INDEX_RATIO, xcor + 0.5 * Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor + 0.8 * Constants.PIXEL_TO_BOARD_INDEX_RATIO, xcor + 0.2 * Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor + 0.7 * Constants.PIXEL_TO_BOARD_INDEX_RATIO);
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
