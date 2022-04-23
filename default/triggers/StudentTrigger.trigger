trigger StudentTrigger on Student__c (before delete, after delete,after Undelete) {
    
    if(Trigger.isDelete){
        if(Trigger.isBefore){
            StudentTriggerHelperClass.CheckStudentActiveOrInactive(Trigger.old);
        }else if(Trigger.isAfter){
            System.debug('Remaining to write ');
        }
    }
    else if(Trigger.isUndelete){
        StudentTriggerHelperClass.UndeleteAndCheckActiveCheckboxAutomatically(Trigger.new);
    }

}