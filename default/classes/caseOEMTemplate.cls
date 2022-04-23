public class caseOEMTemplate {

    public Id caseId {get;set;}
    public List<Case_line_Item__c> getcaseLineItemsfunction()
    {
        System.debug('caseId::'+caseId);
        List<Case_line_Item__c> caseLineItems;
        caseLineItems = [SELECT Id, Model__c, Machine_No__c,Problem__c, Quantity__c,Part_Name__c, Affected_Part_No__c, Part_Sl_No_Batch_No__c FROM Case_line_Item__c WHERE Case__c	 =: caseId];
        System.debug('caseLineItems::'+caseLineItems);
        return caseLineItems;
    }
    
}