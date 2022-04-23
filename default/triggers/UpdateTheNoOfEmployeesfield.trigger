trigger UpdateTheNoOfEmployeesfield on Account (before insert) {
    
    // 1) Trigger.new
    // these code always be run if we create record manually, but it fails when we insert
    // bulk of data from loader or anywhere because it updates only 1st records employee
    // field not others to overcome these problem we have to use for each loop.
   
    
    /*Account a = Trigger.new[0];
    a.Name = a.Name + ' Pvt Ltd';*/
    
    for(Account acc : Trigger.new){
        acc.NumberOfEmployees = 1280;
    }

}