IntroState is = new IntroState();
color background = #EEEEEE;
color hoverColor = #FF0000;
boolean hovered = false;

/*
void setup() {
  size(500, 500);
  is.drawBackground();
}*/
class IntroState extends State {
  int playBW, playBH;
  int playButtonX, playButtonY;

  IntroState() {
    
  }

  void drawBackground() {
    background(background);

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

  void redraw1() {
    fill(background);
    noStroke();
    textSize(20);
    rect(0, 170, width, textAscent() + textDescent());
    fill(hoverColor);
    text("How to Play", width / 2, 170);
  }

  void redraw2() {
    fill(background);
    noStroke();
    textSize(20);
    rect(0, 220, width, textAscent() + textDescent());
    fill(hoverColor);
    text("About", width / 2, 220);
  }

  void redraw3() {
    fill(background);
    noStroke();
    textSize(38);
    rect(0, 270, width, textAscent() + textDescent());
    fill(hoverColor);
    text("Play!", width / 2, 270);
  }
}
/*
void draw() {
  int threshold = 30;
  println(hovered);
  if (get(mouseX, mouseY) != background) {
    if (abs(mouseY - 170) < 20) {
      is.redraw1();
      hovered = true;
    } else if (abs(mouseY - 220) < 20) {
      is.redraw2();
      hovered = true;
    } else if (abs(mouseY - 270) < 38) {
      is.redraw3();
      hovered = true;
    }
  } else if (hovered == true && get(mouseX, mouseY) == background) {
    is.drawBackground();
    hovered = false;
  }
}
*/
