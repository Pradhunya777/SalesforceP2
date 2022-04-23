/*---------------------------------------------------------------------------------------------------------------------------------------------------------------
Description     : Trigger for WorkOrder
Inputs          : WorkOrder that are being triggered
Test Classes    : WorkOrderTriggerHandlerTest
Created         : 15-11-2021
---------------------------------------------------------------------------------------------------------------------------------------------------------------*/

public class WorkOrderTriggerHandler {   
    
    /* 
     * PURPOSE : BeforeInsert
     * PARAM   : Map of WorkOrder
     * RETURNS : 
    */
    public static void beforeInsert(List<WorkOrder> newWorkOrderList) {
        setWorkType(newWorkOrderList);        
    }  
    
    /* 
     * PURPOSE  : AfterInsert 
     * PARAM    : Map of WorkOrder
     * RETURNS  : 
    */ 
    public static void afterInsert(List<WorkOrder> workOrderList, Map<ID,WorkOrder> newWorkOrderMap) {
        //createWorkOrderLineItems(newWorkOrderMap);
        addSkills(newWorkOrderMap); 
        uploadWorkOrderToSAP(newWorkOrderMap.keySet());
    }  
    
    public static void afterUpdate(List<WorkOrder> newWorkOrderList, Map<Id,WorkOrder> oldWorkOrderMap) {
        CaseCloseOnWOClose(newWorkOrderList, oldWorkOrderMap);        
    }
    
    public static void uploadWorkOrderToSAP(Set<Id> workOrderIdSet) {     
        BatchJobUploadWorkOrderToSAP batch = new BatchJobUploadWorkOrderToSAP(workOrderIdSet);
		Database.executeBatch(batch, 80);
    }
    
    public static void addSkills(Map<ID,WorkOrder> newWorkOrderMap) {
        
        set<Id> caseIds = new set<Id>();
        
        for(WorkOrder workOrderRecord : newWorkOrderMap.Values()){
            if(String.isNotBlank(workOrderRecord.CaseId)){
                caseIds.add(workOrderRecord.CaseId);
            }
        }
        
        
        Map<Id, Skills_Selection_Matrix__mdt> skillsMetaDataMap = new Map<Id, Skills_Selection_Matrix__mdt>();
        Map<Id, Case> caseMap = new Map<Id, Case>();
        Map<Id, String> caseTOSkillsMap = new Map<Id, String>();
        
        for(Skills_Selection_Matrix__mdt skillsMetaData : [SELECT Id, Label, Product_Family__c, Skills__c FROM Skills_Selection_Matrix__mdt]){
            skillsMetaDataMap.put(skillsMetaData.Id, skillsMetaData);
            
        }
        
        for(Case caseRecord: [SELECT Id, RecordType.Name, Product_Family__c	 FROM Case Where ID IN : caseIds]) {
            
            for(Skills_Selection_Matrix__mdt skillsMetaRecord : skillsMetaDataMap.Values()){
                
                if(caseRecord.RecordType.Name == skillsMetaRecord.Label && caseRecord.Product_Family__c == skillsMetaRecord.Product_Family__c){
                    
                    caseTOSkillsMap.put(caseRecord.Id, skillsMetaRecord.Skills__c);
                }
            }
        }
        
        Map<String, Skill> skillsMap = new Map<String, Skill>();
        
        for(Skill skillRecord : [SELECT Id, DeveloperName, Language, MasterLabel FROM Skill]){
            skillsMap.put(skillRecord.MasterLabel, skillRecord);
        }
        
        List<SkillRequirement> workorderSkills = new List<SkillRequirement>();
        
        for(WorkOrder workOrderRecord : newWorkOrderMap.Values()){
            
            String Skills;
            List<String> skillsList = new List<String>();
            
            if(String.isNotBlank(workOrderRecord.CaseId) && caseTOSkillsMap.containsKey(workOrderRecord.CaseId)){
                skills = caseTOSkillsMap.get(workOrderRecord.CaseId);
                
                skillsList = skills.split(',');
                System.debug('skillsList::'+skillsList);
                
                for(String skill : skillsList){
                    if(skillsMap.containsKey(skill)){
                        
                        SkillRequirement skillRequirmentRecord = new SkillRequirement();
                        skillRequirmentRecord.RelatedRecordId = workOrderRecord.Id;
                        skillRequirmentRecord.SkillId = skillsMap.get(skill).Id;
                        skillRequirmentRecord.CurrencyIsoCode = 'USD';
                        workorderSkills.add(skillRequirmentRecord);
                    }
                }
            }
        }
        
        if(!workorderSkills.isEmpty()){
            INSERT workorderSkills;
        }
        
    }
    
