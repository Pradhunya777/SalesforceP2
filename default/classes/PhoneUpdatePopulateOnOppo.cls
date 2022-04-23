public class PhoneUpdatePopulateOnOppo {
    
    //***After Update
    //Q.) If Account phone is updated then populate that on all related opportunities
    
    public static void UpdateRelatedPhone(List<Account> newList, Map<Id,Account> oldMap){
        
        Map<Id,Account> accIdToAccountMap = new Map<Id,Account>();
        List<Opportunity> oppToBeUpdated = new List<Opportunity>();
                
        for(Account acc : newList){
            if(oldMap!= Null && acc.Phone != oldMap.get(acc.id).Phone){
                accIdToAccountMap.put(acc.id,acc);
            }
        }
        
        for(Opportunity opp : [Select Id, Phone__c, AccountId FROM Opportunity WHERE AccountId IN : accIdToAccountMap.keySet()]){
            Opportunity oppor = new Opportunity();
            if(accIdToAccountMap.ContainsKey(opp.AccountId)){
                oppor.id = opp.id;
                oppor.Phone__c = accIdToAccountMap.get(opp.AccountId).Phone;
                oppToBeUpdated.add(oppor);
            }
        }
        if(!oppToBeUpdated.isEmpty()){
            update oppToBeUpdated;
        }
        
    }

}