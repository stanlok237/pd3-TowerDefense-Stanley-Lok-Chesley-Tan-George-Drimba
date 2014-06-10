import java.awt.Frame;
PFrame f;
IntroState is = new IntroState();

void setup() {
 size(320, 240);
 PFrame f = new PFrame();
}

void draw() {
  background(255,0,0);
   fill(255);
   is.background(0, 0, 255);
   is.fill(50, 200, 0);
   is.redraw();
}

public class PFrame extends Frame {
    public PFrame() {
        setBounds(100,100,400,300);
        add(is);
        is.drawBackground();
        show();
    }
}

public class IntroState extends PApplet {
    public void setup() {
        size(400, 300);
        noLoop();
    }

    public void drawBackground() {
      fill(0);
      rect(0, 0, height, width);
    }
}
