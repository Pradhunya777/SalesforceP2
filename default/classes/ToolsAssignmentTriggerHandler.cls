public class ToolsAssignmentTriggerHandler {
    public static void afterInsert(List<Tools_Assignment__c> newToolsAssignmentList){
        toolsAssignmentQuantityCount(newToolsAssignmentList);
    }
    public static void afterDelete(List<Tools_Assignment__c> newToolsAssignmentList){
        toolsAssignmentQuantityCount(newToolsAssignmentList);
    }
    public static void afterUpdate(List<Tools_Assignment__c> newToolsAssignmentList){
        toolsAssignmentQuantityCount(newToolsAssignmentList);
    }
    
    public static void toolsAssignmentQuantityCount(List<Tools_Assignment__c> newToolsAssignmentList){
        
        
        Set<String> toolsIdSet= new Set<String>();
        //Get Tools Ids
        for(Tools_Assignment__c record:newToolsAssignmentList){
          toolsIdSet.add(record.Tools__c);
        }
        
        /*
        
        if(newToolsAssignmentList!=Null && !newToolsAssignmentList.isEmpty()){
            
            newToolsAssignmentList=[Select Id,Status__c, Returned__c
                                    FROM Tools_Assignment__c
                                    WHERE Tools__c IN:toolsIdSet AND Status__c='Approved' AND Returned__c= False];
        }
        System.debug('Tools Ids::'+toolsIdSet);
        System.debug('List Of TA::'+newToolsAssignmentList);
        */
        
        AggregateResult[] groupedResults;
        groupedResults=[SELECT Tools__c, SUM(Quantity__c)quantity 
                        FROM Tools_Assignment__c 
                        Where Tools__c IN:toolsIdSet AND Status__c='Approved' AND Returned__c= False GROUP BY Tools__c];
        
       
        List<Tools__c> updateToolsList=new List<Tools__c>();
        
        System.debug('Outside For Loop::');
            
        for(AggregateResult ar:groupedResults){
            System.debug('Inside For Loop::');
            Tools__c toolsRec= new Tools__c();
            toolsRec.Id= (Id)ar.get('Tools__c');
            toolsRec.Issued_quantity__c=(Decimal)ar.get('quantity')==Null?0:(Decimal)ar.get('quantity');
            System.debug('Issue quantity::'+toolsRec.Issued_quantity__c);
            /*if(groupedResults.isEmpty()){
                toolsRec.Issued_quantity__c=0;
                System.debug('Issue quantity::'+toolsRec.Issued_quantity__c);
            }*/
       
            updateToolsList.add(toolsRec);
        }
        
        if(groupedResults.isEmpty()){
            for(Id toolId :toolsIdSet){
                Tools__c tool = new Tools__c();
                tool.Id = toolId;
                tool.Issued_quantity__c = 0;
                
                updateToolsList.add(tool);
            }
        }
        
       if(!updateToolsList.isEmpty()){
            try{
                
            Update updateToolsList;
            }
            catch(DMLException ex){
                newToolsAssignmentList[0].addError(ex.getDmlMessage(0));
            }
        }
        System.debug('Updated List::'+updateToolsList);
        System.debug('Updated List Size::'+updateToolsList.Size());
        
    }    
}