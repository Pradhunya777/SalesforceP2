public class QuoteLineEmailHandler {
    public static void sendEmailToUser(List<Order_Loss__c> orderLoss){
        System.debug('In Send Email');
        OrgWideEmailAddress orgWideEmailAddress = [SELECT Id, Address, DisplayName 
                                                   FROM OrgWideEmailAddress
                                                 WHERE DisplayName = 'Lohia Corp'];
        EmailTemplate emailTemplate = [SELECT Id, Name, DeveloperName 
                                       FROM EmailTemplate
                                      WHERE Name = 'Send Order Loss Notification'];
        System.debug('Email Template:'+emailTemplate.Id);
        System.debug('Email Template Name:'+emailTemplate.Name);
        List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();
        
        
        //singleEmailMessage.setSubject('Order Loss');
        for(Order_Loss__c orderId : orderLoss){
            Messaging.SingleEmailMessage singleEmailMessage = new Messaging.SingleEmailMessage();
            singleEmailMessage.setOrgWideEmailAddressId(orgWideEmailAddress.Id);
            //singleEmailMessage.setTargetObjectId(user.Id);
            //singleEmailMessage.setPlainTextBody('Hi, '+user.Name);
            singleEmailMessage.setTemplateId(emailTemplate.Id);
            singleEmailMessage.setTargetObjectId(orderId.Id);
            singleEmailMessage.setSaveAsActivity(false);
            emailMessages.add(singleEmailMessage);
        }
        
        
        Messaging.SendEmailResult[] results = Messaging.sendEmail(emailMessages, false);
            for(Messaging.SendEmailResult result : results){
                if(!result.isSuccess()){
                    System.debug('error:'+result.getErrors());
                }  
            }
       
    }
}