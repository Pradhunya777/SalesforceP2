public class IndiaMartEmailServiceHandler implements Messaging.InboundEmailHandler{
    public Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope){
        //Create InboundEmailResult object to pass result of apex email service
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        
        // Local variable store email body
        String plainText = email.plainTextBody;
        //Calling extractMobileNumber function
        String matchedMobileNumber = extractMobileNumber(plainText);
        //String cityStr = extractCity(plainText);
        String addressInfo = plainText.contains('*Buylead Details:*')
                             ? plainText.subStringAfter('E-mail:').subStringAfter('\n').subStringBefore('*Buylead Details:*')
            				:plainText.subStringAfter('E-mail:').subStringAfter('\n').subStringBefore('Buylead Details:');
		List<String> splittedString = new List<String>(addressInfo.split(','));
        
        System.debug('##splittedString:'+splittedString);
        //Local variables store the extracted string from plainText local variable  
        String firstName = plainText.containsIgnoreCase('*Buyer\'s Contact Details:*') 
            				? plainText.subStringAfter('*Buyer\'s Contact Details:*').subStringBefore('*Buylead Details:*').trim().substringBefore('\n').substringBefore(' ')
            				:plainText.subStringAfter('Buyer\'s Contact Details:').subStringBefore('Buylead Details:').trim().substringBefore('\n').substringBefore(' ');
        String lastName = plainText.containsIgnoreCase('*Buyer\'s Contact Details:*') 
            				? plainText.subStringAfter('*Buyer\'s Contact Details:*').subStringBefore('*Buylead Details:*').trim().substringBefore('\n')
            				:plainText.subStringAfter('Buyer\'s Contact Details:').subStringBefore('Buylead Details:').trim().substringBefore('\n');       
        String company = plainText.containsIgnoreCase('*Buyer\'s Contact Details:*') 
            				? plainText.subStringAfter('*Buyer\'s Contact Details:*').subStringBefore('*Buylead Details:*').trim().substringAfter('\n').trim().substringBefore('\n')
                        	:plainText.subStringAfter('Buyer\'s Contact Details:').subStringBefore('Buylead Details:').trim().substringAfter('\n').trim().substringBefore('\n');
        
        String city = splittedString[splittedString.size()-3].contains('-') && splittedString[splittedString.size()-3].contains('\n')
            			? splittedString[splittedString.size()-3].subStringBefore('-').subStringAfter('\n') 
            			:splittedString[splittedString.size()-3].subStringBefore('-');
       	String postalCode = splittedString[splittedString.size()-3].contains('-')
            			? splittedString[splittedString.size()-3].subStringAfter('-')
            			:'';
        String country = plainText.containsIgnoreCase('*Buyer\'s Contact Details:*') || plainText.containsIgnoreCase('*Buylead Details:*')
            				? plainText.subStringAfter('E-mail:').subStringBefore('*Buylead Details:*').substringAfterLast(',').trim()
            				: plainText.subStringAfter('E-mail:').subStringBefore('Buylead Details:').substringAfterLast(',').trim();
        String mobilePhone = matchedMobileNumber;
        String emailStr = plainText.containsIgnoreCase('E-mail:') 
            				? plainText.subStringAfter('E-mail:').subStringBefore('\n')
            				: plainText.subStringAfter('Email:').subStringBefore('\n') ;
        String  description = plainText;
        
        System.debug('##firstName: '+firstName);
        System.debug('##lastName: '+lastName);
        System.debug('##company: '+company);
        System.debug('##emailStr: '+emailStr);
        System.debug('##city: '+city);
        System.debug('##postalCode: '+postalCode);
        System.debug('##country: '+country.trim());
        System.debug('##mobilePhone: '+matchedMobileNumber);
        System.debug('##description:'+description);
        
        if(emailStr.contains('>') || emailStr.contains('<')) {
			emailStr = emailStr.subStringBefore('<').remove(',');
            System.debug('emailStr: '+emailStr);
        }
        
        AssignmentRule AR = new AssignmentRule(); 
        AR = [select id from AssignmentRule where SobjectType = 'Lead' and Active = true limit 1];
        //Creating the DMLOptions for "Assign using active assignment rules" checkbox
        Database.DMLOptions dmlOpts = new Database.DMLOptions();
        dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
		dmlOpts.EmailHeader.triggerAutoResponseEmail = true;
 		
        
        //Create New lead for received email        
        Lead newLead = new Lead(
            //FirstName = firstName,
            LastName = String.isNotBlank(lastName) ? lastName : email.fromName,
            Company = String.isNotBlank(company) ? company : email.fromName,
            Country = country,
            City = city,
            PostalCode = postalCode,
            MobilePhone = mobilePhone,
            Email = String.isNotBlank(emailStr) ? emailStr : email.fromAddress,
            Status = 'Open - Not Contacted',
            LeadSource = 'India Mart',
            Description =  description,
            Lead_Description_Comments__c = description
        );
		newLead.setOptions(dmlOpts);            
        try{
            INSERT newLead;
            // Check description contain email plain text body
            if(String.isBlank(country)  //String.isBlank(firstName)  
               || String.isBlank(city) 
               || String.isBlank(PostalCode) 
               || String.isBlank(mobilePhone)){
                // Call Task handler to create task for new lead
                LeadTaskHandler.createTaskForNewLead(newLead.Id,email.subject);
            }
        }catch(DmlException e){
            result.success = true ;
            ExceptionUtility.addExceptionLog(new ExceptionUtility.LogUitlity(null,
                                                                             'IndiaMartEmailServiceHandler'
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
    
    /*private String extractCity(String addressToFetchCity){
        String city ;
        String addressInfo = addressToFetchCity.subStringAfter('E-mail:').subStringAfter('\n').subStringBefore('Buylead Details:');
		List<String> splittedString = new List<String>(addressInfo.split(','));
        if(splittedString[splittedString.size()-3].contains('-')){
            //System.debug('-'+splittedString[splittedString.size()-3].subStringBefore('-'));
            city = 
        }
        return city;
    }*/
    
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