public class FetchAccName {
    public  static void fetchaccount(List<Opportunity> NewOpps) {
 
    List<Id> oppIds = new List<Id>();
        for (Opportunity opp:NewOpps ){
             oppIds.add(opp.Id);
        }
    List<Opportunity> oppo = [select id , Name,Account.Name From Opportunity Where id in :oppIds];
                  for(Opportunity opps : oppo){
                        date D = date.Today();
                        Integer month = D.month();
                        Integer day = D.day();
                        Integer year = D.year();
    opps.Name = (opps.Account.Name +'-'+day+'-'+month+ '-'+year+'-'+' '+opps.Name);
                    }       
 
    Update oppo;
    }
}