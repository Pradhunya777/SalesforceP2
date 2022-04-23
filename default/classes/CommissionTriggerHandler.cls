public class CommissionTriggerHandler {
    public static void onAfterInsert(List<Commission__c> CommissionList) {        
         
        CommissionNameViaFormula(CommissionList);
        CalculateSumOfPendingAndCompletedCommissionBalance(CommissionList);       
 }  
    
    public static void OnAfterUpdate(List<Commission__c> CommissionList, Map<Id,Commission__c> OldCommissionMap){
        
        updateCommission(CommissionList, OldCommissionMap); 
  }
    
    public static void OnAfterDelete(List<Commission__c> CommissionList){
          
        handleAfterDelete(CommissionList);
    }
    
    public static void handleAfterDelete(List<Commission__c> CommissionList){
        
        Set<Id> salesAgentList = new Set<Id>();
        for(Commission__c SARecords : CommissionList){
            salesAgentList.add(SARecords.Sales_Agent__c);
        }
        List<Commission__c> Opportunities = [SELECT Opportunity__c FROM Commission__C 
                                            WHERE Sales_Agent__c =: salesAgentList];
        //System.debug('opportunities is ' +Opportunities);
		
        Set<Id> opportunityIds = new Set<Id>(); 
        for(Commission__c c : Opportunities){
            opportunityIds.add(c.Opportunity__c);
        }
      List<Opportunity> CommissionRecords = [SELECT StageName,
                                        (SELECT Commission_Amount__c FROM Commissions__r WHERE Sales_Agent__c =: salesAgentList)
                                             FROM Opportunity
                                             WHERE Id IN : opportunityIds];
        Decimal Pending_Commission_Balanced=0, Settled_Commission_Balanced=0;
        for(Opportunity oppos : CommissionRecords){ 
            for(Commission__c comm : oppos.Commissions__r){
                if(oppos.StageName == 'Pending'){  
                	Pending_Commission_Balanced = Pending_Commission_Balanced + comm.Commission_Amount__c;
                }
                else{
                    if(oppos.StageName == 'Completed'){
                        Settled_Commission_Balanced = Settled_Commission_Balanced + comm.Commission_Amount__c;
                    }
                }
            }
        }        
       List<Sales_Agent__c> SalesAgentsList = [SELECT Pending_Commission_Balanced__c, Settled_Commission_Balanced__c 
                                              FROM Sales_Agent__c
                                              WHERE ID =: salesAgentList];
       List<Sales_Agent__c> SAUpdate = new List<Sales_Agent__c>();
        for(Sales_Agent__c SA : SalesAgentsList){
            SA.Pending_Commission_Balanced__c = Pending_Commission_Balanced;
            SA.Settled_Commission_Balanced__c = Settled_Commission_Balanced;
            SAUpdate.add(SA);
        }
        UPDATE SAUpdate;
        
    }
    
    public static void updateCommission(List<Commission__c> CommissionList, Map<Id,Commission__c> OldCommissionMap){
        
        for(Commission__c cm : CommissionList){
            if(OldCommissionMap != Null && cm.Commission_Amount__c != OldCommissionMap.get(cm.Id).Commission_Amount__c){
                
                Set<Id> salesAgentList = new Set<Id>();
                for(Commission__c SARecords : CommissionList){
                    salesAgentList.add(SARecords.Sales_Agent__c);
                }  
                List<Commission__c> Opportunities = [SELECT Opportunity__c FROM Commission__C 
                                            WHERE Sales_Agent__c =: salesAgentList];
                //System.debug('opportunities is ' +Opportunities);
                
                Set<Id> opportunityIds = new Set<Id>();
                for(Commission__c c : Opportunities){
                    opportunityIds.add(c.Opportunity__c);
                }
                List<Opportunity> CommissionRecords = [SELECT StageName,
                                                       (SELECT Commission_Amount__c FROM Commissions__r WHERE Sales_Agent__c =: salesAgentList)
                                                       FROM Opportunity
                                                       WHERE Id IN : opportunityIds];
                Decimal Pending_Commission_Balanced=0, Settled_Commission_Balanced=0;
                for(Opportunity oppos : CommissionRecords){ 
                    for(Commission__c comm : oppos.Commissions__r){
                        if(oppos.StageName == 'Pending'){  
                            Pending_Commission_Balanced = Pending_Commission_Balanced + comm.Commission_Amount__c;
                        }
                        else{
                            if(oppos.StageName == 'Completed'){
                                Settled_Commission_Balanced = Settled_Commission_Balanced + comm.Commission_Amount__c;
                            }
                        }
                    }
                }        
                List<Sales_Agent__c> SalesAgentsList = [SELECT Pending_Commission_Balanced__c, Settled_Commission_Balanced__c 
                                                        FROM Sales_Agent__c
                                                        WHERE ID =: salesAgentList];
                List<Sales_Agent__c> SAUpdate = new List<Sales_Agent__c>();
                for(Sales_Agent__c SA : SalesAgentsList){
                    SA.Pending_Commission_Balanced__c = Pending_Commission_Balanced;
                    SA.Settled_Commission_Balanced__c = Settled_Commission_Balanced;
                    SAUpdate.add(SA);
                }
                UPDATE SAUpdate;
                
            }
        }        
    }
     
    public static void CommissionNameViaFormula(List<Commission__c> CommissionList){
        List<Id> CommissionIds = new List<Id>();
        for(Commission__c comm : CommissionList){
            CommissionIds.add(comm.Id);
        }
        
        List<Commission__c> cms = [SELECT Id, Name, Commission_Name__c, Sales_Agent__r.Name, Sales_Agent__r.Sales_Agent_Name__c, Opportunity__r.Name 
                                   FROM Commission__c 
                                   WHERE Id In :CommissionIds];
        for(Commission__c c : cms){
            c.Commission_Name__c = (c.Opportunity__r.Name +'-'+c.Sales_Agent__r.Sales_Agent_Name__c);
           // c.Name = (c.Sales_Agent__r.Name+'-'+c.Name);
        } 
        UPDATE cms;          
    }
    
    public static void CalculateSumOfPendingAndCompletedCommissionBalance(List<Commission__c> CommissionList){
        Set<Id> salesAgentList = new Set<Id>();
        for(Commission__c SARecords : CommissionList){
            salesAgentList.add(SARecords.Sales_Agent__c);
        }
        List<Commission__c> Opportunities = [SELECT Opportunity__c FROM Commission__C 
                                            WHERE Sales_Agent__c =: salesAgentList];
        //System.debug('opportunities is ' +Opportunities);
		
        Set<Id> opportunityIds = new Set<Id>();
        for(Commission__c c : Opportunities){
            opportunityIds.add(c.Opportunity__c);
        }
      List<Opportunity> CommissionRecords = [SELECT StageName,
                                        (SELECT Commission_Amount__c FROM Commissions__r WHERE Sales_Agent__c =: salesAgentList)
                                             FROM Opportunity
                                             WHERE Id IN : opportunityIds];
        Decimal Pending_Commission_Balanced=0, Settled_Commission_Balanced=0;
        for(Opportunity oppos : CommissionRecords){ 
            for(Commission__c comm : oppos.Commissions__r){
                if(oppos.StageName == 'Pending'){  
                	Pending_Commission_Balanced = Pending_Commission_Balanced + comm.Commission_Amount__c;
                }
                else{
                    if(oppos.StageName == 'Completed'){
                        Settled_Commission_Balanced = Settled_Commission_Balanced + comm.Commission_Amount__c;
                    }
                }
            }
        }        
       List<Sales_Agent__c> SalesAgentsList = [SELECT Pending_Commission_Balanced__c, Settled_Commission_Balanced__c 
                                              FROM Sales_Agent__c
                                              WHERE ID =: salesAgentList];
       List<Sales_Agent__c> SAUpdate = new List<Sales_Agent__c>();
        for(Sales_Agent__c SA : SalesAgentsList){
            SA.Pending_Commission_Balanced__c = Pending_Commission_Balanced;
            SA.Settled_Commission_Balanced__c = Settled_Commission_Balanced;
            SAUpdate.add(SA);
        }
        UPDATE SAUpdate;
   	 }        
    }