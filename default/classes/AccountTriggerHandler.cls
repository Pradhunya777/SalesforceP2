public class AccountTriggerHandler {
    public static void beforeInsert(list<Account> newList){
        for(Account acc : newList){
            acc.Description = 'Test Description';
        }
    }

}