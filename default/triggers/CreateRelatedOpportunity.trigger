trigger CreateRelatedOpportunity on Account (After insert) {
        
        //***After Insert
        //Q.) Create related opportunity when Account Is Created
    
        OppoTriggerClassCreateRelatedOppo.createRelatedOpportunity(Trigger.new);
}