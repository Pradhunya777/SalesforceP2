/*---------------------------------------------------------------------------------------------------------------------------------------------------------------
Description     : Trigger for WorkOrderLineItem
Inputs          : WorkOrderLineItem that are being triggered
Handler Classes : WorkOrderLineItemTriggerHandler
Test Classes    : 
Created         : 17-12-2021
-----------------------------------------------------------------------------------------------------------------------------------------------------------------*/
public class WorkOrderLineItemTriggerHandler {
    
    /* PURPOSE : AfterInsert
* PARAM    : Map of WorkOrder
* RETURNS  : 
*/
    public static void afterInsert(Map<ID,WorkOrderLineItem> newWorkOrderLineItemMap){
        updateReportFields(newWorkOrderLineItemMap);
        
    }
        /* PURPOSE : AfterUpdate
* PARAM    : Map of WorkOrder
* RETURNS  : 
*/

    public static void afterUpdate(Map<ID,WorkOrderLineItem> newWorkOrderLineItemMap,Map<ID,WorkOrderLineItem> oldWorkOrderLineItemMap){
        updateReportFields(newWorkOrderLineItemMap);
    }
        /* PURPOSE : AfterDelete
* PARAM    : List WorkOrder
* RETURNS  : 
*/

    public static void afterDelete(List<WorkOrderLineItem>newWorkOrderLineItemList){
        Map<ID,WorkOrderLineItem> lineItemMap = new Map<ID,WorkOrderLineItem>();
        
        for(WorkOrderLineItem workOrderLineItem :newWorkOrderLineItemList){
            lineItemMap.put(workOrderLineItem.Id,workOrderLineItem);
        }
        updateReportFields(lineItemMap);
    }
    
    
    public static void updateReportFields(Map<ID,WorkOrderLineItem> newWorkOrderLineItemMap){
        
        Set<Id> workorderIds = new Set<Id>();
        
        for(WorkOrderLineItem lineItemRecord : newWorkOrderLineItemMap.Values()){
            workorderIds.add(lineItemRecord.WorkOrderId);
        }
        if(!workorderIds.IsEmpty()){
            
            Map<Id,WorkOrder> workOrderMap = new  Map<Id,WorkOrder>([SELECT Id FROM WorkOrder Where ID IN : workorderIds]);
            
            System.debug('workOrderMap ::'+workOrderMap);
            System.debug('workOrderMap Size::'+workOrderMap.Size());
            
            
            Map<Id,WorkOrderLineItem> childWorkOrderLineItemMap = getChildWorkOrderLineItems(workOrderMap.Keyset());
            
            System.debug('childWorkOrderLineItemMap::'+childWorkOrderLineItemMap);
            
            List<WorkOrder> workOrderUpdateList = new List<WorkOrder>();
            
            for(WorkOrder workOrderRecord : workOrderMap.Values()){
                
                String machineNos ;
                String model ;
                
                for(WorkOrderLineItem workOrderLineItem : childWorkOrderLineItemMap.values()){
                    
                    if(workOrderRecord.Id == workOrderLineItem.WorkOrderId && !String.isBlank(machineNos) && String.isNotBlank(workOrderLineItem.Machine_No__c)){
                        machineNos = machineNos +', '+ workOrderLineItem.Machine_No__c;
                        
                        
                    }
                    if(workOrderRecord.Id == workOrderLineItem.WorkOrderId && String.isBlank(machineNos) && String.isNotBlank(workOrderLineItem.Machine_No__c)){
                        machineNos = workOrderLineItem.Machine_No__c;
                    }
                    if(string.isBlank(model) && String.isNotBlank(workOrderLineItem.Model__c)){
                        model= workOrderLineItem.Model__c;
                    }
                    
                }
                
                workOrder workOrder = new workOrder();
                workOrder.Id= workOrderRecord.Id;
                workOrder.Child_Machine_Nos__c = machineNos;
                workOrder.Model__c= model;
                workOrderUpdateList.add(workOrder);
            }
            
            if(!workOrderUpdateList.IsEmpty()){
                Update workOrderUpdateList;
            }
            
        }
        
    }
    
    public static Map<ID,WorkOrderLineItem> getChildWorkOrderLineItems(Set<Id> workOrderIds){
        
        System.debug('workOrderIds::'+workOrderIds);
        Map<Id,WorkOrderLineItem> childWorkOrderLineItemMap = new  Map<Id,WorkOrderLineItem>();
        
        if(!workOrderIds.IsEmpty()){
            
            for(WorkOrderLineItem workOrderLineItemRec :[SELECT Id, Machine_No__c,WorkOrderId,Model__c FROM WorkOrderLineItem Where WorkOrderId IN : workOrderIds]){
                childWorkOrderLineItemMap.put(workOrderLineItemRec.Id, workOrderLineItemRec);
            }
        }
        
        return childWorkOrderLineItemMap;
    }
}