global class BatchWishes implements Database.Batchable<Contact>{ //,Schedulable {
    global Iterable<Contact> start(Database.BatchableContext bc){
        List<Contact> con = [SELECT name,Email FROM Contact WHERE Date_of_Birth__c=today]; 
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
            	 mailEach.setSubject('Birthday Wishes ');
            	 mailEach.setPlainTextBody('Happy Birthday '+c.Name);
            	 mail.add(mailEach); 
            } 
        }
        Messaging.SendEmailResult[] result = Messaging.sendEmail(mail);
        
    }
    global void finish(Database.BatchableContext bc){
        System.debug(bc);  
    }
    /*global void execute(SchedulableContext sc){
        BatchWishes bth = new BatchWishes();
        Database.executeBatch(bth);
    }*/
}

/*  To schedule this class at 12am everyday then we have to paste this code in anonymous window  

	BatchWishes bno = new BatchWishes();
	String cronExp = '0 0 0 * * ? *';
	System.schedule('BatchWishes', cronExp, bno);
*/