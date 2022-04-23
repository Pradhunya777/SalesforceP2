public class MyAccountController {
    public List<Account> accountList{get;set;}
    
    public MyAccountController(){
        accountList=[SELECT Id,Name,CreatedDate FROM Account LIMIT 10];
    }
    
 }