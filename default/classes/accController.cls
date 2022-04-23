public with sharing class accController {
    public String accountId{get;set;}
    public Account actObj{get;set;}
    public accController() {
        actObj = new Account();   
    }  
    @AuraEnabled(cacheable=true)    
    public static List<Account> getAccounts(){
        return[SELECT Id,Name,Type,Industry,Website from Account WHERE website!=null LIMIT 10 ];
    } 
    @AuraEnabled
    public static List<Account> getAccountRecordsList(){
        return [select id,name,type,phone,industry from Account limit 10];
    }
    public pageReference retrieveAccountDetail(){
        if(accountId!=null){
             actObj = [select id,name,type,industry from Account where id=:accountId];
            
        }       
		return null;        
    }

}