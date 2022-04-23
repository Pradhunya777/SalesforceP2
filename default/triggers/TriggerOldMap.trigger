trigger TriggerOldMap on Opportunity (before update) {
    
    Map<id,opportunity> oMap = new Map<id,opportunity>();
    oMap = trigger.oldMap;
    for(Opportunity newOpp : trigger.new){
        opportunity oldOpp = new opportunity();
        oldOpp = oMap.get(newOpp.Id);
        if(newOpp.Amount != oldOpp.Amount){
            newOpp.Amount.addError('Amount cannot be changed ');  //Trigger exception
        }
    }

}