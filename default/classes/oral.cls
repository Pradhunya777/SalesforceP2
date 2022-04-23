public class oral{
   public static void main(){
     list<student__c>slist = [select name,email__c,address__c from student__c where State__c='Maharashtra' AND course__c='M.Tech'];
     System.debug(slist);
}
}