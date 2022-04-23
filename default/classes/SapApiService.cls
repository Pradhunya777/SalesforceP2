/**  
 * @Description        : SAP API Service class to generate access token
 * @Author             : NA
 * @Date               : 11-01-2022 (DD-MM-YYYY)
 * @TestClass          : SapApiServiceTest.cls
 *  
 * Modification Log:
 * Ticket           Author          Date                 Description
 * NA               NA              11-01-2022           Initial Development
*/

public class SapApiService {
    
	public static String authorize() {
        String accessToken = null;

        try {
            Http http = new Http();        
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:SAP_Integration');
            request.setMethod('POST');
            HttpResponse response = http.send(request);
            accessToken = SapApiService.extractAccessToken(response.getBody());
        } catch (Exception ex) {
            accessToken = 'Error: Exception in SAP Authorization. Message: ' + ex.getMessage() + ', LineNo: ' + ex.getLineNumber();
            System.debug(accessToken);
        }
        
        return accessToken;
    }
    
    public static HTTPRequest buildHttpRequest(String methodType, String endpoint, Map<String, String> headersMap, String requestBody) {
        HTTPRequest request = new HTTPRequest();
        request.setMethod(methodType); 
        request.setEndpoint(endpoint);
        request.setTimeout(120000);        
        for (String key : headersMap.keySet()) {
            request.setHeader(key, headersMap.get(key));
        }
        request.setBody(requestBody);
        return request;
    }

    Private static String extractAccessToken(String responseBody) {
		Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(responseBody);
        return (String)responseMap.get('access_token');
    }
}