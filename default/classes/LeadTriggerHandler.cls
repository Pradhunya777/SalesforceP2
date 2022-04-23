public class LeadTriggerHandler {
    public static Boolean isFirstTime = true;
    //Perform update after record is inserted
    public static void afterInsert(List<Lead> newLeads){
        //System.debug('In Trigger');
        if(LeadTriggerHandler.isFirstTime){
            LeadTriggerHandler.isFirstTime = false;
            salesRegionUpdate(newLeads);
        }
    }
    
    //Perform update after record is updated.
    public static void afterUpdate(Map<Id, Lead> newLeadMap, Map<Id, Lead> oldLeadMap){
        compareIsCountryChanged(newLeadMap,oldLeadMap);
    }
    /**
* Function is used to check country is updated or not. 
* Country can change to blank or country
*/
    private static void compareIsCountryChanged(Map<Id, Lead> newLeadMap, Map<Id, Lead> oldLeadMap){
        
        List<Lead> newLeads = new List<Lead>();
        List<Lead> newregionleads = new List<Lead>();
        List<String> countryInMetaData = new List<String>();
        List<String> districtInMetaData = new List<String>();
        //To avoid recusion
        if(LeadTriggerHandler.isFirstTime){
            LeadTriggerHandler.isFirstTime = false;
            
            for(Lead lead : newLeadMap.values()){
                for(Country__mdt country : [SELECT Label 
                                            FROM Country__mdt
                                            WHERE Label = :lead.Country]){
                                                countryInMetaData.add(country.Label);
                                            }
                if(lead.Country == 'India'){
                    for(Domestic__mdt cityState : [SELECT State__c, District__c, Sales_Region_Setting__r.Value__c
                                                   FROM Domestic__mdt
                                                   WHERE State__c = :lead.State
                                                   AND District__c = :lead.City]){
                                                       districtInMetaData.add(cityState.State__c.toLowerCase()+cityState.District__c.toLowerCase());
                                                       //System.debug('districtInMetaData: '+districtInMetaData);
                                                       
                                                   }
                }
            }
            
            for(Lead lead : newLeadMap.values()){
                //Check Country is not blank/null and country is changed
                if(lead.Country != 'India' && (String.isNotBlank(lead.Country) && (lead.Country != oldLeadMap.get(lead.Id).Country))){
                   
                    if(countryInMetaData.contains(lead.Country)){
                        newLeads.add(lead);
                    }else{
                        newregionleads.add(lead);
                    }
                    // Check country is blank and salesregion is not blank
                }else if((String.isBlank(lead.Country) && String.isNotBlank(lead.Sales_Region__c))){
                     newregionleads.add(lead);
                }else if(String.isNotBlank(lead.Country) && lead.Country == 'India'){
                    if(String.isNotBlank(lead.State) && String.isNotBlank(lead.City) 
                       && districtInMetaData.contains(lead.State.toLowerCase()+lead.City.toLowerCase())){
                        if((String.isNotBlank(lead.City) || (lead.City != oldLeadMap.get(lead.Id).City))
                           && ((String.isNotBlank(lead.State) || (lead.State != oldLeadMap.get(lead.Id).State)) ) ){
                               newLeads.add(lead);
                           }else if((String.isBlank(lead.City) && String.isNotBlank(lead.Sales_Region__c)) ){
                                        newregionleads.add(lead);
                                    }else if(String.isNotBlank(lead.City) && (String.isBlank(oldLeadMap.get(lead.Id).City))
                                             || String.isNotBlank(lead.State) && (String.isBlank(oldLeadMap.get(lead.Id).State)) ){
                                                 newLeads.add(lead);
                                             }else if((String.isNotBlank(lead.State) && lead.City.equalsIgnoreCase(oldLeadMap.get(lead.Id).City) 
                                                       && !(lead.State.equalsIgnoreCase(oldLeadMap.get(lead.Id).State)))
                                                      || (String.isNotBlank(lead.City) && lead.State.equalsIgnoreCase(oldLeadMap.get(lead.Id).State) 
                                                          && !(lead.City.equalsIgnoreCase(oldLeadMap.get(lead.Id).City)))                                            ){
                                                              newLeads.add(lead);
                                                          }
                        
                    }else{
                        //City and State is not present in Custom metadata make sales region blank
                        newregionleads.add(lead);
                    }
                    
                }
            } 
            salesRegionUpdate(newLeads); 
            makeSalesRegionBlank(newregionleads);
        }
        
    }
    
    /**
* Make sales region field blank if country is changed to blank 
*/
    private static void makeSalesRegionBlank(List<Lead> Leads){
        //System.debug('In makeSalesRegionBlank');
        List<Lead> leadList = new List<Lead>();
        if(!Leads.isEmpty()){
            for(Lead lead : [SELECT Id, Sales_Region__c
                             FROM Lead
                             WHERE Id IN :Leads]){
                                 lead.Sales_Region__c = null;
                                 leadList.add(lead);
                             }
            try{
                UPDATE leadList;
            }catch(DmlException e){
                //System.debug('dml exception:'+e);
            }
        }
    }
    
/**
* Update sale region as per selected country
*/
    private static void salesRegionUpdate(List<Lead> Leads){
        
        List<Lead> leadList = [SELECT Id, State, City, Country, Sales_Region__c
                               FROM Lead 
                               WHERE Id IN :Leads];
        
        Map<String, Set<Id>> exportMap = new Map<String, Set<Id>>();
        Map<String, Set<Id>> domesticMap = new Map<String, Set<Id>>();
        
        for(Lead lead : leadList){    
            if(String.isNotBlank(lead.Country)){
                if(lead.Country != 'India'){
                    if(!exportMap.containskey(lead.Country)){
                        //Put country as a key and for each lead create new set
                        exportMap.put(lead.Country, new Set<Id>());
                    }
                    // Put country as a key and leads as value
                    exportMap.get(lead.Country).add(lead.Id);
                }
                
                if(String.isNotBlank(lead.State) && String.isNotBlank(lead.City) && lead.Country.containsIgnoreCase('India')){
                    if(!domesticMap.containskey(lead.State.toLowerCase()+lead.City.toLowerCase())){
                        domesticMap.put(lead.State.toLowerCase()+lead.City.toLowerCase(),new Set<Id>());
                    }
                    domesticMap.get(lead.State.toLowerCase()+lead.City.toLowerCase()).add(lead.Id);
                }
                
            }
        }
        
        List<Lead> updatedLeads = new List<Lead>();
        // Take Sales Region from Country Meata data
                
        if(!domesticMap.isEmpty()){
            for(Domestic__mdt domestic : [SELECT State__c, District__c, Sales_Region_Setting__r.Value__c
                                         FROM Domestic__mdt]){//WHERE Sales_Region_Setting__c != null
                                             if(domesticMap.containsKey(domestic.State__c.toLowerCase()+domestic.District__c.toLowerCase())){
                                                 for(Id leadId : domesticMap.remove(domestic.State__c.toLowerCase()+domestic.District__c.toLowerCase())){
                                                     updatedLeads.add(new Lead(Id = leadId,
                                                                              Sales_Region__c = domestic.Sales_Region_Setting__r.Value__c));
                                                 }
                                             }
			}
                  
        }
        if(!exportMap.isEmpty()){
            for(Country__mdt country:[SELECT Label, Sales_Region_Setting__r.Value__c 
                                      FROM Country__mdt 
                                      WHERE Label IN :exportMap.keySet()]){//AND Sales_Region_Setting__r.Value__c != null
                                          if(exportMap.containskey(country.Label)){
                                              // Remove country from map, update salesregion and add to list.
                                              for(Id leadId : ExportMap.remove(country.Label)){
                                                   updatedLeads.add(new Lead(Id = leadId,
                                                                                Sales_Region__c = country.Sales_Region_Setting__r.Value__c));
                                              }  
                                          }
                                      }
        }
        try{
            if(!updatedLeads.isEmpty()){
                UPDATE updatedLeads;
            }        
        }catch(DmlException e){
            // System.debug('DmlException: '+e);
        }
        
    }
    
  
}