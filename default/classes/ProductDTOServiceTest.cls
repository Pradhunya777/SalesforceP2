/*
* Name : ProductDTOServiceTest
* Description: Test class for: ProductDTOService, ProductDTOServiceHandler, ProductDTO.
* CreateDate: 28-Dec-2021
 -------------------------------------------------------
#ModificationDate	: Details
*/
@isTest
public class ProductDTOServiceTest {
    
    /*@purpose: create test data */ 
    @testsetup static void createData() {
        
        Test.startTest();
        Pricebook2 standardPriceBook = createStandardPriceBook();
        System.assertNotEquals(null, standardPriceBook.Id);
        
        List<Product2> productList = createProducts(2);
        INSERT productList;
        System.assertEquals(2, productList.size());
        
        List<Product2> optionalProductList = createOptionalProducts(1);
        INSERT optionalProductList;
        System.assertEquals(1, optionalProductList.size());
        
        List<PricebookEntry> priceBookEntryList = createPriceBookEntries(standardPriceBook, productList, 2);
        INSERT priceBookEntryList;
        System.assertEquals(4, priceBookEntryList.size());
        
        List<SBQQ__ProductFeature__c> productFeaturesList = createProductFeatures(productList, 2);
        INSERT productFeaturesList;
        System.assertEquals(4, productFeaturesList.size());
        
        List<SBQQ__ProductOption__c> productOptionsList = createProductOptions(productList, 2);
        INSERT productOptionsList;
        System.assertEquals(4, productOptionsList.size());
        Test.stopTest();
    }
        
    /* @purpose: Negative test method for doPost */ 
    @isTest static void doPostTest1() {
        
        RestRequest request = new RestRequest();
        request.requestUri = 'https://lohiacorplimited--dev.lightning.force.com/services/apexrest/Product/*';
        request.httpMethod = 'POST';
        jsonResponse = jsonResponse.replace('sapMaterialRef', ''); // make sapMaterialRef blank in response 
		request.requestBody = Blob.valueof(jsonResponse);
        RestContext.request = request;
                
        Test.startTest();
                
        Response response = ProductDTOService.doPost();
        System.assertEquals('false', response.isSuccess);
        
        Test.stopTest();
    }
    
     /* @purpose: Positive test method for doPost */ 
    @isTest static void doPostTest2() {
        RestRequest request = new RestRequest();
        request.requestUri = 'https://lohiacorplimited--dev.lightning.force.com/services/apexrest/Product/*';
        request.httpMethod = 'POST';
		request.requestBody = Blob.valueof(jsonResponse);
        RestContext.request = request;
                
        Product2 product = [SELECT Id, SAP_Material_Ref__c, ProductCode FROM Product2 LIMIT 1];
        product.SAP_Material_Ref__c = '1203824001';
        product.ProductCode = '1203824001';
        UPDATE product;
        
        Test.startTest();
        
        Response response = ProductDTOService.doPost();
        System.assertEquals('true', response.isSuccess);
        
        Test.stopTest();
    }
    
    /* @purpose: Negative test method for doPost*/ 
    @isTest static void doPostTest3() {
        RestRequest request = new RestRequest();
        request.requestUri = 'https://lohiacorplimited--dev.lightning.force.com/services/apexrest/Product/*';
        request.httpMethod = 'POST';
		request.requestBody = Blob.valueof('');
        RestContext.request = request;
                
        Test.startTest();
        Response response = ProductDTOService.doPost();
        System.assertEquals('false', response.isSuccess);
        Test.stopTest();
    }
    
    /* @purpose: Positive test method for doPost */ 
    @isTest static void doPostTest4() {
        
        RestRequest request = new RestRequest();
        request.requestUri = 'https://lohiacorplimited--dev.lightning.force.com/services/apexrest/Product/*';
        request.httpMethod = 'POST';
		request.requestBody = Blob.valueof(jsonResponse);
        RestContext.request = request;
                
        Test.startTest();
        DELETE [SELECT Id FROM SBQQ__ProductFeature__c];        
        
        Response response = ProductDTOService.doPost();
        System.assertEquals('true', response.isSuccess);
        
        response = ProductDTOService.doPost();
        System.assertEquals('true', response.isSuccess);
        
        Test.stopTest();
    }
    
