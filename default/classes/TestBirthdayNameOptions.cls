@isTest
public class TestBirthdayNameOptions {
    @isTest
    public static void TestBirthdayName(){
	String cronExp = '0 0 0 * * ? *';
        System.schedule('TestjobName', cronExp, new BirthdayNameOptions());
    }
}