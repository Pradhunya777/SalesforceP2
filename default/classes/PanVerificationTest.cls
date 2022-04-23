/**  
 * @Description        : Test class for PanVerification Aura Controller class
 * @Author             : NA
 * @Date               : 18-01-2022 (DD-MM-YYYY)
 * @TestClass          : PanVerificationTest.cls
 * 
 * Modification Log: 
 * Ticket           Author          Date                 Description
 * NA               NA              18-01-2022           Initial Development
*/ 

@isTest
global class PanVerificationTest {

    @testSetup  
    static void createTestRecords() {
        Account act = buildAccount('Test Account 100', 'HYTB56LK67HJ');
        INSERT act;
        
        TestFactory.buildCustomSettings();        
    }



    // TEST METHODS
    @isTest
    static void verifyPanNumberTest() {
        Account act = [SELECT Id FROM Account];
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ZoopOneMock());
        DTO.Response response = PanVerification.verifyPanNumber(act.Id);
        Test.stopTest();

        // Assert the functionality - We should expect the successful response
    }

    @isTest
    static void verifyPanNumberNegativeTest() {
        Account act = [SELECT Id FROM Account];

        // Create another account record with null Pan number
        Account act2 = buildAccount('Test Account 101', null);
        INSERT act2;

        DTO.Response response, response2;

        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new ZoopOneMock());
        
        // Call method on Account record with blank PAN number
        response = PanVerification.verifyPanNumber(act2.Id);
        
        // Make error response
        ZoopOneMock.isErrorResponse = true; 
        response2 = PanVerification.verifyPanNumber(act.Id);
        
        Test.stopTest();

        // Assert the functionality - We should expect an error(isSuccess=false) in response
        // as the Pan Number is missing in given account record
        System.assertEquals(false, response.isSuccess);
        System.assertEquals(false, response2.isSuccess);
    }

    @isTest
    static void setPANStatusTest() {
        Account act = [SELECT Id FROM Account];

        Test.startTest();

        DTO.Response res1 = PanVerification.setPANStatus('DummyAccountId', true, 'PAN Number is Valid', true, 'David Cameron');

        DTO.Response res2 = PanVerification.setPANStatus(act.Id, true, 'PAN Number is Valid', true, 'David Cameron');
        
        Test.stopTest();

        // Assert the functionality
    }



    // BUILDER METHODS
    static Account buildAccount(String name, String panNumber) {
        Account act = TestFactory.buildAccount(name);
        act.PAN_Number__c = panNumber;
        return act;
    }
}