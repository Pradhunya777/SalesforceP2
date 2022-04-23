public class preventDeletionIfOppoRelatedToAccHelper {
    public static void preventDeletionIfOpportunityIsRelatedToAccount
        									(Map<Id, Account> oldMap){                                                
          List<Opportunity> oppoList = [SELECT Id, AccountId
                                       FROM Opportunity
                                       WHERE AccountId IN : oldMap.keySet()];  
        for(Opportunity oList : oppoList){
            Account a = oldMap.get(oList.AccountId);
            if(a.Id == oList.AccountId){
                olist.addError('This Acc has some related Opportunity we cant delee this Account');
            }
            delete a;
        }
    }
}   /*trigger AccountContactCheck on Account (before delete) {
Set<id> accountids=new set<id>();
for(account acc:trigger.old){
    accountids.add(acc.id);
}Map<id,contact>conmap=new map<id,contact>([select accountid from contact where accountid in :accountids]);
System.debug('conmap>>>>'+conmap.keySet());
for(account acc:trigger.old){
    if(conmap.get(acc.id)!=null){
        System.debug('Inside If of account >>>>>>');
        acc.adderror('Contact is associated with it.you cant delete account');
    }
}*/