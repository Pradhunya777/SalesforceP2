public class RelationShip {
    Public static void main(){
        //***Child to parent
        
        //***Standard object
        List<Contact> conList = [select FirstName,LastName,Account.Name,Account.NumberOfEmployees from Contact];
        
        //***Custom Object
        List<Application__c> appList = [select Name,Ammount__c,Class__r.Name,Class__r.Description__c from Application__c];
        
        //***Parent to child
        
        //***Standard object
        List<Account>accList=[select name,NumberOfEmployees,(select lastname,phone,email from contacts) From account];
        System.debug(accList);
        
        //***Custom object
        List<Class__c>cList=[select name,Class_Country__c,Sub__c,(select name,Account__c from applications__r)from class__c];
        System.debug(cList);
        
        //***Multilevel Relatioship
        
        //***Standard Object              
        
        //***1st Option
        //Account
        //       Opportunity
        //                  OpportunityLineItems=> Query
        
        List<OpportunityLineItem>oppLineItem=[Select name,quantity,Opportunity.name,
                                             Opportunity.amount,
                                             opportunity.Account.name,
                                             opportunity.account.NumberOfEmployees 
                                             from opportunityLineItem];
        
        //***2nd Option
       //Account
       //       Opportunity=>Query
       //                  OpportunityLineItems=> Query
                         
        List<Opportunity>oppList=[Select Name,Amount,Account.Name,Account.NumberOfEmployees,
                                  (Select Name,quantity from opportunityLineitems)from opportunity];
        
        
        //***Custom Object              
        
        //***1st Option
        //ObjectOne__c 
        //            ObjectTwo__c
        //                        ObjectThree=> Query
        
       List<ObjectThree__c> O3List = [Select Name,ObjectTwo__r.Name,ObjectTwo__r.ObjectOne__r.Name from ObjectThree__c]; 
       
      //***2nd Option
        //ObjectOne__c
        //            ObjectTwo__c=> Query
        //                        ObjectThree
       
        
       List<ObjectTwo__c> O2List = [Select Name,ObjectOne__r.Name,(Select Name from ObjectThrees__r) from ObjectTwo__c];
        
            
            
                                             
        
    }

}