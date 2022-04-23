//Q. oppo name = Oppo.Account.name-createdDate-Createdmonth-Createdyear-Oppo name
public class opportunityTrigger1 {  
    public  static void oppoNameViaFormula(List<Opportunity> oList) {  	       
    List<Id> oppIds = new List<Id>(); 
        for (Opportunity opp:oList ){ 
             oppIds.add(opp.Id);	  
        }
    List<Opportunity> oppo = [SELECT Id , Name,CreatedDate,Account.Name FROM Opportunity WHERE Id IN :oppIds];
        							
                 for(Opportunity opps : oppo){
                        date D = date.Today();
                        Integer month = D.month();
                        Integer day = D.day();
                        Integer year = D.year();
    opps.Name = (opps.Account.Name +'-'+month+ '-'+year+'-'+' '+opps.Name);
                    }        
    UPDATE oppo;    
    }      
}