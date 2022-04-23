@isTest
global class ProductDTOMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
         HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"sapMaterialRef": "1203824000","quantityUnitOfMeasure": "EA","productGroupNumber": "10","productGroup": "Tapeline","productCode": "10106_1","name": "TP 1 Demo Product - 1","materialType": "AE","isActive": true,"family": "Tapeline","description": "This is product description","currencyIsoCode": "INR","attributes": [{"sapMaterialRef": "1203824000","charDescription": "CWM Controller","attributeValues": [{"priceRelevant": false,"internalCharNumber": "L31_CWM_10106_10","description": "","defaultValue": true,"currencyIsoCode": "INR","charDescription": "CWM Controller","characteristicValue": "CWM Controller - 8-Bit"},{"priceRelevant": false,"internalCharNumber": "L31_CWM_10106_11","description": "","defaultValue": false,"currencyIsoCode": "INR", "charDescription": "CWM Controller","characteristicValue": "CWM Controller - 16-Bit"}],"sapMaterialRef": "1203824000","charDescription": "Warp package dia (mm)","attributeValues": [{"priceRelevant": false,"internalCharNumber": "L16_WARP_10106_11", "description": "", "defaultValue": false, "currencyIsoCode": "INR", "charDescription": "Warp package dia (mm)", "characteristicValue": "Warp package dia (mm) 160" },{ "priceRelevant": false, "internalCharNumber": "L16_WARP_10106_10", "description": "", "defaultValue": true, "currencyIsoCode": "INR", "charDescription": "Warp package dia (mm)", "characteristicValue": "Warp package dia (mm) 130" } ]}]}');
        response.setStatusCode(200);
        System.debug('#RESPONSE:'+response);
        return response;
    }
}