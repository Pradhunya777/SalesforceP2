public class AccountTriggerHelperClass {   
    
    
    public static void beforeInsert(List<Account> newList){
        
        //***Before Insert
    //Q.) If Account Industry is not Null & having value as 'Media' then populate rating as 'HOT'.
        
        for(account acc : newList){
            if(acc.industry != 'Null' && acc.industry == 'Media'){
                acc.Rating = 'Hot';
            }
            else{
                acc.Rating = 'Cold';
            } 
        }
    }
    
         
    public static void createRelatedOpportunity(List<Account> newList){
        
        //***After Insert
    //Q.) Create related opportunity when Account Is Created
        
        List<Opportunity> oppToBeInserted = new List <Opportunity>();
        
        for(Account acc : newList){
            opportunity opp = new Opportunity();
            opp.name = acc.name;
            opp.AccountId = acc.Id;
            opp.StageName = 'Prospecting';
            opp.CloseDate = System.today();
            
            oppToBeInserted.add(opp);          
           }
        if(!oppToBeInserted.isEmpty()){ 
            insert oppToBeInserted;
        }
    }
    
    
    
    public static void UpdatePhoneDesc(List<Account> newList,Map<Id,Account> oldMap){
        
        //***Before Update
    //Q.) If account phone is updated the put update message in description 
        
        for(Account acc : newList){
            if(oldMap!=Null && acc.Phone != oldMap.get(acc.Id).Phone){
                acc.Description = 'Phone Number Is Updated ';
            }
        }
    }
    
    
    
    public static void UpdateRelatedPhone(List<Account> newList, Map<Id,Account> oldMap){
        
        //***After Update
    //Q.) If Account phone is updated then populate that on all related opportunities
        
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