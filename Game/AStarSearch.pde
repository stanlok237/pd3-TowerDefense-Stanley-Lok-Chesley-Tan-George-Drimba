
import java.util.*;
import java.io.*;

public class AStarSearch{
  
   private Board board;
   private PriorityQueue<Node> frontier;
   private Base base;
   private Comparator<Node> comparator;
   private ArrayList<Node> checkedNodes;
   
   public class Distance implements Comparator{
     
     private Base base;
     
     public Distance(Base b){
        base = b;
     }
     
     public int compare(Node a, Node b){
       hDistanceA = Math.abs(a.getTile().getX() - base.getTile().getX()) + Math.abs(a.getTile().getY() - base.getTile().getY()); //Tile A Heuristic Distance
       hDistanceB = Math.abs(b.getTile().getX() - base.getTile().getX()) + Math.abs(b.getTile().getY() - base.getTile().getY()); //Tile B Heuristic Distance
       //Get Start Location
       Node tmpa = a;
       Node tmpb = b;
       while(tmpa.hasParent()){
           tmpa = tmpa.getParent();
       }
       while(tmpb.hasParent()){
           tmpb = tmpb.getParent();
       }
       
       hDistanceA += Math.abs(a.getTile().getX() - tmpa.getTile().getX()) + Math.abs(a.getTile().getY() - tmpa.getTile().getY());
       hDistanceB += Math.abs(b.getTile().getX() - tmpb.getTile().getX()) + Math.abs(b.getTile().getY() - tmpb.getTile().getY());
       
       if(hDistanceA > hDistanceB){
         return 1;
       }
       else if(hDistanceA == hDistanceB){
         return 0;
       }
       else{
         return -1;
       }
     }
   }
       
   
   public AStarSearch(int size, Base b){
     board = new Board(size);
     base = b;
     comparator = new Distance(base);
     frontier = new PriorityQueue<Node>(comparator);
     checkedNodes = new ArrayList<Node>();
   }
   
   public Node search(Tile start){
     Node s = new Node(start);
     frontier.add(s);//Initial Frontier
     while(frontier.size() > 0){
         Node current = frontier.remove();
         if (current.getTile().getX() == base.getTile().getX() && current.getTile().getY() == base.getTile().getY()){
            return current;
         }
         checkedNodes.add(current);
         //Making Nearby Nodes
         Node up = new Node(current, Board.getUpper(current.getTile()));
         Node down = new Node(current, Board.getLower(current.getTile()));
         Node left = new Node(current, Board.getLeft(current.getTile()));
         Node right = new Node(current, Board.getRight(current.getTile()));
         //Possible bug here considering each node could possibly contain different parent pointers
         if(!checkedNodes.contain(up)){
           frontier.add(up);
         }
         if(!checkedNodes.contain(down)){
           frontier.add(down);
         }
         if(!checkedNodes.contain(left)){
           frontier.add(left);
         }
         if(!checkedNodes.contain(right)){
           frontier.add(right);
         }
     }
     return null;
   }
       
}
