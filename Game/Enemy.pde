import java.util.*;
import java.io.*;

public abstract class Enemy extends Agent {

  private int currentHealth, maxHealth, currentSpeed, maxSpeed, currentArmor, maxArmor, damage;
  private String name;
  private AStarSearch search;

  public Enemy(int x, int y, int health, int speed, int armor, int damage, String name) {
    super(x, y);
    maxHealth = health;
    currentHealth = maxHealth;
    maxSpeed = speed;
    currentSpeed = maxSpeed;
    maxArmor = armor;
    currentArmor = maxArmor;
    this.damage = damage;
    this.name = name;
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

  public void takeDamage(int d) {
    if (currentHealth - d < 0) {
      die();
    } else {
      currentHealth = currentHealth - d;
    }
  }

  public void slow(int s) {
    if (currentSpeed - s < 5) {
      currentSpeed = 5;
    } else {
      currentSpeed = currentSpeed - s;
    }
  }

  public void die() {
    getTile().removeAgentOn(this);
    //Add Gold Value Here
  }

  public void shredArmor(int a) {
    if (currentArmor - a < 0) {
      currentArmor = 0;
    } else {
      currentArmor = currentArmor - a;
    }
  }
}
