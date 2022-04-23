public class KeywordsSOSL {
    public static void main(){
        
        //1.) OR
        
        List<List<sobject>> slist1 = [find 'pd OR pd2' returning opportunity(name)];
        System.debug(slist1);
        
        //1.) AND
        
        List<List<sobject>> slist2 = [find 'pd AND pd2' returning opportunity(name)];
        System.debug(slist2);
        
    }

}