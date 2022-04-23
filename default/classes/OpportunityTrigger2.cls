public class OpportunityTrigger2 {
 
    public static void oppoNameWithFormula(Map<Id,Opportunity> newOppoMap){    
        //Version 3 : Instead of Trigger.New Use Trigger.NewMap & Use Month Name instead of Digit.     
List<Opportunity> oppoList = [SELECT Id , Name,CreatedDate,Account.Name FROM Opportunity WHERE Id IN :newOppoMap.keySet()];        							
               
        for(Opportunity newOppList : oppoList){                     
                        DateTime Dt = date.Today();
                        String Month =dt.format('MMM'); 
                        Integer Day = Dt.day();
                        Integer Year = Dt.year();
    			newOppList.Name = (newOppList.Account.Name +'-'+Month+ '-'+Year+'-'+' '+newOppList.Name);
                    }         
    UPDATE oppoList;
    }
    
}