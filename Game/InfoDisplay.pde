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
        upgradeButton.setX(parent.boardWidth + Constants.SIDEBAR_WIDTH / 4);
        upgradeButton.setY(Constants.NEW_WALL_BUTTON_HEIGHT + 4 * Constants.INFO_DISPLAY_HEIGHT / 6);
        upgradeButton.setWidth(Constants.SIDEBAR_WIDTH / 2);
        upgradeButton.setHeight(Constants.INFO_DISPLAY_HEIGHT / 8);
        upgradeButton.setBorders(7, 7, 7, 7);
        upgradeButton.setTextColor(color(200));
        upgradeButton.setHoverTextColor(color(240));
        upgradeButton.setText("Upgrade");
        upgradeButton.setTextSize(14);
        upgradeButton.forceDisplay();
      }
      else if (name.equals(Constants.WALL)) {
        Wall w = (Wall)a;
        Tower t = w.getTower();
        if (t != null) {
          showInfo(t);
        }
      }
      else if (a instanceof Enemy) {
        Enemy e = (Enemy)a;
        text("Health: " + e.getHealth(), parent.boardWidth + Constants.SIDEBAR_WIDTH / 2, Constants.NEW_WALL_BUTTON_HEIGHT + 2 * Constants.INFO_DISPLAY_HEIGHT / 6);
        text("Speed: " + e.getSpeed(), parent.boardWidth + Constants.SIDEBAR_WIDTH / 2, Constants.NEW_WALL_BUTTON_HEIGHT + 3 * Constants.INFO_DISPLAY_HEIGHT / 6);
        text("Armor: " + e.getArmor(), parent.boardWidth + Constants.SIDEBAR_WIDTH / 2, Constants.NEW_WALL_BUTTON_HEIGHT + 4 * Constants.INFO_DISPLAY_HEIGHT / 6);
        text("Damage: " + e.getDamage(), parent.boardWidth + Constants.SIDEBAR_WIDTH / 2, Constants.NEW_WALL_BUTTON_HEIGHT + 5 * Constants.INFO_DISPLAY_HEIGHT / 6);
      }
      else if (a instanceof Tower) {
        //range, damage, speed, upgradePrice, sellPrice, level;
        Tower t = (Tower)a;
        text("Range: " + t.getRange(), parent.boardWidth + Constants.SIDEBAR_WIDTH / 2, Constants.NEW_WALL_BUTTON_HEIGHT + 2 * Constants.INFO_DISPLAY_HEIGHT / 7);
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
      }
      else {
        gb.display();
      }
    }
  }
  
}
