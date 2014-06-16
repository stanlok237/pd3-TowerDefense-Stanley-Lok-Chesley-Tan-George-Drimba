public class Zombie extends Enemy {

  public Zombie (int x, int y, int level) {
    super(x, y, 100 + 10 * level, 5, 0, 5 * level, "Zombie" );
  }

  public void act() {
    //To be Implemented when Turrets are done
  }

  public boolean inBody(int x, int y) {
    return (x > xcor && x < xcor + Constants.PIXEL_TO_BOARD_INDEX_RATIO && y > ycor && y < ycor + Constants.PIXEL_TO_BOARD_INDEX_RATIO);
  }

  public void display() {
    
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
