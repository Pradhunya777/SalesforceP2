public class DMLStatements {
    public static void main(){
        
        //***Insert 
        
        List<Account> accList = new List<Account>();
        
        for(Integer i=21;i<30;i++){
            Account a = new Account(Name = 'Test Account '+i,phone='1111'+i);
            accList.add(a);
        }
        insert accList;
        
        //***Update
        
        List<Account> accList1= [select name from Account where createddate=TODAY];
		for(Account a : accList1){
            a.Name = 'Updated '+a.Name;
        }
        update accList1;
        
        //***UpSert 
        
        List<Account>accList2 = [select name,NumberOfEmployees from Account where createddate=TODAY];
        
        for(Account a :accList2){
            a.NumberOfEmployees=10500;
         }
        
        for(Integer i=0;i<30;i++){
            Account a = new Account(Name='New records from upsert'+i);
            accList2.add(a);
        }
        upsert accList2;
        
        //***Delete
        
        List<Account>accList3 = [select name,NumberOfEmployees from Account where createddate=TODAY];
        
        Delete accList3;  
        
        
        //If we want to delete specific record then
        
        List<Account>accList4 = [select name from Account where name like 'mat%'];
        
        Delete accList4;
        
        //***UnDelete
        
        List<Account>accList5 = [select name from Account where CreatedDate = TODAY AND isDeleted = true ALL ROWS];
        
        UnDelete accList5;
        
        //If we want to UnDelete specific record then
        
        List<Account>accList6 = [select name from Account where name like 'mat%' AND isDeleted = true ALL ROWS];
        
        UnDelete accList6; 
        
        //***Merge
        
        
        
    }

}