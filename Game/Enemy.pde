import java.util.*;
import java.io.*;

public abstract class Enemy extends Agent{

    private int health,speed,armor,damage,level;
    private String name;
    
    public Enemy(int x, int y){
      super(x,y);
    }
    
}
