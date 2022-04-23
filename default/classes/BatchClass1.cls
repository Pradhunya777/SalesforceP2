Global class BatchClass1 implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        
        Return Null;
    }
    
    global void execute(Database.BatchableContext bc, List<lead> lList){
        
    }
    
    global void finish(Database.BatchableContext bc){
        
    }
    

}