public class ListClass {
    public static void main(){
        //Declairing list
        List<Integer> l1 = new List<Integer>();
        
        //Initializing list
        l1.add(2);
        l1.add(57);
        l1.add(85);
        System.debug(l1);
        
        //Declairing and initializing list
        List<Integer> l3 = new List<Integer>{2,5,7,8};
        System.debug(l3);
        
        //String
        List<String> l2 = new List<String>();
        l2.add('pradhunya');
        l2.add('Shivaji');
        l2.add('Shewale');
        System.debug(l2);       
        
        List<String> l4 = new List<String>{'I','Am','Good','Boy'};
        System.debug(l4);             
        
        
        // 2-D list 
        
        List<List<Integer>> Llist = new List<List<Integer>>();
        
        List<Integer> ll1 = new List<Integer>{10,20,30};
        List<Integer> ll2 = new List<Integer>{40,50,60};
        List<Integer> ll3 = new List<Integer>{70,80,90};
           
        Llist.add(ll1);
        Llist.add(ll2);
        Llist.add(ll3);
        
        System.debug(Llist);
        
        // 3-D list 
    
        List<List<List<Integer>>> List3D = new List<List<List<Integer>>>{
            new List<List<Integer>>{
                new List<Integer>{10,20,30},
                new List<Integer>{40,50,60},
                new List<Integer>{70,80,90}},
             new List<List<Integer>>{
                new List<Integer>{100,110,120},
                new List<Integer>{130,140,150},
                new List<Integer>{160,170,180}},
             new List<List<Integer>>{
                new List<Integer>{190,200,210},
                new List<Integer>{220,230,240},
                new List<Integer>{250,260,270}}            
        };
        System.debug(List3D);
        
    }

}