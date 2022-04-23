@isTest(seeAllData = true)
public class OpportunityTriggerTest {
    
    @isTest
    public static void OppoNameWithFormulaAfterInsert(){
        Account acc = [SELECT Id FROM Account WHERE name LIKE '%CheckTrigger%'];   
        
        Opportunity oppos = new Opportunity();
    	 oppos.Name = 'Oppoos112';
    	 oppos.CloseDate = System.today();  
    	 oppos.StageName = 'Closed won'; 
    	 oppos.AccountId = acc.Id; 
        				date D = date.Today();
                        Integer month = D.month();
                        Integer day = D.day();
                        Integer year = D.year();        
        INSERT oppos;  
        UPDATE oppos;
        
        Opportunity optys = [SELECT id,Name from Opportunity WHERE id =:oppos.Id];
        System.assertEquals(oppos.Name, optys.Name);
    }    

}