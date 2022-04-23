/**
*@Purpose: Test class for OutdoorDutyTrigger
**/
@isTest
public with sharing class OutdoorDutyTriggerTest {
    @testSetup
    private static void createTestData(){

        List<Trip__c> tripList = createTrips(10);        
        INSERT tripList;
        System.assertEquals([Select Id FROM Trip__c].size(), 10);        
    }

    @isTest
    public static void outdoorDutyTriggerTest(){
        Test.StartTest(); 
        List<Trip__c> tripList = [SELECT Id FROM Trip__c];
        List<Outdoor_Duty__c> outDoorDutyList = createOutdoorDutys(1, tripList[0].Id);
        INSERT outDoorDutyList;
        try{
            outDoorDutyList = createOutdoorDutys(1, tripList[0].Id);
            INSERT outDoorDutyList;
            throw new MyException('Error');
        }catch(Exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains('Outdoor Duty already exist with the same details as Visit start date, visit end date, Owner and Trip') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }

        try{
            outDoorDutyList = createOutdoorDutys(1, tripList[1].Id);
            INSERT outDoorDutyList;
            throw new MyException('Error');
        }catch(Exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains('Another trip on same day not allowed for the same owner.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }
        
        try{
            outDoorDutyList = createOutdoorDutys(1, tripList[0].Id);
            outDoorDutyList[0].Domestic_Visit_Start_Date__c = Date.today() + 5; 
            outDoorDutyList[0].Domestic_Visit_End_Date__c = Date.today() + 15;
            INSERT outDoorDutyList;
            throw new MyException('Error');
        }catch(Exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains('Trips are overlapped with the same Trip.') ? true : false;
            System.debug('test: '+e.getMessage());
            System.AssertEquals(expectedExceptionThrown, true);
        }

        try{
            outDoorDutyList = createOutdoorDutys(1, tripList[1].Id);
            outDoorDutyList[0].Domestic_Visit_Start_Date__c = Date.today() + 5; 
            outDoorDutyList[0].Domestic_Visit_End_Date__c = Date.today() + 15;
            INSERT outDoorDutyList;
            throw new MyException('Error');
        }catch(Exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains('Trips are overlapped with the same owner.') ? true : false;
            System.debug('test: '+e.getMessage());
            System.AssertEquals(expectedExceptionThrown, true);
        }


        Outdoor_Duty__c outdoorDuty = [SELECT Id FROM Outdoor_Duty__c LIMIT 1];
        outdoorDuty.international_Visit_Start_Date__c = Date.today();
        outdoorDuty.International_Visit_End_Date__c = Date.today() + 5;
        outDoorDuty.Domestic_Visit_Start_Date__c = null;
        outDoorDuty.Domestic_Visit_End_Date__c = null;
        UPDATE outdoorDuty;
        //outDoorDuty.Trip__c
        Test.StopTest();
    }

    @isTest
    public static void outdoorDutyTriggerTestWithInternationalDates(){
        Test.StartTest(); 
        List<Trip__c> tripList = [SELECT Id FROM Trip__c];
        List<Outdoor_Duty__c> outDoorDutyList = createOutdoorDutysWithInternationalDates(1, tripList[0].Id);
        INSERT outDoorDutyList;
        try{
            outDoorDutyList = createOutdoorDutysWithInternationalDates(1, tripList[0].Id);
            INSERT outDoorDutyList;
            throw new MyException('Error');
        }catch(Exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains('Outdoor Duty already exist with the same details as Visit start date, visit end date, Owner and Trip') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }

        try{
            outDoorDutyList = createOutdoorDutysWithInternationalDates(1, tripList[1].Id);
            INSERT outDoorDutyList;
            throw new MyException('Error');
        }catch(Exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains('Another trip on same day not allowed for the same owner.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }
        
        try{
            outDoorDutyList = createOutdoorDutysWithInternationalDates(1, tripList[0].Id);
            outDoorDutyList[0].international_Visit_Start_Date__c = Date.today() + 5; 
            outDoorDutyList[0].International_Visit_End_Date__c = Date.today() + 15;
            INSERT outDoorDutyList;
            throw new MyException('Error');
        }catch(Exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains('Trips are overlapped with the same Trip.') ? true : false;
            System.debug('test: '+e.getMessage());
            System.AssertEquals(expectedExceptionThrown, true);
        }

        try{
            outDoorDutyList = createOutdoorDutysWithInternationalDates(1, tripList[1].Id);
            outDoorDutyList[0].international_Visit_Start_Date__c = Date.today() + 5; 
            outDoorDutyList[0].International_Visit_End_Date__c = Date.today() + 15;
            INSERT outDoorDutyList;
            throw new MyException('Error');
        }catch(Exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains('Trips are overlapped with the same owner.') ? true : false;
            System.debug('test: '+e.getMessage());
            System.AssertEquals(expectedExceptionThrown, true);
        }

        Outdoor_Duty__c outdoorDuty = [SELECT Id FROM Outdoor_Duty__c LIMIT 1];
        outdoorDuty.international_Visit_Start_Date__c = Date.today();
        outdoorDuty.International_Visit_End_Date__c = Date.today() + 5;
        outDoorDuty.Domestic_Visit_Start_Date__c = null;
        outDoorDuty.Domestic_Visit_End_Date__c = null;
        UPDATE outdoorDuty;
        try{
            outDoorDutyList = createOutdoorDutysWithInternationalDates(1, tripList[0].Id);
            outDoorDutyList[0].Domestic_Visit_Start_Date__c = Date.today(); 
            outDoorDutyList[0].Domestic_Visit_End_Date__c = Date.today() + 5;
            outDoorDutyList[0].international_Visit_Start_Date__c = null;
        	outDoorDutyList[0].International_Visit_End_Date__c = null;
            INSERT outDoorDutyList;
            throw new MyException('Error');
        }catch(Exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains('Outdoor Duty already exist with the same details as Visit start date, visit end date, Owner and Trip') ? true : false;
            System.debug('test: '+e.getMessage());
            System.AssertEquals(expectedExceptionThrown, true);
        }
        
        Test.StopTest();
    }

    private static List<Trip__c> createTrips(Integer count){
        List<Trip__c> tripList = new List<Trip__c>();
        for(Integer i=0; i<count; i++){
            Trip__c trip = new Trip__c(
                Start_of_Trip__c = Date.today(),
                End_of_Trip__c = Date.today() + 10,
                X1st_Destination__c = 'Test destination'+i,
                Activity__c = 'FMG',
                Reason__c = 'For Loom installation'+i
            );
            tripList.add(trip);
        }  
        return tripList;                       
    }

    private static List<Outdoor_Duty__c> createOutdoorDutys(Integer count, Id tripId){
        List<Outdoor_Duty__c> outdoorDutyList = new List<Outdoor_Duty__c>();
        for(Integer i=0; i<count; i++){
            Outdoor_Duty__c outdoorDuty = new Outdoor_Duty__c(
                Trip__c = tripId,
                Domestic_Visit_Start_Date__c = Date.today(),
                Domestic_Visit_End_Date__c = Date.today() + 10
            );
            outdoorDutyList.add(outdoorDuty);
        }  
        return outdoorDutyList;                      
    }

    private static List<Outdoor_Duty__c> createOutdoorDutysWithInternationalDates(Integer count, Id tripId){
        List<Outdoor_Duty__c> outdoorDutyList = new List<Outdoor_Duty__c>();
        for(Integer i=0; i<count; i++){
            Outdoor_Duty__c outdoorDuty = new Outdoor_Duty__c(
                Trip__c = tripId,
                international_Visit_Start_Date__c = Date.today(),
                International_Visit_End_Date__c = Date.today() + 10
            );
            outdoorDutyList.add(outdoorDuty);
        }  
        return outdoorDutyList;                      
    }

    public class MyException extends Exception{}
}