/*---------------------------------------------------------------------------------------------------------------------------------------------------------------
Description     : Trigger Handler for Outdoor_Duty__c
Inputs          : OutdoorDuty that are being triggered
Test Classes    : OutdoorDutyTriggerHandlerTest
Created         : 28-12-2021
---------------------------------------------------------------------------------------------------------------------------------------------------------------*/

public class OutdoorDutyTriggerHandler {
    public static void beforeUpsert( List<Outdoor_Duty__c> newOutdoorDutyList, Map<Id, Outdoor_Duty__c> oldOutdoorDutyMap ) {
        Set<Id> serviceEngineerIdSet = new Set<Id>();
        Set<Id> currentOdIdSet = new Set<Id>();
        /*Set<Datetime> visitStartDateSet = new Set<Datetime>();
        Set<Datetime> visitEndDateSet = new Set<Datetime>();
        Set<String> tripSet = new Set<String>();*/
        
        if( newOutdoorDutyList != null && !newOutdoorDutyList.isEmpty() ) {
            //&& oldOutdoorDutyMap == null ) {
            for(Outdoor_Duty__c od : newOutdoorDutyList) {
                serviceEngineerIdSet.add( od.OwnerId );
                /*if( od.Domestic_Visit_Start_Date__c != null ){
                    visitStartDateSet.add( od.Domestic_Visit_Start_Date__c );
                    visitEndDateSet.add( od.Domestic_Visit_End_Date__c );
                }else{
                    visitStartDateSet.add( od.international_Visit_Start_Date__c );
                    visitEndDateSet.add( od.International_Visit_End_Date__c );
                } 
                tripSet.add( od.Trip__c );*/
                if( oldOutdoorDutyMap != NULL && !oldOutdoorDutyMap.isEmpty() && oldOutdoorDutyMap.get(od.Id) != null){              
                    currentOdIdSet.add(od.Id);
                }
            }
        } /*else {
            for(Outdoor_Duty__c od : newOutdoorDutyList) {
                Outdoor_Duty__c old_od = oldOutdoorDutyMap.get(od.Id);
                
                if( old_od.OwnerId != od.OwnerId ||
                  	old_od.Domestic_Visit_Start_Date__c != od.Domestic_Visit_Start_Date__c ||
                    old_od.Domestic_Visit_End_Date__c != od.Domestic_Visit_End_Date__c ||
                    old_od.international_Visit_Start_Date__c != od.international_Visit_Start_Date__c ||
                    old_od.International_Visit_End_Date__c != od.International_Visit_End_Date__c ||
                    old_od.Trip__c != od.Trip__c) {
                    currentOdIdSet.add(od.Id);
                    serviceEngineerIdSet.add( od.OwnerId );
                }
            }
        } */
        
        if( serviceEngineerIdSet != NUll && !serviceEngineerIdSet.isEmpty() ) {

            List<Outdoor_Duty__c> existing_odList = getExistingOutdoorDutiesByOwnerIds( serviceEngineerIdSet, currentOdIdSet );
            for(Outdoor_Duty__c od : newOutdoorDutyList) {
                for( Outdoor_Duty__c existing_od :  existing_odList ) {
                    processOutdoorDuties( od, existing_od);   
                }
            }
        }
    }
    
    @TestVisible
    private static List<Outdoor_Duty__c> getExistingOutdoorDutiesByOwnerIds( Set<Id> serviceEngineerIdSet, Set<Id> currentOdIdSet){
    //Set<Datetime> visitStartDateSet, Set<Datetime> visitEndDateSet, Set<String> tripSet) {
        String query = 'SELECT Id, OwnerId, Domestic_Visit_Start_Date__c, Domestic_Visit_End_Date__c,' +
            		   ' International_Visit_End_Date__c, international_Visit_Start_Date__c, Trip__c' +
            		   ' FROM Outdoor_Duty__c' +
            		   ' WHERE OwnerId IN :serviceEngineerIdSet';
                       /*' AND ( ' +
                            ' ( Domestic_Visit_Start_Date__c IN: visitStartDateSet AND Domestic_Visit_End_Date__c IN: visitEndDateSet)'+
                            ' OR'+
                            ' ( international_Visit_Start_Date__c IN: visitStartDateSet AND International_Visit_End_Date__c IN: visitEndDateSet)'+
                       ' )';*/
        
        if( !currentOdIdSet.isEmpty() ) {
            query += ' AND Id NOT IN :currentOdIdSet';
        }
        return Database.query(query);
    }

