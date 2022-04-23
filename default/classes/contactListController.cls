public class contactListController {
    @AuraEnabled(cacheable='true')
    public static List<Contact> getContactList(){
        List<Contact> contactList = new List<Contact>([SELECT Id, FirstName, LastName, 
                                                       Name, Email, Phone 
                                                       FROM Contact 
                                                       WHERE Email != null
                                                       ORDER BY CreatedDate DESC
                                                       LIMIT 10]);
        return contactList;  
    } 
}