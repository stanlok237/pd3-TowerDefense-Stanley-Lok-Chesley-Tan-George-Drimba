public class Base extends Agent {

  private int maxHealth, currentHealth, level;

  public Base(int health) {
    myName = Constants.BASE;
    maxHealth = health;
    currentHealth = health;
    level = 1;
  }

  public Base() {
    super(0, 10);
    myName = Constants.BASE;
    maxHealth = 500;
    currentHealth = maxHealth;
    level = 1;
  }

  public int getHealth() {
    return currentHealth;
  }
  
  public int getMaximumHealth() {
    return maxHealth;
  }
  
  public int getLevel() {
    return level;
  }

  public int takeDamage(int change) {
    currentHealth -= change;
    return -1;
  }

  public void upgrade(String type) {
    //going to add a check later on when theres a money class
    if (type.equals("Health")) {
      maxHealth += 100 + level * 10;
      level++;
      currentHealth = maxHealth;
    }
  }


  public void replenishHealth() {
    currentHealth = maxHealth;
  }

  public String toString() {
    return "Base: " + currentHealth + " / " + maxHealth;
  }

  public int getManDistance(Agent other) {
    Tile baseTile = getTile();
    Tile otherTile = other.getTile();
    return Math.abs(baseTile.getY() - otherTile.getY()) + Math.abs(baseTile.getX() + otherTile.getX());
  }

  public void act() {
  }
  
  public void generateHealthBar() {
    float perc = 1.0 * currentHealth / maxHealth;
    int length = round(perc * Constants.PIXEL_TO_BOARD_INDEX_RATIO);
    fill(50, 200, 0, 100);
    rect(xcor, ycor, length, round(Constants.PIXEL_TO_BOARD_INDEX_RATIO * Constants.BASE_HEALTH_BAR_HEIGHT_PERCENTAGE));
  }
  
  public void display() {
    fill(0, 0, 200, 100);
    rect(xcor, ycor, Constants.PIXEL_TO_BOARD_INDEX_RATIO, Constants.PIXEL_TO_BOARD_INDEX_RATIO);
    generateHealthBar();
  }
  
  public boolean inBody(int x, int y) {
    return (x > xcor && x < xcor + Constants.PIXEL_TO_BOARD_INDEX_RATIO && y > ycor && y < ycor + Constants.PIXEL_TO_BOARD_INDEX_RATIO);
  }
}