    private static void processOutdoorDuties( Outdoor_Duty__c newOutdoorDuty, Outdoor_Duty__c existing_od){        
        //Duplicate
        if(newOutdoorDuty.Trip__c == existing_od.Trip__c && newOutdoorDuty.OwnerId == existing_od.OwnerId &&
        (
         (newOutdoorDuty.Domestic_Visit_Start_Date__c >= existing_od.Domestic_Visit_Start_Date__c &&
         newOutdoorDuty.Domestic_Visit_End_Date__c <= existing_od.Domestic_Visit_End_Date__c) 
            ||
         (newOutdoorDuty.international_Visit_Start_Date__c >= existing_od.international_Visit_Start_Date__c &&
         newOutdoorDuty.International_Visit_End_Date__c <= existing_od.International_Visit_End_Date__c)   
            )
        ) {
            /*newOutdoorDuty.addError('Outdoor Duty already existed with the same details! Domestic Visit Start and End Date: ' +
                     existing_od.Domestic_Visit_Start_Date__c + ' to ' + existing_od.Domestic_Visit_End_Date__c +
                     ' & International Visit Start and End Date: ' + 
                     existing_od.international_Visit_Start_Date__c + ' to ' + existing_od.International_Visit_End_Date__c);*/
            newOutdoorDuty.addError('Outdoor Duty already exist with the same details as Visit start date, visit end date, Owner and Trip');
        }
		
        else if(newOutdoorDuty.Trip__c == existing_od.Trip__c && newOutdoorDuty.OwnerId == existing_od.OwnerId &&
         (
         (newOutdoorDuty.Domestic_Visit_Start_Date__c >= existing_od.international_Visit_Start_Date__c &&
         newOutdoorDuty.Domestic_Visit_End_Date__c <= existing_od.International_Visit_End_Date__c) 
            ||
         (newOutdoorDuty.international_Visit_Start_Date__c >= existing_od.Domestic_Visit_Start_Date__c &&
         newOutdoorDuty.International_Visit_End_Date__c <= existing_od.Domestic_Visit_End_Date__c)   
          )
        ) {
            /*newOutdoorDuty.addError('Outdoor Duty already existed with the same details! Domestic Visit Start and End Date: ' +
                     existing_od.Domestic_Visit_Start_Date__c + ' to ' + existing_od.Domestic_Visit_End_Date__c +
                     ' & International Visit Start and End Date: ' + 
                     existing_od.international_Visit_Start_Date__c + ' to ' + existing_od.International_Visit_End_Date__c);*/
            newOutdoorDuty.addError('Outdoor Duty already exist with the same details as Visit start date, visit end date, Owner and Trip');
        }
        
        //No overlapping. Another trip on same day not allowed
        else if(newOutdoorDuty.Trip__c != existing_od.Trip__c && newOutdoorDuty.OwnerId == existing_od.OwnerId &&
        (
         (newOutdoorDuty.Domestic_Visit_Start_Date__c >= existing_od.Domestic_Visit_Start_Date__c &&
         newOutdoorDuty.Domestic_Visit_End_Date__c <= existing_od.Domestic_Visit_End_Date__c) 
            ||
         (newOutdoorDuty.international_Visit_Start_Date__c >= existing_od.international_Visit_Start_Date__c &&
         newOutdoorDuty.International_Visit_End_Date__c <= existing_od.International_Visit_End_Date__c)   
            )
        ){
            
            newOutdoorDuty.addError('Another trip on same day not allowed for the same owner.');
        }

        //No overlapping. Another trip on same day not allowed
        else if(newOutdoorDuty.Trip__c == existing_od.Trip__c && newOutdoorDuty.OwnerId == existing_od.OwnerId &&
        (
         (newOutdoorDuty.Domestic_Visit_Start_Date__c >= existing_od.Domestic_Visit_Start_Date__c &&
         newOutdoorDuty.Domestic_Visit_Start_Date__c <= existing_od.Domestic_Visit_End_Date__c &&
         newOutdoorDuty.Domestic_Visit_End_Date__c > existing_od.Domestic_Visit_End_Date__c) 
            ||
         (newOutdoorDuty.international_Visit_Start_Date__c >= existing_od.international_Visit_Start_Date__c &&
         newOutdoorDuty.international_Visit_Start_Date__c <= existing_od.International_Visit_End_Date__c &&
         newOutdoorDuty.International_Visit_End_Date__c > existing_od.International_Visit_End_Date__c)   
            )
        ) {
            newOutdoorDuty.addError('Trips are overlapped with the same Trip.');
        }

        //No overlapping. Another trip on same day not allowed
        else if(newOutdoorDuty.Trip__c != existing_od.Trip__c && newOutdoorDuty.OwnerId == existing_od.OwnerId &&
        (
         (newOutdoorDuty.Domestic_Visit_Start_Date__c >= existing_od.Domestic_Visit_Start_Date__c &&
         newOutdoorDuty.Domestic_Visit_Start_Date__c <= existing_od.Domestic_Visit_End_Date__c &&
         newOutdoorDuty.Domestic_Visit_End_Date__c > existing_od.Domestic_Visit_End_Date__c) 
            ||
         (newOutdoorDuty.international_Visit_Start_Date__c >= existing_od.international_Visit_Start_Date__c &&
         newOutdoorDuty.international_Visit_Start_Date__c <= existing_od.International_Visit_End_Date__c &&
         newOutdoorDuty.International_Visit_End_Date__c > existing_od.International_Visit_End_Date__c)   
            )
        ) {
            newOutdoorDuty.addError('Trips are overlapped with the same owner.');
        }
    }
}