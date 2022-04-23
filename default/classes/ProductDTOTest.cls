@IsTest
public class ProductDTOTest  {    
   /* public static testMethod void testPostMethod(){
        Response  response;
        RestRequest request = new RestRequest();
        request.requestUri ='https://lohiacorplimited--dev.my.salesforce.com/services/apexrest/Product';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof('{"sapMaterialRef": "1203824000","quantityUnitOfMeasure": "EA","productGroupNumber": "10","productGroup": "Tapeline","productCode": "10106_1","name": "TP 1 Demo Product - 1","materialType": "AE","isActive": true,"family": "Tapeline","description": "This is product description","currencyIsoCode": "INR","attributes": [{"sapMaterialRef": "1203824000","charDescription": "CWM Controller","attributeValues": [{"priceRelevant": false,"internalCharNumber": "L31_CWM_10106_10","description": "","defaultValue": true,"currencyIsoCode": "INR","charDescription": "CWM Controller","characteristicValue": "CWM Controller - 8-Bit"},{"priceRelevant": false,"internalCharNumber": "L31_CWM_10106_11","description": "","defaultValue": false,"currencyIsoCode": "INR", "charDescription": "CWM Controller","characteristicValue": "CWM Controller - 16-Bit"}]}]}}');
        RestContext.request = request;
        Test.startTest();
 //       Test.SetMock(HttpCallOutMock.class, new ProductDTOMock());
        response = ProductDTOService.doPost();   
        Test.stopTest();
        System.debug('#StringTrue:'+response);
        System.assert(response!=null );
        System.assertEquals(response.isSuccess,'true', 'True message');

    	}
        public static testMethod void testEmptyString(){
              Response  response;
            RestRequest request = new RestRequest();
        request.requestUri ='https://lohiacorplimited--dev.my.salesforce.com/services/apexrest/Product';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof('{}');
        RestContext.request = request;
        Test.startTest();
        Test.SetMock(HttpCallOutMock.class, new ProductDTOMock());
        response=ProductDTOService.doPost();
            if(String.isEmpty(response.toString())){
              System.assertEquals(response.isSuccess,'false','False Response Reply');  
            }
        Test.stopTest();
        System.debug('#StringEmpty:'+response);
       // System.assert(result!=null );
        
        }*/
}