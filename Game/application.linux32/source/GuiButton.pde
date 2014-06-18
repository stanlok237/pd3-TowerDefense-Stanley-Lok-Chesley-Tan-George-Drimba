public class GuiButton {
  String myText;
  int x, y, myHeight, myWidth, borderTopLeft, borderTopRight, borderBottomRight, borderBottomLeft;
  color myColor, myTextColor, myHoverColor, myHoverTextColor, myClickedColor, myClickedTextColor, currentColor, currentTextColor;
  int myTextSize;
  boolean noStroke = true;
  Agent myAgent;
  InfoDisplay idParent;

  public GuiButton() {
  
  }
  
  public GuiButton(InfoDisplay id) {
    idParent = id;
  }

  void setText(String s) {
    myText = s;
  }

  String getText() {
    return myText;
  }

  void setX(int n) {
    x = n;
  }

  void setY(int n) {
    y = n;
  }

  int getX() {
    return x;
  }

  int getY() {
    return y;
  }

  void setColor(color c) {
    myColor = c;
  }

  color getColor() {
    return myColor;
  }

  void setHoverColor(color c) {
    myHoverColor = c;
  }

  color getHoverColor() {
    return myHoverColor;
  }

  void setClickedColor(color c) {
    myClickedColor = c;
  }

  color getClickedColor() {
    return myClickedColor;
  }

  void setTextColor(color c) {
    myTextColor = c;
  }

  color getTextColor() {
    return myTextColor;
  }

  void setHoverTextColor(color c) {
    myHoverTextColor = c;
  }

  color getHoverTextColor() {
    return myHoverTextColor;
  }

  void setClickedTextColor(color c) {
    myClickedTextColor = c;
  }

  color getClickedTextColor() {
    return myClickedTextColor;
  }

  void setHeight(int n) {
    myHeight = n;
  }

  int getHeight() {
    return myHeight;
  }

  void setWidth(int n) {
    myWidth = n;
  }

  int getWidth() {
    return myWidth;
  }
  
  void setBorders(int tl, int tr, int br, int bl) {
    borderTopLeft = tl;
    borderTopRight = tr;
    borderBottomRight = br;
    borderBottomLeft = bl;
  }

  void setTextSize(int n) {
    myTextSize = n;
  }

  int getTextSize() {
    return myTextSize;
  }

  void setStroke(boolean b) {
    noStroke = !b;
  }
  
  void attachAgent(Agent a) {
    myAgent = a;
  }
  
  Agent getAttachedAgent() {
    return myAgent;
  }

  void hover() {
    if (currentColor != myHoverColor || currentTextColor != myHoverTextColor) {
      if (noStroke) {
        noStroke();
      }
      else {
        stroke(Constants.GAME_STROKE_COLOR);
      }
      clear();
      fill(myHoverColor);
      currentColor = myHoverColor;
      rect(x, y, myWidth, myHeight, borderTopLeft, borderTopRight, borderBottomRight, borderBottomLeft);
      textAlign(CENTER, CENTER);
      fill(myHoverTextColor);
      currentTextColor = myHoverTextColor;
      textSize(myTextSize);
      text(myText, x + myWidth / 2, y + myHeight / 2 - textAscent() * 0.1); //hacky fix for inaccurate default centering
    }
    cursor(HAND);
  }

  void clicked() {
    if (currentColor != myClickedColor || currentTextColor != myClickedTextColor) {
      if (noStroke) {
        noStroke();
      }
      else {
        stroke(Constants.GAME_STROKE_COLOR);
      }
      clear();
      fill(myClickedColor);
      currentColor = myClickedColor;
      rect(x, y, myWidth, myHeight, borderTopLeft, borderTopRight, borderBottomRight, borderBottomLeft);
      textAlign(CENTER, CENTER);
      fill(myClickedTextColor);
      currentTextColor = myClickedTextColor;
      textSize(myTextSize);
      text(myText, x + myWidth / 2, y + myHeight / 2 - textAscent() * 0.1);
    }
  }

  void display() {
    if (currentColor != myColor || currentTextColor != myTextColor) {
      forceDisplay();
    }
  }

  void forceDisplay() {
    if (noStroke) {
      noStroke();
    }
    else {
        stroke(Constants.GAME_STROKE_COLOR);
      }
    clear();
    fill(myColor);
    currentColor = myColor;
    rect(x, y, myWidth, myHeight, borderTopLeft, borderTopRight, borderBottomRight, borderBottomLeft);
    textAlign(CENTER, CENTER);
    fill(myTextColor);
    currentTextColor = myTextColor;
    textSize(myTextSize);
    text(myText, x + myWidth / 2, y + myHeight / 2 - textAscent() * 0.1);
    cursor(ARROW);
  }

  void clear() {
    fill(0);
    rect(x, y, myWidth, myHeight, borderTopLeft, borderTopRight, borderBottomRight, borderBottomLeft);
  }

  void clickAction() {
  }
}
