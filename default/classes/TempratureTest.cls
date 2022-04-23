@isTest
public class TempratureTest {
    @isTest
    Private static void warmTempTest(){
        Decimal res = Temprature.FtoC(70);
        System.assertEquals(21.11, res);  
    }
    @isTest
    private static void cooldTestTemp(){
        Decimal res = Temprature.FtoC(30);
        System.assertEquals(-1.11, res);
    }

}