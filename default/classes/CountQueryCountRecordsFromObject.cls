public class CountQueryCountRecordsFromObject {
    public static void main(){
        
        //***Count query
        //***count records from any objet
        
        
        Integer i = Database.countQuery('Select count() from Student__c');
        System.debug(i);
        
    }

}