/*---------------------------------------------------------------------------------------------------------------------------------------------------------------
Description     : Trigger for WorkOrderLineItem
Inputs          : WorkOrderLineItem that are being triggered
Handler Classes : WorkOrderLineItemTriggerHandler
Test Classes    : 
Created         : 17-12-2021
---------------------------------------------------------------------------------------------------------------------------------------------------------------*/
trigger WorkOrderLineItemTrigger on WorkOrderLineItem (after insert,after update,after delete) {
    
    
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            WorkOrderLineItemTriggerHandler.afterInsert(Trigger.newMap);
        }
        if(Trigger.isUpdate){
            WorkOrderLineItemTriggerHandler.afterUpdate(Trigger.newMap, Trigger.oldMap);
        }
        if(Trigger.isDelete){
            WorkOrderLineItemTriggerHandler.afterDelete(Trigger.old);
        }
    }

}