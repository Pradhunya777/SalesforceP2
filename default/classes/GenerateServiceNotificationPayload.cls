/**  
 * @Description        : Generate Payload(JSON) of type ServiceDTO's from WorkOrder & WorkOrderLineItem
 * @Author             : NA
 * @Date               : 06-01-2022 (DD-MM-YYYY)
 * @TestClass          : GenerateServiceNotificationPayloadTest.cls
 * 
 * Modification Log:
 * Ticket           Author          Date                 Description
 * NA               NA              12-01-2022           Initial Development
*/

public class GenerateServiceNotificationPayload {
 
    public static List<ServiceDTO.ServiceNotification> execute(List<WorkOrder> workOrderList) {
        List<ServiceDTO.ServiceNotification> woDtoList = new List<ServiceDTO.ServiceNotification>();
        
        workOrderList = [SELECT Id, WorkOrderNumber, SAP_Record_Id__c, WorkTypeId, Notification_Text__c, AccountId, Malfunctiong_End_Date__c, Malfunctiong_End_Time__c,
                         Breakdown_Time__c, Priority, Person_Response__c, Person_Name__c, Code_Group__c, Coding__c, Subject, Description, Notification_Type__c,
                         Account.SAP_Customer_Code__c, 
                         (SELECT Id, LineItemNumber, Code_Group__c, Affected_Part_No__c, Part_Name__c, Code_Group_Problem__c,
                          Damage_code__c, Problem__c, Subject, Description, Material_code__c, Quantity__c, Part_Sl_No_Batch_No__c,
                          Equipment_Number__c, Machine_No__c 
                          FROM WorkOrderLineItems)
                         FROM WorkOrder 
                         WHERE Id IN : workOrderList];
        
        for (WorkOrder woRec : workOrderList) {
            ServiceDTO.ServiceNotification woDto = new ServiceDTO.ServiceNotification(woRec);
            
            if (woRec.WorkOrderLineItems != null && !woRec.WorkOrderLineItems.isEmpty()) {
                List<ServiceDTO.ServiceNotificationLineItem> woItemDtoList = new List<ServiceDTO.ServiceNotificationLineItem>();
                Integer itemCount = woRec.WorkOrderLineItems.size();
                for (Integer index = 0; index < itemCount; index++) {
                    ServiceDTO.ServiceNotificationLineItem woItemDto = new ServiceDTO.ServiceNotificationLineItem(woRec.WorkOrderLineItems[index]);
                    woItemDto.SfdcNotification = woRec.WorkOrderNumber;
                    woItemDto.NotificationItem = '00000' + (index + 1);
                    woItemDtoList.add(woItemDto);
                }
                woDto.HeadToItem = woItemDtoList;
            }

            woDtoList.add(woDto);
        }
        
        return woDtoList;
    }
}