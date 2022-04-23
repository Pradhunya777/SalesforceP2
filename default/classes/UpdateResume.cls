public class UpdateResume {
    public static void upResume(List<Contact> cList){
    for(Contact con : cList){
        con.Resume_Renewal_Date__c = con.Resume_Upload_Date__c + 180;
    }
  }
}