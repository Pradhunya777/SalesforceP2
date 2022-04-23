@isTest(seeAllData = True)
public class OppNameTest {
    @isTest
    private static void TestOppName(){
        Account acc = [SELECT Id,Name from Account WHERE Name LIKE 'CheckTrigger'];
        Opportunity oppo = new Opportunity();
        oppo.Name='pds';
        oppo.CloseDate=System.today();
        oppo.StageName='Closed Lost';
        oppo.AccountId=acc.Id;
        
        INSERT oppo;
        UPDATE oppo;
        
        Opportunity opps = [SELECT Id,Name FROM Opportunity WHERE Id =:oppo.Id];
        System.assertEquals(oppo.Name, opps.Name); 
        
    }
    

}