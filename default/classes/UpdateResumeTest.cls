@isTest
public class UpdateResumeTest {
    @isTest
    public static void upResumeTest(){
        List<Contact> conList = new List<Contact>();
        Contact con = new Contact();
        con.FirstName = 'Test FirstName';
        con.LastName  = 'Test LastName';
        con.Subject__c = 'Test Subject';
        con.Resume_Upload_Date__c = System.today();
        conList.add(con);
        INSERT conList;
        
        UpdateResume.upResume(conList);
    }

}/* @isTest
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
}*/