public class SOSLClass {
    public static void main(){
        
        list<List<sObject>> l1 = [find 'pd' returning account,contact,student__c];
        System.debug(l1);
        
        List<List<sObject>> l2 = [find 'pd' returning contact(Firstname,lastname),student__c(name,Email__c),teacher__c(name)];
        System.debug(l2);
        
        list<Contact>  conList = l2[0];
        system.debug(conList);
        
        list<Student__c> studList = l2[1];
        System.debug(studList);
        
        list<Teacher__c> tList = l2[2];
        System.debug(tList);
        
        for(contact c : conList){
            System.debug(c.Firstname);
            System.debug(c.Lastname);
        }
        
        for(Student__C s : studList){
            System.debug(s.name);
            System.debug(s.email__c);
        }
        
        For(Teacher__c t : tList){
            System.debug(t.name);
        }
        
    }

}