trigger AccountTrigger on Account (before insert, after insert, before update, after update, before delete, after delete, after undelete) {
    
    if(Trigger.isInsert){        
        if(Trigger.isBefore){
            AccountTriggerHelperClass.beforeInsert(Trigger.new);
        }
        else if(Trigger.isAfter){
            AccountTriggerHelperClass.createRelatedOpportunity(Trigger.new);
        }        
    }
    else if(Trigger.isUpdate){        
        if(Trigger.isBefore){
           AccountTriggerHelperClass.UpdatePhoneDesc(Trigger.new,Trigger.oldMap);
        }
        else if(Trigger.isAfter){
            AccountTriggerHelperClass.UpdateRelatedPhone(Trigger.new,Trigger.oldMap);
        }        
    }
    else if(Trigger.isDelete){        
        if(Trigger.isBefore){
            System.debug('I am before delete');
        }
        else if(Trigger.isAfter){
            System.debug('I am after delete');
        }        
    }
    else if(Trigger.isUndelete){
        System.debug('I am after undelete');
    }
                                           
                                       

                                       
                                       
}