public class AttachmentEmail {
    public static void main(){
        
     //Fetch Student object records
        
     List<Student__c> StudentList = new List<Student__c>();
     StudentList = [select name,email__c,phone__c,address__c,State__c,Course__c from student__c 
                           WHERE State__c='Maharashtra' AND course__c='M.Tech'];
      
     //StudentList = [select name,email__c,phone__c,address__c,State__c,Course__c from student__c];   
        
     //Create a list of comma saperated values 
     
      List<String> StudentDetails = new List<String>();
        if(StudentList != NULL && !StudentList.isEmpty()){
            for(Student__c StudObj : StudentList){
                StudentDetails.add(StudObj.name + ',' + StudObj.email__c  + ',' + StudObj.Phone__c + ',' 
                                   + StudObj.address__c + ',' + StudObj.State__c + ',' + StudObj.Course__c);                
            }
        }
        
      //Creating CSV File
      
      String csvFile;
      String csvColumnHeader = 'Name, Email, Phone, Address, State, Course\n';
      List<String> csvRowValues = new List<String>();
      csvFile = csvColumnHeader + String.join(StudentDetails,'\n');
         
      //Create Attachment
      
      Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
      attach.setContentType('text/csv');
      attach.setFileName('Student file.csv');
      attach.setInline(true);
      attach.body = Blob.valueOf(csvFile);
        
      //Creating Recipient list
      
      List<String>recipientList = new List<String>();
      recipientList.add('pradhunya@dreamwares.com');
      recipientList.add('pdshewale777@gmail.com');
        
      //Sending Mail And Attach the csv File 
      
      List<Messaging.SingleEmailMessage> mailsList = new List<Messaging.SingleEmailMessage>();
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      Mail.setToAddresses(recipientList);
      Mail.setSubject('Details Of Students From Apex Class ');
      String body = 'Question ) 1 ] Fetch all students from Maharastra state who are appliying the M.Tech course 2 ] send information about these students via email send all thise information as a csv atachment. 3 ] Name, Email, Phone, Addr, Course';
     	//String body = 'All Students from student object';
        mail.setHtmlBody(body);
        if(attach != NULL){
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach });
        }
        mailsList.add(mail);
        Messaging.SendEmailResult[] SendEmailResults= Messaging.sendEmail(mailsList);          
	}
}