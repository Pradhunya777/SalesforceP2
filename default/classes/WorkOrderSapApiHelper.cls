/**  
 * @Description        : SAP API Helper class for WorkOrder Sobject
 * @Author             : NA
 * @Date               : 11-01-2022 (DD-MM-YYYY)
 * @TestClass          : WorkOrderSapApiHelperTest.cls
 * 
 * Modification Log:
 * Ticket           Author          Date                 Description
 * NA               NA              11-01-2022           Initial Development
*/

public with sharing class WorkOrderSapApiHelper {

    // TODO: Try to move the base URL and other configurable urls parts to Custom Setting (or similar)
    public static String SAP_NOTIFICATION = 'https://l550064-iflmap.hcisbp.ae1.hana.ondemand.com/http/SAP_NOTIFICATION';

    public static DTO.Response uploadWorkOrder(String accessToken, String workOrderDtoJson) {
        DTO.Response sapResponse = null;

        HttpRequest req = new HttpRequest();
        HttpResponse resp = new HttpResponse();
        Http http = new Http();
        
        req.setEndPoint(SAP_NOTIFICATION);
        req.setHeader('Authorization', 'Bearer ' + accessToken);
        req.setTimeout(120000);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(workOrderDtoJson);

        try {
            resp = http.send(req);
            System.debug('SAP API Response => ' + resp.getBody());
            if (resp.getStatusCode() == 200 || resp.getStatusCode() == 201) {
                sapResponse = new DTO.Response(true, 'WorkOrder Uploaded', resp.getBody());
            } else {
                sapResponse = new DTO.Response(false, 'Upload Failed', resp.getBody());
            }
        } catch (Exception ex) {
            String errMsg = 'Exception: ' + ex.getMessage() + ', LineNo: ' + ex.getLineNumber();
            System.debug(errMsg);
            sapResponse = new DTO.Response(false, 'Upload failed', ex, new List<String>{errMsg});
        }
        
        return sapResponse;
    }
}