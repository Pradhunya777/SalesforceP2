public class MergeClass2 {
    public static void main(){
        
        Account a = [select name from account where name='Shubham1'];
        Account b = [select name from account where name='Test'];
         
        merge a b;
        
       
        
        
    }

}