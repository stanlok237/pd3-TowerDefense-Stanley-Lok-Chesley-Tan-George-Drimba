public abstract class Tower extends Agent{

    private int range,damage,speed,upgradePrice,sellPrice;

    public int getRange() {
        return range;
    }

    public int getDamage() {
        return damage;
    }

    public int getSpeed() {
        return speed;
    }

    public int getUpgradePrice() {
        return upgradePrice; 
    }

    public int getSellPrice() {
        return sellPrice;
    }

    //Should we make it like GridWorld type of getting monsters and modifying them


    //Abstract Functions to be implemented in subclasses
    public abstract void shoot();
  //Generic Shooting
    
    public abstract void upgrade();
  //Upgrades Stats at a cost

    public abstract void sell();
  //Removes the tower
   
}

