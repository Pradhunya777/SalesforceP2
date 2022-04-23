trigger OppName on Opportunity (before insert) {
    Set<Id> AccountIds = new Set<Id>(); 
    String oppName; 
    String accName;
    for (Opportunity oppoList : Trigger.new) {  
      accountIds.add(oppoList.AccountId);
    }  
    Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Name FROM Account WHERE Id IN :accountIds]);
    for (Opportunity newOppos : Trigger.new) {        
        DateTime Dt = date.Today();
                        String Month =dt.format('MMM'); 
                        Integer Day = Dt.day();
                        Integer Year = Dt.year();
        accName = accountMap.get(newOppos.AccountId).Name;
            oppName = accName + ' - ' +Month+ '-' +Year+'-' +newOppos.Name;
            newOppos.Name = oppName;
    }
}