public class SendEmailResponseHandler {
    public static void sendMail(List<Id> leadIds){
        
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        Id ownerId = UserInfo.getUserId();
        Id templateId = [SELECT Id
                         FROM EmailTemplate
                         WHERE Name = 'Auto Response to Email Service'].Id;
        
        if(!leadIds.isEmpty() && templateId != Null ){
            for(Id leadId : leadIds){
                Messaging.SingleEmailMessage singleEmailMessage = new Messaging.SingleEmailMessage();
                singleEmailMessage.setTargetObjectId(leadId);
                singleEmailMessage.setTemplateId(templateId);
                emailList.add(singleEmailMessage);
            }
            if(!emailList.isEmpty()){
                Messaging.SendEmailResult[] results = Messaging.sendEmail(emailList, false);
                for(Messaging.SendEmailResult result : results){
                    if(!result.isSuccess()){
                        System.debug('error:'+result.getErrors());
                    }
                }
            }
        }
    }
}