//Q. oppo name = Oppo.Account.name-createdDate-Createdmonth-Createdyear-Oppo name

trigger oppoTrigger1 on Opportunity (after insert) {
    opportunityTrigger1.oppoNameViaFormula(Trigger.new); 
}