public class OppoTriggerClassCreateRelatedOppo {
    
    //***After Insert
    //Q.) Create related opportunity when Account Is Created
    
    public static void createRelatedOpportunity(List<Account> newList){
        
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

}