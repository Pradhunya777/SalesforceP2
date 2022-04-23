public class DateLiterals {
    public static void main(){
        
        List<Account> acc = [select name from account where createddate = yesterday];
        System.debug(acc);
        
        List<Account> acc1 = [select name from account where createddate = today];
        System.debug(acc1);
        
        List<Account> acc2 = [select name from account where createddate = tomorrow];
        System.debug(acc2);
        
        List<Account> acc3 = [select name from account where createddate = Last_week];
        System.debug(acc3);
        
        List<Account> acc4 = [select name from account where createddate = Last_month];
        System.debug(acc4);
        
    }

}