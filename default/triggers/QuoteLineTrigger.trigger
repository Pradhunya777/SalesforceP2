trigger QuoteLineTrigger on SBQQ__QuoteLine__c (before delete, before update, before insert) {
    
    if(Trigger.isBefore){
        if(Trigger.isDelete){
            //System.debug('In before delete');
            QuoteLineTriggerHandler.beforeDelete(Trigger.old);
        }else if(Trigger.isUpdate){
            //System.debug('In before update');
            QuoteLineTriggerHandler.beforeUpdate(Trigger.newMap,Trigger.oldMap);
        }else if(Trigger.isInsert){
            //System.debug('In Insert');
            QuoteLineTriggerHandler.beforeInsert(Trigger.new);
        }
    }
}