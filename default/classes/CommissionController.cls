public  class CommissionController {
    @AuraEnabled(cacheable=true) 
    public static List<Commission__c> getCommission() {
        return[SELECT Id, Name, Commission_Name__c 
                FROM Commission__c LIMIT 10 ];
    }
}