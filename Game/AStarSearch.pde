import java.util.*;
import java.io.*;
/*
public class basesearch {
        private AreaMap map;
        private ArrayList<Node> closedList;
        private SortedNodeList openList;
        private Path shortestPath;

        public basesearch(AreaMap map) {
                this.map = map;

                closedList = new ArrayList<Node>();
                openList = new SortedNodeList();
        }

        public Path cShortestPath(int startX, int startY, int destX, int destY) {

                map.setStartLocation(startX, startY);
                map.setDestLocation(destX, destY);

                if (map.getNode(destX, destY).isOccupiedTile) {
                        return null;
                }

                map.getStartNode().setDistanceFromStart(0);
                closedList.clear();
                openList.clear();
                openList.add(map.getStartNode());

                //tobecontinued
        }
}*/

public class AStarSearch{
  
   private Board board;
   private PriorityQueue<Agent> frontier;
  //private ManhattanDistance distance;
   private Base base;
   
   public class Node{  //SHOULD THIS BE A SEPERATE CLASS IN GENERAL SO A TILE COULD HAVE A NODE ATTACHED??
     //Tile Agent is on
     private Tile tile;
     //You can actually have a path
     private Node parent;
     //The Base for Location
     //private Base base;  Better to be in Comparator
     //private int gCost, hCost  Going to be calculated in the Comparator
         
     public Node(Node n, Tile t){
       //base = b;
       tile = t;
       parent = n;
     }   
       
     public Node(Tile t){
       tile = t;
       parent = null;
     }
   
     public Node getParent(){
       return parent;
     }
     
     public boolean hasParent(){
       return parent != null;
     }
     
     public Tile getTile(){
       return tile;
     }
     
     public void setTile(Tile t){
       tile = t;
     }
 
     /*
     public int getFCost(){
       return gCost + hCost;
     }
     
     public int getGCost(){
       return gCost;
     }
     
     public int getHCost(){
       return hCost;
     }
     */
   }
   
   public class Distance implements Comparator{
     
     private Base base;
     
     public Distance(Base b){
        base = b;
     }
     
     public Tile compare(Node a, Node b){
       hDistanceA = Math.abs(a.getX() - base.getTile().getX()) + Math.abs(a.getY() - base.getTile().getY()); //Tile A Heuristic Distance
       hDistanceB = Math.abs(b.getX() - base.getTile().getX()) + Math.abs(b.getY() - base.getTile().getY()); //Tile B Heuristic Distance
       
       sDistanceA = 
       
   
   public AStarSearch(int size, Base b){
     board = new Board(size);
     base = b;
     distance = new ManhattanDistance(base);
     frontier = new PriorityQueue<Agent>();
   }
   
   /*  I'm Going to make the class Node based
   public class ManhattanDistance implements Comparator{
     
     private Base base;
     
     public ManhattanDistance(Base b){
         base = b;
     }
     
     public Agent compare(Agent a, Agent b){
         int aDistance = base.getManDistance(a);
         int bDistance = base.getManDistance(b);
    */     
         
         
