public class DirectIndustryEmailServiceHandler implements Messaging.InboundEmailHandler {
    public Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope){
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        
        // Local variable store email body
        String plainText = email.plainTextBody;
        
        //Local variables store the extracted string from plainText local variable
        String lastName = plainText.subStringAfter('Buyer:').subStringAfter('/info.gif>').subStringBefore('\n');
        String company = plainText.subStringAfter('Buyer:').subStringAfter('/website.gif>').subStringBefore('\n');//<https://img.directindustry.com/media/ps/images/mail/common/branded/request/media
        String emailStr = email.fromAddress;
        String country = plainText.subStringAfter('Buyer:').subStringAfter('/pin.gif>').subStringAfter(',').subStringBefore('\n');
        String description = plainText.subStringAfter('\n\n').subStringBefore('[image: sep]')
            					+ plainText.subStringAfter('[image: image]').subStringAfter('\n').subStringBefore('\n');
               
        AssignmentRule AR = new AssignmentRule(); 
        AR = [select id from AssignmentRule where SobjectType = 'Lead' and Active = true limit 1];
        //Creating the DMLOptions for "Assign using active assignment rules" checkbox
        Database.DMLOptions dmlOpts = new Database.DMLOptions();
        dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
		//dmlOpts.EmailHeader.triggerAutoResponseEmail = true;
 	
        //Create New lead for received email        
        Lead newLead = new Lead(
            LastName = String.isNotBlank(LastName) ? lastName : email.fromName,
            Company = String.isNotBlank(company) ? company : email.fromName,
            Email = emailStr,
            Country = country,
            Status = 'Open - Not Contacted',
            LeadSource = 'Direct Industry',
            Description =  String.isNotBlank(description) ? description : plainText,
            Lead_Description_Comments__c = String.isNotBlank(description) ? description : plainText
        );
		newLead.setOptions(dmlOpts);            
        try{
            INSERT newLead;
            // Check description contain email plain text body
            if( String.isBlank(lastName) 
               || String.isBlank(company) 
               || String.isBlank(emailStr) 
               || String.isBlank(country) 
              ){
                // Call Task handler to create task for new lead
                LeadTaskHandler.createTaskForNewLead(newLead.Id,email.subject);
            }
        }catch(Exception e){
            result.success = true ;
            ExceptionUtility.addExceptionLog(new ExceptionUtility.LogUitlity(null,
                                                                             'DirectIndustryEmailServiceHandler'
                                                                             ,'handleInboundEmail'
                                                                             ,e.getStackTraceString()
                                                                             ,e.getMessage()
                                                                             ,e.getTypeName()
                                                                             ,e.getLineNumber()));
          
            ExceptionUtility.commiLog();
            
        }                
        // Set Result to sucess. Error message is not send to back to user
        result.success = true ;
        // return result for apex email service
        return result;
    }
}