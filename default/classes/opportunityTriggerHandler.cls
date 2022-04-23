public class opportunityTriggerHandler {   
    public static void OppoNameWithFormula(List<Opportunity> newOppoList){
        
//Requirement1 : Task 1 : Develop a trigger logic whenever a new oppo is created set 
		//opportunity name with below formula?
		//oppo name = Oppo.Account.name-createdDate-Createdmonth-Createdyear-Oppo name
        //With proper Naming convensions. 
        
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
    
    Public static void OpportunityNameWithFormula(list<Opportunity> newOpportunities){
        
   //Requirement1 : Task 2 : instead of After insert use Before Insert.
        
    Set<Id> AccountIds = new Set<Id>(); 
    String oppName; 
    String accName;
    for (Opportunity oppoList : newOpportunities) {    //Adding an account Id to the list of every Oppo
      accountIds.add(oppoList.AccountId);			  //got by trigger.
    }   
    Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Name FROM Account WHERE Id IN :accountIds]);
    for (Opportunity newOppos : newOpportunities) {        
        DateTime Dt = date.Today();
                        String Month =dt.format('MMM'); 
                        Integer Day = Dt.day();
                        Integer Year = Dt.year();
        accName = accountMap.get(newOppos.AccountId).Name;
            oppName = accName + ' - ' +Month+ '-' +Year+'-' +newOppos.Name;
       		newOppos.Name = oppName;
    	}     
    }
    
    public static void RelatedOpportunitiesCount(List<Opportunity> newListOppo,List<Opportunity> oldListOppo){
     
      //Requirement2 : On creation of opportunity or deletion or updation of opportunity, update the No.Of 
      //open opportunity field.
      
    Set<Id> accIDs = new Set<Id>();      
    if(Trigger.isInsert || Trigger.isUndelete){       
        for(Opportunity oppos : newListOppo){
            accIDs.add(oppos.AccountId);
        }
        updateAccount(accIDs);     
    } 
    else if(Trigger.isDelete){
        for(Opportunity opptys : oldListOppo){
            accIDs.add(opptys.AccountId);
        }
        updateAccount(accIDs);  
    } 
  }
	  public static void updateAccount(Set<Id> accountIDs){
        List<Account> accList = [SELECT Id, Number_Of_Open_Opportunities__c FROM Account WHERE Id in :accountIDs];
        List<Opportunity> oppsList = [SELECT Id,Stagename FROM Opportunity WHERE AccountId in :accountIDs AND Stagename != 'Closed Won'AND Stagename != 'Closed Lost'];
        for(Account accounts : accList){
            accounts.Number_Of_Open_Opportunities__c= oppsList.size(); 
        }   
       UPDATE accList;          
    }     
 }