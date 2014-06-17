public class Zombie extends Enemy {

  public Zombie (int level, Tile t, Board b) {
    super(t,b, 100 + 10 * level, 5, 0, 5 * level,5 ,"Zombie" );
  }

  public void act() {
    //To be Implemented when Turrets are done
  }

  public boolean inBody(int x, int y) {
    return (x > xcor && x < xcor + Constants.PIXEL_TO_BOARD_INDEX_RATIO * .5 && y > ycor && y < ycor + Constants.PIXEL_TO_BOARD_INDEX_RATIO * .5);
  }

  public void display() {
    fill(65, 185, 120);
    // COOL LOOKING SHAPE TO BE USED LATER
    //quad(xcor + .25 * Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor, xcor, ycor + .25 * Constants.PIXEL_TO_BOARD_INDEX_RATIO, xcor + .5 * Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor + .25 * Constants.PIXEL_TO_BOARD_INDEX_RATIO, xcor + .25 * Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor + 0.5 * Constants.PIXEL_TO_BOARD_INDEX_RATIO);
    quad(xcor + .25 * Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor, xcor, ycor + .25 * Constants.PIXEL_TO_BOARD_INDEX_RATIO, xcor + .25 * Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor + 0.5 * Constants.PIXEL_TO_BOARD_INDEX_RATIO, xcor + .5 * Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor + .25 * Constants.PIXEL_TO_BOARD_INDEX_RATIO);
    generateHealthBar();
  }

  public String toString() {
    //String stat = "";
    String n = super.getName();
    int h = super.getHealth();
    int mh = super.getMaxHealth();
    int s = super.getSpeed();
    int a = super.getArmor();
    return n + ": " + h + " / " + mh + "\nSpeed: "  + s + "\nArmor: " + a;
  }
} 
