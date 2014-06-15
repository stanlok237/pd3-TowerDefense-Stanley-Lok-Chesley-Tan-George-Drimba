public class EnSquare extends Enemy {

  public EnSquare (int level, int x, int y) {
    super(x, y, 25 * level, 10, 0, 1 * level,"Grunt" );
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
    
  }
  
  public void display(){
    
  }
  
}
