public abstract class Tower extends Agent {

  private int range, damage, speed, upgradePrice, sellPrice, level;
  private String name, effect;

  public Tower(Tile t, int damage, int speed, int range, int upPrice, int sellPrice, String name, String effect) {
    setTile(t);
    this.damage = damage;
    this.speed = speed;
    upgradePrice = upPrice;
    this.sellPrice = sellPrice;
    this.name = name;
    this.effect = effect;
    level = 1;
  }

  public int getLevel(){
    return level;
  }

  public String getEffect() {
    return effect;
  }

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

  public void upRange(int r) {
    range += r;
  }

  public void upDamage(int d) {
    damage += d;
  }

  public void upSpeed(int s) {
    speed += s;
  }

  public void upUpgradePrice(int p) {
    upgradePrice += p;
  }

  public void upSellPrice() {
    sellPrice = upgradePrice / 2;
  }

  public void upLevel(){
    level++;
  }

  //Should we make it like GridWorld type of getting monsters and modifying them
  //Abstract Functions to be implemented in subclasses
  //Replace shoot() with act() in Agent Class
  //public abstract void shoot();
  //Generic Shooting

  public abstract void upgrade();
  //Upgrades Stats at a cost

  public void sell() {
    //Removes the tower
    getTile().removeAgentOn(this);
    //Add Gold to Player Here
  }
}
