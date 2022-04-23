public with sharing class Accountcls {
    public static List<Account> getAccountList(){
        return[SELECT Id, Name, Type, Industry, AnnualRevenue 
                FROM Account 
                WHERE Industry != null AND AnnualRevenue!=null];
    }
}