/*
* Controller	: EnquiryDTOServiceHandler
* Purpose		: Process on Quote/Enquiry Data
* Created Date	: 24-Dec-2021
-------------------------------------------------------
#ModificationDate	: Details
24-Dec-2021			: To update the error message response.
*/
public class EnquiryDTOServiceHandler {
    static String token = '';
    static Integer expirseIn = 0;
    static String enquiryData = '';
    public static void pushEnquiryToSAP(String quoteId){
        System.debug('#QuoteId:'+ quoteId);
        getAccessToken();
        sendRequest();
        
    }
    public static void getAccessToken(){  
        System.debug('Access token method called.'); 
        String endpoint = 'https://oauthasservices-ldb39be14.ae1.hana.ondemand.com/oauth2/api/v1/token?grant_type=client_credentials';
        String username = '3cb683bc-1d57-3bca-b044-aa03e316e4cc';
        String password = 'SFDC@1234';        
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'Basic ' +EncodingUtil.base64Encode(headerValue);
        System.debug('#authorizationHeader:'+authorizationHeader); 
        
        HttpRequest req = new HttpRequest();        
        req.setEndpoint(endpoint);
        req.setHeader('Authorization', authorizationHeader);
        req.setMethod('POST');
        req.setHeader('Content-Type','application/text'); 
        
        Http http = new Http();
        HTTPResponse response = http.send(req);
        System.debug('#Response:'+ response.getBody());
        if(response.getStatusCode() == 200){
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            token = (String)results.get('access_token');
            expirseIn = (Integer)results.get('expires_in');
            System.debug('#Access_Token:'+  token);
            System.debug('#expirseIn:'+  expirseIn);
        }else{
            System.debug('#ErrorCode:'+ response.getStatusCode());
        }
    }
    public static void sendRequest(){
         System.debug('Sending Request to push data to SAP'); 
        String endpoint = 'https://l550064-iflmap.hcisbp.ae1.hana.ondemand.com/http/SAP_ENQUIRY';       
        String authorizationHeader = 'Bearer ' +token;
        System.debug('#authorizationHeader:'+authorizationHeader);         
        HttpRequest req = new HttpRequest();        
        req.setEndpoint(endpoint);
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Content-Type','application/text'); 
        req.setMethod('POST');
       
        Http http = new Http();
        HTTPResponse response = http.send(req);       
        if(response.getStatusCode() == 200){
            System.debug('#Response:'+ response.getBody());
        }else{
            System.debug('#ErrorCode:'+ response.getStatusCode());
        }
    }
    public static void createRequestData(String quoteId){
      
        List<SBQQ__Quote__c> quoteList = [Select Id,Name,CreatedDate,SBQQ__StartDate__c,SBQQ__EndDate__c,
                                          (Select Id,Name,SBQQ__Product__c,SBQQ__ProductName__c,SBQQ__Group__c,SBQQ__Quantity__c,
                                           SAP_Material_Ref__c,Round_Off_Value__c,Short_Description__c,Additional_item_value__c,
                                           Quote_Disc__c,Plant__c,Insurance__c,Freight__c,Internal_Char_Number__c,Product_Feature__c,
                                           Product_Description__c,SBQQ__ProductCode__c,SBQQ__ProductOption__c,SBQQ__ProductOption__r.SBQQ__ConfiguredSKU__c
                                           From SBQQ__LineItems__r)
                                          From SBQQ__Quote__c
                                          Where Id =: quoteId];
                                          //Where Id = 'a176D000000kxifQAA'];
        System.debug('#quoteList:'+JSON.serialize(quoteList));
        
        EnquiryDTO enquiry = new EnquiryDTO();
        enquiry.SfdcEnquiry = quoteList[0].Name;
        enquiry.SapEnquiry = '';
        enquiry.ExchangeRate = '';
        enquiry.Port = '';
        enquiry.PiNumber = '';
        enquiry.EnqReceiptDate = '';
        enquiry.ReasonRejection = '';
        enquiry.DistributionChannel = '';
        enquiry.SoldToParty = '';
        enquiry.PriceingDate = '';       
        enquiry.CustReference = '';
        enquiry.SalesOrg = '';
        enquiry.currencyIsoCode = '';
        enquiry.BillTo = '';
        enquiry.OrderReason = '';
        enquiry.Division = '';       
        enquiry.Inquirytype = '';
        enquiry.PriceList = '';
        enquiry.EnquiryDate = '';
        enquiry.Payer = '';
        enquiry.ProvisionalPrices = '';
        enquiry.EnqResponseDate = '';
        enquiry.PaymentTerm = '';
        enquiry.ShipToParty = '';
        enquiry.ExpectedOrderDate = '';
        enquiry.IncotermLocation1 = '';
        enquiry.Incoterm = '';
        enquiry.SalesType = '';        
        List<EnquiryDTO.MessageRespSet> messageRepSetList = new List<EnquiryDTO.MessageRespSet>();
        enquiry.MessageRespSet = messageRepSetList;
        
        List<EnquiryDTO.VariantCharSet> variantCharSets = new List<EnquiryDTO.VariantCharSet>();
        Map<String,List<SBQQ__QuoteLine__c>> leadVariantMap = new Map<String,List<SBQQ__QuoteLine__c>>();        
        Map<String,SBQQ__QuoteLine__c> leadProductMap = new Map<String,SBQQ__QuoteLine__c>();
        
        for(SBQQ__Quote__c quote : quoteList){
            for(SBQQ__QuoteLine__c lineItem : quote.SBQQ__LineItems__r){     
                if(lineItem.SBQQ__ProductOption__c!=null){
                    if(!leadVariantMap.isEmpty() && leadVariantMap.containsKey(lineItem.SBQQ__ProductOption__r.SBQQ__ConfiguredSKU__c)){
                        leadVariantMap.get(lineItem.SBQQ__ProductOption__r.SBQQ__ConfiguredSKU__c).add(lineItem);
                    }else{
                        leadVariantMap.put(lineItem.SBQQ__ProductOption__r.SBQQ__ConfiguredSKU__c,new List<SBQQ__QuoteLine__c>{lineItem});
                    }                    
                }else{
                    if(String.isNotBlank(lineItem.SAP_Material_Ref__c)){
                        leadProductMap.put(lineItem.SBQQ__Product__c,lineItem);                        
                    }
                }
            }
        }        
        
        System.debug('#leadVariantMap:'+ JSON.serialize(leadVariantMap));
        List<EnquiryDTO.EnquiryItemSet> enquiryItemList = new List<EnquiryDTO.EnquiryItemSet>();
        Integer lineItemIndex = 0, variantIndex = 0;
        for(SBQQ__Quote__c quote : quoteList){     
             lineItemIndex = 000001;
            for(SBQQ__QuoteLine__c lineItem : quote.SBQQ__LineItems__r){
                if(!leadProductMap.isEmpty() && leadProductMap.containsKey(lineItem.SBQQ__Product__c)){
                    SBQQ__QuoteLine__c parentLineItem = leadProductMap.get(lineItem.SBQQ__Product__c);
                    EnquiryDTO.EnquiryItemSet enquiryItem = new  EnquiryDTO.EnquiryItemSet();
                    enquiryItem.SfdcEnquiry = quote.Id;
                    enquiryItem.EnquiryItem = String.valueOf(lineItemIndex);
                    enquiryItem.SapItem = '';
                    enquiryItem.FgsapCode = parentLineItem.SAP_Material_Ref__c;
                    enquiryItem.MaterialSalesText = parentLineItem.SBQQ__ProductName__c;
                    enquiryItem.Quantity = String.valueOf(parentLineItem.SBQQ__Quantity__c);
                    enquiryItem.Plant = String.isNotBlank(parentLineItem.Plant__c) ? parentLineItem.Plant__c : '';
                    enquiryItem.Insurance = parentLineItem.Insurance__c == 0 ? '0' : String.valueOf(parentLineItem.Insurance__c);
                    enquiryItem.Freight = parentLineItem.Freight__c == 0 ? '0' : String.valueOf(parentLineItem.Freight__c);
                    enquiryItem.RoundOffValue = String.valueOf(parentLineItem.Round_Off_Value__c);
                    enquiryItem.AdditionalField = parentLineItem.Additional_item_value__c == 0 ? '0':String.valueOf(parentLineItem.Additional_item_value__c);                    
                    if(!leadVariantMap.isEmpty() && leadVariantMap.containsKey(lineItem.SBQQ__Product__c)){
                        List<EnquiryDTO.VariantCharSet>  variantCharList = new List<EnquiryDTO.VariantCharSet>();
                        variantIndex = 000001;
                        for(SBQQ__QuoteLine__c variant : leadVariantMap.get(lineItem.SBQQ__Product__c)){
                            EnquiryDTO.VariantCharSet variantItem = new EnquiryDTO.VariantCharSet();
                            variantItem.SfdcEnquiry = quote.Id;
                            variantItem.EnquiryItem = String.valueOf(lineItemIndex);
                            variantItem.VariantItem = String.valueOf(variantIndex);
                            variantItem.InternalCharacterstics = '';
                            variantItem.CharactersticsDesc = variant.Product_Feature__c;
                            variantItem.CharatesticsValue = variant.SBQQ__ProductName__c;
                            variantCharList.add(variantItem); 
                            variantIndex++;
                        }
                        enquiryItem.VariantCharSet = variantCharList;                       
                    }
                    enquiryItemList.add(enquiryItem);
                    lineItemIndex++;
                }                
            }
        }
        
        enquiry.EnquiryItmSet = enquiryItemList;
        enquiryData = JSON.serialize(enquiry);
        System.debug('#EnquiryDTO:'+ JSON.serialize(enquiryData));
        
        
    }
}