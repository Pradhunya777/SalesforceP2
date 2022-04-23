/*
* Name : ProductDTOService
* Description: To create and upate product from SAP to salesforce
* TestMethod:
* CreateDate: 13-Nov-2021
-------------------------------------------------------
#ModificationDate	: Details

*/
@RestResource(urlMapping='/Product/*')
global with sharing	class ProductDTOService{
    @HttpPost
    global static Response doPost(){
        Response  response; 
        ProductDTO productDTO;
        try{
            //rest context objects for request and response
            RestRequest req = RestContext.request;
            String productDTOJson = req.requestBody.toString();        
            System.debug('#productDTOJson:'+productDTOJson); 
            
            if(String.isBlank(productDTOJson)){
                return new Response('','false','Invliad Product data.');                                  
            }
            
            productDTO = (ProductDTO)System.JSON.deserialize(productDTOJson,ProductDTO.class);    
            System.debug('#productDTO:'+productDTO); 
            if(productDTO.sapMaterialRef!=null){
                String error = validateProduct(productDTO);
                if(String.isNotBlank(error)){
                    response = new Response(productDTO.sapMaterialRef,'false',error);
                }else{
                    response = ProductDTOServiceHandler.createProduct(productDTO);
                }               
            }else{
                response = new Response(productDTO.sapMaterialRef,'false','SAP Material Ref material is missing.');
            }
        }catch(Exception ex){
            ExceptionUtility.addExceptionLog(new ExceptionUtility.LogUitlity(null,'ProductDTOService','doPost',
                                                                             ex.getStackTraceString(),ex.getMessage(),ex.getTypeName(),ex.getLineNumber()));
            ExceptionUtility.commiLog();
            response = new Response(productDTO.sapMaterialRef,'false',ex.getMessage());
        }   
        return response;
    }    
    /*
* Name : validateProduct
* Parameter: Product request json
* Description: To validate if required fields missing then add it in error message.
* CreatedDate: 30-Dec-2021
* LastModifiedDate:30-Dec-2021
*/
    public static String validateProduct(ProductDTO productDTO){
        String error = '';
        Set<String> errorMessages = new Set<String>();
        for(productDTO.ProductAttribute productAttribute:  productDTO.attributes){
            if(String.isBlank(productAttribute.charDescription)){
                errorMessages.add('Attribute name is missing.');
            }            
            for(productDTO.ProductAttributeValues values : productAttribute.attributeValues){
                if(String.isBlank(values.characteristicValue)){
                    errorMessages.add('characteristicValue name is missing.');
                }
            }           
        }
        if(!errorMessages.isEmpty()){
            for(String msg : errorMessages){
                error += msg+', ';
            }
        }
        error = String.isNotBlank(error)? error.trim().removeEnd(','):'';
        return error;
    }
    
}