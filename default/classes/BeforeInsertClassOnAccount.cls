public class BeforeInsertClassOnAccount {
    
    //***Before Insert
    //Q.) If Account Industry is not Null & having value as 'Media' then populate rating as 'HOT'.
    
    public static void beforeInsert(List<Account> newList){
        for(account acc : newList){
            if(acc.industry != 'Null' && acc.industry == 'Media'){
                acc.Rating = 'Hot';
            }
            else{
                acc.Rating = 'Cold';
            } 
        }
    }

}