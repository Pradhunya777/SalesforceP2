/**  
 * @Description        : Generic DTO's (Wrapper classes)
 * @Author             : NA
 * @Date               : 12-01-2022 (DD-MM-YYYY)
 * @TestClass          : DTOTest.cls
 * 
 * Modification Log:
 * Ticket           Author          Date                 Description
 * NA               NA              12-01-2022           Initial Development
*/

public class DTO {
    
    public class Response {
        @AuraEnabled 
        public Boolean isSuccess;

        @AuraEnabled 
        public String message;

        @AuraEnabled 
        public Object data;

        @AuraEnabled 
        public List<String> errors;

        public Response(Boolean isSuccess, String message, Object data) {
            this.isSuccess = isSuccess;
            this.message = message;
            this.data = data;
            this.errors = new List<String>();
        }

        public Response(Boolean isSuccess, String message, Object data, List<String> errors) {
            this.isSuccess = isSuccess;
            this.message = message;
            this.data = data;
            this.errors = errors;
        }
    }

    public class PANStatusResult {
        @AuraEnabled 
        public String pan_status; 		// "Valid"
        
        @AuraEnabled 
        public String pan_number;		// "GAZPS93xxx"
        
        @AuraEnabled 
        public String user_full_name;	// "Rahul Gupta"
  	}
    
    public class ZoopAPIResponse {
    	public String request_id;
        public String task_id;
        public String group_id;
        public Boolean success;
        public String response_code;
        public String response_message;        
        public String request_timestamp;	// "2022-01-05T06:12:18.133Z"
        public String response_timestamp;  // "2022-01-05T06:12:18.188Z"
        @AuraEnabled 
        public PANStatusResult result;
    }

    public class PANLiteRequest {
        public PANLiteRequestData data;
        public PANLiteRequest(PANLiteRequestData reqData) {
            data = reqData;
        }
    }
    
    public class PANLiteRequestData {
        public String customer_pan_number;
        public String consent;
        public String consent_text;
        public PANLiteRequestData(String custPanNumber) {
            customer_pan_number = custPanNumber;
            consent = 'Y';
            consent_text = 'I hear by declare my consent agreement for fetching my information via ZOOP API.';
        }
    }
}