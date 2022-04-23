/**  
 * @Description        : Test class for PanVerification Aura Controller class
 * @Author             : NA
 * @Date               : 18-01-2022 (DD-MM-YYYY)
 * @Usage              : PanVerificationTest
 * 
 * Modification Log:
 * Ticket           Author          Date                 Description
 * NA               NA              18-01-2022           Initial Development
*/

@isTest
global class ZoopOneMock implements HttpCalloutMock {
  
    public static Boolean isErrorResponse = false;

    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(200);

        String endpoint = req.getEndpoint();
        if (endpoint.contains('/pan/lite')) {
            if (!isErrorResponse) {
                res.setBody('{"request_id":"asdfsadf","task_id":"asdfasdf","group_id":"asdfasdf","success":true,"response_code":"100","response_message":"PAN Is Valid","request_timestamp":"2022-01-05T06:12:18.133Z","response_timestamp":"2022-01-05T06:12:18.188Z","result":{"pan_status":"Valid","pan_number":"GAZPS93xxx","user_full_name":"Rahul Gupta"}}');
            } else {
                res.setBody('{"request_id":"asdfsadf","task_id":"asdfasdf","group_id":"asdfasdf","success":false,"response_code":"104","response_message":"PAN Is Invalid","request_timestamp":"2022-01-05T06:12:18.133Z","response_timestamp":"2022-01-05T06:12:18.188Z","result":{"pan_status":"Invalid","pan_number":"GAZPS93xxx"}}');
            }
        }
        
        return res;
    }
}