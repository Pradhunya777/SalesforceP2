public class LeadConversion {
    public static void main(){
        
        lead l =[select name from lead where name like 'Ram%' limit 1];
        
        Database.LeadConvert lc = new Database.LeadConvert();
        
        lc.setLeadId(l.Id);
        
        System.debug('Id of record inserted is '+l.Id);
        
        lc.convertedstatus = 'Closed - Converted'; 
        
        lc.ownerid = '0055g00000AoBWyAAN';
        
        Database.LeadConvertResult lc1 = Database.convertLead(lc);
        
    }

}