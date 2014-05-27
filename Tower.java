/* Super Class For all Towers/Turrets*/
public class Tower{

    private int range,damage,speed,upgradePrice,sellPrice;

    //Should we make it like GridWorld type of getting monsters and modifying them

    public void shoot(){
	//Generic Shooting
    }

    public void upgrade(){
	//Upgrades Stats at a cost
    }

    public void sell(){
	//Removes the tower
    }

}
