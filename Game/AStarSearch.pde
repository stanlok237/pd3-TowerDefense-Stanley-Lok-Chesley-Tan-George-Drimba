import java.util.*;

public class AStarSearch{
  
   private Board board;
   private PriorityQueue<Node> frontier;
   private Base base;
   private Comparator<Node> comparator;
   private ArrayList<Tile> checkedNodes;
   
   public class Distance implements Comparator<Node>{
     
     private Base base;
     
     public Distance(Base b){
        base = b;
     }
     
     public int compare(Node a, Node b){
       //Node a = (Node)(tma);
       //Node b = (Node)(tmb);
       int hDistanceA = Math.abs(a.getTile().getX() - base.getTile().getX()) + Math.abs(a.getTile().getY() - base.getTile().getY()); //Tile A Heuristic Distance
       int hDistanceB = Math.abs(b.getTile().getX() - base.getTile().getX()) + Math.abs(b.getTile().getY() - base.getTile().getY()); //Tile B Heuristic Distance
       //Get Start Location
       Node tmpa = a;
       Node tmpb = b;
       while(tmpa.hasParent()){
          hDistanceA++;
           tmpa = tmpa.getParent();
       }
       while(tmpb.hasParent()){
           hDistanceB++;
           tmpb = tmpb.getParent();
       }
       
       //hDistanceA += Math.abs(a.getTile().getX() - tmpa.getTile().getX()) + Math.abs(a.getTile().getY() - tmpa.getTile().getY());
       //hDistanceB += Math.abs(b.getTile().getX() - tmpb.getTile().getX()) + Math.abs(b.getTile().getY() - tmpb.getTile().getY());
       
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
     frontier = new PriorityQueue<Node>(10, comparator);
     checkedNodes = new ArrayList<Tile>();
   }
   
   public Node search(Tile start){
     Node s = new Node(start);
     frontier.add(s);//Initial Frontier
     while(frontier.size() > 0){
         Node current = frontier.remove();
         System.out.println(current);
         //System.out.println("remove");
         if (current.getTile().equals(base.getTile())){
            return current;
         }
         checkedNodes.add(current.getTile());
         //Making Nearby Nodes
         //System.out.println(current.getTile());
         
         Node up = new Node(current, board.getUpper(current.getTile()));
         Node down = new Node(current, board.getLower(current.getTile()));
         Node left = new Node(current, board.getLeft(current.getTile()));
         Node right = new Node(current, board.getRight(current.getTile()));
        
           
         //Possible bug here considering each node could possibly contain different parent pointers
         if(up.getTile() != null && !checkedNodes.contains(up.getTile()) && up.getTile().getAgent() == null){
           System.out.println("up");
           frontier.add(up);
         }
         if(down.getTile() != null && !checkedNodes.contains(down.getTile()) && down.getTile().getAgent() == null){
           frontier.add(down);
         }
         if(left.getTile() != null && !checkedNodes.contains(left.getTile()) && left.getTile().getAgent() == null){
           frontier.add(left);
         }
         if(right.getTile() != null && !checkedNodes.contains(right.getTile()) && right.getTile().getAgent() == null){
           frontier.add(right);
         }
     }
     return null;
   }
       
}
