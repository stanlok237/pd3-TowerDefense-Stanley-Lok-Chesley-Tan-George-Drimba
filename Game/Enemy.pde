public abstract class Enemy extends Agent {

  protected int currentHealth, maxHealth, currentSpeed, maxSpeed, currentArmor, maxArmor, damage, reward;
  protected AStarSearch search;
  protected Stack<Tile> path;

  public Enemy(Tile t , Board b, int health, int speed, int armor, int damage, int value, String name) {
    setTile(t);
    setBoard(b);
    maxHealth = health;
    currentHealth = maxHealth;
    maxSpeed = speed;
    currentSpeed = maxSpeed;
    maxArmor = armor;
    currentArmor = maxArmor;
    this.damage = damage;
    reward = value;
    myName = name;
    search = new AStarSearch(myBoard);
    Node tmp =  search.search(myTile);
    path = new Stack<Tile>();
    while (tmp != null) {
      //println(tmp);
      path.add(tmp.getTile());
      tmp = tmp.getParent();
    }
  }
  public int getHealth() {
    return currentHealth;
  }

  public int getSpeed() {
    return currentSpeed;
  }

  public int getArmor() {
    return currentArmor;
  }

  public int getDamage() {
    return damage;
  }

  public int getMaxHealth() {
    return maxHealth;
  }

  public int getMaxSpeed() {
    return maxSpeed;
  }

  public int getMaxArmor() {
    return maxArmor;
  }

  public int getReward() {
    return reward;
  }

  public void takeDamage(int d) {
    if (currentHealth - d < 0) {
      die();
    } else {
      currentHealth = currentHealth - d;
    }
  }

  public void die() {
    getTile().removeAgentOn(this);
    //Add Gold Value Here
  }
  public void slow(int s) {
    if (currentSpeed - s < 5) {
      currentSpeed = 5;
    } else {
      currentSpeed = currentSpeed - s;
    }
  }
  public void shredArmor(int a) {
    if (currentArmor - a < 0) {
      currentArmor = 0;
    } else {
      currentArmor = currentArmor - a;
    }
  }

  public void generateHealthBar() {
    float perc = 1.0 * currentHealth / maxHealth;
    int length = round(perc * Constants.PIXEL_TO_BOARD_INDEX_RATIO / 2);
    fill(50, 200, 0, 100);
    rect(xcor, ycor, length, round(Constants.PIXEL_TO_BOARD_INDEX_RATIO * Constants.HEALTH_BAR_HEIGHT_PERCENTAGE));
  }

  public Stack<Tile> getPath() {
    return path;
  }

  public void act() {
  }

  /* public void move() {
   --- need some way to store the path in a class 
   if (nextStepinPath.equals("completed")) {
   return;
   }
   else if (nextStepinPath.equals("step")) {
   }
   if (.angleBetween(v1, v2)) {getTile().getRight(this);}
   else if (.angleBetween(v1, v2)) {getTile().getRight(this);} --- insert radian args -- use pvector for simple dimension
   else if (.angleBetween(v1, v2) ) {getTile().getLower(this);}
   else {getTile().getUpper(this);} 
   fill(250,0,0);
   stroke(0);
   ellipse(xcor,ycor,tileSize/2,tileSize/2);
   fill(0);
   }
   */
}
