/*---------------------------------------------------------------------------------------------------------------------------------------------------------------
Description     : Test class for Trigger for Case
Created         : 09-11-2021
---------------------------------------------------------------------------------------------------------------------------------------------------------------*/
@isTest
public class CaseTriggerHandlerTest {
    
    @isTest
    static void testenableCaseAssignmentRule() {
        
        List<Case> caseList = new List<Case>();
        
        for(Integer i=0; i<=80;i++){
            case caseRecord = new case();
            caseRecord.CurrencyIsoCode	 = 'USD';
            caseRecord.Status = 'New';
            caseRecord.Origin ='Outlook';
            caseRecord.Sub_status__c=NULL;
            caseRecord.Contracted_Services__c='FMC';
            caseList.add(caseRecord);
        }
        INSERT caseList;
    }
}