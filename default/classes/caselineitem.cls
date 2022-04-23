public class caselineitem {
    public List<Case_Line_Item__c> caseLineItemList;
    public caselineitem(ApexPages.StandardSetController controller) {
        caseLineItemList = new List<Case_Line_Item__c>();
        caseLineItemList = controller.getSelected();
        system.debug('selected records '+caseLineItemList);
    }
    public PageReference addWorkOrderLineItem(){
        
        PageReference page;
        
        String WorkOrderInsertedID= NULL;
        
        Savepoint rollBackSavePoint = Database.setSavepoint();
        
        try
        {
            if(caseLineItemList != null && caseLineItemList.size()>0){
                
                caseLineItemList = [Select Case__c,Asset__c, Name, Machine_No__c, Model__c,
                                    Part_Name__c, Part_Sl_No_Batch_No__c, Problem__c, Quantity__c, Affected_Part_No__c
                                    From Case_line_Item__c 
                                    Where Id IN: caseLineItemList];
                Id caseId= caseLineItemList[0].Case__c;
                system.debug('CaseIds '+caseId);
                
                //create work order for caseId
                Case caseRecord = [SELECT AccountId, ContactId, Priority,BusinessHoursId,EntitlementId,ServiceContractId,RecordType.Name FROM Case WHERE Id =:caseId limit 1];
                
                //WorkType wtRecord = [SELECT Id FROM WorkType Where Name = :caseRecord.RecordType.Name limit 1];
                
                WorkOrder workOrderRec= new WorkOrder();
                //workOrderRec.WorkTypeId=wtRecord.Id;
                workOrderRec.CaseId=caseId;
                workOrderRec.AccountId=caseRecord.AccountId;
                workOrderRec.ContactId=caseRecord.ContactId;
                workOrderRec.BusinessHoursId=caseRecord.BusinessHoursId;
                workOrderRec.EntitlementId=caseRecord.EntitlementId;
                workOrderRec.ServiceContractId=caseRecord.ServiceContractId;
                
                INSERT workOrderRec;
                
                WorkOrderInsertedID = workOrderRec.Id;
                
                List<WorkOrderLineItem> workOrderLineItemList= new List<WorkOrderLineItem>();
                
                //work order must have predefined value like work type 
                if(workOrderRec!=null && !String.isBlank(workOrderRec.Id)){
                    /*for(Case_line_Item__c caseLineItemRec:[Select Case__c,Asset__c, Name, Machine_No__c, Model__c,
                    Part_Name__c, Part_Sl_No_Batch_No__c, Problem__c, Quantity__c, Affected_Part_No__c
                    From Case_line_Item__c 
                    Where Id IN: caseLineItemList]){*/
                    for(Case_line_Item__c caseLineItemRec: caseLineItemList){
                        
                        WorkOrderLineItem WorkOrderLineItemRecord = new WorkOrderLineItem();
                        WorkOrderLineItemRecord.Case_line_Item__c=caseLineItemRec.Id;
                        WorkOrderLineItemRecord.AssetId=caseLineItemRec.Asset__c;
                        WorkOrderLineItemRecord.Machine_No__c=caseLineItemRec.Machine_No__c;
                        WorkOrderLineItemRecord.Model__c=caseLineItemRec.Model__c;
                        WorkOrderLineItemRecord.Part_Name__c=caseLineItemRec.Part_Name__c;
                        WorkOrderLineItemRecord.Part_Sl_No_Batch_No__c=caseLineItemRec.Part_Sl_No_Batch_No__c;
                        WorkOrderLineItemRecord.Problem__c=caseLineItemRec.Problem__c;
                        WorkOrderLineItemRecord.Quantity__c=caseLineItemRec.Quantity__c;
                        WorkOrderLineItemRecord.Affected_Part_No__c=caseLineItemRec.Affected_Part_No__c;
                        WorkOrderLineItemRecord.WorkOrderId=workOrderRec.Id;
                        workOrderLineItemList.add(WorkOrderLineItemRecord);
                        
                    }
                }
                
                if(!workOrderLineItemList.IsEmpty()){
                    INSERT workOrderLineItemList;
                }
                
            }
            else {
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Please select at least one Case Line Item'));
            }
            
        }catch(DmlException dmlEx){
			Database.rollback(rollBackSavePoint);
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, dmlEx.getDmlMessage(0)));
            return NULL;
		}
        catch (Exception ex){
            
            Database.rollback(rollBackSavePoint);
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ex.getMessage()));
            return NULL;
        }  
        
        // Redirect to WorkOrder record Inserted
        
        string url;
        if(!String.isBlank(WorkOrderInsertedID)){
            
            url = System.URL.getSalesforceBaseUrl().toExternalForm()+'/'+WorkOrderInsertedID;
            page = new PageReference(url);
            page.setRedirect(true);
        }
        return page;
        
        // Redirect Code Ends here
        
    }             
}