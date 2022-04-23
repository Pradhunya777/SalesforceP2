public  class SalesAgentRecords {
    @AuraEnabled(cacheable=true)   
    public static List<Sales_Agent__c> getSalesAgents(Id lwcRecordId) { 
        Set<Id> agentIdSet = new Set<Id>();
        for(Commission__c commission :[SELECT Name,Sales_Agent__c FROM Commission__c
                                        WHERE Commission__c.Opportunity__c =: lwcRecordId]){
                                            agentIdSet.add(commission.Sales_Agent__c);  
                                        }
        return [SELECT Id, Name, Default_Commission_Rate__c 
                FROM Sales_Agent__c
                 WHERE Id NOT In : agentIdSet];    
    }   
    @AuraEnabled  
    public static void createCommissions(List<Id> selCommissionId, Id lwcRecordId){
                                        
        
        List<Sales_Agent__c> SaList = new List<Sales_Agent__c>();
        SaList = [SELECT Id FROM Sales_Agent__c WHERE Id  =: selCommissionId];
            List<Commission__c> com = new List<Commission__c>();
            for(integer i=0; i<SaList.size(); i++){
                 Commission__c comm = new Commission__c(); 
                 comm.Sales_Agent__c = SaList[i].Id;
                 comm.Opportunity__c = lwcRecordId; 
                 com.add(comm);
            }
            INSERT com; 
    }    
}