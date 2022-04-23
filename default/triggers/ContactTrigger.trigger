trigger ContactTrigger on Contact (after insert,after update, after delete, after undelete) {
   
    Set<Id> accountIds = new Set<Id>();
    if(Trigger.isDelete){
        for(Contact conRecord : Trigger.Old)
            accountIds.add(conRecord.AccountId);
    }else{
        for(Contact conRecord : Trigger.New){
            if(Trigger.isInsert || Trigger.isUndelete)
                accountIds.add(conRecord.AccountId);
            if(Trigger.isUpdate && conRecord.AccountId != Trigger.oldMap.get(conRecord.Id).AccountId){
                accountIds.add(conRecord.AccountId);
                accountIds.add(Trigger.oldMap.get(conRecord.Id).AccountId);
            }
        }        
    }
    if(accountIds.size() > 0){
        List<Account> accountList = [SELECT Roll_up_Contact__c, (SELECT Id FROM Contacts) FROM Account WHERE Id in: accountIds];
        if(accountList.size() > 0){
            for(Account accRecord : accountList)
                accRecord.Roll_up_Contact__c = accRecord.Contacts.size();
            UPDATE accountList;
        }
    }
        
}