public class BeforeInsertClassOnAccounts {
    
    public static void firstBefore(List<Account> newList){
        for(account acc : newList){
            if(acc.industry != Null && acc.industry == 'Media'){
                acc.Rating = 'hot';
            }
            else
                acc.Rating = 'cold';
        }
    }
    
}