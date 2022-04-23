@isTest
public class CreateRelatedConWhenAccountIsCreatedTest {
    @isTest
    public static void createRelatedContactWhenAccountIsCreatedTest(){
       List<Account> accList = new List<Account>();
         Account acc = new Account();
   		 acc.Name = 'Test Acc';
  		 acc.Number_of_contacts_to_create__c = 5;
  		 acc.Has_to_create_contacts__c = true;
        accList.add(acc);
        INSERT accList;         
    
        CreateRelatedConWhenAccountIsCreated.createRelatedContactWhenAccountIsCreated(accList); 
    }
}