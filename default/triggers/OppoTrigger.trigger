trigger OppoTrigger on Opportunity (before insert, before update, after insert, after update, before delete, after delete) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            
        } else if (Trigger.isUpdate) {                
             
        } else if (Trigger.isDelete) {    
              
		}
    } else if (Trigger.isAfter) {   
        if (Trigger.isInsert) {    
            
        } else if (Trigger.isUpdate) {   
            OppoTriggerHandler.OnAfterUpdate(Trigger.new, Trigger.OldMap);   
             
        } else if (Trigger.isDelete) { 
            OppoTriggerHandler.OnAfterDelete(Trigger.old);  
            
		} else if (Trigger.isUnDelete) {
            
		}
    }
}