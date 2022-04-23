/**  
 * @Description        : SAP Service related DTO's (Wrapper classes)
 * @Author             : NA
 * @Date               : 06-01-2022 (DD-MM-YYYY)
 * @TestClass          : ServiceDTOTest.cls
 * 
 * Modification Log:
 * Ticket           Author          Date                 Description
 * NA               NA              12-01-2022           Initial Development
*/

public class ServiceDTO {

    /*
        Notes:
        1 - Do not send any field value as null, always send "" for text, "0" for number fields in case of blank values
        2 - If Date or DateTime or Time field is null, then send "0000-00-00" or "0000-00-00T00:00:00" or "00:00:00" respectively        
    */

    public static final String SAP_DATE_TIME_FORMAT = 'yyyy-MM-dd\'T\'HH:mm:ss';
    public static final String SAP_TIME_FORMAT = 'HH:mm:ss';


    public class ServiceNotification {
        public String SfdcNotification;
        public String SAPNotification;
        public String NotificationType;
        public String NotificationText;
        public String Reportedby;
        public String CustReference;
        public String CustReferenceDate;
        public String RespDate;
        public String MalfunctiongStartDate;        
        public String MalfunctiongEndDate;
        public String MalfunctiongStartTime;
        public String MalfunctiongEndTime;
        public String BreakdownTime;
        public String Equipment;
        public String Machine;
        public String SerialNumber;
        public String Priority;
        public String PersonRespons;
        public String PersonName;
        public String CodeGroup;
        public String Coding;
        public String DescriptionStext;
        public String DescriptionLtext;
        public String AdditionalFiled1;
        public String AdditionalFiled2;
        public String AdditionalFiled3;
        public String AdditionalFiled4;
        public HeaderMessage HeaderToMsg;
        public List<ServiceNotificationLineItem> HeadToItem;
        
        public ServiceNotification(WorkOrder wo) {
            SfdcNotification = wo.WorkOrderNumber;
            SAPNotification = (String.isNotBlank(wo.SAP_Record_Id__c)) ? wo.SAP_Record_Id__c : '';  // WorkOrder number returned by SAP
            NotificationType = (String.isNotBlank(wo.Notification_Type__c)) ? wo.Notification_Type__c : 'AA';
            NotificationText = (String.isNotBlank(wo.Notification_Text__c)) ? wo.Notification_Text__c : 'Certain parts against W.S., Comm. & Tech';
            Reportedby = 'KAWALJEET';   // MAPPING ?
            CustReference = 'FOC Request'; // MAPPING ? wo.AccountId ?
            CustReferenceDate = DateTime.now().format(SAP_DATE_TIME_FORMAT);   // MAPPING ?
            RespDate = DateTime.now().format(SAP_DATE_TIME_FORMAT);             // MAPPING ?
            MalfunctiongStartDate = DateTime.now().format(SAP_DATE_TIME_FORMAT);  // MAPPING ? 
            MalfunctiongStartTime = DateTime.now().format(SAP_TIME_FORMAT); // MAPPING ?
            MalfunctiongEndDate = DateTime.now().format(SAP_DATE_TIME_FORMAT); // MAPPING ? (wo.Malfunctiong_End_Date__c != null) ? wo.Malfunctiong_End_Date__c.format(SAP_DATE_TIME_FORMAT) : DateTime.now().format(SAP_DATE_TIME_FORMAT);
            MalfunctiongEndTime = DateTime.now().format(SAP_TIME_FORMAT); // MAPPING ? (wo.Malfunctiong_End_Time__c != null) ? wo.Malfunctiong_End_Time__c.format(SAP_DATE_TIME_FORMAT) : DateTime.now().format(SAP_TIME_FORMAT);
            BreakdownTime = '4.32E5'; //(wo.Breakdown_Time__c != null) ? wo.Breakdown_Time__c : DateTime.now().format(SAP_TIME_FORMAT); ? MAPPING as well as VALUE Type ? ? What is 4.32EF ?
            Equipment = '10100048179';  // MAPPING ?
            Machine = '';   // MAPPING ?
            SerialNumber = '3318';  // MAPPING ?
            Priority = (String.isNotBlank(wo.Priority)) ? wo.Priority : '2';    // Default Low Priority
            PersonRespons = (String.isNotBlank(wo.Person_Response__c)) ? wo.Person_Response__c : '';
            PersonName = (String.isNotBlank(wo.Person_Name__c)) ? wo.Person_Name__c : '';
            CodeGroup = (String.isNotBlank(wo.Code_Group__c)) ? wo.Code_Group__c : 'PREINSTL';  // MAPPING ?
            Coding = (String.isNotBlank(wo.Coding__c)) ? wo.Coding__c : 'PRST'; // MAPPING ?
            DescriptionStext = ''; // MAPPING ?
            DescriptionLtext = '';  // MAPPING ?
            AdditionalFiled1 = 'Additional Filed1';  // MAPPING ?
            AdditionalFiled2 = 'Additional Filed2';  // MAPPING ?
            AdditionalFiled3 = 'Additional Filed3';  // MAPPING ?
            AdditionalFiled4 = 'Additional Filed4';  // MAPPING ?

            HeaderToMsg = new HeaderMessage();
            HeaderToMsg.SfdcNotification = wo.WorkOrderNumber;
            HeaderToMsg.MessageItem = 'S';  // MAPPING ?
            HeaderToMsg.MessageType = '';   // MAPPING ?
            HeaderToMsg.Message = 'Sucess';   // MAPPING ?

            HeadToItem = new List<ServiceNotificationLineItem>();
        }
    }
    
