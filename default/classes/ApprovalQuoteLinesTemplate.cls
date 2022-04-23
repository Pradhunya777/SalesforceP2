public class ApprovalQuoteLinesTemplate {
    public Id quoteId {get;set;}
    
    public List<SBQQ__QuoteLine__c> getQuoteLines(){
        List<SBQQ__QuoteLine__c> quoteLines = [SELECT SBQQ__ProductName__c, SBQQ__Quantity__c, Total_list_price__c, Net_Quote_Price__c,
                                               Discount_Value__c,Discount_Percent__c
                                               FROM SBQQ__QuoteLine__c
                                               WHERE SBQQ__Quote__c = :quoteId AND SBQQ__Product__r.SAP_Material_Ref__c != Null];
        return quoteLines;
    }
}