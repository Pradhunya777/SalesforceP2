public with sharing class MyContacts {

    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactList(){
        System.debug('contactList: started');
        List<Contact> contactList = [SELECT Id, Name, FirstName, Phone, Email
                                        FROM Contact ORDER BY CreatedDate DESC];
        System.debug('contactList:' +contactList);
        return contactList;
    }
    @AuraEnabled(cacheable=true)
    public static Contact getContactDetail(Id contactId){
        System.debug('contactDetail: started');
        Contact contactDetail=[SELECT Id, Name, FirstName, Phone, Email
                                 FROM Contact 
                                 WHERE Id=:contactId];
        System.debug('contactDetail:'+contactDetail);
        return contactDetail;
    }  
           
    @AuraEnabled
    public static  string addNewContact(String fname,String lname,String email,String phone){
        Contact contactToBeSaved=new Contact(FirstName=fname,LastName=lname,Email=email,Phone=phone);
            System.debug('contactToBeSaved: '+contactToBeSaved);
        insert contactToBeSaved;
        return contactToBeSaved.FirstName+' '+contactToBeSaved.LastName;
    }
    @AuraEnabled
    public static id updateContactRecord(contact contactToBeUpdated){
          System.debug('contactToBeUpdated:'+contactToBeUpdated+'contactToBeUpdated.Id'+contactToBeUpdated.Id);
          Contact contactUpdate= [SELECT Id, Name, FirstName, Phone, Email
                                  FROM Contact 
                                  WHERE Id=:contactToBeUpdated.Id];
          if (contactToBeUpdated.FirstName!=null && contactToBeUpdated.FirstName!='')    
                contactUpdate.FirstName=contactToBeUpdated.FirstName;
          if (contactToBeUpdated.LastName!=null && contactToBeUpdated.LastName!='')    
                contactUpdate.LastName=contactToBeUpdated.LastName;
          if (contactToBeUpdated.Email!=null && contactToBeUpdated.Email!='')    
                contactUpdate.Email=contactToBeUpdated.Email;
            System.debug('contactToBeUpdated: '+contactUpdate.Id);
            update contactUpdate;
            return contactUpdate.Id;      
          
    }
}