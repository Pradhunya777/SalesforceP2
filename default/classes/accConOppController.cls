public class accConOppController {
    
    public string accName;
     
    public Integer accEmployees;
    
    public string conName{get;set;}
    
    public string conEmail{get;set;} 
    
    public string oppName{get;set;}
    
    public Decimal oppAmmount{get;set;}
     
    
    
    public accConOppController(){
        
    }
    
    public void saveTheRecord(){
        
        Account a = new Account(Name=accName,NumberOfEmployees=accEmployees);
        INSERT a;
        
        Contact c = new Contact(lastName=conName,email=conEmail,AccountID=a.Id);
        
        Opportunity o = new Opportunity(Name=oppName,Amount = oppAmmount,AccountId=a.Id,CloseDate=System.today(),StageName='Prospecting');
        
        INSERT c;
        INSERT o;
        
        
    }
    
    public void setaccName(String p){
        accName = p;
    }
    
    public String getaccName(){
        return accName; 
    }
    
    public void setaccEmployees(Integer p){
        accEmployees = p;
    }
    
    public Integer getaccEmployees(){
        return accEmployees;
    }


}