public class GuiButton {
  String myText;
  int x, y, myHeight, myWidth;
  color myColor, myTextColor, myHoverColor, myHoverTextColor, myClickedColor, myClickedTextColor, currentColor, currentTextColor;
  int myTextSize;

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

  void setTextSize(int n) {
    myTextSize = n;
  }

  int getTextSize() {
    return myTextSize;
  }

  void hover() {
    if (currentColor != myHoverColor || currentTextColor != myHoverTextColor) {
      clear();
      fill(myHoverColor);
      currentColor = myHoverColor;
      rect(x, y, myWidth, myHeight);
      textAlign(CENTER, CENTER);
      fill(myHoverTextColor);
      currentTextColor = myHoverTextColor;
      textSize(myTextSize);
      text(myText, x + myWidth / 2, myHeight / 2);
    }
  }

  void clicked() {
    if (currentColor != myClickedColor || currentTextColor != myClickedTextColor) {
      clear();
      fill(myClickedColor);
      currentColor = myClickedColor;
      rect(x, y, myWidth, myHeight);
      textAlign(CENTER, CENTER);
      fill(myClickedTextColor);
      currentTextColor = myClickedTextColor;
      textSize(myTextSize);
      text(myText, x + myWidth / 2, myHeight / 2);
    }
  }
  
  void display() {
    if (currentColor != myColor || currentTextColor != myTextColor) {
      forceDisplay();
    }
  }

  void forceDisplay() {
    clear();
    fill(myColor);
    currentColor = myColor;
    rect(x, y, myWidth, myHeight);
    textAlign(CENTER, CENTER);
    fill(myTextColor);
    currentTextColor = myTextColor;
    textSize(myTextSize);
    text(myText, x + myWidth / 2, myHeight / 2);
  }

  void clear() {
    fill(0);
    rect(x, y, myWidth, myHeight);
  }
}