    /* @purpose: Negative test method for doPost */ 
    @isTest static void doPostTest5() {
        
        jsonResponse = jsonResponse.replace('TP 1 Demo Product - 1', '');
        
        RestRequest request = new RestRequest();
        request.requestUri = 'https://lohiacorplimited--dev.lightning.force.com/services/apexrest/Product/*';
        request.httpMethod = 'POST';
		request.requestBody = Blob.valueof(jsonResponse);
        
        RestContext.request = request;
                
        Test.startTest();        
        Response response = ProductDTOService.doPost();
        System.assertEquals('false', response.isSuccess);
       
        Test.stopTest();
    }
    
    /* @purpose: Negative test method for doPost */ 
    @isTest static void doPostTest6() {
        
        RestRequest request = new RestRequest();
        request.requestUri = 'https://lohiacorplimited--dev.lightning.force.com/services/apexrest/Product/*';
        request.httpMethod = 'POST';
		request.requestBody = Blob.valueof('Test');
        RestContext.request = request;
                
        Test.startTest();        
        Response response = ProductDTOService.doPost();
        System.assertEquals('false', response.isSuccess);
                
        ProductDTO productDTO = new ProductDTO();
        Test.stopTest();
    }
    
    /* @purpose: create standard price book
     * @params: none
     * @return: Pricebook2
     */ 
    private static Pricebook2 createStandardPriceBook() {
        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        UPDATE standardPricebook;
        return standardPricebook;
    }
    
    /* @purpose: create products
     * @params: Integer numberOfRecords
     * @return: List<Product2> 
     */ 
    private static List<Product2> createProducts(Integer numberOfRecords) {
        List<Product2> productsList = new List<Product2>();
        for(Integer ind = 0; ind < numberOfRecords; ind++) {
            productsList.add(new Product2(
                Name = 'Car-'+ind, 
                Family = 'Vehicle'
            ));
        }
        return productsList;
    }
    
     /* @purpose: create Optional products
     * @params: Integer numberOfRecords
     * @return: List<Product2>
     */ 
    private static List<Product2> createOptionalProducts(Integer numberOfRecords) {
        List<Product2> productsList = new List<Product2>();
        for(Integer ind = 0; ind < numberOfRecords; ind++) {
            String productName = 'Product-'+ind;
            if(ind == 0) {
                productName = 'Inlet Drive required - Load cell'; 
            }
            productsList.add(new Product2(
                Name = productName,
                Family = 'Options'
            ));
        }
        return productsList;
    }
    
    /* @purpose: create price book entries
     * @params: Pricebook2 standardPriceBook, List<Product2> productList, Integer perProductPbe
     * @return: List<PricebookEntry>
     */ 
    private static List<PricebookEntry> createPriceBookEntries(Pricebook2 standardPriceBook, List<Product2> productList, Integer perProductPbe) {
        List<String> currencyCodes = new List<String>{'INR','USD','EUR'};
        List<PricebookEntry> priceBookEntryList = new List<PricebookEntry>();
        
        for(Product2 product : productList) {
            for(Integer num = 0; num < perProductPbe; num++) {
                priceBookEntryList.add(new PricebookEntry (
                    Pricebook2Id = standardPriceBook.Id,
                    Product2Id = product.Id,
                    UnitPrice = 1020,
                    IsActive = true,
                    CurrencyIsoCode = currencyCodes[num]
                ));
            }
        }
        return priceBookEntryList;
    }
 
