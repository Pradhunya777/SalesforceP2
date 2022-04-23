global class leadUpdateViaSchedulableBatchClass implements database.Batchable<sObject>,Schedulable {
    
    global database.QueryLocator start(database.BatchableContext bc){ 
       
        Return database.getQueryLocator([Select AnnualRevenue from lead]);
        
        
    }
    global void execute(database.BatchableContext bc, List<Lead> lList){ 
       //Integer a=8000;
        for(lead l : lList){  
            l.AnnualRevenue = 35000;
            //a++;
        }
       Update lList; 
        System.abortJob(bc.getJobId());
    }
    global void finish(database.BatchableContext bc){
        Messaging.SingleEmailMessage mail = new messaging.SingleEmailMessage();
        String[] toAddress = new String[] {'pradhunya@dreamwares.com'};
        mail.setToAddresses(toAddress);
        mail.setSubject('Batch class completed.');
        mail.setPlainTextBody('Hey, the batch class that we started is successfully completed.');
        messaging.sendEmail(new messaging.SingleEmailMessage[]{mail});
         
        
    }
     global void execute(SchedulableContext sc){
        
        leadUpdateViaSchedulableBatchClass lus = new leadUpdateViaSchedulableBatchClass();
        Database.executeBatch(lus);
        
    }
    
      

} 

 /*
    cron expression via code execution
	string cronExp1 = '0 15 14 * * ?';
    System.schedule('ScheduledBatchViaCronExp', cronExp1, new leadUpdateViaSchedulableBatchClass());
	*/


/* 
Batch scheduled for every 5 minutes code

Datetime dt = System.now().addMinutes(2); 
        String day = string.valueOf(dt.day());
        String month = string.valueOf(dt.month());
        string hour = string.valueOf(dt.hour());
        string minute = string.valueOf(dt.minute());
        string second = '00';
        string year = string.valueOf(System.now().year());
        string strJobName = 'SampleSchedulingClass-' + year + '-' + month + '-' + day + '-' + hour + ':' + minute + ':' + second;
        string strSchedule = '00' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ?' + ' ' +year;
        System.schedule(strJobName, strSchedule, new leadUpdateViaSchedulableBatchClass());

*/

/*
Batch scheduled for every 5 minutes code 

string cronExp1 = '0 00 * * * ?';
System.schedule('ScheduledBatchViaCronExp0', cronExp0, new leadUpdateViaSchedulableBatchClass());
string cronExp1 = '0 05 * * * ?';
System.schedule('ScheduledBatchViaCronExp1', cronExp1, new leadUpdateViaSchedulableBatchClass());
string cronExp2 = '0 10 * * * ?';
System.schedule('ScheduledBatchViaCronExp2', cronExp2, new leadUpdateViaSchedulableBatchClass());
string cronExp3 = '0 15 * * * ?';
System.schedule('ScheduledBatchViaCronExp3', cronExp3, new leadUpdateViaSchedulableBatchClass());
string cronExp4 = '0 20 * * * ?'; 
System.schedule('ScheduledBatchViaCronExp4', cronExp4, new leadUpdateViaSchedulableBatchClass());
string cronExp5 = '0 25 * * * ?';
System.schedule('ScheduledBatchViaCronExp5', cronExp5, new leadUpdateViaSchedulableBatchClass());
string cronExp6 = '0 30 * * * ?';
System.schedule('ScheduledBatchViaCronExp6', cronExp6, new leadUpdateViaSchedulableBatchClass());
string cronExp7 = '0 35 * * * ?';
System.schedule('ScheduledBatchViaCronExp7', cronExp7, new leadUpdateViaSchedulableBatchClass());
string cronExp8 = '0 40 * * * ?';
System.schedule('ScheduledBatchViaCronExp8', cronExp8, new leadUpdateViaSchedulableBatchClass());
string cronExp9 = '0 45 * * * ?';
System.schedule('ScheduledBatchViaCronExp9', cronExp9, new leadUpdateViaSchedulableBatchClass());
string cronExp10 = '0 50 * * * ?';
System.schedule('ScheduledBatchViaCronExp10', cronExp10, new leadUpdateViaSchedulableBatchClass());
string cronExp11 = '0 55 * * * ?';
System.schedule('ScheduledBatchViaCronExp11', cronExp11, new leadUpdateViaSchedulableBatchClass());
*/