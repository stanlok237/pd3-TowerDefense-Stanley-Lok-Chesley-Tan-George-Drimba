/*
public class Turret extends Tower {
  
  public Turret (int level){
   name = Turret;
   range = 15;
   speed = 10;
   expneed = 10
   upgradePrice = 20;
   sellPrice = 92;
   this.level = level;
 }
   //public act here --------------------
   public String toString(){
     String stat = "";
     return stat + name + " r =" + range + "s = "+ speed + "u= " + upgradePrice + "s= "+ sellPrice + "d=" + damage;
   }
 }
public void level(int exp) {
  experience = experience + exp;
  if (exp > expneed) {
    level = level + 1;

  Random r = new Random();
  int i = r.nextInt(2); 
  if (i == 1) {
    range = range + 5;
    expneed= expneed + 5 * (level - 1);
  }
  if (i == 2) {
    damage = damage + 5;
    expneed = expneed + 5 * (level - 1);
  }
  else {
    speed = speed + 5;
    expneed = expneed + 5 * (level - 1); 
  }
  maxhealth = strength;
  health = maxhealth; //health regeneration
  }
*/
  
  
