public class IntroState extends PApplet {
  color introBgColor = #EEEEEE;
  boolean introHovered = false;
  String screen = "menu";
  int howTo_buttonSize = 30;
  int about_buttonSize = 30;
  int play_buttonSize = 48;
  int back_buttonSize = 30;
  PApplet parent;
  Game parentGame;

  public IntroState(PApplet parent) {
    this.parent = parent;
    parentGame = (Game) parent;
  }

  public void setup() {
    cursor(WAIT);
    size(500, 400);
    drawMenu();
    cursor(ARROW);
  }

  public void drawMenu() {
    background(introBgColor);
    textAlign(CENTER, TOP);
    fill(50);
    textSize(50);
    text("Tower Defense", width / 2, 40);
    fill(50);
    textSize(howTo_buttonSize);
    text("How to Play", width / 2, 170);

    textSize(about_buttonSize);
    text("About", width / 2, 220);

    textSize(play_buttonSize);
    text("Play!", width / 2, 270);
  }

  public void drawHowToScreen() {
    background(introBgColor);
    fill(color(255, 64, 0));
    textSize(16);
    text("The goal is to defend your base by placing down new walls\n" + 
    "strategically in order to impede the path of the invading\n" + 
    "enemies, who must find the shortest path to your base.\n\n" + 
    "You can place towers on the walls to attack the enemies,\n" + 
    "preventing them from reaching your base and destroying it."
    , width / 2 , 70);
    drawBack();
  }
  
  public void drawAboutScreen() {
    background(introBgColor);
    fill(color(25, 25, 200, 150));
    textSize(20);
    text("This game was written by:", width / 2, 70);
    fill(color(25,25,200,200));
    text(
    "Chesley Tan\n" +
    "Stanley Lok\n" +
    "George Drimba\n"
    , width / 2, 130);
    textSize(16);
    fill(color(50,50,200,100));
    text("Written in Processing/Java", width / 2, 270);
    drawBack();
  }

  public void draw() {
    if (screen.equals("menu")) {
      if (!introHovered && get(mouseX, mouseY) != introBgColor) {
        if (abs(mouseY - 170) < howTo_buttonSize) {
          redrawHowTo();
          cursor(HAND);
          introHovered = true;
        } else if (abs(mouseY - 220) < about_buttonSize) {
          redrawAbout();
          cursor(HAND);
          introHovered = true;
        } else if (abs(mouseY - 270) < play_buttonSize) {
          redrawPlay();
          cursor(HAND);
          introHovered = true;
        }
      } else if (introHovered && get(mouseX, mouseY) == introBgColor) {
        drawMenu();
        cursor(ARROW);
        introHovered = false;
      }
    } else if (screen.equals("howto")) {
      if (!introHovered && get(mouseX, mouseY) != introBgColor) {
        if (abs(mouseY - 340) < back_buttonSize) {
          redrawHowToBack();
          cursor(HAND);
          introHovered = true;
        }
      } else if (introHovered && get(mouseX, mouseY) == introBgColor) {
        drawBack();
        cursor(ARROW);
        introHovered = false;
      }
    } else if (screen.equals("about")) {
      if (!introHovered && get(mouseX, mouseY) != introBgColor) {
        if (abs(mouseY - 340) < back_buttonSize) {
          redrawAboutBack();
          cursor(HAND);
          introHovered = true;
        }
      } else if (introHovered && get(mouseX, mouseY) == introBgColor) {
        drawBack();
        cursor(ARROW);
        introHovered = false;
      }
    }
  }

  void redrawHowTo() {
    fill(introBgColor);
    noStroke();
    textSize(howTo_buttonSize);
    rect(0, 170, width, textAscent() + textDescent());
    fill(#FF8300);
    text("How to Play", width / 2, 170);
  }

  void redrawAbout() {
    fill(introBgColor);
    noStroke();
    textSize(about_buttonSize);
    rect(0, 220, width, textAscent() + textDescent());
    fill(25, 25, 200, 200);
    text("About", width / 2, 220);
  }

  void redrawPlay() {
    fill(introBgColor);
    noStroke();
    textSize(play_buttonSize);
    rect(0, 270, width, textAscent() + textDescent());
    fill(#FF4346);
    text("Play!", width / 2, 270);
  }

  public void drawBack() {
    fill(introBgColor);
    noStroke();
    textSize(about_buttonSize);
    rect(0, 340, width, textAscent() + textDescent());
    fill(50);
    textSize(back_buttonSize);
    text("Back", width / 2, 340);
  }

  public void redrawHowToBack() {
    fill(introBgColor);
    noStroke();
    textSize(about_buttonSize);
    rect(0, 340, width, textAscent() + textDescent());
    fill(#FF8300);
    textSize(back_buttonSize);
    text("Back", width / 2, 340);
  }
  
  public void redrawAboutBack() {
    fill(introBgColor);
    noStroke();
    textSize(about_buttonSize);
    rect(0, 340, width, textAscent() + textDescent());
    fill(color(25, 25, 200, 200));
    textSize(back_buttonSize);
    text("Back", width / 2, 340);
  }

  void mouseClicked() {
    if (get(mouseX, mouseY) != introBgColor) {
      if (screen.equals("menu")) {
        if (abs(mouseY - 170) < howTo_buttonSize) {
          screen = "howto";
          drawHowToScreen();
        } else if (abs(mouseY - 220) < about_buttonSize) {
          screen = "about";
          drawAboutScreen();
        } else if (abs(mouseY - 270) < play_buttonSize) {
          parentGame.startGame();
          noLoop();
        }
      } else if (screen.equals("howto") || screen.equals("about")) {
        if (abs(mouseY - 340) < back_buttonSize) {
          screen = "menu";
          drawMenu();
        }
      }
    }
  }
}
