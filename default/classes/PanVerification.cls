/**  
 * @Description        : Aura Component Controller class for UploadWorkOrderToSAP LTNG Component
 * @Author             : NA
 * @Date               : 30-12-2021 (DD-MM-YYYY)
 * @TestClass          : PanVerificationTest.cls
 * 
 * Modification Log:
 * Ticket           Author          Date                 Description
 * NA               NA              30-12-2021           Initial Development
*/

public class PanVerification {
    
    @AuraEnabled
    public static DTO.Response verifyPanNumber(String accountId) {
        DTO.Response auraResponse;
        String errMsg;
        
        Account account = [SELECT Id, Name, PAN_Number__c FROM Account WHERE Id = :accountId];
        if (String.isBlank(account.PAN_Number__c)) {
            return new DTO.Response(false, 'PAN Number not found!', account.PAN_Number__c);                
        }        

        try {
            ZOOP_ONE_API_Setting__c config = ZOOP_ONE_API_Setting__c.getOrgDefaults();
            Map<String, String> headersMap = new Map<String, String>();
            headersMap.put('api-key', config.API_Key__c);
            headersMap.put('app-id', config.App_Id__c); 
            headersMap.put('Content-Type', 'application/json;charset=UTF-8');                
            DTO.PANLiteRequestData reqData = new DTO.PANLiteRequestData(account.PAN_Number__c);
            DTO.PANLiteRequest reqBody = new DTO.PANLiteRequest(reqData);
            HTTPRequest request = SapApiService.buildHttpRequest('POST', config.Endpoint__c, headersMap, JSON.serialize(reqBody));
            
            HTTP http = new HTTP();
            HTTPResponse response = http.send(request);
            if (response != null && response.getBody() != null) {
                DTO.ZoopAPIResponse apiResp = (DTO.ZoopAPIResponse)JSON.deserialize(response.getBody(), DTO.ZoopAPIResponse.class);
                if (apiResp.response_code == '100') {
                    Map<String, Object> dataMap = new Map<String, Object>();
                    dataMap.put('account', account);
                    dataMap.put('panResult', apiResp.result);
                    auraResponse = new DTO.Response(true, 'PAN Number is Valid.', dataMap);
                } else {                    
                    errMsg = 'Error! Message: ' + apiResp.response_message;
                    auraResponse = new DTO.Response(false, errMsg, apiResp.result);
                }
            } else {                
                errMsg = 'Error! Unable to verify the PAN Number. Blank HTTP Response. Please try again.';
                auraResponse = new DTO.Response(false, errMsg, response);
            }                        
        } catch (Exception ex) {            
            errMsg = 'Exception - ' + ex.getMessage();
            auraResponse = new DTO.Response(false, errMsg, null);
        }
        
        // Update Account record with success/error        
        // Note: On Account record set error message if any, else remove earlier error message in case of success
        if (String.isNotBlank(errMsg)) {
            account.PAN_Verified__c = false;
        	account.PAN_Verification_Error_Details__c = errMsg;
            UPDATE account;
        }
        
        return auraResponse;
    }
    
    @AuraEnabled
    public static DTO.Response setPANStatus(String accountId, Boolean isPANVerified, String comments, Boolean isCopyPANName, String nameOnPANCard) {
        DTO.Response response;
        
        try {
            Account act = new Account(Id = accountId, PAN_Verified__c = isPANVerified, PAN_Verification_comments__c = comments);
            if (isPANVerified) act.PAN_Verification_Error_Details__c = null;
            if (isCopyPANName) act.Name = nameOnPANCard;
            UPDATE act;
            response = new DTO.Response(true, 'PAN status updated successfully.', null);
        } catch (Exception ex) {
            response = new DTO.Response(false, ex.getMessage(), null);
        }
        
        return response;
    }    
}