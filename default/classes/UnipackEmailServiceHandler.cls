public class UnipackEmailServiceHandler implements Messaging.InboundEmailHandler {
    public Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope){
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        
        // Local variable store email body
        String plainText = email.plainTextBody;
        
        //Local variables store the extracted string from plainText local variable
        String firstName = plainText.subStringAfter('С уважением,\n').substringBefore(' ').substringBefore('\n');
        String lastName = plainText.subStringAfter('С уважением,\n').substringAfter(' ').substringBefore('\n');
        String company = plainText.subStringAfter('С уважением,\n').subStringAfter('\n').subStringAfter('\n').substringBefore('Тел.:').substringBefore('E-mail:');
        String phone = plainText.subStringAfter('Тел.:').substringBefore('\n');
        String emailStr = plainText.subStringAfter('E-mail:').subStringBefore('Страна, регион:');
        String  description = plainText;
        
        AssignmentRule AR = new AssignmentRule(); 
        AR = [select id from AssignmentRule where SobjectType = 'Lead' and Active = true limit 1];
        //Creating the DMLOptions for "Assign using active assignment rules" checkbox
        Database.DMLOptions dmlOpts = new Database.DMLOptions();
        dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
		dmlOpts.EmailHeader.triggerAutoResponseEmail = true;
 	
        //Create New lead for received email        
        Lead newLead = new Lead(
            FirstName = firstName,
            LastName = String.isNotBlank(lastName) ? lastName : email.fromName,
            Company = String.isNotBlank(company) ? company : email.fromName,
            Country = 'Russian Federation',
            Phone = phone,
            Email = String.isNotBlank(emailStr) ? emailStr : email.fromAddress,
            Status = 'Open - Not Contacted',
            LeadSource = 'unipack.ru',
            Description =  description,
            Lead_Description_Comments__c = description
        );
                
		newLead.setOptions(dmlOpts);            
        try{
            INSERT newLead;
            // Check description contain email plain text body
            if(String.isBlank(firstName)  
               || String.isBlank(lastName) 
               || String.isBlank(company) 
               || String.isBlank(phone)){
                // Call Task handler to create task for new lead
                LeadTaskHandler.createTaskForNewLead(newLead.Id,email.subject);
            }
        }catch(DmlException e){
             result.success = true ;
            ExceptionUtility.addExceptionLog(new ExceptionUtility.LogUitlity(null,
                                                                             'UnipackEmailServiceHandler'
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