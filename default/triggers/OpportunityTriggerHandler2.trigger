trigger OpportunityTriggerHandler2 on Opportunity (After insert) {
    OpportunityTrigger2.oppoNameWithFormula(Trigger.newMap);
}