    /* @purpose: create product features
     * @params: List<Product2> productList, Integer perProductFeatures
     * @return: List<SBQQ__ProductFeature__c>
     */ 
    private static List<SBQQ__ProductFeature__c> createProductFeatures(List<Product2> productList, Integer perProductFeatures) {
        List<SBQQ__ProductFeature__c> productFeaturesList = new List<SBQQ__ProductFeature__c>();
        List<String> currencyCodes = new List<String>{'USD','INR','EUR'};
        for(Product2 product : productList) {
            for(Integer ind = 0; ind < perProductFeatures; ind++) {
                String featureName = 'Inlet Drive required';
                if(ind == 0) {
                    featureName = product.Name+' Feature-'+ind;
                }
                productFeaturesList.add(new SBQQ__ProductFeature__c(
                    Name = featureName, 
                    SBQQ__MinOptionCount__c = 1,
                    SBQQ__MaxOptionCount__c = 3,
                    SBQQ__Number__c = 5,
                    SBQQ__ConfiguredSKU__c = product.id,
                    CurrencyIsoCode = currencyCodes[ind]
                ));
            }
        }
        
        return productFeaturesList;
    }
    
    /* @purpose: create product options
     * @params: List<Product2> productList, Integer perProductOptions
     * @return: List<SBQQ__ProductOption__c>
     */ 
    private static List<SBQQ__ProductOption__c> createProductOptions(List<Product2> productList, Integer perProductOptions) {
        List<SBQQ__ProductOption__c> productOptionsList = new List<SBQQ__ProductOption__c>();
        List<Product2> optionalProductList = [SELECT Id FROM Product2 WHERE Family = 'Options'];
        List<String> currencyCodes = new List<String>{'USD','INR','EUR'};
            
        for(Product2 product : productList) {
            for(Integer ind = 0; ind < perProductOptions; ind++) {
                productOptionsList.add(new SBQQ__ProductOption__c(
                    SBQQ__Number__c = 5, 
                    SBQQ__Quantity__c = 1,
                    SBQQ__MinQuantity__c = 1,
                    SBQQ__MaxQuantity__c = 5,
                    SBQQ__ConfiguredSKU__c = product.id,
                    SBQQ__OptionalSKU__c = optionalProductList[0].id,
                    CurrencyIsoCode = currencyCodes[ind]
                ));
            }
        }
        
        return productOptionsList;
    }
    
    // webservice response string
    private static String jsonResponse = '{'+
	'"sapMaterialRef": "1203824001",'+
	'"quantityUnitOfMeasure": "EA",'+
	'"productGroupNumber": "1",'+
	'"productGroup": "Cheese Winder",'+
	'"productCode": "10106_5",'+
	'"name": "Cheese Winder Demo Product",'+
	'"materialType": "AE",'+
	'"isActive": "true",'+
	'"family": "Cheese Winder",'+
	'"description": "Test Product Description",'+
	'"currencyIsoCode": "INR",'+
	'"netWeight": "1.5",'+
	'"weightUnit": "1",'+
	'"tod": "Test",'+
	'"programming": "Test",'+
  '"attributes": ['+
    '{'+
      '"sapMaterialRef": "1203824000",'+
      '"internalCharNumber": "123",'+
      '"charDescription": "Inlet Drive required",'+
      '"attributeValues": ['+
        '{'+
          '"priceRelevant": "true",'+
          '"isActive": "True",'+
          '"description": "",'+
          '"defaultValue": "false",'+
          '"currencyIsoCode": "INR",'+
          '"charDescription": "Inlet Drive required",'+
          '"characteristicValue": "Inlet Drive required - Load cell"'+
        '},'+
        '{'+
          '"priceRelevant": "false",'+
          '"isActive": "True",'+
          '"description": "This is product description",'+
          '"defaultValue": "false",'+
          '"currencyIsoCode": "INR",'+
          '"charDescription": "Inlet Drive required",'+
          '"characteristicValue": "TP 1 Demo Product - 1"'+
        '}'+
      ']'+
    '}'+
  ']'+
'}';
}