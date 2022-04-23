/*
    * Name : QuotePDFLineItemController
    * Description: To show Table of content and Pricing schedule table in Quote PDF
    * TestMethod:
    * CreateDate: 18-Nov-2021
    */
public class QuotePDFLineItemController {
    public List<ProductWrapper> productTableOfContentList{get;set;} 
    public List<ProductWrapper> productPriceSchdeuleContentList{get;set;}
    public List<ProductWrapper> technicalOfferQuoteLines{get;set;}
    public String quoteId;  
    public String incoterns {get;set;}
    public String incotermsDescription {get;set;}
    public Static Decimal subTotal {get;set;}
    public Static Decimal netAmount {get;set;}
    public Static Decimal frieght {get;set;}
    public Static Decimal insurance {get;set;}
    public Static Decimal taxableValue {get;set;}
    public Static Decimal gst {get;set;}
    public Static Decimal tcs {get;set;}
    public Static String domainName {get;set;}
    public Static String tableBody{get;set;}
    public Static String termsConditionAdditionallyNegotiate{get;set;}
    public QuotePDFLineItemController() {  
        quoteId = ApexPages.currentPage().getParameters().get('qid');
        productTableOfContentList = new List<ProductWrapper>();
        productPriceSchdeuleContentList = new List<ProductWrapper>();
        technicalOfferQuoteLines = new List<ProductWrapper>();
        netAmount = 0;
        domainName = String.valueOf(URL.getSalesforceBaseUrl().toExternalForm());
        tableBody = '';
    }
    public void init(){
        try{
            SBQQ__Quote__c quote = [Select Id,Name,SBQQ__Account__r.Incoterms__c,SBQQ__Account__r.Incoterms_Description__c,SBQQ__NetAmount__c,Company_Name__c,SBQQ__BillingCity__c, 
                                    SBQQ__BillingCountry__c,SBQQ__BillingPostalCode__c, SBQQ__BillingState__c,SBQQ__BillingStreet__c,
                                    Freight__c,InsuranceSum__c,Insurance__c,GST_Value__c,Terms_Condition_Additionally_Negotiate__c,
                                    TelePhone__c,Mobile__c,Email__c,Fax__c,Website__c,PAN_Number__c,Exim_Code__c,VAT_Number__c 
                                    From SBQQ__Quote__c 
                                    WHERE Id =:quoteId];
            incoterns = String.isNotBlank(quote.SBQQ__Account__r.Incoterms__c)? quote.SBQQ__Account__r.Incoterms__c : '';
            termsConditionAdditionallyNegotiate = String.isNotBlank(quote.Terms_Condition_Additionally_Negotiate__c)?
                                                  quote.Terms_Condition_Additionally_Negotiate__c.replace('&','and').replaceAll('<[^>]+>',' '):
                                                  '';
            incotermsDescription = String.isNotBlank(quote.SBQQ__Account__r.Incoterms_Description__c)? quote.SBQQ__Account__r.Incoterms_Description__c : '';
            List<SBQQ__QuoteLine__c> quoteLines = [SELECT Id,SBQQ__Product__c,SBQQ__ProductName__c,Product_Group_Number__c,SBQQ__ProductFamily__c,
                                                   Product_Image__c,SBQQ__ListPrice__c,SBQQ__Quantity__c,SBQQ__ListTotal__c,
                                                   SBQQ__NetTotal__c,Price_Relevant__c,Default__c,SBQQ__ProductOption__c,
                                                   SBQQ__ProductOption__r.SBQQ__ConfiguredSKU__c,GST_Value__c, Material_Sales_Text__c,
                                                   Additional_Item_Remark__c, Non_Standard_Technical_Specification__c,Is_Allow_AIR__c
                                                   FROM SBQQ__QuoteLine__c 
                                                   WHERE SBQQ__Quote__c = :quoteId 
                                                   Order by Product_Group_Number__c asc];
            
            getCompanyInformation(quote);
            getProductTableOfContent(productTableOfContentList,quoteLines);
            getProductPriceSchdeuleContentList(productPriceSchdeuleContentList,quoteLines);  
            getTechnicalOffer(technicalOfferQuoteLines,quoteLines);
        }
        catch(Exception e){
            System.debug('Exception:'+ e.getMessage());
        }
    }
    public static void getCompanyInformation(SBQQ__Quote__c quote){
        
        tableBody = '<table border-collapse="collapse" display-align="left" table-layout="fixed" width="100%">'+ //margin-top="5pt"
            '<table-column column-width="25%"/><table-column column-width="2%"/><table-column column-width="50%"/>'+
            '<table-body>';
        
        if(quote.Company_Name__c != null){
            tableBody += '<table-row display-align="left"><table-cell display-align="left">'+//" padding="3"
                '<block font-weight="bold" font-size="medium"><inline text-align="left">Company/Customer Name</inline>'+
                '</block></table-cell>'+
                '<table-cell><block font-size="medium"><inline>: </inline></block></table-cell>';
            tableBody += '<table-cell display-align="left">'+// padding="5"
                '<block font-size="medium"><inline>'+quote.Company_Name__c+'</inline>'+
                '</block></table-cell></table-row>';
        }
        tableBody += '<table-row display-align="left"><table-cell display-align="left">'+
            '<block font-weight="bold" font-size="medium"><inline text-align="left">Address</inline>'+
            '</block></table-cell>'+
            '<table-cell><block font-size="medium"><inline>: </inline></block></table-cell>';
        tableBody += '<table-cell display-align="left">'+
            '<block font-size="medium"><inline>';
        if(quote.SBQQ__BillingStreet__c != null){
            tableBody += quote.SBQQ__BillingStreet__c+', ';
        }
        if(quote.SBQQ__BillingCity__c != null){
            tableBody += quote.SBQQ__BillingCity__c+', ';
        }
        if(quote.SBQQ__BillingPostalCode__c != null){
            tableBody += quote.SBQQ__BillingPostalCode__c+', ';
        }
        if(quote.SBQQ__BillingState__c != null){
            tableBody += quote.SBQQ__BillingState__c+', ';
        }
        if(quote.SBQQ__BillingCountry__c != null){
            tableBody += quote.SBQQ__BillingCountry__c;
        }
        tableBody += '</inline></block></table-cell></table-row>';
        if(quote.TelePhone__c != null){
            tableBody += '<table-row display-align="left"><table-cell display-align="left">'+
                '<block font-weight="bold" font-size="medium"><inline text-align="left">Tel</inline>'+
                '</block></table-cell>'+
                '<table-cell><block font-size="medium"><inline>: </inline></block></table-cell>';
            tableBody += '<table-cell display-align="left">'+
                '<block font-size="medium"><inline>'+quote.TelePhone__c+'</inline>'+
                '</block></table-cell></table-row>';
        }
        if(quote.Mobile__c != null){
            tableBody += '<table-row display-align="left"><table-cell display-align="left">'+
                '<block font-weight="bold" font-size="medium"><inline text-align="left">Mobile</inline>'+
                '</block></table-cell>'+
                '<table-cell><block font-size="medium"><inline>: </inline></block></table-cell>';
            tableBody += '<table-cell display-align="left">'+
                '<block font-size="medium"><inline>'+quote.Mobile__c+'</inline>'+
                '</block></table-cell></table-row>';
        }
        if(quote.Email__c != null){
            tableBody += '<table-row display-align="left"><table-cell display-align="left">'+
                '<block font-weight="bold" font-size="medium"><inline text-align="left">Email</inline>'+
                '</block></table-cell>'+
                '<table-cell><block font-size="medium"><inline>: </inline></block></table-cell>';
            tableBody += '<table-cell display-align="left">'+
                '<block font-size="medium"><inline>'+quote.Email__c+'</inline>'+
                '</block></table-cell></table-row>';
        }
        if(quote.Fax__c != null){
            tableBody += '<table-row display-align="left"><table-cell display-align="left">'+
                '<block font-weight="bold" font-size="medium"><inline text-align="left">Fax</inline>'+
                '</block></table-cell>'+
                '<table-cell><block font-size="medium"><inline>: </inline></block></table-cell>';
            tableBody += '<table-cell display-align="left">'+
                '<block font-size="medium"><inline>'+quote.Fax__c+'</inline>'+
                '</block></table-cell></table-row>';
        }
        if(quote.Website__c != null){
            tableBody += '<table-row display-align="left"><table-cell display-align="left">'+
                '<block font-weight="bold" font-size="medium"><inline text-align="left">Website</inline>'+
                '</block></table-cell>'+
                '<table-cell><block font-size="medium"><inline>: </inline></block></table-cell>';
            tableBody += '<table-cell display-align="left">'+
                '<block font-size="medium"><inline>'+quote.Website__c+'</inline>'+
                '</block></table-cell></table-row>';
        }
        if(quote.PAN_Number__c != null){
            tableBody += '<table-row display-align="left"><table-cell display-align="left">'+
                '<block font-weight="bold" font-size="medium"><inline text-align="left">PAN</inline>'+
                '</block></table-cell>'+
                '<table-cell><block font-size="medium"><inline>: </inline></block></table-cell>';
            tableBody += '<table-cell display-align="left">'+
                '<block font-size="medium"><inline>'+quote.PAN_Number__c+'</inline>'+
                '</block></table-cell></table-row>';
        }
        if(quote.Exim_Code__c != null){
            tableBody += '<table-row display-align="left"><table-cell display-align="left">'+
                '<block font-weight="bold" font-size="medium"><inline text-align="left">Exim Code</inline>'+
                '</block></table-cell>'+
                '<table-cell><block font-size="medium"><inline>: </inline></block></table-cell>';
            tableBody += '<table-cell display-align="left">'+
                '<block font-size="medium"><inline>'+quote.Exim_Code__c+'</inline>'+
                '</block></table-cell></table-row>';
        }
        if(quote.VAT_Number__c != null){
            tableBody += '<table-row display-align="left"><table-cell display-align="left">'+
                '<block font-weight="bold" font-size="medium"><inline text-align="left">VAT No.</inline>'+
                '</block></table-cell>'+
                '<table-cell><block font-size="medium"><inline>: </inline></block></table-cell>';
            tableBody += '<table-cell display-align="left">'+
                '<block font-size="medium"><inline>'+quote.VAT_Number__c+'</inline>'+
                '</block></table-cell></table-row>';
        }
        tableBody += '</table-body></table>';
    }
    public static void getProductTableOfContent(List<ProductWrapper> productTableOfContentList,List<SBQQ__QuoteLine__c> quoteLines){
        integer index = 1;        
        for(SBQQ__QuoteLine__c quoteLine : quoteLines){
            if(String.isNotBlank(quoteLine.SBQQ__ProductFamily__c)){
                string productName = quoteLine.SBQQ__ProductName__c.replace('&', '&amp;');
                productName = productName.replaceAll('<[^>]+>',' ');               
                ProductWrapper productWrapper = new ProductWrapper();
                productWrapper.index = index;
                productWrapper.offerType = 'Technical Offer';
                productWrapper.productName = productName;
                productTableOfContentList.add(productWrapper);
                index++;
            }
        }            
        if(!productTableOfContentList.isEmpty()){
            index = productTableOfContentList.size()+1;
        }        
        productTableOfContentList.add(new ProductWrapper(index,'Commercial Offer','For below equipments','','',0,0,0,0,0,'','',''));
        productTableOfContentList.add(new ProductWrapper(++index,'General','Terms &amp; Conditions','','',0,0,0,0,0,'','',''));
        
    }    
    public static void getProductPriceSchdeuleContentList(List<ProductWrapper> productPriceSchdeuleContentList,List<SBQQ__QuoteLine__c> quoteLines){
        integer index = 1;
        Map<Id,SBQQ__QuoteLine__c>  productMap= new Map<Id,SBQQ__QuoteLine__c>();
        Map<Id,List<SBQQ__QuoteLine__c>>  productOptionMap= new Map<Id,List<SBQQ__QuoteLine__c>>();
        for(SBQQ__QuoteLine__c quoteLine : quoteLines){           
            if(!String.isBlank(quoteLine.SBQQ__ProductOption__c)){
                if(productOptionMap.containsKey(quoteLine.SBQQ__ProductOption__r.SBQQ__ConfiguredSKU__c)){                    
                    productOptionMap.get(quoteLine.SBQQ__ProductOption__r.SBQQ__ConfiguredSKU__c).add(quoteLine);
                }else{
                    productOptionMap.put(quoteLine.SBQQ__ProductOption__r.SBQQ__ConfiguredSKU__c,new List<SBQQ__QuoteLine__c>{quoteLine});
                }
            }
        }        
        for(SBQQ__QuoteLine__c quoteLine : quoteLines){
            if(String.isNotBlank(quoteLine.SBQQ__ProductFamily__c)){
                string productName = quoteLine.SBQQ__ProductName__c.replace('&', '&amp;');
                productName = productName.replaceAll('<[^>]+>',' ');               
                ProductWrapper productWrapper = new ProductWrapper();
                productWrapper.index = index;
                productWrapper.offerType = 'Technical Offer';
                productWrapper.productName = productName;
                productWrapper.productFamily = quoteLine.SBQQ__ProductFamily__c;                             
                productWrapper.productImage = String.isNotBlank(quoteLine.Product_Image__c)?domainName + quoteLine.Product_Image__c : '';
                productWrapper.productGroupNumber = Integer.valueOf(quoteLine.Product_Group_Number__c);
                productWrapper.quantity = quoteLine.SBQQ__Quantity__c; 
                Decimal itemTotal = 0;
                Decimal listPriceTotal = quoteLine.SBQQ__ListPrice__c;
                Decimal priceTotal = quoteLine.SBQQ__ListTotal__c;                 
                if(!productOptionMap.isEmpty() && productOptionMap.containsKey(quoteLine.SBQQ__Product__c)){
                    List<SBQQ__QuoteLine__c> lineItems = productOptionMap.get(quoteLine.SBQQ__Product__c);
                    for(SBQQ__QuoteLine__c item :lineItems){
                        if(item.Price_Relevant__c){                            
                            listPriceTotal = listPriceTotal + item.SBQQ__ListPrice__c;
                            itemTotal = item.SBQQ__ListTotal__c;
                            priceTotal = priceTotal + itemTotal;
                        }
                    }
                }
                productWrapper.productListPrice = listPriceTotal;
                productWrapper.productListTotal = priceTotal;
                productWrapper.productNetTotal = quoteLine.SBQQ__NetTotal__c;
                productPriceSchdeuleContentList.add(productWrapper);                
                netAmount = netAmount + priceTotal;
                index++;
            }
        }        
        System.debug('#productWrapper:'+ JSON.serialize(productPriceSchdeuleContentList));
    }
    
