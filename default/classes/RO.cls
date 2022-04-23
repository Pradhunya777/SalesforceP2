public class RO {
 
  public static void Roooo(List<Opportunity> newListOppo,List<Opportunity> oldListOppo){
     
    Set<Id> accIDs = new Set<Id>();  
    if(Trigger.isInsert || Trigger.isUndelete){
        
        for(Opportunity oppos : newListOppo){
            accIDs.add(oppos.AccountId);
        }
        updateAcc(accIDs);    
    } 
    else if(Trigger.isDelete){
        for(Opportunity opptys : oldListOppo){
            accIDs.add(opptys.AccountId);
        }
        updateAcc(accIDs);    
    } 
  }
	  public static void updateAcc(Set<Id> accIds){
        List<Account> accList = [select id, Number_Of_Open_Opportunities__c from Account where Id in :accIds];
        List<Opportunity> oppsList = [select id,Stagename from Opportunity where AccountId in :accIds AND Stagename != 'Closed Won'AND Stagename != 'Closed Lost'];
        for(Account a : accList){
            a.Number_Of_Open_Opportunities__c= oppsList.size(); 
        }   
       update accList;          
    }  
}