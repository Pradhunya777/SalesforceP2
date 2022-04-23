public class MapKeyValue {
    public static void main(){
        
           Map<string,Student__c> Students = new Map<string,Student__c>();
			Student__c s1 = new Student__c();
			s1.Name = 'Amey';
			s1.last_name__c = 'Shirsath';
			s1.email__c = 'As@gmail.com';   
        
        	Student__c s2 = new Student__c();
				s2.Name = 'Adi';
				s2.last_name__c = 'Jadhav';
				s2.email__c = 'Aj@gmail.com';

			Students.put(s1.email__c,s1);
        Students.put(s2.email__c,s2);
        
            System.debug('Result is = '+Students);
			//system.debug('------ '+Students.get(s1.email__c));
        
    }

}