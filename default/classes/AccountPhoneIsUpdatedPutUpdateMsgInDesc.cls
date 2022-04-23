public class AccountPhoneIsUpdatedPutUpdateMsgInDesc {
    
    //***Before Update
    //Q.) If account phone is updated the put update message in description 
    
    public static void UpdatePhoneDesc(List<Account> newList,Map<Id,Account> oldMap){
        
        for(Account acc : newList){
            if(oldMap!=Null && acc.Phone != oldMap.get(acc.Id).Phone){
                acc.Description = 'Phone Number Is Updated ';
            }
        }
    }

}