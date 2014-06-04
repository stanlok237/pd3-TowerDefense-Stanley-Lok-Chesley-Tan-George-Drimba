import java.util.*;
import java.io.*;

public abstract class Tower extends Agent{

    private int range,damage,speed,upgradePrice,sellPrice;

    //Should we make it like GridWorld type of getting monsters and modifying them


    //Abstract Functions to be implemented in subclasses
    public abstract void shoot();
  //Generic Shooting
    
    public abstract void upgrade();
  //Upgrades Stats at a cost

    public abstract void sell();
  //Removes the tower
   
}

