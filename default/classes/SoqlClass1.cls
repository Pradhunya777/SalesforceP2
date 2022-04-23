public class SoqlClass1 {
    public static void main(){
        List<Account> accList = [Select name,NumberOfEmployees from Account];
        
        //For loop
        for(integer i=0;i<accList.size();i++){ 
            System.debug(accList[i].NumberOfEmployees);
        } 
        
        //for each 
        for(Account a:accList){
            System.debug('******** Acc Name *******'+a.Name+'******* No.Of.emps*******'+a.Numberofemployees);
        }
    }

}