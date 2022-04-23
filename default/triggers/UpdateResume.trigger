trigger UpdateResume on Contact (before insert, before update) {
    UpdateResume.upResume(Trigger.new);
}
/*Trigger updateFields on Test_Object__c (before update){
  for (Test_Object__c obj: trigger.new){
    field_1__c = field_2__c;
  }
}
Trigger AccountUpdate on Contact (after insert, after update) { 

    Set <String> accID = New Set <String> (); 
    For (Contact con: Trigger.new) { 
        if (con.AccountId != Null ) { 
        accID.add (con.AccountId); 
        } 
    } 
    If (accID.size ()> 0) { 
        List <Account> upAccList = new List <Account> (); 
        For (Account ac: 
[SELECT Id, Field_Update__c FROM Account WHERE id in: AccID AND Field_Update__c != True]) { 
            ac.Field_Update__c = true; 
            UpAccList.add (ac); 
        } 
        If (upAccList.size ()> 0) 
            update upAccList; 
    } 
}*/