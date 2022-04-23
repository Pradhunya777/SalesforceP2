public class InsertAccountWithRelatedContact {
    public void insertAccountWithCon(){
    try {
    Account acct = new Account(Name='SFDC2 Account');
    insert acct;
    ID acctID = acct.ID;
        
    Contact con = new Contact(
        FirstName='Joe',
        LastName='Smith',
        Phone='415.555.1212',
        AccountId=acctID);
    insert con;
} catch(DmlException e) {
    System.debug('An unexpected error has occurred: ' + e.getMessage());
}
    }

}