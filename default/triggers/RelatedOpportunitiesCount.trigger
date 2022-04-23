trigger RelatedOpportunitiesCount on Opportunity (after insert, after delete, after undelete){
    
    Set<Id> accIDs = new Set<Id>();
    if(Trigger.isInsert || Trigger.isUndelete){
       
        for(Opportunity oppos : Trigger.New){
            accIDs.add(oppos.AccountId);
        }
        updateAcc(accIDs); 
    }
    else if(Trigger.isDelete){
        for(Opportunity opptys : Trigger.old){
            accIDs.add(opptys.AccountId);
        }
        updateAcc(accIDs);   
    }  
    public void updateAcc(Set<Id> accIds){
        List<Account> accList = [select id, Number_Of_Open_Opportunities__c from Account where Id in :accIds];
        List<Opportunity> oppsList = [SELECT id,Stagename FROM Opportunity WHERE AccountId IN :accIds 
                                      AND Stagename != 'Closed Won'AND Stagename != 'Closed Lost'];
        for(Account a : accList){
            a.Number_Of_Open_Opportunities__c= oppsList.size(); 
        }   
       update accList;          
    }  
}