public class Oppoo {
    public static void abbbb(List<Opportunity> oList){
        List<Id> oppIds = new List<Id>();
        for(Opportunity opp:oList){
            oppIds.add(opp.Id);
        } 
    List<Opportunity> oppo = [select Id,Name,CreatedDate,Account.Name From Opportunity WHERE Id IN : oppIds];
    for(Opportunity o : oppo){
        				DateTime D = date.Today();
                        String month =d.format('MMM'); 
                        Integer day = D.day();
                        Integer year = D.year(); 
        o.Name=(o.Account.Name+'-'+month+'-'+year+'-'+o.Name);
    }
        UPDATE oppo;
    } 
}
/*public class OpportunityTrigger {   
    public static void OppoNameWithFormula(List<Opportunity> newOppoList){
        List<Id> oppoIds = new List<Id>();
        For(Opportunity newOppos : newOppoList){
            oppoIds.add(newOppos.Id);
        }
        List<Opportunity> newOpportunities = [SELECT Id,Name,Account.Name FROM Opportunity WHERE Id IN : oppoIds];
        for(Opportunity newOppList : newOpportunities){
            			DateTime Dt = date.Today();
                        String Month =dt.format('MMM'); 
                        Integer Day = Dt.day();
                        Integer Year = Dt.year();
    			newOppList.Name = (newOppList.Account.Name +'-'+Month+ '-'+Year+'-'+' '+newOppList.Name);
        }
       UPDATE newOpportunities;
    }
} */