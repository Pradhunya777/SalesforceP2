trigger CommissionTrigger on Commission__c (before insert, before update, after insert, after update, before delete, after delete) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) { 
            
        } else if (Trigger.isUpdate) {              
             
        } else if (Trigger.isDelete) {    
               
		}
    } else if (Trigger.isAfter) {
        if (Trigger.isInsert) {   
            CommissionTriggerHandler.onAfterInsert(Trigger.new);       
        } else if (Trigger.isUpdate) {        
            CommissionTriggerHandler.OnAfterUpdate(Trigger.new, Trigger.OldMap);  
              
        } else if (Trigger.isDelete) {
            CommissionTriggerHandler.OnAfterDelete(Trigger.old); 
            
		} else if (Trigger.isUnDelete) { 
             
		}
    }
}