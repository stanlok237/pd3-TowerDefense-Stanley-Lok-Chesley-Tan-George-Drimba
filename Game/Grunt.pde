public class Grunt extends Enemy {

  public Grunt (int level, Tile t) {
    super(t, 25 * level, 10, 0, 1 * level,"Grunt" );
  }

  //public act here -----------------------
  public String toString() {
    //String stat = "";
    String n = super.getName();
    int h = super.getHealth();
    int mh = super.getMaxHealth();
    return n + " " + h + " / " + mh;
  }
  
  public void act(){
    //If within range of turret, take damage
  }
  
  public void display(){
    
  }
  
  public boolean inBody(int x, int y){
    return (x > xcor && x < xcor + Constants.PIXEL_TO_BOARD_INDEX_RATIO && y > ycor && y < ycor + Constants.PIXEL_TO_BOARD_INDEX_RATIO);
  }
  
}
