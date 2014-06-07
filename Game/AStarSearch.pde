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
   private PriorityQueue<Node> frontier;
  //private ManhattanDistance distance;
   private Base base;
   private Distance distance;
   private Comparator<Node> comparator;
   
   public class Distance implements Comparator{
     
     private Base base;
     
     public Distance(Base b){
        base = b;
     }
     
     public int compare(Node a, Node b){
       hDistanceA = Math.abs(a.getX() - base.getTile().getX()) + Math.abs(a.getY() - base.getTile().getY()); //Tile A Heuristic Distance
       hDistanceB = Math.abs(b.getX() - base.getTile().getX()) + Math.abs(b.getY() - base.getTile().getY()); //Tile B Heuristic Distance
       //Get Start Location
       Node tmpa = a;
       Node tmpb = b;
       while(tmpa.hasParent()){
           tmpa = tmpa.getParent();
       }
       while(tmpb.hasParent()){
           tmpb = tmpb.getParent();
       }
       
       hDistanceA += Math.abs(a.getX() - tmpa.getX()) + Math.abs(a.getY() - tmpa.getY());
       hDistanceB += Math.abs(b.getX() - tmpb.getX()) + Math.abs(b.getY() - tmpb.getY());
       
       if(hDistanceA > hDistanceB){
         return 1;
       }
       else if(hDistanceA == hDistanceB){
         return 0;
       }
       else{
         return -1
       }
     }
   }
       
   
   public AStarSearch(int size, Base b){
     board = new Board(size);
     base = b;
     comparator = new Distance(base);
     frontier = new PriorityQueue<Node>(10, comparator);
   }
   
   public Node search(Tile start){
     Node s = new Node(start);
     frontier.add(s);//Initial Frontier
     while(frontier.size() > 0){
       
     
   
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
         
         
