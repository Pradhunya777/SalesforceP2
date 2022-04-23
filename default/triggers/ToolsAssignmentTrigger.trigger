trigger ToolsAssignmentTrigger on Tools_Assignment__c (after insert, after update , after delete) {
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            ToolsAssignmentTriggerHandler.afterInsert(Trigger.New);
        }
        if(Trigger.isUpdate){
            ToolsAssignmentTriggerHandler.afterUpdate(Trigger.New);
        }
         if(Trigger.isDelete){
            ToolsAssignmentTriggerHandler.afterDelete(Trigger.Old);
        }

}
}