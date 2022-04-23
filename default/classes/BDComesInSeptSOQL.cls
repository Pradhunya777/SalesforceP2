public class BDComesInSeptSOQL {
    public static void main(){
        List<Student__c>Slist = [SELECT ID, Name FROM Student__c
                                 WHERE CALENDAR_MONTH(BirthDate__c) = 9];
        System.debug(Slist);
    }
}