import java.util.ArrayList;
public class InfoDisplay {
  Game parent;
  color INFO_TEXT_COLOR = color(50, 220, 0, 250);
  ArrayList<GuiButton> myButtons;

  public InfoDisplay(Game p) {
    parent = p;
    myButtons = new ArrayList<GuiButton>();
  }
  public void showInfo(Agent a) {
    myButtons = new ArrayList<GuiButton>();
    noStroke();
    if (a == null) {
      clear();
    } else {
      String name = a.getClass().getName();
      name = name.substring(name.indexOf("$") + 1);
      clear();
      fill(INFO_TEXT_COLOR);
      textSize(Constants.INFO_TEXT_SIZE + 6);
      textAlign(CENTER, CENTER);
      text(name, parent.boardWidth + Constants.SIDEBAR_WIDTH / 2, Constants.NEW_WALL_BUTTON_HEIGHT + Constants.INFO_DISPLAY_HEIGHT / 6);
      name = a.getName();
      textSize(Constants.INFO_TEXT_SIZE);
      if (name.equals(Constants.BASE)) {
        Base b = (Base)a;
        text("Health: " + b.getHealth(), parent.boardWidth + Constants.SIDEBAR_WIDTH / 2, Constants.NEW_WALL_BUTTON_HEIGHT + 2 * Constants.INFO_DISPLAY_HEIGHT / 6);
        text("Level: " + b.getLevel(), parent.boardWidth + Constants.SIDEBAR_WIDTH / 2, Constants.NEW_WALL_BUTTON_HEIGHT + 3 * Constants.INFO_DISPLAY_HEIGHT / 6);
        GuiButton upgradeButton = new GuiButton(this) {
          @Override
            public void clickAction() {
            ((Base)myAgent).upgrade("Health");
            idParent.showInfo(myAgent);
            idParent.getButtons().get(0).hover(); // hover effect on the new button created
          }
        };
        myButtons.add(upgradeButton);
        upgradeButton.attachAgent(b);
        upgradeButton.setStroke(false);
        upgradeButton.setColor(color(25, 25, 200, 180));
        upgradeButton.setHoverColor(color(50, 50, 225, 100));
        upgradeButton.setY(Constants.NEW_WALL_BUTTON_HEIGHT + 4 * Constants.INFO_DISPLAY_HEIGHT / 6);
        upgradeButton.setHeight(Constants.INFO_DISPLAY_HEIGHT / 8);
        upgradeButton.setBorders(7, 7, 7, 7);
        upgradeButton.setTextColor(color(200));
        upgradeButton.setHoverTextColor(color(240));
        String upgradeString = "Upgrade ($" + b.getUpgradePrice() + ")";
        upgradeButton.setText(upgradeString);
        upgradeButton.setWidth(ceil(textWidth(upgradeString)) + 10);
        upgradeButton.setX(parent.boardWidth + (Constants.SIDEBAR_WIDTH - upgradeButton.getWidth()) / 2);
        upgradeButton.setTextSize(14);
        upgradeButton.forceDisplay();
      } else if (name.equals(Constants.WALL)) {
        Wall w = (Wall)a;
        Tower t = w.getTower();
        if (t != null) {
          showInfo(t);
        } else { //Brute Adding Turret Buttons That Do Nothing as of now
          GuiButton turretButton = new GuiButton(this) {
            @Override
            public void clickAction() {
              Wall w = (Wall)myAgent;
              myAgent.getTile().addAgent(Constants.TURRET);
              idParent.showInfo(w.getTower());
              int x = myAgent.getTile().getX();
              int y= myAgent.getTile().getY();
              idParent.getParent().tiles[y][x].forceDisplay();
              idParent.getButtons().get(0).hover(); // hover effect on the new button created
              idParent.getParent().removeCurrency(Constants.TURRET_PRICE);
            }
          };
          myButtons.add(turretButton);
          turretButton.attachAgent(w);
          turretButton.setStroke(false);
          turretButton.setColor(color(25, 25, 200, 180));
          turretButton.setHoverColor(color(50, 50, 225, 100));
          turretButton.setY(Constants.NEW_WALL_BUTTON_HEIGHT + 2 * Constants.INFO_DISPLAY_HEIGHT / 6);
          turretButton.setHeight(Constants.INFO_DISPLAY_HEIGHT / 8);
          turretButton.setBorders(7, 7, 7, 7);
          turretButton.setTextColor(color(200));
          turretButton.setHoverTextColor(color(240));
          String turretString = "Turret ($" + Constants.TURRET_PRICE + ")";
          turretButton.setText(turretString);
          turretButton.setWidth(ceil(textWidth(turretString)) + 10);
          turretButton.setX(parent.boardWidth + (Constants.SIDEBAR_WIDTH - turretButton.getWidth()) / 2);
          turretButton.setTextSize(14);
          turretButton.forceDisplay();
          GuiButton cannonButton = new GuiButton(this) {
            @Override
            public void clickAction() {
              Wall w = (Wall)myAgent;
              myAgent.getTile().addAgent(Constants.CANNON);
              idParent.showInfo(w.getTower());
              int x = myAgent.getTile().getX();
              int y= myAgent.getTile().getY();
              idParent.getParent().tiles[y][x].forceDisplay();
              idParent.getButtons().get(0).hover(); // hover effect on the new button created
              idParent.getParent().removeCurrency(Constants.CANNON_PRICE);
            }
          };
          myButtons.add(cannonButton);
          cannonButton.attachAgent(w);
          cannonButton.setStroke(false);
          cannonButton.setColor(color(25, 25, 200, 180));
          cannonButton.setHoverColor(color(50, 50, 225, 100));
          cannonButton.setY(Constants.NEW_WALL_BUTTON_HEIGHT + 3 * Constants.INFO_DISPLAY_HEIGHT / 6);
          cannonButton.setHeight(Constants.INFO_DISPLAY_HEIGHT / 8);
          cannonButton.setBorders(7, 7, 7, 7);
          cannonButton.setTextColor(color(200));
          cannonButton.setHoverTextColor(color(240));
          String cannonString = "Cannon ($" + Constants.CANNON_PRICE + ")";
          cannonButton.setText(cannonString);
          cannonButton.setWidth(ceil(textWidth(cannonString)) + 10);
          cannonButton.setX(parent.boardWidth + (Constants.SIDEBAR_WIDTH - cannonButton.getWidth()) / 2);
          cannonButton.setTextSize(14);
          cannonButton.forceDisplay();
          GuiButton rayButton = new GuiButton(this) {
            @Override
            public void clickAction() {
              Wall w = (Wall)myAgent;
              myAgent.getTile().addAgent(Constants.RAY_GUN);
              idParent.showInfo(w.getTower());
              int x = myAgent.getTile().getX();
              int y= myAgent.getTile().getY();
              idParent.getParent().tiles[y][x].forceDisplay();
              idParent.getButtons().get(0).hover(); // hover effect on the new button created
              idParent.getParent().removeCurrency(Constants.RAY_GUN_PRICE);
            }
          };
          myButtons.add(rayButton);
          rayButton.attachAgent(w);
          rayButton.setStroke(false);
          rayButton.setColor(color(25, 25, 200, 180));
          rayButton.setHoverColor(color(50, 50, 225, 100));
          rayButton.setY(Constants.NEW_WALL_BUTTON_HEIGHT + 4 * Constants.INFO_DISPLAY_HEIGHT / 6);
          rayButton.setHeight(Constants.INFO_DISPLAY_HEIGHT / 8);
          rayButton.setBorders(7, 7, 7, 7);
          rayButton.setTextColor(color(200));
          rayButton.setHoverTextColor(color(240));
          String rayString = "Ray Gun ($" + Constants.RAY_GUN_PRICE + ")";
          rayButton.setText(rayString);
          rayButton.setWidth(ceil(textWidth(rayString)) + 10);
          rayButton.setX(parent.boardWidth + (Constants.SIDEBAR_WIDTH - rayButton.getWidth()) / 2);
          rayButton.setTextSize(14);
          rayButton.forceDisplay();
        }
      } else if (a instanceof Enemy) {
        Enemy e = (Enemy)a;
        text("Health: " + e.getHealth(), parent.boardWidth + Constants.SIDEBAR_WIDTH / 2, Constants.NEW_WALL_BUTTON_HEIGHT + 2 * Constants.INFO_DISPLAY_HEIGHT / 6);
        text("Speed: " + e.getSpeed(), parent.boardWidth + Constants.SIDEBAR_WIDTH / 2, Constants.NEW_WALL_BUTTON_HEIGHT + 3 * Constants.INFO_DISPLAY_HEIGHT / 6);
        text("Armor: " + e.getArmor(), parent.boardWidth + Constants.SIDEBAR_WIDTH / 2, Constants.NEW_WALL_BUTTON_HEIGHT + 4 * Constants.INFO_DISPLAY_HEIGHT / 6);
        text("Damage: " + e.getDamage(), parent.boardWidth + Constants.SIDEBAR_WIDTH / 2, Constants.NEW_WALL_BUTTON_HEIGHT + 5 * Constants.INFO_DISPLAY_HEIGHT / 6);
      } else if (a instanceof Tower) {
        //range, damage, speed, upgradePrice, sellPrice, level;
        Tower t = (Tower)a;
        //text("Damage: " + t.getDamage()(), parent.boardWidth + Constants.SIDEBAR_WIDTH / 2, Constants.NEW_WALL_BUTTON_HEIGHT + 2 * Constants.INFO_DISPLAY_HEIGHT / 7);
        text("Damage: " + t.getDamage(), parent.boardWidth + Constants.SIDEBAR_WIDTH / 2, Constants.NEW_WALL_BUTTON_HEIGHT + 2 * Constants.INFO_DISPLAY_HEIGHT / 7);
        text("Speed: " + t.getSpeed(), parent.boardWidth + Constants.SIDEBAR_WIDTH / 2, Constants.NEW_WALL_BUTTON_HEIGHT + 3 * Constants.INFO_DISPLAY_HEIGHT / 7);
        text("Level: " + t.getLevel(), parent.boardWidth + Constants.SIDEBAR_WIDTH / 2, Constants.NEW_WALL_BUTTON_HEIGHT + 4 * Constants.INFO_DISPLAY_HEIGHT / 7);
        GuiButton upgradeButton = new GuiButton(this) {
          @Override
            public void clickAction() {
            ((Tower)myAgent).upgrade();
            idParent.showInfo(myAgent);
            idParent.getButtons().get(0).hover(); // hover effect on the new button created
          }
        };
        myButtons.add(upgradeButton);
        upgradeButton.attachAgent(t);
        upgradeButton.setStroke(false);
        upgradeButton.setColor(color(25, 25, 200, 180));
        upgradeButton.setHoverColor(color(50, 50, 225, 100));
        upgradeButton.setY(Constants.NEW_WALL_BUTTON_HEIGHT + 5 * Constants.INFO_DISPLAY_HEIGHT / 7);
        upgradeButton.setHeight(Constants.INFO_DISPLAY_HEIGHT / 8);
        upgradeButton.setBorders(7, 7, 7, 7);
        upgradeButton.setTextColor(color(200));
        upgradeButton.setHoverTextColor(color(240));
        String upgradeString = "Upgrade ($" + t.getUpgradePrice() + ")";
        upgradeButton.setText(upgradeString);
        textSize(14);
        upgradeButton.setWidth(ceil(textWidth(upgradeString)) + 10);
        upgradeButton.setX(parent.boardWidth + (Constants.SIDEBAR_WIDTH - upgradeButton.getWidth()) / 2);
        upgradeButton.setTextSize(14);
        upgradeButton.forceDisplay();

        GuiButton sellButton = new GuiButton(this) {
          @Override
            public void clickAction() {
            ((Tower)myAgent).sell();
            int agentX = myAgent.getTile().getX();
            int agentY = myAgent.getTile().getY();
            idParent.getParent().tiles[agentY][agentX].forceDisplay();
            idParent.showInfo(null);
          }
        };
        myButtons.add(sellButton);
        sellButton.attachAgent(t);
        sellButton.setStroke(false);
        sellButton.setColor(color(25, 25, 200, 180));
        sellButton.setHoverColor(color(50, 50, 225, 100));
        sellButton.setY(Constants.NEW_WALL_BUTTON_HEIGHT + 6 * Constants.INFO_DISPLAY_HEIGHT / 7);
        sellButton.setHeight(Constants.INFO_DISPLAY_HEIGHT / 8);
        sellButton.setBorders(7, 7, 7, 7);
        sellButton.setTextColor(color(200));
        sellButton.setHoverTextColor(color(240));
        String sellString = "Sell ($" + t.getSellPrice() + ")";
        sellButton.setText(sellString);
        textSize(14);
        sellButton.setWidth(ceil(textWidth(sellString)) + 10);
        sellButton.setX(parent.boardWidth + (Constants.SIDEBAR_WIDTH - sellButton.getWidth()) / 2);
        sellButton.setTextSize(14);
        sellButton.forceDisplay();
      }
    }
    stroke(Constants.GAME_STROKE_COLOR);
  }
  public ArrayList<GuiButton> getButtons() {
    return myButtons;
  }
  public void clear() {
    fill(Constants.GAME_BACKGROUND_COLOR);
    rect(parent.boardWidth + g.strokeWeight, Constants.NEW_WALL_BUTTON_HEIGHT + g.strokeWeight, Constants.SIDEBAR_WIDTH - g.strokeWeight, Constants.INFO_DISPLAY_HEIGHT - g.strokeWeight);
  }
  public Game getParent() {
    return parent;
  }
  public void clickAction(int x, int y) {
    for (GuiButton gb : myButtons) {
      if (x > gb.getX() && y > gb.getY() && x < gb.getX() + gb.getWidth() && y < gb.getY() + gb.getHeight()) {
        gb.clickAction();
      }
    }
  }
  public void hoverAction(int x, int y) {
    for (GuiButton gb : myButtons) {
      if (x > gb.getX() && y > gb.getY() && x < gb.getX() + gb.getWidth() && y < gb.getY() + gb.getHeight()) {
        gb.hover();
      } else {
        gb.display();
      }
    }
  }
}
