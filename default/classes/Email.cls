public class Email {
    public static void main(){
        
     //Fetch Student object records
        
     List<Student__c> StudentList = new List<Student__c>();
     StudentList = [select name,email__c,phone__c,address__c,State__c,Course__c from student__c 
                            WHERE State__c='Maharashtra' AND course__c='M.Tech'];
      
     //Create a list of comma saperated values
     
      List<String> StudentDetails = new List<String>();
        if(StudentList != NULL && !StudentList.isEmpty()){
            for(Student__c StudObj : StudentList){
                StudentDetails.add(StudObj.name + ',' + StudObj.email__c + ',' + StudObj.address__c);                
            }
        }   
      //Creating CSV File
      
      String csvFile;
      String csvColumnHeader = 'Name, Email, Address, State, Course\n';
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
        
      //Sending Mail And Attach the csv File
      
      List<Messaging.SingleEmailMessage> mailsList = new List<Messaging.SingleEmailMessage>();
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      Mail.setToAddresses(recipientList);
      Mail.setSubject('Details Of Students');
      String body = 'Please find the attachment...';
      mail.setHtmlBody(body);
        if(attach != NULL){
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach });
        }
        mailsList.add(mail);
        Messaging.SendEmailResult[] SendEmailResults= Messaging.sendEmail(mailsList);     
     
	}
}