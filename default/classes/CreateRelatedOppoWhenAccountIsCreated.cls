public class CreateRelatedOppoWhenAccountIsCreated {
    public static void createRelatedOppo(List<Account> newList){
        List<Opportunity> oppToBeInserted = new List<Opportunity>();
        for(Account acc : newList){
            Opportunity opp = new Opportunity();
            opp.Name = acc.Name;
            opp.AccountId = acc.id;
            opp.StageName = 'Prospecting';
            opp.CloseDate = System.today();
            oppToBeInserted.add(opp);
        }
        if(!oppToBeInserted.isEmpty()){
            INSERT oppToBeInserted;
        }
                
    }

}