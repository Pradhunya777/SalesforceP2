public class PlasteMartEmailServiceHandler implements Messaging.InboundEmailHandler{
    public Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope){
       //Create InboundEmailResult object to pass result of apex email service
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
               
        //Calling extractMobileNumber function
        String matchedMobileNumber = extractMobileNumber(email.plainTextBody);
        String plainText = getNewPlainText(email.plainTextBody);
        
                
        //Local variables store the extracted string from plainText local variable
        String firstName = plainText.subStringAfter('$$Name:').trim().subStringBefore('$$').subStringBefore('\n').subStringBefore(' ');
        String lastName = plainText.subStringAfter('$$Name:').trim().subStringBefore('$$').subStringBefore('\n').subStringAfter(' ');
        String company = plainText.subStringAfter('$$Company:').trim().subStringBefore('$$').subStringBefore('\n');
        String country = plainText.subStringAfter('$$Country:').trim().subStringBefore('$$').subStringBefore('\n');
        String mobilePhone = matchedMobileNumber;
        String emailStr = plainText.subStringAfter('$$Email Address:').trim().subStringBefore('$$').subStringBefore('\n');
        String street = plainText.subStringAfterLast('$$Address:').trim().subStringBefore('$$').subStringBefore('\n');
        String description = email.plainTextBody;
        
        /*System.debug('firstName:'+firstName);
        System.debug('lastName:'+lastName);
        System.debug('company:'+company);
        System.debug('country:'+country);
        System.debug('mobilePhone:'+mobilePhone);
        System.debug('emailStr:'+emailStr);
        System.debug('street:'+street);*/
        
        
        if(emailStr.contains('>') || emailStr.contains('<')) {
			emailStr = emailStr.subStringAfter('>').remove(',');
        }
        
        AssignmentRule AR = new AssignmentRule(); 
        AR = [select id from AssignmentRule where SobjectType = 'Lead' and Active = true limit 1];
        //Creating the DMLOptions for "Assign using active assignment rules" checkbox
        Database.DMLOptions dmlOpts = new Database.DMLOptions();
        dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
        dmlOpts.EmailHeader.triggerAutoResponseEmail = true;
        
        Lead newLead = new Lead(
            				FirstName = firstName,
            				LastName = String.isNotBlank(lastName) ? lastName : email.fromName,
                            Company = String.isNotBlank(company) ? company : email.fromName,
            				Country = country,
            				Street = street,
            				MobilePhone = mobilePhone,
            				Email = String.isNotBlank(emailStr) ? emailStr : email.fromAddress,
                            Status = 'Open - Not Contacted',
            				LeadSource = 'Plaste Mart',
                            Description = description,
            				Lead_Description_Comments__c = description
                          );
        newLead.setOptions(dmlOpts); 
        try{
            INSERT newLead;
            // Check description contain email plain text body
            if(String.isBlank(firstName) 
               || String.isBlank(LastName) 
               || String.isBlank(company)  
               || String.isBlank(country) 
               || String.isBlank(mobilePhone) 
               || String.isBlank(emailStr)){
                // Call Task handler to create task for new lead
                LeadTaskHandler.createTaskForNewLead(newLead.Id,email.subject);
            }
        }catch(DmlException e){
            result.success = true ;
            ExceptionUtility.addExceptionLog(new ExceptionUtility.LogUitlity(null,
                                                                             'PlasteMartEmailServiceHandler'
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
    
    public String getNewPlainText(String emailPlainTextBody){
        Set<String> splittedString = new Set<String>(emailPlainTextBody.split('\n'));
        splittedString.remove('');
        List<String> splittedNewString = new List<String>();
        for(String s : splittedString){
            if(s.containsIgnoreCase('Name:') 
               || s.containsIgnoreCase('Company:')
               || s.containsIgnoreCase('Email Address:')
               || s.containsIgnoreCase('Address:')
               || s.containsIgnoreCase('Country:')
               || s.containsIgnoreCase('Mobile:')){
                   splittedNewString.add('$$'+s);
               } else{
                   splittedNewString.add(s);
               }
        }   
        
        String newPlainText = String.join(splittedNewString, '\n');
        return newPlainText;
    }

    
    private String extractMobileNumber(String mobileNumberToMatch){
        //Most complicated added first in the regex list
        List<String> regex = new List<String>{'\\+?\\(?[0-9]{1,8}\\)?[\\-|\\s]?[0-9]{3,4}[\\-|\\s]?[0-9]*[\\-|\\s]?[0-9]{3,4}',
            '(\\+?\\(?[0-9]{1,5}\\)?[\\-|\\s]?[0-9]{8,10})', '([0-9]{8,10})'};
        String matchingMobileNumber;
        do{
            Pattern mobileRegxPattern = Pattern.compile(regex.remove(0));
            Matcher mobileMatcher = mobileRegxPattern.matcher(mobileNumberToMatch);
            if(mobileMatcher.find()){
                matchingMobileNumber = mobileMatcher.group(0);
            }
        }while(String.isBlank(matchingMobileNumber) && !regex.isEmpty());
        
        return matchingMobileNumber;
    }
}