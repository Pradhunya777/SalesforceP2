/*---------------------------------------------------------------------------------------------------------------------------------------------------------------
Description     : Trigger for Case
Inputs          : Case that are being triggered
Test Classes    : CaseTriggerHandlerTest
Created         : 09-11-2021
---------------------------------------------------------------------------------------------------------------------------------------------------------------*/
public class CaseTriggerHandler {
    
    /* PURPOSE : AfterInsert
    * PARAM    : Map of Case
    * RETURNS  : 
    */
    public static void afterInsert(Map<ID,Case> newCaseMap){
        enableCaseAssignmentRule(newCaseMap);
    }
    
    /* PURPOSE : Enable Case Assignment Rule
    * PARAM    : Map of Case
    * RETURNS  : 
    */
    public static void enableCaseAssignmentRule(Map<ID,Case> newCaseMap){
        
        //List to Update case Records 
        List<Case> caseUpdateList = new List<Case>();
        
        Database.DMLOptions caseRule = new Database.DMLOptions();
        caseRule.AssignmentRuleHeader.useDefaultRule = true;
        
        System.debug('Case Assignment Rule Activated');
        
        //Set Case Assignmet Rule for Records and add to list for Update
        for(Case caseRecord : [SELECT Id FROM Case WHERE Id IN: newCaseMap.keySet()]) {
            caseRecord.setOptions(caseRule);
            caseUpdateList.add(caseRecord);
        }
        
        //Check if Case list is not Empty before Update
        If(!caseUpdateList.isEmpty()){
            UPDATE caseUpdateList;
        }
    }
}