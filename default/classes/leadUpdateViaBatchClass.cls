global class leadUpdateViaBatchClass implements database.Batchable<sObject> {
    
    global database.QueryLocator start(database.BatchableContext bc){
       
        Return database.getQueryLocator([Select AnnualRevenue from lead]);
        
    }
    global void execute(database.BatchableContext bc, List<Lead> lList){
        
        for(lead l : lList){
            l.AnnualRevenue = 2000000;
        }
       Update lList; 
    }
    global void finish(database.BatchableContext bc){
        
        Messaging.SingleEmailMessage mail = new messaging.SingleEmailMessage();
        String[] toAddress = new String[] {'pradhunya@dreamwares.com'};
        mail.setToAddresses(toAddress);
        mail.setSubject('Batch class completed.');
        mail.setPlainTextBody('Hey, the batch class that we started is successfully completed.');
        messaging.sendEmail(new messaging.SingleEmailMessage[]{mail});
        
    }   

}