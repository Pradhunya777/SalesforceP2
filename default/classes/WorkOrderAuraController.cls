/**  
 * @Description        : Aura Component Controller class for UploadWorkOrderToSAP LTNG Component
 * @Author             : NA
 * @Date               : 11-01-2022 (DD-MM-YYYY)
 * @TestClass          : WorkOrderAuraControllerTest.cls
 * 
 * Modification Log:
 * Ticket           Author          Date                 Description
 * NA               NA              11-01-2022           Initial Development
*/

public class WorkOrderAuraController {

    @AuraEnabled
    public static DTO.Response uploadWorkOrderToSAP(String workOrderId) {
        DTO.Response response;

        try {
            // Get accessToken from SapApiService
            String accessToken = SapApiService.authorize();

            // Generate DTO of WorkOrder
            WorkOrder woRec = new WorkOrder(Id = workOrderId);
            List<ServiceDTO.ServiceNotification> workOrderDtoList = GenerateServiceNotificationPayload.execute(new List<WorkOrder>{woRec});
 
            // Send WorkOrder DTO to SAP server
            String jsonWoDto = JSON.serialize(workOrderDtoList[0]);
            System.debug('jsonWoDto => ' + jsonWoDto);
            response = WorkOrderSapApiHelper.uploadWorkOrder(accessToken, jsonWoDto);
            
            // Set Success/failure on WorkOrder record
            woRec.SAP_Upload_Date__c = Datetime.now();
            if (!response.isSuccess) {
                woRec.Uploaded_to_SAP__c = false;
                woRec.SAP_Integration_Error__c = String.valueOf(response.data);
            } else {
                // Handle the success response
                ServiceDTO.ServiceNotificationResponse sapResponse = (ServiceDTO.ServiceNotificationResponse)JSON.deserialize(String.valueOf(response.data), ServiceDTO.ServiceNotificationResponse.class);
                woRec.SAP_Record_Id__c = sapResponse.NotiHeader.SapNotification;
                woRec.Uploaded_to_SAP__c = true;
                woRec.SAP_Integration_Error__c = null;
            }
            
            // Update WorkOrder record
            UPDATE woRec;
        } catch (Exception ex) {
            System.debug('Exception: ' + ex.getMessage() + ' - LineNo: ' + ex.getLineNumber());
            response = new DTO.Response(false, ex.getMessage(), null);
        }

        return response;
    }
}