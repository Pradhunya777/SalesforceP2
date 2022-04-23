/*
* Controller	: ProductPriceMasterDTOService
* Purpose		: This is a Web service controller. It is used for adding or updating pricing of FG and its variants.
Prices coming from SAP to SF
* Created Date	: 18-Nov-2021
-------------------------------------------------------
#ModificationDate	: Details
15-Dec-2021			: To update the error message response.
*/
@RestResource(urlMapping='/ProductPriceMasterDTOService/*')
global class ProductPriceMasterDTOService {
    static string sapMaterialCode ='';
    @HttpPost
    global static Response doPost(){
        List<String> errorMessage = new List<String>(); 
        String msg ='';
        Response  response; 
        RestRequest req = RestContext.request; //rest context objects for request and response
        String productPricingDTOJson = req.requestBody.toString();        
        System.debug('#productPricingDTOJson:'+productPricingDTOJson); 
        
        if(String.isBlank(productPricingDTOJson)){            
            return new Response('','false','Invalid Product Pricing data.',errorMessage);            
        }
        
        ProductPriceMasterDTO productPriceMasterDTO;
        try{
            productPriceMasterDTO = (ProductPriceMasterDTO) System.JSON.deserialize(productPricingDTOJson,ProductPriceMasterDTO.class);            
            System.debug('#ProductPriceMasterDTO:'+productPriceMasterDTO);
            if(productPriceMasterDTO.productPriceList == null || productPriceMasterDTO.productPriceList.isEmpty()){                
                return new Response('','false','Invalid Product Pricing data.',errorMessage);
            }
        }catch(Exception ex){
                               
            return new Response('','false','Invalid Product Pricing data:'+ex.getMessage() ,errorMessage);
        }
        
        errorMessage = validatePriceData(productPriceMasterDTO);
        System.debug('#errorMessage:'+ errorMessage);
        
        try{
            if(errorMessage.isEmpty() || errorMessage.size()==0){               
                ProductPriceMasterDTOServiceHandler.updateProductPricing(productPriceMasterDTO);
            }             
        }catch(Exception ex){
            ExceptionUtility.addExceptionLog(new ExceptionUtility.LogUitlity(null,'ProductPriceMasterDTOService','doPost',
                                                                             ex.getStackTraceString(),ex.getMessage(),ex.getTypeName(),ex.getLineNumber()));
            ExceptionUtility.commiLog();
            msg = ex.getMessage();
            errorMessage.add('LineNumber:'+ex.getLineNumber()+'Exception: '+ex.getMessage());
        }        
        
        if(!errorMessage.isEmpty() || !ProductPriceMasterDTOServiceHandler.errorMessageSet.isEmpty()){
            for(String error : errorMessage){
                msg += error;
            }
            for(String error : ProductPriceMasterDTOServiceHandler.errorMessageSet){
                msg += error;
                errorMessage.add(error);
            }
            msg = msg.trim().removeEnd(',');
            return new Response(sapMaterialCode,'false',msg,errorMessage);
        }
        return new Response(sapMaterialCode,'true','success',errorMessage);
    }
        /*
    * Method : validatePriceData
    * I/P : Parse Product pricing data
    * Purpose : To validate any required filled missing or not from the Product Pricing Data
    */
    public static List<String> validatePriceData(ProductPriceMasterDTO productPriceMasterDTO){
        List<String> errorMessage = new List<String>(); 
        ProductPriceMasterDTO.productPriceList = productPriceMasterDTO.productPriceList;
        if(!ProductPriceMasterDTO.productPriceList.isEmpty()){
            sapMaterialCode = productPriceMasterDTO.productPriceList[0].sapMaterialCode;
        }
        
        Integer index = 0;        
        for(ProductPriceMasterDTO.ProductPrice productPrice: ProductPriceMasterDTO.productPriceList){	
            try{
                if(String.isBlank(productPrice.sapMaterialCode) && String.isEmpty(productPrice.sapMaterialCode)){
                    errorMessage.add('SAP MaterialCode Missing at index '+index+'.');
                }
            }catch(Exception ex){
                errorMessage.add('SAP MaterialCode Missing at index '+index+'. ');
            }            
            try{
                if(String.isEmpty(productPrice.pricingConditionType)){
                    errorMessage.add('Missing PricingConditionType at index '+index+'. ');
                }
                try{
                    if(productPrice.pricingConditionType =='VA00' && String.isEmpty(productPrice.priceListCode)){
                        errorMessage.add('Missing PriceListCode at index '+index+'. ');
                    }  
                }catch(Exception ex){
                    errorMessage.add('Missing PriceListCode at index '+index+'. ');
                }
            }catch(Exception ex){
                errorMessage.add('Missing PricingConditionType at index '+index+'. ');
            }             
            try{
                if(productPrice.priceListItems==null || productPrice.priceListItems.isEmpty()){
                    errorMessage.add('Missing PriceListItem at index '+index+'. ');
                }else{
                    Integer ind = 0;
                    for(ProductPriceMasterDTO.PriceListItem priceListItem : productPrice.priceListItems){
                        try{
                            if(productPrice.pricingConditionType =='PR00' && (String.isBlank(priceListItem.priceListCode) || String.isEmpty(priceListItem.priceListCode))){
                                errorMessage.add('Missing PriceListCode at index  '+ind+' of Parent '+index+'. ');
                            }                             
                        }catch(Exception ex){
                            errorMessage.add('Missing PriceListCode at index  '+ind+' of Parent '+index+'. ');
                        }
                        try{
                            if(productPrice.pricingConditionType =='VA00' && (String.isBlank(priceListItem.characteristicValue) || String.isEmpty(priceListItem.characteristicValue))){
                                errorMessage.add('Missing CharacteristicValue at index  '+ind+' of Parent '+index+'. ');
                            }                             
                        }catch(Exception ex){
                            errorMessage.add('Missing CharacteristicValue at index  '+ind+' of Parent '+index+'. ');
                        }
                        try{
                            if(String.isBlank(priceListItem.conditionCurrency) || String.isEmpty(priceListItem.conditionCurrency)){
                                errorMessage.add('Missing ConditionCurrency at index '+ind+' of Parent '+index+'. ');
                            }                             
                        }catch(Exception ex){
                            errorMessage.add('Missing ConditionCurrency at index '+ind+' of Parent '+index+'. ');
                        }
                        try{
                            if(String.isBlank(priceListItem.conditionAmount) || String.isEmpty(priceListItem.conditionAmount)){
                                errorMessage.add('Missing ConditionAmount at index '+ind+' of Parent '+index+'. ');
                            }                             
                        }catch(Exception ex){
                            errorMessage.add('Missing ConditionAmount at index '+ind+' of Parent '+index+'. ');
                        }
                        ind++;
                    }
                }
            }catch(Exception ex){
                errorMessage.add('Missing PriceListItem at index '+index);
            }
            index++; 
        }
        return errorMessage;
    } 	
}