    public class ServiceNotificationLineItem {
        public String SfdcNotification;
        public String NotificationItem;
        public String CodeGroup;
        public String ObjectPartcode;
        public String PartDescription;
        public String CodeGroupProblem;
        public String DamageCode;
        public String DamagesDescription;
        public String DescriptionStext;
        public String DescriptionLtext;
        public String MaterialCode;
        public String Qty;
        public String SerialBatchNumber;
        public String EquipmentCs;
        public String MachineSerial;
        public String AdditionalFiled1;
        public String AdditionalFiled2;
        public String AdditionalFiled3;
        public String AdditionalFiled4;
        
        public ServiceNotificationLineItem(WorkOrderLineItem item) {
            // SfdcNotification = WorkOrder.WorkOrderNumber;    // Fill the value PayloadGenerator
            // NotificationItem = (String.isNotBlank(item.LineItemNumber)) ? item.LineItemNumber : ''; // Alphanumeric value like "00001", "00002" // Fill the value PayloadGenerator
            CodeGroup = (String.isNotBlank(item.Code_Group__c)) ? item.Code_Group__c : 'CTGR';  // MAPPING ?
            ObjectPartcode = (String.isNotBlank(item.Affected_Part_No__c)) ? item.Affected_Part_No__c : 'IMRV'; // MAPPING ?
            PartDescription = (String.isNotBlank(item.Part_Name__c)) ? item.Part_Name__c : '';
            CodeGroupProblem = (String.isNotBlank(item.Code_Group_Problem__c)) ? item.Code_Group_Problem__c : '';
            DamageCode = (String.isNotBlank(item.Damage_code__c)) ? item.Damage_code__c : '';
            DamagesDescription = (String.isNotBlank(item.Problem__c)) ? item.Problem__c : '';
            DescriptionStext = (String.isNotBlank(item.Subject)) ? item.Subject : 'Technical';
            DescriptionLtext = (String.isNotBlank(item.Description)) ? item.Description : '';
            MaterialCode = (String.isNotBlank(item.Material_code__c)) ? item.Material_code__c : '';
            Qty = (item.Quantity__c != null && item.Quantity__c > 0) ? String.valueOf(item.Quantity__c) : '0';  // Do not send negative values instead sent 0 within quote only
            SerialBatchNumber = (String.isNotBlank(item.Part_Sl_No_Batch_No__c)) ? item.Part_Sl_No_Batch_No__c : '';
            EquipmentCs = (String.isNotBlank(item.Equipment_Number__c)) ? item.Equipment_Number__c : '';
            MachineSerial = (String.isNotBlank(item.Machine_No__c)) ? item.Machine_No__c : '';
            AdditionalFiled1 = '';  // MAPPING ?
            AdditionalFiled2 = '';  // MAPPING ?
            AdditionalFiled3 = '';  // MAPPING ?
            AdditionalFiled4 = '';  // MAPPING ?
        }
    }
    
    public class HeaderMessage {
        public String SfdcNotification;
        public String MessageItem;
        public String MessageType;
        public String Message;        
    }

    public class ServiceNotificationResponse {
        public ServiceNotiHeader NotiHeader;
    }

    public class ServiceNotiHeader {
        public String SapNotification;
    }
}