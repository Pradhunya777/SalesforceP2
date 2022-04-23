public with sharing class AccountSearchCls {
    public AccountSearchCls() {

    }
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(String actName){
        String keyString = '%'+actName+'%';
        return [SELECT Id, Name 
                FROM Account
                WHERE Name LIKE:keyString];
    }
}