    public static void getTechnicalOffer(List<ProductWrapper> technicalOfferQuoteLines,List<SBQQ__QuoteLine__c> quoteLines){
        
        for(SBQQ__QuoteLine__c quoteLine : quoteLines){
            if(String.isNotBlank(quoteLine.SBQQ__ProductFamily__c)){   
                
            string productName = quoteLine.SBQQ__ProductName__c.replace('&', '&amp;');
            productName = productName.replaceAll('<[^>]+>',' ');
            
            String nonStandardTechnicalSpecification = String.isNotBlank(quoteLine.Non_Standard_Technical_Specification__c)?quoteLine.Non_Standard_Technical_Specification__c.replace('&', '&amp;'):'';
            nonStandardTechnicalSpecification = nonStandardTechnicalSpecification.replaceAll('<[^>]+>',' ');
            
            String materialSalesText = String.isNotBlank(quoteLine.Material_Sales_Text__c)?quoteLine.Material_Sales_Text__c.replace('&', '&amp;'):'';
            materialSalesText = materialSalesText.replaceAll('<[^>]+>',' ');
            
            String additionalItemRemark = quoteLine.Is_Allow_AIR__c && String.isNotBlank(quoteLine.Additional_Item_Remark__c)?
                                                  quoteLine.Additional_Item_Remark__c.replace('&','and'): 
                                                  '';
            ProductWrapper productWrapper = new ProductWrapper();
            productWrapper.productName = productName;
            productWrapper.productImage = String.isNotBlank(quoteLine.Product_Image__c)?domainName + quoteLine.Product_Image__c : '';
            productWrapper.materialSalesText = materialSalesText;
            productWrapper.additionalItemRemark = additionalItemRemark;
            productWrapper.nonStandardTechnicalSpecification = nonStandardTechnicalSpecification;
             
            technicalOfferQuoteLines.add(productWrapper);
                /*if(!productOptionMap.isEmpty() && productOptionMap.containsKey(quoteLine.SBQQ__Product__c)){
                    for(SBQQ__QuoteLine__c lineItem : productOptionMap.remove(quoteLine.SBQQ__Product__c)){
                        String lineProductName = lineItem.SBQQ__ProductName__c.replace('&', '&amp;');
                        lineProductName = lineProductName.replaceAll('<[^>]+>',' ');
                        
                        String lineshortDescription = String.isNotBlank(lineItem.ShortDescription__c)?lineItem.ShortDescription__c.replace('&', '&amp;'):'';
                        lineshortDescription = lineshortDescription.replaceAll('<[^>]+>',' ');
                        
						ProductWrapper wrapper1 = new ProductWrapper();
                        wrapper1.productName = lineProductName;
                        wrapper1.productImage = String.isNotBlank(lineItem.Product_Image__c)?domainName + lineItem.Product_Image__c:'';
                        wrapper1.shortDescription = lineshortDescription;
                        wrapper1.additionalItemRemark = String.isNotBlank(lineItem.Additional_Item_Remark__c)?lineItem.Additional_Item_Remark__c:'';
                        wrapper1.nonStandardTechnicalSpecification = String.isNotBlank(lineItem.Non_Standard_Technical_Specification__c)?lineItem.Non_Standard_Technical_Specification__c:'';
                       
                        technicalOfferQuoteLines.add(wrapper1);
                    }
                }*/
            }
        }
    }
    public class ProductWrapper{
        public integer index {get;set;}
        public String offerType {get;set;}
        public String productName {get;set;}       
        public String productFamily {get;set;}
        public String productImage {get;set;}
        public Integer productGroupNumber {get;set;}
        public String materialSalesText {get;set;}
        public String additionalItemRemark {get;set;}
        public String nonStandardTechnicalSpecification {get;set;}
        public Decimal quantity {get;set;}
        public Decimal productListPrice {get;set;}        
        public Decimal productListTotal {get;set;}
        public Decimal productNetTotal {get;set;} 
        
        
        public ProductWrapper(){}
        public ProductWrapper(integer index,String offerType,String productName,String productFamily,String productImage,Integer productGroupNumber,
                              Decimal quantity,Decimal productListPrice,Decimal productListTotal,Decimal productNetTotal,String materialSalesText,
                             String additionalItemRemark,String nonStandardTechnicalSpecification)
        {
            this.index = index;
            this.offerType = offerType;
            this.productName = productName;
            this.productFamily = productFamily;
            this.productImage = productImage;
            this.productGroupNumber = productGroupNumber;
            this.quantity = quantity;
            this.productListPrice = productListPrice;
            this.productListTotal = productListTotal;
            this.productNetTotal = productNetTotal;
            this.materialSalesText = materialSalesText;
            this.additionalItemRemark = additionalItemRemark;
            this.nonStandardTechnicalSpecification = nonStandardTechnicalSpecification;
        }
    }
}