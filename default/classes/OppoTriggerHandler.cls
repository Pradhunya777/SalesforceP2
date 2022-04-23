public class OppoTriggerHandler {
    public static void OnAfterUpdate(List<Opportunity> OppoList, Map<Id,Opportunity> OldOppoMap){
        
        updateAmount(OppoList, OldOppoMap);
        stageCompletedToPending(OppoList, OldOppoMap);
    }     //StageName  Stages__c
     
    public static void OnAfterDelete(List<Opportunity> OppoList){
          
        handleAfterDelete(OppoList);   
    }
    
         
       public static void handleAfterDelete(List<Opportunity> OppoList){
         
        Set<Id> op = new Set<Id>();
        for(Opportunity oppo : OppoList){
            op.add(oppo.Id);
        }
        List<Opportunity> opps = [SELECT StageName FROM Opportunity
                                                       WHERE Id IN : op];
        
        
        Decimal Pending_Commission_Balanced=0, Settled_Commission_Balanced=0;
                for(Opportunity oppos : opps){ 
                    for(Commission__c comm : oppos.Commissions__r){
                        if(oppos.StageName == 'Pending'){  
                                //Pending_Commission_Balanced =  comm.Commission_Amount__c;
                                Pending_Commission_Balanced =  Pending_Commission_Balanced - comm.Commission_Amount__c;
                        }
                        else{
                            if(oppos.StageName == 'Completed'){
                                //Settled_Commission_Balanced =  comm.Commission_Amount__c;
                                Settled_Commission_Balanced =  Settled_Commission_Balanced - comm.Commission_Amount__c;
                            }
                        }
                    }
                }  
        //Change below *******
                List<Sales_Agent__c> SalesAgentsList = [SELECT Pending_Commission_Balanced__c, Settled_Commission_Balanced__c 
                                                        FROM Sales_Agent__c ];
                List<Sales_Agent__c> SAUpdate = new List<Sales_Agent__c>();
                for(Sales_Agent__c SA : SalesAgentsList){
                    SA.Pending_Commission_Balanced__c = Pending_Commission_Balanced;
                    SA.Settled_Commission_Balanced__c = Settled_Commission_Balanced;
                    SAUpdate.add(SA);
                }
                UPDATE SAUpdate;
    }
    
    
    
    public static void updateAmount(List<Opportunity> OppoList, Map<Id,Opportunity> OldOppoMap){
        for(Opportunity oppo : OppoList){
            if(OldOppoMap != Null && oppo.Amount != OldOppoMap.get(oppo.Id).Amount){
              
                Set<Id> op =  new Set<Id>();
                for(Opportunity o : OppoList){
                    op.add(o.Id);
                }
                
                List<Commission__c> CommissionList = [SELECT Opportunity__c,Sales_Agent__c  FROM Commission__C 
                                            WHERE Opportunity__c IN : op]; 
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
                            Pending_Commission_Balanced =  comm.Commission_Amount__c;
                        }
                        else{
                            if(oppos.StageName == 'Completed'){
                                Settled_Commission_Balanced =  comm.Commission_Amount__c;
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
    
    public static void stageCompletedToPending(List<Opportunity> OppoList, Map<Id,Opportunity> OldOppoMap){
        for(Opportunity oppo : OppoList){
            if(OldOppoMap != Null && oppo.StageName != OldOppoMap.get(oppo.Id).StageName){
                
                 Set<Id> op =  new Set<Id>();
                for(Opportunity o : OppoList){
                    op.add(o.Id);
                }
                
                List<Commission__c> CommissionList = [SELECT Opportunity__c,Sales_Agent__c  FROM Commission__C 
                                            WHERE Opportunity__c IN : op]; 
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
                                Pending_Commission_Balanced =  comm.Commission_Amount__c;
                                //Pending_Commission_Balanced =  Pending_Commission_Balanced + comm.Commission_Amount__c;
                        }
                        else{
                            if(oppos.StageName == 'Completed'){
                                Settled_Commission_Balanced =  comm.Commission_Amount__c;
                                //Settled_Commission_Balanced =  Settled_Commission_Balanced + comm.Commission_Amount__c;
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
}