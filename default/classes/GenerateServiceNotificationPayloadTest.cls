@isTest 
global class GenerateServiceNotificationPayloadTest {
    
	@isTest 
    static void executeTest(){

    List<WorkOrder> woList = new List<WorkOrder>();    
        WorkOrder wo = new WorkOrder();
        wo.SAP_Record_Id__c = '5432';
        wo.Notification_Text__c ='Test Notification text77';
        wo.Priority = 'Low';
        wo.Person_Name__c = 'Test Person';         
        woList.add(wo); 
        INSERT woList;  
         
     /*   WorkOrderLineItem woli = new WorkOrderLineItem();
        woli.Part_Name__c = 'Test part';
        woli.Subject = 'Test subject'; 
        woli.Description = 'Test Description';
        INSERT woli;*/
        
       /* woList = [SELECT Id, WorkOrderNumber, SAP_Record_Id__c, WorkTypeId, Notification_Text__c, AccountId, Malfunctiong_End_Date__c, Malfunctiong_End_Time__c,
                         Breakdown_Time__c, Priority, Person_Response__c, Person_Name__c, Code_Group__c, Coding__c, Subject, Description, Notification_Type__c,
                         Account.SAP_Customer_Code__c, 
                         (SELECT Id, LineItemNumber, Code_Group__c, Affected_Part_No__c, Part_Name__c, Code_Group_Problem__c,
                          Damage_code__c, Problem__c, Subject, Description, Material_code__c, Quantity__c, Part_Sl_No_Batch_No__c,
                          Equipment_Number__c, Machine_No__c 
                          FROM WorkOrderLineItems)
                         FROM WorkOrder 
                         WHERE Id IN : woList];*/
        
        Test.startTest();
        List<ServiceDTO.ServiceNotification> res = GenerateServiceNotificationPayload.execute(woList);
        Test.stopTest();   
        
    }
}