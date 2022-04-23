trigger MakeMaillingCityAsBillingCity on Account (before update) {
    
    //Trigger.NewMap
    //We can create trigger.newmap only on {Before update, after update, after insert, after undelete}

    //We want to update a contacts mailling city as associated accounts billing city.
    
    Map<ID,account> mMap = new map<Id,account>();
    
    mmap = Trigger.newmap;  //Here we got ID's as well as sObjects in mmap;
    
    List<contact> cList = [select lastname,AccountId from contact where AccountId IN :mMap.keySet()];
    //Key set method returns all the keys
    //IN : with the help of in keyword we can compare all thee keys
    //If the account that i am tyring to update is there are any associated contacts then got all of 
    //that contacts in cList;
    
    for(Contact c : cList){
        Account a = mMap .get(c.AccountId);
        c.MailingCity = a.BillingCity;
    }
    update cList;
    
}