    /* 
     * PURPOSE : Create WorkOrderLineItems if present on Parent Case
     * PARAM    : Map of WorkOrder
     * RETURNS  : 
    */
    public static void setWorkType(List<WorkOrder> newWorkOrderList){
        
        Map<String, WorkOrder_Type_Selection__mdt> caseTypeToWorkORderMAP = new Map<String, WorkOrder_Type_Selection__mdt>();
        Map<String, WorkOrder_Type_Selection__mdt> caseTOWorkOrderMap = new Map<String, WorkOrder_Type_Selection__mdt>();
        Map<String, String> typeTOWorkOrderMap = new Map<String, String>();
        Map<String, String> recordTypeTOWorkOrderMap = new Map<String, String>();
        
        Set<Id> caseIds = new Set<Id>();
        
        for(WorkOrder_Type_Selection__mdt worktypeMetaData : [SELECT Id, Label, Type__c, WorkOrderName__c from WorkOrder_Type_Selection__mdt]){
            caseTypeToWorkORderMAP.put(worktypeMetaData.Label, worktypeMetaData);
            recordTypeTOWorkOrderMap.put(worktypeMetaData.Label, worktypeMetaData.WorkOrderName__c);
            if(!String.isBlank(worktypeMetaData.Type__c)){
                typeTOWorkOrderMap.put(worktypeMetaData.Label+worktypeMetaData.Type__c, worktypeMetaData.WorkOrderName__c);
                caseTOWorkOrderMap.put(worktypeMetaData.Label, worktypeMetaData);
            }
        }
        System.debug('caseTypeToWorkORderMAP::'+caseTypeToWorkORderMAP.keyset());
        System.debug('caseTOWorkOrderMap::'+caseTOWorkOrderMap.keyset());
        System.debug('typeTOWorkOrderMap::'+typeTOWorkOrderMap.keyset());
        
        for(WorkOrder workOrderRecord : newWorkOrderList){
            caseIds.add(workOrderRecord.CaseId);
        }
        
        Map<ID, Case> caseMap = new Map<ID, Case>([SELECT Id,Complaint_Classification__c,RecordType.Name FROM Case Where Id IN : caseIds]);
        Map<String, ID> workTypeMap = new Map<String, ID>();
        
        if(!caseMap.isEmpty()){
            
            for(WorkType workTypeRecord : [SELECT Id, Name FROM WorkType]){
                workTypeMap.put(workTypeRecord.Name, workTypeRecord.Id);
            }       
            
            for(WorkOrder workOrderRecord : newWorkOrderList){
                
                String recordTypeName = caseMap.get(workOrderRecord.CaseId).RecordType.Name;
                if(caseTypeToWorkORderMAP.ContainsKey(recordTypeName) && String.isBlank(caseTypeToWorkORderMAP.get(recordTypeName).Type__c)){
                    
                    if(recordTypeTOWorkOrderMap.containskey(recordTypeName) ){
                        
                        recordTypeName = recordTypeTOWorkOrderMap.get(recordTypeName);
                        
                        if(workTypeMap.containsKey(recordTypeName)){
                            workOrderRecord.WorkTypeId = workTypeMap.get(recordTypeName);
                        }
                    }
                }
                System.debug('recordTypeName'+recordTypeName);
                
                if(caseTOWorkOrderMap.containsKey(recordTypeName)){
                    System.debug('inside second if');
                    
                    string recordTypeCode;
                    
                    if(!String.isBlank(caseMap.get(workOrderRecord.CaseId).Complaint_Classification__c)){
                        recordTypeCode= caseMap.get(workOrderRecord.CaseId).RecordType.Name + caseMap.get(workOrderRecord.CaseId).Complaint_Classification__c;
                    }
                    else{
                        recordTypeCode= caseMap.get(workOrderRecord.CaseId).RecordType.Name +'External';
                    }
                    if(typeTOWorkOrderMap.containsKey(recordTypeCode)){
                        workOrderRecord.WorkTypeId =  workTypeMap.get(typeTOWorkOrderMap.get(recordTypeCode));
                    }
                    
                }
                
            }
        }
        
        
    }
    
