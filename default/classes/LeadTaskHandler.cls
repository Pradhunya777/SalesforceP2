public class LeadTaskHandler {
     //Create Task for newly created lead of email service
    public static void createTaskForNewLead(Id leadId, String subject){
        
        // Get Name of user to which unassigned lead are assigned
        UserName__c user = UserName__c.getOrgDefaults();
        
        //Get Id of user
        Id ownerId = [SELECT Id
                      FROM User 
                      WHERE Username = :user.UserName__c].Id;
		  
        //Create Task for newly created lead
        Task newTaskToNewLead = new Task(
            WhoId = leadId,
            OwnerId = ownerId,
            IsReminderSet = true,
            ReminderDateTime = System.now(),
            Status = 'Not Started',
            Subject = subject
        );
        
        try{
            INSERT newTaskToNewLead;
        }catch(DmlException e){
           ExceptionUtility.addExceptionLog(new ExceptionUtility.LogUitlity(null,
                                                                             'LeadTaskHandler'
                                                                             ,'createTaskForNewLead'
                                                                             ,e.getStackTraceString()
                                                                             ,e.getMessage()
                                                                             ,e.getTypeName()
                                                                             ,e.getLineNumber()));
            
            ExceptionUtility.commiLog();
        }
    }

}