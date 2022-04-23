trigger AddLimitedAfterAccNameTrigger on Account (before insert) {
   
    //Trigger.new
    
    
    Account a = Trigger.new[0];
    a.Name = a.Name + ' Pvt Ltd';
    
   
}