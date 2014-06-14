import java.util.ArrayList;
public class InfoDisplay {
  Game parent;
  color INFO_TEXT_COLOR = color(50, 200, 0, 250);
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
      textSize(Constants.INFO_TEXT_SIZE);
      textAlign(CENTER, CENTER);
      text(name, parent.boardWidth + Constants.SIDEBAR_WIDTH / 2, Constants.NEW_WALL_BUTTON_HEIGHT + Constants.INFO_DISPLAY_HEIGHT / 6);
      name = a.getName();
      if (name.equals(Constants.BASE)) {
        Base b = (Base)a;
        text("Health: " + b.getHealth(), parent.boardWidth + Constants.SIDEBAR_WIDTH / 2, Constants.NEW_WALL_BUTTON_HEIGHT + 2 * Constants.INFO_DISPLAY_HEIGHT / 6);
        text("Level: " + b.getLevel(), parent.boardWidth + Constants.SIDEBAR_WIDTH / 2, Constants.NEW_WALL_BUTTON_HEIGHT + 3 * Constants.INFO_DISPLAY_HEIGHT / 6);
        GuiButton upgradeButton = new GuiButton(this) {
          @Override
          public void clickAction() {
            ((Base)myAgent).upgrade("Health");
            idParent.showInfo(myAgent);
          }
        };
        myButtons.add(upgradeButton);
        upgradeButton.attachAgent(b);
        upgradeButton.setStroke(false);
        upgradeButton.setColor(color(100, 100, 200, 100));
        upgradeButton.setHoverColor(color(150, 150, 250, 100));
        upgradeButton.setX(parent.boardWidth + Constants.SIDEBAR_WIDTH / 4);
        upgradeButton.setY(Constants.NEW_WALL_BUTTON_HEIGHT + 4 * Constants.INFO_DISPLAY_HEIGHT / 6);
        upgradeButton.setWidth(Constants.SIDEBAR_WIDTH / 2);
        upgradeButton.setHeight(Constants.INFO_DISPLAY_HEIGHT / 8);
        upgradeButton.setTextColor(color(240));
        upgradeButton.setHoverTextColor(color(240));
        upgradeButton.setText("Upgrade");
        upgradeButton.setTextSize(14);
        upgradeButton.forceDisplay();
      }
      else if (name.equals(Constants.WALL)) {
        Agent wallAgent = ((Wall)a).getAgent();
        if (wallAgent != null) {
          showInfo(wallAgent);
        }
      }
    }
    stroke(Constants.GAME_STROKE_COLOR);
  }
  public void clear() {
    fill(Constants.GAME_BACKGROUND_COLOR);
    rect(parent.boardWidth + g.strokeWeight, Constants.NEW_WALL_BUTTON_HEIGHT + g.strokeWeight, Constants.SIDEBAR_WIDTH - g.strokeWeight, Constants.INFO_DISPLAY_HEIGHT - g.strokeWeight);
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
