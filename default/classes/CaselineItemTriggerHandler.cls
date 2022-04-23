/*---------------------------------------------------------------------------------------------------------------------------------------------------------------
Description     : Trigger for Case_line_Item__c
Inputs          : WorkOCase_line_Item__crder that are being triggered
Test Classes    : CaselineItemTriggerHandlerTest
Created         : 16-11-2021
---------------------------------------------------------------------------------------------------------------------------------------------------------------*/
public class CaselineItemTriggerHandler {
    
    /* PURPOSE : AfterInsert
* PARAM    : Map of WorkOrder
* RETURNS  : 
*/
    public static void afterUpdate(Map<ID,Case_line_Item__c> newCaselineItemMap){
        createCaseWorkOrderLineItems(newCaselineItemMap);
    }
    
    /* PURPOSE : Create WorkOrderLineItems if present on Parent Case
* PARAM    : Map of WorkOrder
* RETURNS  : 
*/
    public static void createCaseWorkOrderLineItems(Map<ID,Case_line_Item__c> newCaselineItemMap){
        
        Map<Id, WorkOrderLineItem> workOrderLineItemsMap = new  Map<Id, WorkOrderLineItem>([SELECT ID , Case_line_Item__c, AssetId, Problem__c, Affected_Part_No__c, Machine_No__c, Model__c,
                                                                                            Part_Name__c, Part_Sl_No_Batch_No__c, Quantity__c
                                                                                            FROM WorkOrderLineItem
                                                                                            WHERE Case_line_Item__c IN : newCaselineItemMap.KeySet()]);
        
        
        
        if(!workOrderLineItemsMap.isEmpty()){
            
            List<WorkOrderLineItem> workOrderLineUpdateList = new List<WorkOrderLineItem>();
            
            for(WorkOrderLineItem workOrderLineRecord : workOrderLineItemsMap.values()){
                if(workOrderLineRecord.AssetId != newCaselineItemMap.get(workOrderLineRecord.Case_line_Item__c).Asset__c ||
                   workOrderLineRecord.Problem__c != newCaselineItemMap.get(workOrderLineRecord.Case_line_Item__c).Problem__c ||
                   workOrderLineRecord.Affected_Part_No__c != newCaselineItemMap.get(workOrderLineRecord.Case_line_Item__c).Affected_Part_No__c ||
                   workOrderLineRecord.Machine_No__c != newCaselineItemMap.get(workOrderLineRecord.Case_line_Item__c).Machine_No__c ||
                   workOrderLineRecord.Model__c != newCaselineItemMap.get(workOrderLineRecord.Case_line_Item__c).Model__c ||
                   workOrderLineRecord.Part_Name__c != newCaselineItemMap.get(workOrderLineRecord.Case_line_Item__c).Part_Name__c ||
                   workOrderLineRecord.Part_Sl_No_Batch_No__c != newCaselineItemMap.get(workOrderLineRecord.Case_line_Item__c).Part_Sl_No_Batch_No__c ||
                   workOrderLineRecord.Quantity__c != newCaselineItemMap.get(workOrderLineRecord.Case_line_Item__c).Quantity__c
                   
                  ){
                      
                      WorkOrderLineItem workOrderLineItem = new WorkOrderLineItem();
                      workOrderLineItem.Id= workOrderLineRecord.Id;
                      workOrderLineItem.AssetId = newCaselineItemMap.get(workOrderLineRecord.Case_line_Item__c).Asset__c;
                      workOrderLineItem.Problem__c = newCaselineItemMap.get(workOrderLineRecord.Case_line_Item__c).Problem__c;
                      workOrderLineItem.Affected_Part_No__c = newCaselineItemMap.get(workOrderLineRecord.Case_line_Item__c).Affected_Part_No__c;
                      workOrderLineItem.Machine_No__c = newCaselineItemMap.get(workOrderLineRecord.Case_line_Item__c).Machine_No__c;
                      workOrderLineItem.Model__c = newCaselineItemMap.get(workOrderLineRecord.Case_line_Item__c).Model__c;
                      workOrderLineItem.Part_Name__c = newCaselineItemMap.get(workOrderLineRecord.Case_line_Item__c).Part_Name__c;
                      workOrderLineItem.Part_Sl_No_Batch_No__c = newCaselineItemMap.get(workOrderLineRecord.Case_line_Item__c).Part_Sl_No_Batch_No__c;
                      workOrderLineItem.Quantity__c	 = newCaselineItemMap.get(workOrderLineRecord.Case_line_Item__c).Quantity__c;
                      
                      workOrderLineUpdateList.add(workOrderLineItem);
                      
                      System.debug('Work Order added to updated List');
                      
                  }
                
            }
            
            System.debug('workOrderLineUpdateList::'+workOrderLineUpdateList);
            System.debug('workOrderLineUpdateList  SIZE::'+workOrderLineUpdateList.Size());
            
            if(!workOrderLineUpdateList.IsEmpty()){
                UPDATE workOrderLineUpdateList;
            }
            
        }
        
    }
    
}