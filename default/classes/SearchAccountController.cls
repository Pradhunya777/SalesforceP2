public class SearchAccountController {
    
    public string searchText{get;set;}
    public List<Account> accList{get;set;}
    
    public SearchAccountController(){
        
    } 
    
    public void search(){
        
        searchText = searchText +'%';
        accList = [SELECT Name,NumberOfEmployees,phone FROM Account WHERE Name LIKE : searchText];
        
    }

}