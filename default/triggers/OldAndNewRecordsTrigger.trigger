trigger OldAndNewRecordsTrigger on Account (before update) {
            
    //Trigger.old&new
    
    //If we insert manually one record at a time 
    Account aOld = Trigger.old[0];
    Account aNew = Trigger.new[0];
    
    System.debug('Old name value = '+aOld.Name+' Old No of employees value = '+aOld.NumberOfEmployees);
    System.debug('New name value = '+aNew.Name+' New no of employees value = '+aNew.NumberOfEmployees);

    
    //If we insert bulk of records then 
    /*for(account aOld : Trigger.old){
        System.debug('Old name value = '+aOld.Name+' Old No of employees value = '+aOld.NumberOfEmployees);
    }
    for(account aNew : Trigger.new){
        System.debug('New name value = '+aNew.Name+' New no of employees value = '+aNew.NumberOfEmployees);
    }*/

}