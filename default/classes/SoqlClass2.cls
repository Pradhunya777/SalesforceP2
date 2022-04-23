public class SoqlClass2 {
    public static void main(){
        
        // Comparing Dynamic value
        String pd = 'aryan';
        List <Contact> cList =  [select firstname,lastname,email from contact where firstname= :pd];
        System.debug(cList);
        
        //Comparing static value
        List <Contact> cList2 =  [select firstname,lastname,email from contact where firstname= 'pradhunya'];
        System.debug(cList2);
       
    }
}