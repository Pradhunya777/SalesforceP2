public class DynamicApex {
    public static void main(){
        
        //***Dynamic SOQL
        
       /* String pd = 'Select name from student__c';
        String pd1 = String.escapeSingleQuotes(pd);
        List<Sobject> pd2 = Database.query(pd1);
        System.debug(pd2); */
        
        String pd3 = 'select id';
        String []Fields = new List<String>();
        Fields.add('name');
        Fields.add('numberofemployees');
        Fields.add('phone ');
        
        String ObjectName = 'Account';
        
        for(String f : Fields){
            pd3 += ','+f;
        }
        pd3 += ' from ' + ObjectName;
        
        String pd4 = String.escapeSingleQuotes(pd3);
        
        List<sObject>pd5= Database.query(pd4);
        
        System.debug(pd5);
        
        
    }
}