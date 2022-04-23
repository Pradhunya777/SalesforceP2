public class Q2Oral2 {
    public static void main(){
        
           Map<string,Student__c> Students = new Map<string,Student__c>();
			Student__c s1 = new Student__c();
			s1.Name = 'Ashish';
			s1.last_name__c = 'shewale';
			s1.email__c = 'pds@gmail.com';

			Students.put(s1.email__c,s1);
        
            System.debug('Result is = '+Students);
			//system.debug('------ '+Students.get(s1.email__c));
        
    }

}