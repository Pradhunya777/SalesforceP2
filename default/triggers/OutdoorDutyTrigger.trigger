/*---------------------------------------------------------------------------------------------------------------------------------------------------------------
Description     : Trigger for Outdoor_Duty__c
Inputs          : WorkOrder that are being triggered
Handler Classes : OutdoorDutyTriggerHandler
Test Classes    : OutdoorDutyTriggerHandlerTest
Created         : 28-12-2021
---------------------------------------------------------------------------------------------------------------------------------------------------------------*/
trigger OutdoorDutyTrigger on Outdoor_Duty__c (before insert, before update) {

    if( Trigger.isBefore ) {
        if( Trigger.isInsert ) {
            OutdoorDutyTriggerHandler.beforeUpsert( Trigger.new, null );
        
        } else if( Trigger.isUpdate ) {
            OutdoorDutyTriggerHandler.beforeUpsert( Trigger.new, Trigger.oldMap );
        }
    }
}