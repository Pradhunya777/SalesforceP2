public class accountController {
    @AuraEnabled(cacheable=true)    
    public static List<Account> getAccounts(){
                 return[SELECT 
                        Id, Name, Type, Industry, Website 
                        FROM Account 
                        WHERE website!=null 
                       LIMIT 10 ];
    }
}