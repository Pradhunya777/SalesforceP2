trigger opportunityTrigger on Opportunity (After Insert, Before Insert, after delete, after undelete) {
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            opportunityTriggerHandler.OppoNameWithFormula(Trigger.new);
            
            opportunityTriggerHandler.RelatedOpportunitiesCount(Trigger.new,Trigger.old);
        }
        else if(Trigger.isDelete){
            opportunityTriggerHandler.RelatedOpportunitiesCount(Trigger.new,Trigger.old);
        }
        else if(Trigger.isUnDelete){
            opportunityTriggerHandler.RelatedOpportunitiesCount(Trigger.new,Trigger.old);
        } 
        
    }
    else if(Trigger.isBefore){ 
        if(Trigger.isInsert){
            //opportunityTriggerHandler.OpportunityNameWithFormula(Trigger.new);
        }        
    }
}