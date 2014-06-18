public class Grunt extends Enemy {

  public Grunt (int level, Tile t, Board b) {
    super(t, b, 100 + 50 * level, 10, 0, 10 * level, 15 + 5 * level, "Grunt" );
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
    return (x > xcor && x < xcor + Constants.PIXEL_TO_BOARD_INDEX_RATIO * .5 && y > ycor && y < ycor + Constants.PIXEL_TO_BOARD_INDEX_RATIO * .5);
  }
}
