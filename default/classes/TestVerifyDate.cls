@isTest
public class TestVerifyDate {
    @isTest
    public static void testDate(){
        date d = System.today();
        date d1 = System.today();
        date d2 = System.today()+31;
        
        VerifyDate.CheckDates(d,d1);
        VerifyDate.DateWithin30Days(d,d1);
        VerifyDate.SetEndOfMonthDate(d);
        
        VerifyDate.CheckDates(d,d2);
    }

}