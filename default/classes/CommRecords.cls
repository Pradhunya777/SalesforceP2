public class CommRecords {
    @AuraEnabled(cacheable=true) 
    public static List<Commission__c> getCommissions(Id lwcRecordId) {
        return [SELECT Id, Name,Commission_Name__c,Commission_Amount__c, Opportunity__c, Overridden_Rate__c,
        Sales_Agent__c ,Sales_Agent__r.Name 
        FROM Commission__c  
        WHERE Opportunity__r.Id =: lwcRecordId];        
    } 
  
    @AuraEnabled  
    public static void deleteSelectedCommission(List<Id> selCommissionId) {
        List<Commission__c> commList = new List<Commission__c>();
        commList = [SELECT Id FROM Commission__c 
                            WHERE Id In :selCommissionId]; 
            if(commList!=Null && commList.size()>0){
                delete commList; 
            }         
    } 
}  