/*---------------------------------------------------------------------------------------------------------------------------------------------------------------
Description     : Test class for Trigger for WorkOrder
Created         : 16-11-2021
---------------------------------------------------------------------------------------------------------------------------------------------------------------*/
@isTest
public class WorkOrderTriggerHandlerTest {
    
    @testsetup
    static void testData(){
        
        case caseRecord = new case();
        caseRecord.CurrencyIsoCode	 = 'USD';
        caseRecord.Status = 'New';
        caseRecord.Origin ='Outlook';
        caseRecord.Sub_status__c=NULL;
        caseRecord.Contracted_Services__c='FMC';
        
        INSERT caseRecord;
        
        List<Case_line_Item__c> caselineItemList = new List<Case_line_Item__c>();
        
        Case_line_Item__c caselineItem = new Case_line_Item__c();
        caselineItem.Case__c = caseRecord.Id;
        caselineItem.Affected_Part_No__c ='test';
        caselineItem.Problem__c ='test Issue';
        caselineItem.Model__c ='21324';
        caselineItem.Part_Name__c ='Engine';
        caselineItem.Affected_Part_No__c ='Piston';
        
        caselineItemList.add(caselineItem);
        
        Case_line_Item__c caselineItem1 = new Case_line_Item__c();
        caselineItem1.Case__c = caseRecord.Id;
        caselineItem.Affected_Part_No__c ='test';
        caselineItem.Problem__c ='test Issue';
        caselineItem.Model__c ='54545';
        caselineItem.Part_Name__c ='GearBOX';
        caselineItem.Affected_Part_No__c ='Chain';
        caselineItemList.add(caselineItem1);
        
        Insert caselineItemList;
    }
    
    @isTest
    static void testCreateWorkOrderLineItems() {
        Case caseRecord = [SELECT ID FROM Case LIMIT 1];
        
        WorkOrder workOrderRecord = new WorkOrder();
        workOrderRecord.CaseId = caseRecord.Id;
        
        Test.startTest();
        
        Insert workOrderRecord;
        
        Test.stopTest();         
    }

}