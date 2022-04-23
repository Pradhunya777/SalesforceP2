trigger UserNameAsASalesAgentName on Sales_Agent__c (before insert) {
  
    if(trigger.isbefore && trigger.isinsert)
    { 
        User objUser = new User();
        objUser = [ SELECT Name, Id FROM User WHERE Id = : UserInfo.getUserId() ];
            for(Sales_Agent__c a: trigger.new)
            {
               a.Sales_Agent_Name__c = objUser.Name;
                //a.Name = (objUser.Name+'-'+a.Name);
            }
    }    
}