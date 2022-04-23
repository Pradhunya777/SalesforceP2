/**  
 * @Description        : Batch job to send WorkOrder record details to SAP Server
 * @Author             : NA
 * @Date               : 11-01-2022 (DD-MM-YYYY)
 * @TestClass          : BatchJobUploadWorkOrderToSAPTest.cls
 * 
 * Modification Log:
 * Ticket           Author          Date                 Description
 * NA               NA              11-01-2022           Initial Development
*/

public with sharing class BatchJobUploadWorkOrderToSAP implements Database.Batchable<SObject>, Database.AllowsCallouts {

    public static String BATCH_CLASS_NAME = 'BatchJobUploadWorkOrderToSAP';
    public Set<Id> workOrderIdSet;
    public String query;

    public BatchJobUploadWorkOrderToSAP(Set<Id> workOrderIdSet) {
        this.workOrderIdSet = workOrderIdSet;
        doInit();
    }

    public void doInit() {
        // 1 - Set Batch level defaults        
        workOrderIdSet = (workOrderIdSet != null) ? workOrderIdSet : new Set<Id>();

        // 2 - Construct batch job query
        query = 'SELECT Id, WorkOrderNumber FROM WorkOrder WHERE Id IN : workOrderIdSet';
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<WorkOrder> workOrderList) {
        System.debug(BATCH_CLASS_NAME + ' - in execute() - WorkOrder records received to send over SAP server ' + JSON.serialize(workOrderList));
        
        // 1 - Get access_token
        String accessToken = SapApiService.authorize();                
        System.debug('accessToken => ' + accessToken);

        if (!accessToken.startsWith('Error')) {
            // 2 - Construct a simple Map of WorkOrder by WorkOrderNumber, later to be used to link with equivalent DTO object
            Map<String, WorkOrder> workOrderMap = new Map<String, WorkOrder>();
            for (WorkOrder wo : workOrderList) {
                workOrderMap.put(wo.WorkOrderNumber, wo);
            }

            // 3 - Generate DTO's(payload) for WorkOrder records
            List<ServiceDTO.ServiceNotification> workOrderDtoList = GenerateServiceNotificationPayload.execute(workOrderList);        
            System.debug('workOrderDtoList => ' + workOrderDtoList);

            // 4 - Send WorkOrder DTO individually to SAP server
            for (ServiceDTO.ServiceNotification workOrderDto : workOrderDtoList) {
                String jsonWoDto = JSON.serialize(workOrderDto);
                System.debug('jsonWoDto => ' + jsonWoDto);
                DTO.Response sapResponse = WorkOrderSapApiHelper.uploadWorkOrder(accessToken, jsonWoDto);
                System.debug('sapResponse => ' + sapResponse);
                
                // Update Success/failure on respected WorkOrder record
                WorkOrder woRec = workOrderMap.get(workOrderDto.SAPNotification);
                if (!sapResponse.isSuccess) {
                    woRec.Uploaded_to_SAP__c = false;
                    woRec.SAP_Integration_Error__c = String.valueOf(sapResponse.data);
                } else {
                    woRec.Uploaded_to_SAP__c = true;
                    woRec.SAP_Integration_Error__c = null;
                }
                woRec.SAP_Upload_Date__c = Datetime.now();
            }

            List<Database.SaveResult> updateResult = Database.update(workOrderMap.values(), false);
        }
    }

    public void finish(Database.BatchableContext bc) {
        System.debug(BATCH_CLASS_NAME + ' - in finish() method execution...');
    }
}