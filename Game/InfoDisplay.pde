public class InfoDisplay {
  Game parent;
  color INFO_TEXT_COLOR = color(50, 200, 0, 250);
  public InfoDisplay(Game p) {
    parent = p;
  }
  public void showInfo(Agent a) {
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
}
