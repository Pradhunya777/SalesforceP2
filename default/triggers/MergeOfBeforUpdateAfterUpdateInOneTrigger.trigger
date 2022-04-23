trigger MergeOfBeforUpdateAfterUpdateInOneTrigger on Account (before update,after update) {
    
    if(trigger.isBefore){
        if(trigger.isInsert){
            System.debug('I am Before Insert ');
        }
        else if(trigger.isUpdate){
            Account aOld = Trigger.old[0];
            Account aNew = Trigger.new[0];
    
                System.debug('I am before Update Trigger');
                System.debug('Old name value = '+aOld.Name+', Old No of employees value = '+aOld.NumberOfEmployees);
                System.debug('New name value = '+aNew.Name+', New no of employees value = '+aNew.NumberOfEmployees);
        }
        else if(trigger.isDelete){
            System.debug('I am before delete ');
        }
    }
    
    else if(trigger.isAfter){
        if(trigger.isInsert){
            System.debug('I am After Insert ');
        }
        else if(trigger.isUpdate){
            Account aOld = Trigger.old[0];
            Account aNew = Trigger.new[0];
    
                System.debug('I am after Update Trigger');
                System.debug('Old name value = '+aOld.Name+', Old No of employees value = '+aOld.NumberOfEmployees);
                System.debug('New name value = '+aNew.Name+', New no of employees value = '+aNew.NumberOfEmployees);
        }
        else if(trigger.isDelete){
            System.debug('I am after delete ');
        }
        else if(trigger.isUndelete){
            System.debug('I am a after Undelete ');
        }
    }
   
    
    
}