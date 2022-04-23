@isTest
global class SapApiServiceTest {
        @isTest
     	static void authorizeTest(){       
        Test.startTest();  
            
        Test.setMock(HttpCalloutMock.class, new ZoopOneMock());     
        String auth = SapApiService.authorize(); 
         
        Test.stopTest();    
     }  
       @isTest
    static void buildHttpRequestTest(){
        Test.startTest();
        Map<String, String> TestMap = new Map<String, String>();
        HTTPRequest req = SapApiService.buildHttpRequest('Test Method', 'Test EndPoint', TestMap, 'est TrequestBody');
        
        Test.stopTest();
    }
     /*@isTest
    static void extractAccessToken(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ZoopOneMock());     
		//extractAccessToken method is private in SapApiService Class
        String st = SapApiService.extractAccessToken('{"request_id":"asdfsadf","task_id":"asdfasdf","group_id":"asdfasdf","success":false,"response_code":"104","response_message":"PAN Is Invalid","request_timestamp":"2022-01-05T06:12:18.133Z","response_timestamp":"2022-01-05T06:12:18.188Z","result":{"pan_status":"Invalid","pan_number":"GAZPS93xxx"}}');
        Test.stopTest(); 
    }*/  
}