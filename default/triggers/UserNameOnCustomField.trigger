trigger UserNameOnCustomField on account(before insert)
{
if(trigger.isbefore && trigger.isinsert)
{
User objUser = new User();
objUser = [ SELECT Name, Id FROM User WHERE Id = : UserInfo.getUserId() ];
for(Account a: trigger.new)
{
    a.Custom_Field__c = objUser.Name;
}
}
}