    /* 
     * PURPOSE : Create WorkOrderLineItems if present on Parent Case
     * PARAM    : Map of WorkOrder
     * RETURNS  : 
    */
    public static void createWorkOrderLineItems(Map<ID,WorkOrder> newWorkOrderMap) {
        
        Set<Id> caseIds = new Set<Id>();
        Map<String, String> caseWorkOrderMap = new Map<String, String>();
        
        //Get CaseIds
        for(WorkOrder workOrderRecord : newWorkOrderMap.values()){
            if(String.isNotBlank(workOrderRecord.CaseId)){
                caseIds.add(workOrderRecord.CaseId);
                caseWorkOrderMap.put(workOrderRecord.CaseId, workOrderRecord.Id);
            }
        }
        
        //get caseline records from Case
        
        
        Map<ID,List<Case_line_Item__c>> caseLineItemMap = new Map<ID,List<Case_line_Item__c>>();
        for(Case_line_Item__c caseLineRecord : [Select Id, Asset__c, Case__c, Name, Machine_No__c, Model__c	,
                                                Part_Name__c, Part_Sl_No_Batch_No__c, Problem__c, Quantity__c, Affected_Part_No__c
                                                FROM Case_line_Item__c 
                                                Where Case__c IN : caseIds]){
                                                    
                                                    if(!caseLineItemMap.containsKey(caseLineRecord.Case__c)){
                                                        caseLineItemMap.put(caseLineRecord.Case__c, new List<Case_line_Item__c>());
                                                    }
                                                    caseLineItemMap.get(caseLineRecord.Case__c).add(caseLineRecord);                      
                                                }
        
        System.debug('caseLineItemMap::'+caseLineItemMap);
        
        List<WorkOrderLineItem> workOrderLineItemList = new List<WorkOrderLineItem>();
        
        for(WorkOrder workOrderRecord : newWorkOrderMap.values()){
            
            if(caseLineItemMap.containsKey(workOrderRecord.CaseId)){
                
                for(Case_line_Item__c caseLineRecord: caseLineItemMap.get(workOrderRecord.CaseId)){
                    
                    WorkOrderLineItem WorkOrderLineItemRecord = new WorkOrderLineItem();
                    
                    WorkOrderLineItemRecord.AssetId = caseLineRecord.Asset__c;
                    WorkOrderLineItemRecord.Problem__c = caseLineRecord.Problem__c;
                    WorkOrderLineItemRecord.Affected_Part_No__c = caseLineRecord.Affected_Part_No__c;
                    WorkOrderLineItemRecord.Machine_No__c = caseLineRecord.Machine_No__c;
                    WorkOrderLineItemRecord.Model__c = caseLineRecord.Model__c;
                    WorkOrderLineItemRecord.Part_Name__c = caseLineRecord.Part_Name__c;
                    WorkOrderLineItemRecord.Part_Sl_No_Batch_No__c = caseLineRecord.Part_Sl_No_Batch_No__c;
                    WorkOrderLineItemRecord.Quantity__c	 = caseLineRecord.Quantity__c;
                    WorkOrderLineItemRecord.Case_line_Item__c = caseLineRecord.Id;
                    WorkOrderLineItemRecord.WorkOrderId = caseWorkOrderMap.get(caseLineRecord.Case__c);
                    workOrderLineItemList.add(WorkOrderLineItemRecord);
                    
                }
            }
        }
        
        System.debug('workOrderLineItemList::'+ workOrderLineItemList);
        System.debug('workOrderLineItemList   SIZE  ::'+ workOrderLineItemList.size());
        
        if(!workOrderLineItemList.IsEmpty()){
            INSERT workOrderLineItemList;
        }        
    }
    
    //Auto Close Case If All WorkOrders Are Completed or Canceled
    public static void CaseCloseOnWOClose(List<WorkOrder> newWorkOrderList,Map<Id,WorkOrder> oldWorkOrderMap) {
        Set<String> caseIdSet= new Set<String>();
        //Get Case Ids
        for(WorkOrder record:newWorkOrderList){
            
            if((record.Status=='Completed' && oldWorkOrderMap.get(record.Id).Status!=record.Status)||
               (record.Status=='Canceled' && oldWorkOrderMap.get(record.Id).Status!=record.Status)){
                   caseIdSet.add(record.CaseId);
               }
            
        }
        //Fetch WorkOrders Related to Case Ids
        List<WorkOrder> workorderList=new List<WorkOrder>();
        workorderList=[Select Id,CaseId,Case.Status,Status FROM WorkOrder Where CaseId IN: caseIdSet];
        Map<Id,List<WorkOrder>> caseIdToWorkOrder= new Map<Id,List<WorkOrder>>();
        for(WorkOrder woRec:workorderList){
            if(!caseIdToWorkOrder.containskey(woRec.caseId)){
                caseIdToWorkOrder.put(woRec.CaseId,new List<WorkOrder>());
            }
            caseIdToWorkOrder.get(woRec.CaseId).add(woRec);
        }
        //Check for WorkOrder Status is Completed or Canceled
        List<String> workOrderStatus= new List<String>{'Completed','Canceled'};
            List<Case> caseListToUpdate=new List<Case>();
        for(Id CaseId:caseIdToWorkOrder.keySet()){
            if(caseIdToWorkOrder.get(CaseId).size()>0){
                Boolean allWorkOrderCompletedOrCanceled=true;
                for(WorkOrder workOrderRecord:caseIdToWorkOrder.get(CaseId)){
                    if(!workOrderStatus.contains(workOrderRecord.Status)){
                        allWorkOrderCompletedOrCanceled=false;
                    }
                    
                }
                //Update Status of Case
                if(allWorkOrderCompletedOrCanceled){
                    caseListToUpdate.add(new Case(Id=CaseId, Close_Reason__c='All WorkOrders Are Completed', Status='Closed'));
                }
            }            
        }
        
        //Update Action 
        if(caseListToUpdate.size()>0){
            update caseListToUpdate;
        }
    }
}