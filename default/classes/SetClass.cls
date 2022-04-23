public class SetClass {
    public static void main(){
        Set<String>sset=new set<String>();
        sset.add('pradhunya');
        sset.add('shivaji');
        sset.add('shewale');
        System.debug(sset);
        
        Set<Integer>sset2=new set<Integer>{1,2,3};
        /*sset2.add(1);
        sset2.add(2);
        sset2.add(3);*/
        System.debug(sset2);
        
        Set<Boolean>sset3=new set<Boolean>();
        sset3.add(false);
        sset3.add(true);
        sset3.add(false);        
        System.debug(sset3);
    }

}