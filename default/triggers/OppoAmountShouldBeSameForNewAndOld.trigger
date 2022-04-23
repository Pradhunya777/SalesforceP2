trigger OppoAmountShouldBeSameForNewAndOld on Opportunity (before update) {
    
    //Trigger.old & Trigger.new
    //The trigger.old only available on Update & delete triggers
    
    for(opportunity oldOpp : Trigger.old){
        for(opportunity newOpp : Trigger.new){
            if(oldOpp.id == newOpp.id && oldOpp.Amount != newOpp.Amount)
                newOpp.Amount.addError('Amount cannot be changed ');  //Error on Amount field
              //newOpp.addError('Amount cannot be changed ');    //Error on record
        }
    }

}