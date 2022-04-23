public class CreateRelatedConWhenAccountIsCreated {
    public static void createRelatedContactWhenAccountIsCreated(List<Account> newList){
        List<Contact> conToBeInserted = new List<Contact>();
        
        for(Account acc : newList){
            Decimal n = acc.Number_of_contacts_to_create__c;
            Boolean c = acc.Has_to_create_contacts__c;
        if(c==True){
            for( integer i=1; i<=n;i++){
            Contact con = new Contact();
            con.AccountId = acc.Id; 
            con.FirstName = 'TC';
            con.LastName = 'Contact '+i;
            con.Subject__c = 'Doing great';
            conToBeInserted.add(con);            
            }
           }  
         if(!conToBeInserted.isEmpty()){
            INSERT conToBeInserted;
         }
       }
    }
}