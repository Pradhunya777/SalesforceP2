/*---------------------------------------------------------------------------------------------------------------------------------------------------------------
Description     : Trigger for Case_line_Item__c
Inputs          : Case_line_Item__c that are being triggered
Handler Classes : CaselineItemTriggerHandler
Test Classes    : 
Created         : 16-11-2021
---------------------------------------------------------------------------------------------------------------------------------------------------------------*/
trigger CaseLineItemTrigger on Case_line_Item__c (after update) {
    
    if(Trigger.isAfter){
        if(Trigger.isUpdate){
            CaselineItemTriggerHandler.afterUpdate(Trigger.NewMap);
        }
    }
    
}