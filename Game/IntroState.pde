class IntroState extends State {
   
  void setup() {
  }
     
  void drawBackground() {
 // fill(, ,);
  rect(0, 0, width, height);
   
  textAlign(CENTER, TOP);
  textSize(40);
  color outline = color(250,250,250);
  color fill = color(0,0,0);
  int y = height/2 - 60;
  text("Tower Defense", width/2, y, outline, fill);
  y += 50;
   
  textSize(20);
  text("How to Play", width/2, y, outline, fill);
  y += 40;
   
  outline = color(0,0,255);
  fill = color(255,255,255);
  text("Press a certain key to start", width/2, y, outline, fill);
  y += 20;
}
    
  }
