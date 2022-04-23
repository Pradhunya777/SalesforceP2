/*fetch all students from Maharastra state who are appliying the  
 science course and send information about these students via email to me
send all thise information as a csv attachment.
 name, email, phone, addr, course*/
public class EmailSend {
    public static void main(){
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        
        String[] mailAddress = new String[]{'pradhunya@dreamwares.com','shewalepradhunya@gmail.com'};
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSubject('Mail from apex class');
        mail.setPlainTextBody('I did it....');
        mail.setToAddresses(mailAddress);
        mailList.add(mail);

		 if(!mailList.isEmpty())
             Messaging.sendEmail(mailList);
    }

}