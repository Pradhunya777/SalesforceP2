/*
* Name 			: ProductPriceMasterDTO
* Description	: This DTO is used for adding or updating pricing of FG and its variants.Prices coming from SAP to SF.
* Reference		: It is used in ProductPriceMasterDTOService,ProductPriceMasterDTOServiceHandler
* CreateDate	: 18-Nov-2021
-------------------------------------------------------
#ModificationDate	: Details
15-Dec-2021			: To update the error message response.
*/
public class ProductPriceMasterDTO{    
    public List<ProductPrice> productPriceList{get;set;}    
    public class ProductPrice{
        public string conditionNo {get;set;} 
        public string pricingConditionType {get;set;}      
        public string salesOrg {get;set;}  
        public string sapMaterialCode {get;set;}  // FG Code 
        public string priceListCode {get;set;} 
        public String priceListDescription {get;set;} 
        public List<PriceListItem> priceListItems {get;set;} 
    }       
    public class PriceListItem{
        public string conditionNo {get;set;}  
        public string characteristicValue{get;set;} 
        public string priceListCode{get;set;} 
        public String conditionAmount {get;set;}     
        public String conditionCurrency {get;set;} 
        public String validFrom {get;set;} 
        public String validTo {get;set;} 
        public String priceListDescription {get;set;} 
    }
}