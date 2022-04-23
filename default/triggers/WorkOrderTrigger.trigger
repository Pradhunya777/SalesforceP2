/*---------------------------------------------------------------------------------------------------------------------------------------------------------------
Description     : APEX Trigger for WorkOrder standard object
Test Class      : WorkOrderTriggerHandlerTest
Created Date    : 15-11-2021 (DD-MM-YYYY)

Modificatgion Log:
Date				Description
15-11-2021			Initial Development
---------------------------------------------------------------------------------------------------------------------------------------------------------------*/

trigger WorkOrderTrigger on WorkOrder (after insert, after update, before insert) {

    if (Trigger.isBefore) {
        if (Trigger.isInsert) {   
            WorkOrderTriggerHandler.beforeInsert(Trigger.new); 
        } 
    }     
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {  
             WorkOrderTriggerHandler.afterInsert(Trigger.new, Trigger.newMap);  
        } 
        if (Trigger.isUpdate) { 
            WorkOrderTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}