public class SOSLSearchGroups {
    public static void main(){
        
        /*
			1) All fields
			2) Name fields
			3) Email fields
			4) Phone fields 
			5) Sidebar fields
		*/
        
        //***All fields
        
        List<List<sObject>>SoList = [find 'pd' in all fields returning contact,student__c];
        List<contact> cList = Solist[0];
        List<Student__c> sList = SoList[1];
        for(contact c : cList){
            System.debug(c);
        }
        for(Student__c s : sList){
            System.debug(s);
        }
        
        //***Name Fields
        
        List<List<sObject>>nameList = [find 'univ*' in name fields returning Account(name,Billingcountry)];
        List<Account> aList = nameList[0];
        System.debug(nameList);
        System.debug(aList);
        
        //***Email Fields
        
        List<List<sObject>>emailList = [find '*com' in email fields returning contact(firstname,lastname,email)];
        List<contact> con = emailList[0];
        System.debug(emailList);
        System.debug(con);
        System.debug(con[0].email);
        
        //***Phone fields
        
        List<List<sObject>>phoneList = [find '(336)222-7000' in phone fields returning contact(firstname,lastname,email,phone)];
        List<contact> p  = phoneList[0];
        System.debug(phoneList);
        System.debug(p); 
        System.debug(p[0].email);
        
        //***Sidebar fields
        
        List<List<sObject>>sidebarList = [find '(336)222-7000' in sidebar fields returning contact(firstname,lastname,email,phone)];
        List<contact> sbar  = sidebarList[0];
        System.debug(sidebarList);
        System.debug(sbar); 
        System.debug(sbar[0].email);

    }

}