public class accountController2 {
    @AuraEnabled
    public static List<Account> getAccountRecords(){
        return[SELECT Id, Name, Type, Industry, Website 
                    FROM Account WHERE Website!=null LIMIT 10 ];
    }
}