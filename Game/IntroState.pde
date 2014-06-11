public class IntroState extends PApplet {
  color introBgColor = #EEEEEE;
  color introHoverColor = #FF8300;
  boolean introHovered = false;
  PApplet parent;
  Game parentGame;

  public IntroState(PApplet parent) {
    this.parent = parent;
    parentGame = (Game) parent;
  }

  public void setup() {
    size(500, 400);
    drawBackground();
  }

  public void drawBackground() {
    background(introBgColor);
    textAlign(CENTER, TOP);
    fill(0);
    textSize(40);
    text("Tower Defense", width / 2, 70);
    fill(0);
    textSize(20);
    text("How to Play", width / 2, 170);

    textSize(20);
    text("About", width / 2, 220);

    textSize(38);
    text("Play!", width / 2, 270);
  }

  public void draw() {
    if (get(mouseX, mouseY) != introBgColor) {
      if (abs(mouseY - 170) < 20) {
        redraw1();
        introHovered = true;
      } else if (abs(mouseY - 220) < 20) {
        redraw2();
        introHovered = true;
      } else if (abs(mouseY - 270) < 38) {
        redraw3();
        introHovered = true;
      }
    } else if (introHovered == true && get(mouseX, mouseY) == introBgColor) {
      drawBackground();
      introHovered = false;
    }
  }

  void redraw1() {
    fill(introBgColor);
    noStroke();
    textSize(20);
    rect(0, 170, width, textAscent() + textDescent());
    fill(introHoverColor);
    text("How to Play", width / 2, 170);
  }

  void redraw2() {
    fill(introBgColor);
    noStroke();
    textSize(20);
    rect(0, 220, width, textAscent() + textDescent());
    fill(introHoverColor);
    text("About", width / 2, 220);
  }

  void redraw3() {
    fill(introBgColor);
    noStroke();
    textSize(38);
    rect(0, 270, width, textAscent() + textDescent());
    fill(introHoverColor);
    text("Play!", width / 2, 270);
  }

  void mouseClicked() {
    if (get(mouseX, mouseY) != introBgColor) {
      if (abs(mouseY - 170) < 20) {
        //
      } else if (abs(mouseY - 220) < 20) {
        //
      } else if (abs(mouseY - 270) < 38) {
        parentGame.startGame();
        noLoop();
      }
    }
  }
}

