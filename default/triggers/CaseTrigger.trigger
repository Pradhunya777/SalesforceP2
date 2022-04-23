/*---------------------------------------------------------------------------------------------------------------------------------------------------------------
Description     : Trigger for Case
Inputs          : Case that are being triggered
Handler Classes : CaseTriggerHandler
Test Classes    : 
Created         : 09-11-2021
---------------------------------------------------------------------------------------------------------------------------------------------------------------*/
trigger CaseTrigger on Case (after insert) {

    if(Trigger.isAfter){
        if(Trigger.isInsert){
            CaseTriggerHandler.afterInsert(Trigger.NewMap);
        }
    }
}