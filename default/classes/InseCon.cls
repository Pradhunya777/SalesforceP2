public class InseCon {
    public static void insertContact(){
        List<Contact> conList = new List<Contact>();
        Contact con = new Contact();
        date d1;
        d1 = date.newInstance(2021, 08, 12);
        con.LastName = 'Test6';
        con.Subject__c = 'Test7';
        con.Email = 'pd@gmail.com';
        con.Resume_Upload_Date__c = d1;
        conList.add(con);
        
        INSERT conList;
    }

}