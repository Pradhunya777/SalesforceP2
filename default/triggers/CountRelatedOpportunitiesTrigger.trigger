trigger CountRelatedOpportunitiesTrigger on Opportunity (after insert, after delete, after undelete) {
    CountRelatedOpportunities.getRelatedOpportunities(Trigger.new, Trigger.old);
    
}