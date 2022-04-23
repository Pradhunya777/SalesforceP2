@isTest 
public class UpdateResumeClassTest 
{
    public static testMethod void testMethod1() 
    {
        //If we want to give static date then use below two lines
       // date d1;
       // d1 = date.newInstance(2021, 08, 13);
        List<Contact> conList= new List<Contact>(); 
        Contact con = new Contact();
        con.LastName = 'Test lastName';    
        con.Subject__c = 'Test Subject'; 
        con.Email = 'pradhunya@dreamwares.com'; 
        con.Resume_Upload_Date__c = System.today()-180;   //d1;
      //  con.Resume_Renewal_Date__c = System.today()-180;
        conList.add(con);
        insert conList;             
        
        
         List<Contact> cons = [SELECT name, Email, Resume_Upload_Date__c  FROM Contact WHERE Resume_Renewal_Date__c=today]; 
               
        List<Messaging.SingleEmailMessage> mail = new list<Messaging.SingleEmailMessage>();
        
        for(Contact c : cons){ 
            Messaging.SingleEmailMessage mailEach = new Messaging.SingleEmailMessage();
            List<String> toAddress = new List<String>();
            If(c.Email != null){
           		 toAddress.add(c.Email);   
            	 mailEach.setToAddresses(toAddress); 
            	 mailEach.setSubject('Please Update Your Resume ');
            	 mailEach.setPlainTextBody('You didnt update your resume in while, please provide the latest resume. Last resume uploaded date :');
            	 mail.add(mailEach); 
            } 
        }
        Messaging.SendEmailResult[] result = Messaging.sendEmail(mail);
        
        UpdateResumeClass obj = new UpdateResumeClass();
        DataBase.executeBatch(obj); 
        
        String cronExp = '0 0 0 * * ? *';
        System.schedule('TestjobName', cronExp, new UpdateResumeClass());
        
    }
}