public abstract class Tower extends Agent {

  protected Wall myWall;
  protected int range, damage, speed, upgradePrice, sellPrice, level;
  protected String name, effect;
  protected long lastShot;

  public Tower(Tile t, int damage, int speed, int range, int upPrice, int sellPrice, String name, String effect) {
    setTile(t);
    this.damage = damage;
    this.speed = speed;
    this.range = range;
    upgradePrice = upPrice;
    this.sellPrice = sellPrice;
    this.name = name;
    this.effect = effect;
    level = 1;
  }

  public int getLevel() {
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

  public void upLevel() {
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
  public void shoot(ArrayList<Enemy> enemiesSpawned) {
    //println("s");
    if (System.currentTimeMillis() - lastShot > speed * 100) {
      for (Iterator<Enemy> it = enemiesSpawned.iterator (); it.hasNext(); ) {
        Enemy t = it.next();
        float d = dist(myTile.getX(), myTile.getY(), t.getX(), t.getY());
        if (d <= range) {
          t.takeDamage(damage);
          if (t.getHealth() <= 0) {
            it.remove(); // Remove the enemy from Game's enemiesSpawned
          }
          lastShot = System.currentTimeMillis();
          break;
        }
      }
    }
  }

  public abstract void upgrade();
  //Upgrades Stats at a cost

  public void sell() {
    myBoard.getParent().removeFromTowers(this);
    myWall.removeTower();
    myTile.removeAgentOn(this);
    myBoard.getParent().addCurrency(sellPrice);
  }
}
