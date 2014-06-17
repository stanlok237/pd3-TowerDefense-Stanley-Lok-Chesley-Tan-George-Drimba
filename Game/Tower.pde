public abstract class Tower extends Agent {

  protected Wall myWall;
  protected int range, damage, speed, upgradePrice, sellPrice, level;
  protected String name, effect;

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
  
  public Wall getWall() {
    return myWall;
  }
  
  public void setWall(Wall w) {
    myWall = w;
  }

  //Should we make it like GridWorld type of getting monsters and modifying them
  //Abstract Functions to be implemented in subclasses
  //Replace shoot() with act() in Agent Class
  
  //Generic Shooting
  public void shoot(){
    float d = dist(myTile.getX() * Constants.PIXEL_TO_BOARD_INDEX_RATIO), myTile.getY() * Constants.PIXEL_TO_BOARD_INDEX_RATIO) , t.getX() * Constants.PIXEL_TO_BOARD_INDEX_RATIO), t.getY() * Constants.PIXEL_TO_BOARD_INDEX_RATIO));
  while d < range {
    delay(100 - speed);
    act(); // need to implement an act
  }
    
  }

  public abstract void upgrade();
  //Upgrades Stats at a cost

  public void sell() {
    myWall.removeTower();
    myTile.removeAgentOn(this);
    myBoard.getParent().addCurrency(sellPrice);
  }
}
