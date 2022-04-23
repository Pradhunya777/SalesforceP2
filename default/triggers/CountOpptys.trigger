trigger CountOpptys on Opportunity (after insert,after update, after delete, after undelete) {
   
    Set<Id> accountIds = new Set<Id>();
    if(Trigger.isDelete){
        for(Opportunity oppRecord : Trigger.Old)  
            accountIds.add(oppRecord.AccountId);
    }else{
        for(Opportunity oppoRecord : Trigger.New){
            if(Trigger.isInsert || Trigger.isUndelete)
                accountIds.add(oppoRecord.AccountId);
            if(Trigger.isUpdate && oppoRecord.AccountId != Trigger.oldMap.get(oppoRecord.Id).AccountId){
                accountIds.add(oppoRecord.AccountId);
                accountIds.add(Trigger.oldMap.get(oppoRecord.Id).AccountId);
            } 
        }         
    }
    if(accountIds.size() > 0){
        List<Account> accountList = [SELECT Number_Of_Open_Opportunities__c, (SELECT Id FROM Opportunities) FROM Account WHERE Id in: accountIds];
        if(accountList.size() > 0){
            for(Account accRecord : accountList)
                accRecord.Number_Of_Open_Opportunities__c = accRecord.Opportunities.size();
            UPDATE accountList;
        }
    }
}