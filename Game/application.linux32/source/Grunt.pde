public class Grunt extends Enemy {

  public Grunt (int level, Tile t, Board b) {
    super(t, b, 100 + 50 * level, 1, 0, 10 * level, 15 + 5 * level, "Grunt" );
  }

  public String toString() {
    String n = super.getName();
    int h = super.getHealth();
    int mh = super.getMaxHealth();
    int s = super.getSpeed();
    int a = super.getArmor();
    return n + ": " + h + " / " + mh + "\nSpeed: "  + s + "\nArmor: " + a;
  }

  public void generateHealthBar() {
    float perc = 1.0 * currentHealth / maxHealth;
    int length = round(perc * Constants.PIXEL_TO_BOARD_INDEX_RATIO / 2);
    fill(50, 200, 0, 100);
    rect(xcor + .25 * Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor + .25* Constants.PIXEL_TO_BOARD_INDEX_RATIO, length, round(Constants.PIXEL_TO_BOARD_INDEX_RATIO * Constants.HEALTH_BAR_HEIGHT_PERCENTAGE));
  }

  public void display() {
    fill(20, 150, 175);
    triangle(xcor + 0.25 * Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor + 0.25 * Constants.PIXEL_TO_BOARD_INDEX_RATIO, xcor + 0.75 * Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor + .25 * Constants.PIXEL_TO_BOARD_INDEX_RATIO, xcor + 0.5 * Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor + 0.75 * Constants.PIXEL_TO_BOARD_INDEX_RATIO);
    generateHealthBar();
  }

  public boolean inBody(int x, int y) {
    return (x > xcor + 0.25 * Constants.PIXEL_TO_BOARD_INDEX_RATIO && x < xcor + Constants.PIXEL_TO_BOARD_INDEX_RATIO * .75 && y > ycor + Constants.PIXEL_TO_BOARD_INDEX_RATIO * .25 && y < ycor + Constants.PIXEL_TO_BOARD_INDEX_RATIO * .75);
  }
}
