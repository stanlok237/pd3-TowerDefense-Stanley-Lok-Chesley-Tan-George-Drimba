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
   private ManhattanDistance distance;
   private Base base;
   
   public AStarSearch(int size, Base b){
     board = new Board(size);
     base = b;
     distance = new ManhattanDistance(base);
     frontier = new PriorityQueue<Agent>();
   }
   
   public class ManhattanDistance implements Comparator{
     
     private Base base;
     
     public ManhattanDistance(Base b){
         base = b;
     }
     
     public Agent compare(Agent a, Agent b){
         int aDistance = base.getManDistance(a);
         int bDistance = base.getManDistance(b);
         
         
         
