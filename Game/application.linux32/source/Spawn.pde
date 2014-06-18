public class Spawn extends Agent {
  private LinkedList<Enemy> spawnQueue = new LinkedList<Enemy>();
  private Game myGame;
  private int roundLoaded;
  private long lastSpawn;
  private long coolDown = 1000; // milliseconds
  private boolean queueEmpty;

  public Spawn(Game g) {
    myName = Constants.SPAWN;
    myGame = g;
  }

  public void act() {
    if (spawnQueue.isEmpty()) {
      int round = myGame.getRound();
      if (roundLoaded != round) {
        if (round < 3) {
          for (int i = 0; i < round; i++)
            spawnQueue.add(new Grunt(round, myTile, myBoard));
        } else if (round < 5) {
          for (int i = 0; i < round; i++)
            spawnQueue.add(new Grunt(round, myTile, myBoard));
          for (int i = 0; i < round; i++)
            spawnQueue.add(new Bat(round, myTile, myBoard));
        } else if (round < 7) {
          for (int i = 0; i < 2 * round; i++)
            spawnQueue.add(new Bat(round, myTile, myBoard));
        } else if (round < 9) {
          for (int i = 0; i < round; i++)
            spawnQueue.add(new Alien(round, myTile, myBoard));
        } else if (round < 11) {
          for (int i = 0; i < round; i++)
            spawnQueue.add(new Alien(round, myTile, myBoard));
          for (int i = 0; i < round / 2; i++)
            spawnQueue.add(new Giant(round, myTile, myBoard));
        } else if (round < 13) {
          for (int i = 0; i < round; i++)
            spawnQueue.add(new Alien(round, myTile, myBoard));
          for (int i = 0; i < round; i++)
            spawnQueue.add(new Bat(round, myTile, myBoard));
        } else if (round < 15) {
          for (int i = 0; i < round; i++)
            spawnQueue.add(new Grunt(round, myTile, myBoard));
          for (int i = 0; i < round; i++)
            spawnQueue.add(new Grunt(round, myTile, myBoard));
        } else if (round >= 15) {
          for (int i = 0; i < round; i++)
            spawnQueue.add(new Grunt(round, myTile, myBoard));
          for (int i = 0; i < round; i++)
            spawnQueue.add(new Bat(round, myTile, myBoard));
          for (int i = 0; i < round; i++)
            spawnQueue.add(new Alien(round, myTile, myBoard));
          for (int i = 0; i < round; i++)
            spawnQueue.add(new Giant(round, myTile, myBoard));
        }
        roundLoaded = round;
        queueEmpty = false;
      }
    }
    if (!spawnQueue.isEmpty() && System.currentTimeMillis() - lastSpawn > coolDown) {
      lastSpawn = System.currentTimeMillis();
      Enemy e = spawnQueue.remove();
      myGame.addToAlive(e);
      myTile.addAgentOn(e);
    }
    else if (spawnQueue.isEmpty()) {
      queueEmpty = true;
    }
  }
  
  public boolean queueEmpty() {
    return queueEmpty;
  }

  public String toString() {
    return "Spawn: " + spawnQueue.toString();
  }

  public void display() {
  }
  public boolean inBody(int x, int y) {
    return false;
  }
}
