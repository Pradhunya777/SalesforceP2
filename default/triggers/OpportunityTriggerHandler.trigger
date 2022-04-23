trigger OpportunityTriggerHandler on Opportunity (After Insert, Before Insert, after delete, after undelete) {
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            OpportunityTrigger.OppoNameWithFormula(Trigger.new);
            
            OpportunityTrigger.RelatedOpportunitiesCount(Trigger.new,Trigger.old);
        }
        else if(Trigger.isDelete){
            OpportunityTrigger.RelatedOpportunitiesCount(Trigger.new,Trigger.old);
        }
        else if(Trigger.isUnDelete){
            OpportunityTrigger.RelatedOpportunitiesCount(Trigger.new,Trigger.old);
        } 
        
    }
    else if(Trigger.isBefore){ 
        if(Trigger.isInsert){
            //OpportunityTrigger.OpportunityNameWithFormula(Trigger.new);
        }        
    }
}