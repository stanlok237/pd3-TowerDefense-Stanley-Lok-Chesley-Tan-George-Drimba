public abstract class Tower extends Agent {

  private int range, damage, speed, upgradePrice, sellPrice, level;

  public Tower(int x, int y) {
    super(x, y);
  }

  public int getRange() {
    return range;
  }

  public int getLevel(){
    return level;
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

  public void sell(){
  //Removes the tower
  getTile().removeAgentOn(this);
  //Add Gold Here
  }
  
}
