public class Giant extends Enemy{
  
  public Giant(int level, Tile t){
    super(t, 400 + 100 * level, 2, 10 + 1 * level, 50 * level, "Giant" );
  }
  
  public void act() {
    //To be Implemented when Turrets are done
  }

  public boolean inBody(int x, int y) {
    return (x > xcor && x < xcor + Constants.PIXEL_TO_BOARD_INDEX_RATIO * .5 && y > ycor && y < ycor + Constants.PIXEL_TO_BOARD_INDEX_RATIO * .5);
  }

  public void display() {
    fill(0,7,77);
    quad(xcor + .5 * Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor, xcor, ycor + .5 * Constants.PIXEL_TO_BOARD_INDEX_RATIO,xcor + .5 * Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor + Constants.PIXEL_TO_BOARD_INDEX_RATIO, xcor + Constants.PIXEL_TO_BOARD_INDEX_RATIO, ycor + .5 * Constants.PIXEL_TO_BOARD_INDEX_RATIO);
  }
  
  public String toString(){
    String n = super.getName();
    int h = super.getHealth();
    int mh = super.getMaxHealth();
    int s = super.getSpeed();
    int a = super.getArmor();
    return n + ": " + h + " / " + mh + "\nSpeed: "  + s + "\nArmor: " + a;
  }
}
