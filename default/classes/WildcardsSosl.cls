public class WildcardsSosl {
    public static void main(){
        
        // *(Asterisk) => ) to N no.of characters.
         
        list<list<sobject>> slist1 = [find 'univ*' in name fields returning account(name),contact(name)];
        System.debug(slist1);
        
        list<list<sobject>> studlist = [find 'pr*' in  name fields returning Student__c(name)];
        System.debug(studlist);
        
        // ?(Question mark) => A single character
        
        list<list<sobject>> studlist1 = [find 'pra?hunya' in  name fields returning Student__c(name)];
        System.debug(studlist1);
    }

}