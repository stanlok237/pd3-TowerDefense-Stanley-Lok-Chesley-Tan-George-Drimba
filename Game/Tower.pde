public abstract class Tower extends Agent {

  protected Wall myWall;
  protected int range, damage, speed, upgradePrice, sellPrice, level;
  protected int defaultRange, defaultDamage, defaultSpeed;
  protected String name, effect;
  protected long lastShot;

  public Tower(Tile t, int damage, int speed, int range, int upPrice, int sellPrice, String name, String effect) {
    setTile(t);
    this.damage = damage;
    defaultDamage = damage;
    this.speed = speed;
    defaultSpeed = speed;
    this.range = range;
    defaultRange = range;
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

  public void setRange(int r) {
    range = r;
  }

  public void setDamage(int d) {
    damage = d;
  }

  public void setSpeed(int s) {
    speed = s;
  }
  
  public Wall getWall() {
    return myWall;
  }



  public void setWall(Wall w) {
    myWall = w;
  }

  //Generic Shooting
  public void shoot(ArrayList<Enemy> enemiesSpawned) {
    if (System.currentTimeMillis() - lastShot > (float)(1000 / speed)) {
      for (Iterator<Enemy> it = enemiesSpawned.iterator (); it.hasNext(); ) {
        Enemy t = it.next();
        float d = dist(myTile.getX(), myTile.getY(), t.getTile().getX(), t.getTile().getY());
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

  public void sell() {
    myBoard.getParent().removeFromTowers(this);
    myWall.removeTower();
    myTile.removeAgentOn(this);
    myBoard.getParent().addCurrency(sellPrice);
  }
}
