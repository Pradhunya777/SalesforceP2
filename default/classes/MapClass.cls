public class MapClass {
    public static void main(){
        Map<Integer,String>mmap= new map <Integer,String>();
        mmap.put(11,'jack');
        mmap.put(12,'john');
        mmap.put(13,'ron');
        System.debug(mmap);
        
       // Q2. Define a map of students where student.email would be the key & student
       //  will be the value?
       
           Map<string,Student__c> Students = new Map<string,Student__c>();
			Student__c s1 = new Student__c();
			s1.Name = 'Ashish';
			s1.last_name__c = 'shewale';
			s1.email__c = 'pds@gmail.com';

			Students.put(s1.email__c,s1);
        
       	     System.debug('Result is = '+Students);
			//system.debug('------ '+Students.get(s1.email__c));

       /* Map<String,Student__c>Students=new map <String,Student__c>
      		([select name,email__c from student__c]);
		 case 2)   Students.put('pd@gmail.com',[select id from student__c]);
	     case 3)   Students.put('pd1@gmail.com',2);
        System.debug(Students);*/
        
		/*Map<string,Contact> ccMap = new Map<string,Contact>();
Contact c1 = new Contact();
c1.firstname = 'Joe';
c1.lastname = 'User';
c1.email = 'joe@example.com';
//c1.accountId ='<some id>';

ccMap.put(c1.email,c1);
system.debug('------ '+ccMap.get(c1.email)); */
       
        
        /*Map <String,Student__c>Students=new map <String,Student__c>
            ((Student__c.Email),[select name,email__c from student__c]);
        System.debug(Students);*/
        
    }

}