global class UpdateResumeClass implements Database.Batchable<Contact>,Schedulable {
    global Iterable<Contact> start(Database.BatchableContext bc){
        List<Contact> con = [SELECT name, Email, Resume_Upload_Date__c, Resume_Renewal_Date__c FROM Contact WHERE Resume_Renewal_Date__c=today]; 
        return con;
    } 
    global void execute(Database.BatchableContext bc, List<Contact> lList){
        List<Messaging.SingleEmailMessage> mail = new list<Messaging.SingleEmailMessage>();
        
        for(Contact c : lList){ 
            Messaging.SingleEmailMessage mailEach = new Messaging.SingleEmailMessage();
            List<String> toAddress = new List<String>();
            If(c.Email != null){
           		 toAddress.add(c.Email);   
            	 mailEach.setToAddresses(toAddress); 
            	 mailEach.setSubject('Please Update Your Resume ');
            	 mailEach.setPlainTextBody('Hi '+c.Name+ ' You didnt update your resume in while, please provide the latest resume. Last resume uploaded date :'+c.Resume_Upload_Date__c);
            	 mail.add(mailEach); 
            } 
        }
        Messaging.SendEmailResult[] result = Messaging.sendEmail(mail);
        
    }  
    global void finish(Database.BatchableContext bc){
        System.debug(bc);    
    }
    global void execute(SchedulableContext sc){
        UpdateResumeClass bth = new UpdateResumeClass();
        Database.executeBatch(bth);
    }
}

/* UpdateResumeClass bno = new UpdateResumeClass();
String cronExp = '0 30 16 * * ? *';
System.schedule('UpdateResumeClass', cronExp, bno);  */