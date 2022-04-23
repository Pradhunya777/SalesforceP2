trigger Oppooooooo on Opportunity (Before Insert) {     
   Oppoo.abbbb(Trigger.new);
}
/*
public class opportunityTrigger1 { 

    public  static void oppoNameViaFormula(List<Opportunity> oList) {       
        
        //map<id,opportunity> newOppoMap = new map<id,opportunity>();
        //newOppoMap=Trigger.newMap; 
        
    List<Id> oppIds = new List<Id>(); 
        for (Opportunity opp:oList ){ 
             oppIds.add(opp.Id);      
        }
    List<Opportunity> oppo = [select id , Name,CreatedDate,Account.Name From Opportunity Where id IN :oppIds];
                                    
                 for(Opportunity opps : oppo){
                        date D = date.Today();
                        Integer month = D.month();
                        Integer day = D.day();
                        Integer year = D.year();
    opps.Name = (opps.Account.Name +'-'+month+ '-'+year+'-'+' '+opps.Name);
  //  opps.Name = (opps.Account.Name +'-'+opps.CreatedDate+'-'+opps.Name);
                    }        
    Update oppo;    
    }      
}
*/

/*
 
Map<Id,Opportunity> newOppoMap = new Map<Id,Opportunity>();
     newOppoMap = Trigger.newMap;
    List<Opportunity> oppList = new List<Opportunity>();
    oppList = Trigger.new;
     List<Id> oppIds = new List<Id>(); 
        for (Opportunity opp : oppList ){ 
             oppIds.add(opp.Id);      
        }

List<Opportunity> oppo = [select Name,CreatedDate,Account.Name From Opportunity];
                                    
                 for(Opportunity opps : oppo){
                        DateTime D = date.Today();
                        String month =d.format('MMM'); 
                        Integer day = D.day();
                        Integer year = D.year();
    opps.Name = (opps.Account.Name +'-'+month+ '-'+year+'-'+' '+opps.Name);
  //  opps.Name = (opps.Account.Name +'-'+opps.CreatedDate+'-'+opps.Name);

*/