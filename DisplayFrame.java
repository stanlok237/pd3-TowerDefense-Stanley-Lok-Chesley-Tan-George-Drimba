package processJava;
public class DisplayFrame extends javax.swing.JFrame {
    public DisplayFrame(){
        this.setSize(600, 600); 
        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);
        javax.swing.JPanel panel = new javax.swing.JPanel();
	// panel.setBounds();
        //processing.core.PApplet sketch = new Sketch();
        panel.add(sketch);
        this.add(panel);
        sketch.init(); 
        this.setVisible(true);
    }
}