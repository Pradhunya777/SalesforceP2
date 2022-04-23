public class SA {
    public static void Calc(){
        Opportunity oppo = new Opportunity();
        oppo.Completed_Commission_Amounts__c = oppo.Amount * oppo.Default_Commission_Rate__c;
    }

}