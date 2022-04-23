public class DynamicSOSL {
    public static void main(){
        
        String s = 'find\'pradhunya\'returning account(name),contact(name where firstname=\'aryan\'),student__c(name)';
        List<List<Sobject>> sList = Search.query(s);
        System.debug(sList);        
    }
}