/**
 Update Sales Region based on country.

*/
trigger LeadTrigger on Lead (after insert,after update, before insert) {
    if(Trigger.isAfter){
        if(Trigger.isInsert){
           LeadTriggerHandler.afterInsert(Trigger.new);
        }else if(Trigger.isUpdate){
           LeadTriggerHandler.afterUpdate(Trigger.newMap,Trigger.oldMap);
        }
    }
}