trigger preventDeletionIfOpportunityIsRelatedToAccount on Account (before delete) {
   Set<id> accountids=new set<id>();
	for(account acc:trigger.old){
		   accountids.add(acc.id);
	}
    Map<id,Opportunity>conmap = new map<id,Opportunity>([select accountid from Opportunity where accountid in :accountids]);
	System.debug('conmap = '+conmap.keySet());
	for(account acc:trigger.old){
    	if(conmap.get(acc.id)!=null){ 
     		   System.debug('Inside If of ');
     			  acc.adderror('This Account has some related Opportunity record(s), you cannot delete this Account.');
   		 }
        else 
            delete conmap.get(acc.Id);
	}   
}