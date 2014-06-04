public class Base extends Agent{

    private int maxHealth, currentHealth, level, price;
    
    public Base(int health){
	maxHealth = health;
	currentHealth = health;
	level = 1;
	price = 200;
    }
    
    public Base(){
	maxHealth = 500;
	level = 1;
    }
    
    public int getHealth(){
	return currentHealth;
    }

    public int takeDamage(int change){
	currentHealth -= change;
        return -1;
    }

    public void upgrade(String type){
	//going to add a check later on when theres a money class
	if (type.equals("Health")){
	    maxHealth += 100 + level * 10;
	    level++;
	    currentHealth = maxHealth;
	}
    }
	    
    
    public void replenishHealth(){
	currentHealth = maxHealth;
    }

    public String toString(){
	return "Base: " + currentHealth + " / " + maxHealth;
    }

}
