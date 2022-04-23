public class Soslkeywords {
    public static void main(){
        
        //***Where clause
        
        List<List<sobject>> slist1 = [find 'univ*' in name fields returning 
                                      account(name,billingcountry where createddate < TODAY)
                                      ,contact(name),
                                      student__c(name where email__c='u@gmail.com')];
        system.debug(slist1);
         
        List<List<sobject>> c1 = [find 'pd' in name fields returning case(casenumber,type where origin='email')];
        System.debug(c1);
           
        //***OrderBy clause
        
        list<list<sobject>> slist2 = [find 'pd' returning account(name,phone where website!= null ORDER By name DESC)
                                     ,contact(name ORDER BY name LIMIT 1)];
        System.debug(slist2);
        
    }

}