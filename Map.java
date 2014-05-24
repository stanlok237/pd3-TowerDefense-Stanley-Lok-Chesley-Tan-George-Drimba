import java.io.*;
public class Map {
    Object[][] map;

    public Map(String file) {
        try {
            BufferedReader mapFile = new BufferedReader(new FileReader(file));
            String nextLine = mapFile.readLine();
            map = new Object[Integer.parseInt(nextLine.split(" ")[0])][Integer.parseInt(nextLine.split(" ")[1])];
            nextLine = mapFile.readLine();
            int row = 0;
            for (;nextLine != null;nextLine = mapFile.readLine()) {
                String[] objects = nextLine.split(" ");
                for (int i = 0;i < objects.length;i++) {
                    map[row][i] = objects[i];
                }
                row++;
            }
        } catch (IOException e) {
            System.err.println("Error reading map file. Exiting....");
            System.exit(1);
        }
    }

    public String toString() {
        String retStr = "";
        for (int r = 0;r < map.length;r++) {
            for (int c = 0;c < map[0].length;c++) {
                retStr += map[r][c] + " ";
            }
            retStr += "\n";
        }
        return retStr;
    }
    
    public static void main(String[] args) {
        Map m = new Map("resources/maps/Example.MAP");
        System.out.println(m.toString());
    } 
}
