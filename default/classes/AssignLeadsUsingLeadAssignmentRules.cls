public with sharing class AssignLeadsUsingLeadAssignmentRules {
	@InvocableMethod 
    public static void leadAssign(List<Id> leadIds){
        assignOwnerToLead(leadIds);
    }
    
    @future
    public static void assignOwnerToLead(List<Id> leadIds){
		AssignmentRule AR = new AssignmentRule(); 
        AR = [select id from AssignmentRule where SobjectType = 'Lead' and Active = true limit 1];
        //Creating the DMLOptions for "Assign using active assignment rules" checkbox
        Database.DMLOptions dmlOpts = new Database.DMLOptions();
        dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
        List<Lead> leads = new List<Lead>();
        for(Id leadId : leadIds){
            Lead lead = new Lead(Id = leadId);
            lead.setOptions(dmlOpts);
            leads.add(lead);
        }
        try{
            UPDATE leads;
        }catch(DmlException e){
            System.debug('Exception: '+e);
        }
        
        
        SendEmailResponseHandler.sendMail(leadIds);
    }
    
}