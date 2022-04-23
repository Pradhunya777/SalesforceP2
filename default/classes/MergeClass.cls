public class MergeClass {
    public static void main(){
        
        List<Account> accList = [select name from account where name like 'Shubh%' Order By name  limit 3];
        
        Account a = accList[0];
        Account b = accList[1];
        
        merge a b;
        
        
    }

}