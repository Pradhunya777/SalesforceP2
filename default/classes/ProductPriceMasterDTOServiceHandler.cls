/*
 * Controller	: ProductPriceMasterDTOServiceHandler
 * Purpose		: This controller is used to process the pricing data
 * Created Date	: 19-Nov-2021
-------------------------------------------------------
#ModificationDate	: Details
15-Dec-2021			: To update the error message response.
*/
public class ProductPriceMasterDTOServiceHandler {  
 	public static Set<String> errorMessageSet = new Set<String>();   
    /*
    * Method	: updateProductPricing
    * I/P		: Parse Product pricing wrapper.
    * Purpose	: To create map of FG and Variants, and pass these maps to create and update pricing for FG and Variants.
    */
    public static void updateProductPricing(ProductPriceMasterDTO productPriceMasterDTO){
        Map<String,List<ProductPriceMasterDTO.PriceListItem>> leadProductPriceMap = new Map<String,List<ProductPriceMasterDTO.PriceListItem>>();
        Map<String,List<ProductPriceMasterDTO.ProductPrice>> variantProductPriceListMap = new  Map<String,List<ProductPriceMasterDTO.ProductPrice>>();
        Set<String> productSAPMaterialCode = new Set<String>();        
        Set<String> variantNameSet = new Set<String>();       
            Pricebook2 standardPriceBook = [SELECT Id FROM Pricebook2 WHERE isStandard = TRUE LIMIT 1];
            
            ProductPriceMasterDTO.productPriceList = productPriceMasterDTO.productPriceList;        
            if(ProductPriceMasterDTO.productPriceList != null){
                for(ProductPriceMasterDTO.ProductPrice productPrice: ProductPriceMasterDTO.productPriceList){
                    if(String.isNotBlank(productPrice.sapMaterialCode) && !String.isEmpty(productPrice.sapMaterialCode)){
                        productSAPMaterialCode.add(productPrice.sapMaterialCode);
                        if(!leadProductPriceMap.containsKey(productPrice.sapMaterialCode) && productPrice.pricingConditionType == 'PR00'){
                            if(!productPrice.priceListItems.isEmpty()){
                                leadProductPriceMap.put(productPrice.sapMaterialCode,productPrice.priceListItems); 
                            }
                        }
                        if(!variantProductPriceListMap.containsKey(productPrice.sapMaterialCode) && productPrice.pricingConditionType == 'VA00'){
                            variantProductPriceListMap.put(productPrice.sapMaterialCode,new List<ProductPriceMasterDTO.ProductPrice>{productPrice});
                        }else if(variantProductPriceListMap.containsKey(productPrice.sapMaterialCode) && productPrice.pricingConditionType == 'VA00'){
                            variantProductPriceListMap.get(productPrice.sapMaterialCode).add(productPrice);
                        }  
                        if(!productPrice.priceListItems.isEmpty()){
                            for(ProductPriceMasterDTO.PriceListItem priceListItem : productPrice.priceListItems){
                                if(String.isNotBlank(priceListItem.characteristicValue)){
                                    variantNameSet.add(priceListItem.characteristicValue.toUpperCase());
                                }
                            }
                        }                        
                    }               
                }            
            }   
            
            System.debug('#leadProductPriceMap:'+ JSON.serialize(leadProductPriceMap));
            System.debug('#variantProductPriceListMap:'+ JSON.serialize(variantProductPriceListMap));
            System.debug('#productSAPMaterialCode:'+ JSON.serialize(productSAPMaterialCode));
            System.debug('#variantNameSet:'+ JSON.serialize(variantNameSet));
            
            Set<String> priceListCodesSet = new Set<String>();  
            Map<String,String> priceListCodeMap = new Map<String,String>();
            if(!leadProductPriceMap.isEmpty() && leadProductPriceMap!=null){
                for(String productSAPCode : leadProductPriceMap.keySet()){
                    for(ProductPriceMasterDTO.PriceListItem priceListItem : leadProductPriceMap.get(productSAPCode)){
                        if(String.isNotBlank(priceListItem.priceListCode)){
                            priceListCodesSet.add(priceListItem.priceListCode); 
                            if(!priceListCodeMap.containsKey(priceListItem.priceListCode)){
                                priceListCodeMap.put(priceListItem.priceListCode,priceListItem.priceListDescription);
                            }
                        }                    
                    }
                }  
            }
            if(!variantProductPriceListMap.isEmpty() && variantProductPriceListMap!=null){
                for(String productSAPCode : variantProductPriceListMap.keySet()){
                    for(ProductPriceMasterDTO.ProductPrice productPrice : variantProductPriceListMap.get(productSAPCode)){
                        if(String.isNotBlank(productPrice.priceListCode)){
                            priceListCodesSet.add(productPrice.priceListCode);  
                            if(!priceListCodeMap.containsKey(productPrice.priceListCode)){
                                priceListCodeMap.put(productPrice.priceListCode,productPrice.priceListDescription);
                            }
                        }                    
                    }
                }
            }
            System.debug('#priceListCodesSet:'+ JSON.serialize(priceListCodesSet));
            System.debug('#priceListCodeMap:'+ JSON.serialize(priceListCodeMap));
            
            //Create custom price book if not exist
            Map<String,Pricebook2> customPriceBookMap = createCustomPriceBook(priceListCodesSet,priceListCodeMap);            
            System.debug('#customPriceBookMap 1:'+ JSON.serialize(customPriceBookMap));    
        
            if(!leadProductPriceMap.isEmpty() && leadProductPriceMap!=null){
                addLeadProductPriceBookEntry(standardPriceBook,customPriceBookMap,productSAPMaterialCode,leadProductPriceMap);
            }       
            if(!variantProductPriceListMap.isEmpty() && variantProductPriceListMap!=null){
                addVariantProductPriceBookEntry(standardPriceBook,customPriceBookMap,productSAPMaterialCode,variantNameSet,variantProductPriceListMap);
            }
        if((!variantProductPriceListMap.isEmpty() && variantProductPriceListMap!=null) ||(!leadProductPriceMap.isEmpty() && leadProductPriceMap!=null)){
            System.debug('#Condition True');
            createPriceBookForVariants(standardPriceBook,customPriceBookMap,productSAPMaterialCode);
        }else{
            System.debug('#Condition False');
        }
    }
    
    /*
* Method : addProductPriceBookEntry
* I/P : PriceBook Map with name and record,Set of SAP material code, Map of SAP code with list of price list items
* Purpose : To create and update price for proudct (FG Product) 
*/
    public static void addLeadProductPriceBookEntry(Pricebook2 standardPriceBook,Map<String,Pricebook2> customPriceBookMap,
                                                    Set<String> productSAPMaterialCode,
                                                    Map<String,List<ProductPriceMasterDTO.PriceListItem>> leadProductPriceMap)
    {       
        
        List<Product2> productList = [Select Id, Name, SAP_Material_Ref__c,ProductCode,
                                      (Select Id, Name, Pricebook2Id,Pricebook2.Name, Product2Id,Product2.Name,ProductCode, 
                                       CurrencyIsoCode, UnitPrice, IsActive, UseStandardPrice,Valid_From__c,Valid_To__c 
                                       From PricebookEntries)
                                      From Product2 
                                      WHERE SAP_Material_Ref__c IN: productSAPMaterialCode];
        
        Set<String> productIds = new Set<String>();
        Map<String,Product2> productMap = new Map<String,Product2>();
        for(Product2 productRecord : productList){
            productIds.add(productRecord.Id);            
            productMap.put(productRecord.SAP_Material_Ref__c.toUpperCase(),productRecord);
        }
        if(productIds.isEmpty()){
            errorMessageSet.add('SAP meterial code '+ productSAPMaterialCode +' does not exist in CRM. ');
            return;
        }
        String missingProductCode = '';
        for(String sapMaterialCode : productSAPMaterialCode){
            if(!productMap.containsKey(sapMaterialCode)){
                missingProductCode +=sapMaterialCode+', ';
            }
        }        
        if(String.isNotBlank(missingProductCode)){
            errorMessageSet.add('SAP meterial code '+missingProductCode.trim().removeEnd(',')+' does not exist in CRM. ');
            return;
        }
        
        Map<String,Map<String,Map<String,PricebookEntry>>> mapOfProductPriceBookEntry = getMapOfProductPriceBookEntry(productSAPMaterialCode);
        //System.debug('#mapOfProductPriceBookEntry:'+JSON.serialize(mapOfProductPriceBookEntry));
        
        List<PricebookEntry> stdPricebookEntryList = addLeadProductToStandardPriceBook(leadProductPriceMap,mapOfProductPriceBookEntry,productMap,standardPriceBook);
        //System.debug('#stdPricebookEntryList:'+JSON.serialize(stdPricebookEntryList));
        
        List<PricebookEntry> pricebookEntryList = new List<PricebookEntry>();
        for(String productSAPCode : leadProductPriceMap.keySet()){
            Product2 productRecord = productMap.get(productSAPCode.toUpperCase());
            List<ProductPriceMasterDTO.PriceListItem> priceListItemList = leadProductPriceMap.get(productSAPCode.toUpperCase());   
            if(mapOfProductPriceBookEntry.containsKey(productSAPCode.toUpperCase())){
                Map<String,Map<String,PricebookEntry>> conditionCurrencyMap = mapOfProductPriceBookEntry.get(productSAPCode.toUpperCase());
                for(ProductPriceMasterDTO.PriceListItem priceListItem : priceListItemList){   
                  //  System.debug('priceListCode:'+priceListItem.priceListCode);
                  //  System.debug('conditionCurrency:'+priceListItem.conditionCurrency);
                    PriceBook2 priceBook = customPriceBookMap.get(priceListItem.priceListCode.toUpperCase());
                  //  System.debug('#priceBook:'+priceBook);
                    if(conditionCurrencyMap.containsKey(priceListItem.conditionCurrency.toUpperCase())){
                        Map<String,PricebookEntry> priceListCodeMap = conditionCurrencyMap.get(priceListItem.conditionCurrency.toUpperCase());
                        // System.debug('#priceListCodeMap:'+priceListCodeMap);
                        if(priceListCodeMap.containsKey(priceListItem.priceListCode.toUpperCase())){
                            PricebookEntry pbEntry = priceListCodeMap.get(priceListItem.priceListCode.toUpperCase());
                            pbEntry.UnitPrice = Decimal.valueOf(priceListItem.conditionAmount); 
                            //priceBookEntryRecord.Valid_From__c = 
                            //priceBookEntryRecord.Valid_To__c =
                            pricebookEntryList.add(pbEntry);
                        }else{
                            PricebookEntry priceBookEntryRecord = new PricebookEntry();
                            priceBookEntryRecord.Product2Id = productRecord.Id;
                            priceBookEntryRecord.Pricebook2Id = priceBook.Id;
                            priceBookEntryRecord.CurrencyIsoCode = priceListItem.conditionCurrency.toUpperCase();
                            priceBookEntryRecord.UnitPrice = Decimal.valueOf(priceListItem.conditionAmount);
                            priceBookEntryRecord.UseStandardPrice = false;
                            priceBookEntryRecord.IsActive = true;
                            //priceBookEntryRecord.Valid_From__c = 
                            //priceBookEntryRecord.Valid_To__c
                            pricebookEntryList.add(priceBookEntryRecord);
                        }                    
                    }else{
                        System.debug('Currency not exist for SAP Code.');
                        PricebookEntry priceBookEntryRecord = new PricebookEntry();
                        priceBookEntryRecord.Product2Id = productRecord.Id;
                        priceBookEntryRecord.Pricebook2Id = priceBook.Id;
                        priceBookEntryRecord.CurrencyIsoCode = priceListItem.conditionCurrency.toUpperCase();
                        priceBookEntryRecord.UnitPrice = Decimal.valueOf(priceListItem.conditionAmount);
                        priceBookEntryRecord.UseStandardPrice = false;
                        priceBookEntryRecord.IsActive = true;
                        //priceBookEntryRecord.Valid_From__c = 
                        //priceBookEntryRecord.Valid_To__c
                        pricebookEntryList.add(priceBookEntryRecord);
                    }                
                }                
            }else{
                System.debug('Product Price Entry not exist for SAP Code.');
                for(ProductPriceMasterDTO.PriceListItem priceListItem : priceListItemList){  
                    PriceBook2 priceBook = customPriceBookMap.get(priceListItem.priceListCode.toUpperCase());
                    PricebookEntry priceBookEntryRecord = new PricebookEntry();
                    priceBookEntryRecord.Product2Id = productRecord.Id;
                    priceBookEntryRecord.Pricebook2Id = priceBook.Id;
                    priceBookEntryRecord.CurrencyIsoCode = priceListItem.conditionCurrency.toUpperCase();
                    priceBookEntryRecord.UnitPrice = Decimal.valueOf(priceListItem.conditionAmount);
                    priceBookEntryRecord.UseStandardPrice = false;
                    priceBookEntryRecord.IsActive = true;
                    //priceBookEntryRecord.Valid_From__c = 
                    //priceBookEntryRecord.Valid_To__c
                    pricebookEntryList.add(priceBookEntryRecord);
                }
            }
        }
        
        //System.debug('#pricebookEntryList:'+JSON.serialize(pricebookEntryList));
        if(!pricebookEntryList.isEmpty()){
                Database.UpsertResult[] uprList = Database.upsert(pricebookEntryList, false);                
                for (Database.UpsertResult result : uprList) {
                    if (result.isSuccess()) {                        
                        // Operation was successful, so get the ID of the record that was processed
                        System.debug('Successfully upserted PricebookEntry. PricebookEntry Id:' + result.getId());
                    }
                    else {
                        // Operation failed, so get all errors                
                        for(Database.Error err : result.getErrors()) {
                            System.debug('The following error has occurred.');                    
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('PriceBookEntry fields that affected this error: ' + err.getFields());
                        }
                    }
                }                   
        }        
    }
    
    /*
* Method : addvariantProductPriceBookEntry
* I/P : PriceBook Map with name and record,Set of SAP material code, Map of SAP code with list of price list items
* Purpose : To create and update price for proudct(FG Variants)
*/
    public static void addVariantProductPriceBookEntry(Pricebook2 standardPriceBook,Map<String,Pricebook2> customPriceBookMap,
                                                       Set<String> productSAPMaterialCode,Set<String> variantNameSet,
                                                       Map<String,List<ProductPriceMasterDTO.ProductPrice>> variantProductPriceListMap)
    {        
        List<SBQQ__ProductOption__c> productOptionList = [Select Id,Name,SBQQ__OptionalSKU__c,SBQQ__ProductName__c,SBQQ__ProductCode__c, 
                                                          SBQQ__ConfiguredSKU__r.Name,
                                                          SBQQ__ConfiguredSKU__r.SAP_Material_Ref__c,SBQQ__ConfiguredSKU__r.isActive
                                                          From 
                                                          SBQQ__ProductOption__c
                                                          Where SBQQ__ConfiguredSKU__r.SAP_Material_Ref__c IN: productSAPMaterialCode
                                                          AND SBQQ__ProductName__c IN: variantNameSet ];
        if(productOptionList.isEmpty()){
            errorMessageSet.add(productSAPMaterialCode+' does not exist.');
            return;
        }
        
        Set<String> variantProductIdSet = new Set<String>();
        Map<String,Map<String,SBQQ__ProductOption__c>> variantLeadProductMap = new Map<String,Map<String,SBQQ__ProductOption__c>>();
        
        for(SBQQ__ProductOption__c productOption : productOptionList){
            variantProductIdSet.add(productOption.SBQQ__OptionalSKU__c);
            Map<String,SBQQ__ProductOption__c> variantMap = new Map<String,SBQQ__ProductOption__c>();             
            if(variantLeadProductMap.containskey(productOption.SBQQ__ConfiguredSKU__r.SAP_Material_Ref__c.toUpperCase())){                 
                variantMap.put(productOption.SBQQ__ProductName__c.toUpperCase(),productOption);
                variantLeadProductMap.get(productOption.SBQQ__ConfiguredSKU__r.SAP_Material_Ref__c.toUpperCase()).putAll(variantMap);	
            }else{
                variantLeadProductMap.put(productOption.SBQQ__ConfiguredSKU__r.SAP_Material_Ref__c.toUpperCase(),
                                          new Map<String,SBQQ__ProductOption__c>{productOption.SBQQ__ProductName__c.toUpperCase() => productOption}); 
            }
        }
        //System.debug('#variantLeadProductMap:'+ JSON.serialize(variantLeadProductMap));
        
        if(variantProductIdSet.isEmpty()){
            errorMessageSet.add('Variants does not exist');
            return;
        }
        
        if(!variantLeadProductMap.isEmpty()){
            for(String sapMaterialCode : productSAPMaterialCode){
                if(variantLeadProductMap.containsKey(sapMaterialCode.toUpperCase())){
                    Map<String,SBQQ__ProductOption__c>  varianMap = variantLeadProductMap.get(sapMaterialCode.toUpperCase());
                    System.debug('#varianMap:'+ varianMap);
                    if(!varianMap.isEmpty()){
                        for(String variantName : varianMap.keySet()){
                            System.debug('#variantName:'+ variantName.toUpperCase());
                            if(!variantNameSet.contains(variantName.toUpperCase())){
                                errorMessageSet.add(variantName +' does not exist. ');
                            }
                        }
                    }
                   /* for(String variantName : variantNameSet){
                        System.debug('#variantName:'+ variantName.toUpperCase());
                        if(!varianMap.containsKey(variantName.toUpperCase())){
                            errorMessageSet.add(variantName +' does not exist. ');
                        }
                    }*/
                }else{
                   errorMessageSet.add(sapMaterialCode +' does not exist. '); 
                }                
            }            
        }
        if(!errorMessageSet.isEmpty()){
         	return;   
        }
        
        List<Product2> variantProductList = [Select Id, Name, SAP_Material_Ref__c,ProductCode,
                                             (Select Id, Name, Pricebook2Id,Pricebook2.Name,Pricebook2.IsStandard, Product2Id,Product2.Name,ProductCode , CurrencyIsoCode,
                                              UnitPrice, IsActive, UseStandardPrice,Valid_From__c,Valid_To__c 
                                              From PricebookEntries)
                                             From Product2 
                                             WHERE Id IN: variantProductIdSet];
         Map<String,Set<String>> variantCurrencyMap = new Map<String,Set<String>>();
        for(Product2 productRecord : variantProductList){
            Set<String> currencySet = new Set<String>();
            for(PricebookEntry priceBookEntryRecord : productRecord.PricebookEntries){
                if(priceBookEntryRecord.Pricebook2.IsStandard){	
                    if(!currencySet.contains(priceBookEntryRecord.CurrencyIsoCode.toUpperCase()) && String.isNotBlank(priceBookEntryRecord.CurrencyIsoCode.toUpperCase())){
                        currencySet.add(priceBookEntryRecord.CurrencyIsoCode.toUpperCase());   
                    }
                }
            }
            if(!currencySet.isEmpty()){
                variantCurrencyMap.put(productRecord.Id,currencySet);
            }
        }
        
        Map<String,Map<String,Map<String,Map<String,PricebookEntry>>>> variantPriceBookMap = getMapOfVariantPricebookEntry(variantProductList);
        
        //Check StandardPricebook entry for currency against the product exist or not. If not then add Pricebook entry
        addVariantProductToStandardPriceBook(standardPriceBook,variantLeadProductMap,variantCurrencyMap,variantPriceBookMap,variantProductPriceListMap);
        
        
        /* Region Start: Create List of PricebookEntry for insert or update */
        List<PricebookEntry> priceBookEntryList = new List<PricebookEntry>();
        for(String productSAPCode : variantProductPriceListMap.keySet()){
            if(variantPriceBookMap.containsKey(productSAPCode.toUpperCase())){
               Map<String,Map<String,Map<String,PricebookEntry>>> existingVariantPriceBookMap =  variantPriceBookMap.get(productSAPCode.toUpperCase());                
               //  System.debug('#Variant existingVariantPriceBookMap:'+JSON.serialize(existingVariantPriceBookMap));
                List<ProductPriceMasterDTO.ProductPrice> productPriceList = variantProductPriceListMap.get(productSAPCode.toUpperCase());                
                for(ProductPriceMasterDTO.ProductPrice productPriceRecord : productPriceList){   
                     Pricebook2 priceBook = customPriceBookMap.get(productPriceRecord.priceListCode.toUpperCase());
                    for(ProductPriceMasterDTO.PriceListItem priceListItemRecord : productPriceRecord.priceListItems){
                        if(existingVariantPriceBookMap.containsKey(priceListItemRecord.characteristicValue.toUpperCase())){
                            System.debug('#1');
                  //           System.debug(priceListItemRecord.characteristicValue.toUpperCase()+' Already Exist');  
                            if(variantLeadProductMap.containsKey(productSAPCode.toUpperCase())){
                                 System.debug('#2');
                                Map<String,SBQQ__ProductOption__c> productVariantMap =  variantLeadProductMap.get(productSAPCode.toUpperCase());                                
                                if( productVariantMap.containsKey(priceListItemRecord.characteristicValue.toUpperCase())){   
                                    System.debug('#3');
                                    SBQQ__ProductOption__c productVariantRecord = productVariantMap.get(priceListItemRecord.characteristicValue.toUpperCase());                                    
                                    Map<String,Map<String,PricebookEntry>> priceBookEntryMap = existingVariantPriceBookMap.get(priceListItemRecord.characteristicValue.toUpperCase());                                    
                      //              System.debug('#VariantPriceEntryMap:'+JSON.serialize(priceBookEntryMap));
                                    if(priceBookEntryMap.containsKey(productPriceRecord.priceListCode.toUpperCase())){
                                        System.debug('#4');
                                        Map<String,PricebookEntry> existingPBMap = priceBookEntryMap.get(productPriceRecord.priceListCode.toUpperCase());
                                        if(existingPBMap.containsKey(priceListItemRecord.conditionCurrency.toUpperCase())){
                                            System.debug('#5');
                                            System.debug('Updated entry for:'+priceListItemRecord.characteristicValue.toUpperCase() + ' and currency'+ priceListItemRecord.conditionCurrency);
                                            PricebookEntry pbEntry = existingPBMap.get(priceListItemRecord.conditionCurrency.toUpperCase());
                                            pbEntry.UnitPrice = Decimal.valueOf(priceListItemRecord.conditionAmount);
                                            priceBookEntryList.add(pbEntry);
                                        }else{
                                            System.debug('#6');
                                            System.debug('Created new entry for:'+priceListItemRecord.characteristicValue.toUpperCase() + ' and currency'+ priceListItemRecord.conditionCurrency);
                                            System.debug('Currency '+priceListItemRecord.conditionCurrency +' does not exist for ' +priceListItemRecord.characteristicValue);
                                            PricebookEntry pbEntry = new PricebookEntry();
                                            pbEntry.Product2Id = productVariantRecord.SBQQ__OptionalSKU__c;
                                            pbEntry.Pricebook2Id = priceBook.Id;
                                            pbEntry.CurrencyIsoCode = priceListItemRecord.conditionCurrency.toUpperCase();
                                            pbEntry.UnitPrice = Decimal.valueOf(priceListItemRecord.conditionAmount);
                                            pbEntry.UseStandardPrice = false;
                                            pbEntry.IsActive = true;
                                            priceBookEntryList.add(pbEntry);
                                        }
                                    }else{
                                        System.debug('#7');
                                        System.debug('PriceBookEntry '+productPriceRecord.priceListCode +' does not exist for ' +priceListItemRecord.characteristicValue);
                                        PricebookEntry pbEntry = new PricebookEntry();
                                        pbEntry.Product2Id = productVariantRecord.SBQQ__OptionalSKU__c;
                                        pbEntry.Pricebook2Id = priceBook.Id;
                                        pbEntry.CurrencyIsoCode = priceListItemRecord.conditionCurrency.toUpperCase();
                                        pbEntry.UnitPrice = Decimal.valueOf(priceListItemRecord.conditionAmount);
                                        pbEntry.UseStandardPrice = false;
                                        pbEntry.IsActive = true;
                                        priceBookEntryList.add(pbEntry);
                                    }
                                }else{
                                    System.debug('#8');
                                    System.debug(priceListItemRecord.characteristicValue+' does not exist for LeadProduct '+ productSAPCode+' in CRM');  
                                } 
                            }else{
                                System.debug('#9');
                                System.debug('Product '+productSAPCode+' deos not exist in CRM.');  
                            }  
                        }else{
                            System.debug('#10');
                            System.debug(priceListItemRecord.characteristicValue +' does not exist for LeadProduct' +productSAPCode);
                        }                      
                    }
                }
            }else{
                System.debug(productSAPCode+' not exist in currentMap');
                for(ProductPriceMasterDTO.ProductPrice productPriceRecord : variantProductPriceListMap.get(productSAPCode.toUpperCase())){
                    Pricebook2 priceBook = customPriceBookMap.get(productPriceRecord.priceListCode.toUpperCase());
                    Map<String,SBQQ__ProductOption__c> productVariantMap =  variantLeadProductMap.get(productSAPCode.toUpperCase());
                    for(ProductPriceMasterDTO.PriceListItem priceListItemRecord : productPriceRecord.priceListItems){
                        SBQQ__ProductOption__c productVariantRecord = productVariantMap.get(priceListItemRecord.characteristicValue.toUpperCase());
                        PricebookEntry pbEntry = new PricebookEntry();
                        pbEntry.Product2Id = productVariantRecord.SBQQ__OptionalSKU__c;
                        pbEntry.Pricebook2Id = priceBook.Id;
                        pbEntry.CurrencyIsoCode = priceListItemRecord.conditionCurrency.toUpperCase();
                        pbEntry.UnitPrice = Decimal.valueOf(priceListItemRecord.conditionAmount);
                        pbEntry.UseStandardPrice = false;
                        pbEntry.IsActive = true;
                        priceBookEntryList.add(pbEntry);
                    }                    
                }
            }
        }
        
       // System.debug('#priceBookEntryList:'+ JSON.serialize(priceBookEntryList)); 
        if(!priceBookEntryList.isEmpty()){
                         
                Database.UpsertResult[] uprList = Database.upsert(priceBookEntryList, false);              
                for (Database.UpsertResult result : uprList) {
                    if (result.isSuccess()) {                        
                        // Operation was successful, so get the ID of the record that was processed
                        System.debug('Successfully upserted PricebookEntry. PricebookEntry Id:' + result.getId());
                    }
                    else {
                        // Operation failed, so get all errors                
                        for(Database.Error err : result.getErrors()) {
                            System.debug('The following error has occurred.');                    
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('PriceBookEntry fields that affected this error: ' + err.getFields());
                        }
                    }
                }
        }
        /* Region End: Create List of PricebookEntry for insert or update */
    }
    
    /*
    * Method: addLeadProductToStandardPriceBook
    * I/N Parameters : Map of SAP code with price list items : Map<String,List<ProductPriceMasterDTO.PriceListItem>>,
    * Map of SAP code, Map of Currency code with price book entry : Map<String,Map<String,Map<String,PricebookEntry>>>,
    * Product map productMap, Standard price book record
    * O/P: List of Product pricebook entry map with standard pricebook
    * Purpose : To create Standard Pricebook entry with different currency for Lead Products
    */
    public static List<PricebookEntry> addLeadProductToStandardPriceBook(Map<String,List<ProductPriceMasterDTO.PriceListItem>> leadProductPriceMap,
                                                               Map<String,Map<String,Map<String,PricebookEntry>>> mapOfProductPriceBookEntry,
                                                               Map<String,Product2> productMap,
                                                               Pricebook2 standardPriceBook)
    { 
        List<PricebookEntry> stdPricebookEntryList = new List<PricebookEntry>();
        for(String productSAPCode : leadProductPriceMap.keySet()){
            Product2 productRecord = productMap.get(productSAPCode.toUpperCase());
            List<ProductPriceMasterDTO.PriceListItem> priceListItemList = leadProductPriceMap.get(productSAPCode.toUpperCase());   
            if(mapOfProductPriceBookEntry.containsKey(productSAPCode.toUpperCase())){
                Map<String,Map<String,PricebookEntry>> conditionCurrencyMap = mapOfProductPriceBookEntry.get(productSAPCode.toUpperCase());
                Map<String,String> productPBMap = new Map<String,String>();
                for(ProductPriceMasterDTO.PriceListItem priceListItem : priceListItemList){ 
                    if(!conditionCurrencyMap.containsKey(priceListItem.conditionCurrency.toUpperCase())){
                        System.debug('Currency '+priceListItem.conditionCurrency+' not exist for SAP Code:'+productSAPCode);
                        if(!conditionCurrencyMap.containsKey(priceListItem.conditionCurrency.toUpperCase())){
                            String productId = productPBMap.get(priceListItem.conditionCurrency.toUpperCase());
                            if(productId!=String.valueOf(productRecord.Id)){
                                PricebookEntry stdPBEntryRecord = new PricebookEntry();
                                stdPBEntryRecord.Product2Id = productRecord.Id;
                                stdPBEntryRecord.Pricebook2Id = standardPriceBook.Id;
                                stdPBEntryRecord.CurrencyIsoCode = priceListItem.conditionCurrency.toUpperCase();
                                stdPBEntryRecord.UnitPrice = Decimal.valueOf(priceListItem.conditionAmount);
                                stdPBEntryRecord.UseStandardPrice = false;
                                stdPBEntryRecord.IsActive = true;
                                stdPricebookEntryList.add(stdPBEntryRecord);
                                productPBMap.put(priceListItem.conditionCurrency.toUpperCase(),productRecord.Id); 
                            }
                        }
                    }                
                }                
            }else{
                System.debug('Product Price Entry not exist for SAP Code:'+productSAPCode);
                Map<String,String> productPBMap = new Map<String,String>();
                for(ProductPriceMasterDTO.PriceListItem priceListItem : priceListItemList){  
                    if(!productPBMap.containsKey(priceListItem.conditionCurrency.toUpperCase())){  
                        String productId = productPBMap.get(priceListItem.conditionCurrency.toUpperCase());
                        if(productId!=String.valueOf(productRecord.Id)){
                            PricebookEntry stdPBEntryRecord = new PricebookEntry();
                            stdPBEntryRecord.Product2Id = productRecord.Id;
                            stdPBEntryRecord.Pricebook2Id = standardPriceBook.Id;
                            stdPBEntryRecord.CurrencyIsoCode = priceListItem.conditionCurrency.toUpperCase();
                            stdPBEntryRecord.UnitPrice = Decimal.valueOf(priceListItem.conditionAmount);
                            stdPBEntryRecord.UseStandardPrice = false;
                            stdPBEntryRecord.IsActive = true;
                            stdPricebookEntryList.add(stdPBEntryRecord);
                            productPBMap.put(priceListItem.conditionCurrency.toUpperCase(),productRecord.Id);  
                        }                        
                    }
                    
                }
            }
        }
        //System.debug('#stdPricebookEntryList:'+JSON.serialize(stdPricebookEntryList));
        if(!stdPricebookEntryList.isEmpty()){
            Database.UpsertResult[] uprList = Database.upsert(stdPricebookEntryList, false);                
            for (Database.UpsertResult result : uprList) {
                if (result.isSuccess()) {                        
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully upserted PricebookEntry. PricebookEntry Id:' + result.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : result.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('addLeadProductToStandardPriceBook PriceBookEntry fields that affected this error: ' + err.getFields());
                    }
                }
            }
            
        }
        return stdPricebookEntryList;
    }
  
    /*
    * Method: addVariantProductToStandardPriceBook
    * I/N Parameters : Map of SAP code with ProductPrice items with List Item Code i.e Pricebook Name : Map<String,List<ProductPriceMasterDTO.ProductPrice>>,
    * Map of SAP code, Map of Currency code with price book entry : Map<String,Map<String,Map<String,Map<String,PricebookEntry>>>>,
    * Product map productMap, Standard price book record
    * Map of CurrencyCode and ProductId : variantCurrencyMap
    * O/P: List of Product pricebook entry map with standard pricebook
    * Purpose : To create Standard Pricebook entry with different currency for Variant Products
    */ 
    public static void addVariantProductToStandardPriceBook(Pricebook2 standardPriceBook,Map<String,
                                               Map<String,SBQQ__ProductOption__c>> variantLeadProductMap,
                                               Map<String,Set<String>> variantCurrencyMap,
                                               Map<String,Map<String,Map<String,Map<String,PricebookEntry>>>> variantPriceBookMap,
                                               Map<String,List<ProductPriceMasterDTO.ProductPrice>> variantProductPriceListMap)
    {
	  List<PricebookEntry> stdPriceBookEntryList = new List<PricebookEntry>();
		for(String productSAPCode : variantProductPriceListMap.keySet()){
			if(variantPriceBookMap.containsKey(productSAPCode.toUpperCase())){
				Map<String,Map<String,Map<String,PricebookEntry>>> existingVariantPriceBookMap =  variantPriceBookMap.get(productSAPCode.toUpperCase());                
				List<ProductPriceMasterDTO.ProductPrice> productPriceList = variantProductPriceListMap.get(productSAPCode.toUpperCase());                
				for(ProductPriceMasterDTO.ProductPrice productPriceRecord : productPriceList){
					for(ProductPriceMasterDTO.PriceListItem priceListItemRecord : productPriceRecord.priceListItems){
						if(existingVariantPriceBookMap.containsKey(priceListItemRecord.characteristicValue.toUpperCase())){
                            Map<String,SBQQ__ProductOption__c> productVariantMap =  variantLeadProductMap.get(productSAPCode.toUpperCase());
							SBQQ__ProductOption__c productVariantRecord = productVariantMap.get(priceListItemRecord.characteristicValue.toUpperCase());
							Set<String> productCurrencySet = variantCurrencyMap.get(productVariantRecord.SBQQ__OptionalSKU__c);
							if(!productCurrencySet.contains(priceListItemRecord.conditionCurrency.toUpperCase())){
								PricebookEntry pbEntry = new PricebookEntry();
								pbEntry.Product2Id = productVariantRecord.SBQQ__OptionalSKU__c;
								pbEntry.Pricebook2Id = standardPriceBook.Id;
								pbEntry.CurrencyIsoCode = priceListItemRecord.conditionCurrency.toUpperCase();
								pbEntry.UnitPrice = Decimal.valueOf(priceListItemRecord.conditionAmount);
								pbEntry.UseStandardPrice = false;
								pbEntry.IsActive = true;
								stdPriceBookEntryList.add(pbEntry);
							}
						}else{
							System.debug(priceListItemRecord.characteristicValue +' does not exist for LeadProduct' +productSAPCode);
						}                      
					}
				}
			}else{
				System.debug(productSAPCode+' not exist in currentMap');
				Map<String,String> productPBMap = new Map<String,String>();				
				Map<String,SBQQ__ProductOption__c> productOptionMap = variantLeadProductMap.get(productSAPCode.toUpperCase());
				for(ProductPriceMasterDTO.ProductPrice productPriceRecord : variantProductPriceListMap.get(productSAPCode.toUpperCase())){
					for(ProductPriceMasterDTO.PriceListItem priceListItemRecord : productPriceRecord.priceListItems){
						SBQQ__ProductOption__c productVariantRecord = productOptionMap.get(priceListItemRecord.characteristicValue.toUpperCase());
						PricebookEntry pbEntry = new PricebookEntry();
						pbEntry.Product2Id = productVariantRecord.SBQQ__OptionalSKU__c;
						pbEntry.Pricebook2Id = standardPriceBook.Id;
						pbEntry.CurrencyIsoCode = priceListItemRecord.conditionCurrency.toUpperCase();
						pbEntry.UnitPrice = Decimal.valueOf(priceListItemRecord.conditionAmount);
						pbEntry.UseStandardPrice = false;
						pbEntry.IsActive = true;
						stdPriceBookEntryList.add(pbEntry);
						productPBMap.put(priceListItemRecord.conditionCurrency.toUpperCase(),productVariantRecord.SBQQ__OptionalSKU__c);  
					}					
				}
			}
		}
		//System.debug('#Variant stdPricebookEntryList:'+JSON.serialize(stdPricebookEntryList));
		if(!stdPricebookEntryList.isEmpty()){
                Database.UpsertResult[] uprList = Database.upsert(stdPricebookEntryList, false);                
                for (Database.UpsertResult result : uprList) {
                    if (result.isSuccess()) {                        
                        // Operation was successful, so get the ID of the record that was processed
                        System.debug('Successfully upserted PricebookEntry. PricebookEntry Id:' + result.getId());
                    }
                    else {
                        // Operation failed, so get all errors                
                        for(Database.Error err : result.getErrors()) {
                            System.debug('The following error has occurred.');                    
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('PriceBookEntry fields that affected this error: ' + err.getFields());
                        }
                    }
                }
		}
	}
    
    /*
    * Method : createCustomPriceBook 
    * I/P : Price List Code/PriceBook Name
    * O/P : Map of Pricebook Name and it's record
    * Purpose: To create Price books which are not present in CRM/SF
    */
    public static Map<String,Pricebook2> createCustomPriceBook(Set<String> priceListCodesSet,Map<String,String> priceListCodeMap){
        Map<String,Pricebook2> customPriceBookMap = new Map<String,Pricebook2>();       
        Set<String> priceListCodeNotExistSet = new Set<String>();
        Set<String> priceListCodeExistSet = new Set<String>();
        List<Pricebook2> priceBookList = [Select Id,Name,IsStandard,IsActive From Pricebook2 WHERE Name IN : priceListCodesSet];
        for(Pricebook2 pricebook : priceBookList){
            priceListCodeExistSet.add(pricebook.Name);
        }        
        for(String priceListCode : priceListCodesSet){
            if(!priceListCodeExistSet.contains(priceListCode.toUpperCase())){
                priceListCodeNotExistSet.add(priceListCode.toUpperCase());
            }
        }
        List<Pricebook2> newPriceBookList = new List<Pricebook2>();
        if(!priceListCodeNotExistSet.isEmpty()){           
            for(String priceCode : priceListCodeNotExistSet){
                Pricebook2 priceBook = new Pricebook2();
                priceBook.Name = priceCode.toUpperCase();
                priceBook.IsActive = true;  
                priceBook.Description = priceListCodeMap.get(priceCode.toUpperCase());
                newPriceBookList.add(priceBook);
            }
        }
        System.debug('#newPriceBookList:'+JSON.serialize(newPriceBookList));
        if(!newPriceBookList.isEmpty()){            
                Database.UpsertResult[] uprList = Database.upsert(newPriceBookList, false);                
                for (Database.UpsertResult result : uprList) {
                    if (result.isSuccess()) {                        
                        // Operation was successful, so get the ID of the record that was processed
                        System.debug('Successfully upserted PricebookEntry. PricebookEntry Id:' + result.getId());
                    }
                    else {
                        // Operation failed, so get all errors                
                        for(Database.Error err : result.getErrors()) {
                            System.debug('The following error has occurred.');                    
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('PriceBookEntry fields that affected this error: ' + err.getFields());
                        }
                    }
                }
        }
        
        priceBookList = [Select Id,Name,IsStandard,IsActive,CurrencyIsoCode From Pricebook2 WHERE Name IN : priceListCodesSet];        
        for(Pricebook2 pbRecord : priceBookList){
            customPriceBookMap.put(pbRecord.Name.toUpperCase(),pbRecord);
        }
        return customPriceBookMap;        
    }
    
    /* 
    * Method :getMapOfProductPriceBookEntry 
    * I/P : Product SAP Material Code
    * O/P : Map of CurrencyCode,PriceBookEntry,SAP Material Code
    * Purpose: To create Map of CurrencyCode,PriceBookEntry,SAP Material Code
    */
    public static Map<String,Map<String,Map<String,PricebookEntry>>> getMapOfProductPriceBookEntry(Set<String> productSAPMaterialCode){        
        
        Map<String,Map<String,Map<String,PricebookEntry>>> existingProductPriceBookMap = new Map<String,Map<String,Map<String,PricebookEntry>>>();
        
        List<Product2> productList = [Select Id, Name, SAP_Material_Ref__c,ProductCode,
                                      (Select Id, Name, Pricebook2Id,Pricebook2.Name,Pricebook2.IsStandard, Product2Id,Product2.Name,ProductCode , CurrencyIsoCode,
                                       UnitPrice, IsActive, UseStandardPrice,Valid_From__c,Valid_To__c 
                                       From PricebookEntries)
                                      From Product2 
                                      WHERE SAP_Material_Ref__c IN: productSAPMaterialCode];
        
        for(Product2 productRecord : productList){  
            
            Map<String,Map<String,PricebookEntry>> priceBookEntryMap = new Map<String,Map<String,PricebookEntry>>();
            for(PricebookEntry priceBookEntryRecord : productRecord.PricebookEntries){
                if(!priceBookEntryRecord.Pricebook2.IsStandard){					
                    Map<String,PricebookEntry> existingPBMap = new Map<String,PricebookEntry>();
                    if(!priceBookEntryMap.isEmpty() && priceBookEntryMap.containsKey(priceBookEntryRecord.CurrencyIsoCode)){
                        existingPBMap = priceBookEntryMap.get(priceBookEntryRecord.CurrencyIsoCode);
                        if(!existingPBMap.containsKey(priceBookEntryRecord.Pricebook2.Name.toUpperCase())){
                            existingPBMap.put(priceBookEntryRecord.Pricebook2.Name.toUpperCase(),priceBookEntryRecord);
                            priceBookEntryMap.get(priceBookEntryRecord.CurrencyIsoCode).putAll(existingPBMap);						
                        }                        
                    }else if(!priceBookEntryMap.containsKey(priceBookEntryRecord.CurrencyIsoCode)){						
                        priceBookEntryMap.put(priceBookEntryRecord.CurrencyIsoCode, new Map<String,PricebookEntry>{priceBookEntryRecord.Pricebook2.Name.toUpperCase() =>priceBookEntryRecord});
                    }
                }                          
            }  
          //  System.debug('#PriceBookEntry:'+JSON.serialize(priceBookEntryMap));
            if(!priceBookEntryMap.isEmpty()){
                existingProductPriceBookMap.put(productRecord.SAP_Material_Ref__c.toUpperCase(),priceBookEntryMap);
            }
        }
        //System.debug('#existingProductPriceBookMap:'+JSON.serialize(existingProductPriceBookMap));
        return existingProductPriceBookMap;
    }

    /*
     * Method : getMapOfVariantPricebookEntry
     * I/P : List of Product variants with it's Pricebook
     * O/p : Map of SAP materail code,Currency Code,Pricebook name
    */
    public static Map<String,Map<String,Map<String,Map<String,PricebookEntry>>>> getMapOfVariantPricebookEntry(List<Product2> variantProductList){
        
        Map<String,Map<String,Map<String,Map<String,PricebookEntry>>>> variantPriceBookMap = new Map<String,Map<String,Map<String,Map<String,PricebookEntry>>>>();
       
        Map<String,Set<String>> variantCurrencyMap = new Map<String,Set<String>>();
        for(Product2 productRecord : variantProductList){
            Map<String,Map<String,Map<String,PricebookEntry>>> existingVariantPriceBookMap = new Map<String,Map<String,Map<String,PricebookEntry>>>();
            Map<String,Map<String,PricebookEntry>> priceBookEntryMap = new Map<String,Map<String,PricebookEntry>>();
            Set<String> currencySet = new Set<String>();
            
            for(PricebookEntry priceBookEntryRecord : productRecord.PricebookEntries){
                if(!priceBookEntryRecord.Pricebook2.IsStandard){					
                    Map<String,PricebookEntry> existingPBMap = new Map<String,PricebookEntry>();
                    if(!priceBookEntryMap.isEmpty() && priceBookEntryMap.containsKey(priceBookEntryRecord.Pricebook2.Name.toUpperCase())){
                        existingPBMap = priceBookEntryMap.get(priceBookEntryRecord.Pricebook2.Name.toUpperCase());
                        if(!existingPBMap.containsKey(priceBookEntryRecord.Pricebook2.Name.toUpperCase())){
                            existingPBMap.put(priceBookEntryRecord.CurrencyIsoCode,priceBookEntryRecord);
                            priceBookEntryMap.get(priceBookEntryRecord.Pricebook2.Name.toUpperCase()).putAll(existingPBMap);						
                        }                        
                    }else if(!priceBookEntryMap.containsKey(priceBookEntryRecord.CurrencyIsoCode)){						
                        priceBookEntryMap.put(priceBookEntryRecord.Pricebook2.Name.toUpperCase(), new Map<String,PricebookEntry>{priceBookEntryRecord.CurrencyIsoCode =>priceBookEntryRecord});
                    }
                }                       
            }  
        //    System.debug('#PriceBookEntry:'+JSON.serialize(priceBookEntryMap));
            if(!priceBookEntryMap.isEmpty()){                
                existingVariantPriceBookMap.put(productRecord.Name.toUpperCase(),priceBookEntryMap);
        //        System.debug('#existingVariantPriceBookMap:'+ JSON.serialize(existingVariantPriceBookMap));
                if(!variantPriceBookMap.containsKey(productRecord.ProductCode.toUpperCase())){
                    variantPriceBookMap.put(productRecord.ProductCode.toUpperCase(),existingVariantPriceBookMap);
                }else{
                    System.debug(productRecord.ProductCode.toUpperCase()+'#Aready Exist in variantPriceBookMap');
                    variantPriceBookMap.get(productRecord.ProductCode.toUpperCase()).putAll(existingVariantPriceBookMap);
                }
            }            
        }
       
     //   System.debug('#variantPriceBookMap:'+ JSON.serialize(variantPriceBookMap));
        return variantPriceBookMap;
    }
    
    /*
     * Method : createPriceBookForVariants
     * I/P		: List of Product variants with it's Pricebook
     * Purpose	: To create Pricebook for variants which are not PriceRelevant if PricebookEntry not exist
    */
    public static void createPriceBookForVariants(Pricebook2 standardPriceBook,
                                                  Map<String,Pricebook2> customPriceBookMap,
                                                  Set<String> productSAPMaterialCode)
    {
        System.debug('#createPriceBookForVariants:');
        List<Product2> leadProductList = [Select Id, Name, SAP_Material_Ref__c,ProductCode,
                                          (Select Id, Name, Pricebook2Id,Pricebook2.Name,Pricebook2.IsStandard, Product2Id,Product2.Name,
                                           ProductCode , CurrencyIsoCode,UnitPrice, IsActive, UseStandardPrice,Valid_From__c,Valid_To__c 
                                           From PricebookEntries)
                                          From Product2  
                                          WHERE SAP_Material_Ref__c IN: productSAPMaterialCode];
        //System.debug('#leadProductList:'+JSON.serialize(leadProductList));
        Set<Id> leadProductIdSet = new Set<Id>(new Map<Id, Product2>(leadProductList).keySet());
        Map<String,Set<String>> leadProductStdPbeMap = new Map<String,Set<String>>();
        Map<String,Set<String>> leadProductCustPbeMap = new Map<String,Set<String>>();
        Map<String,Map<String,Set<String>>> leadProductCustPbeCurrMap = new Map<String,Map<String,Set<String>>>();
        for(Product2 productRecord : leadProductList){            
            for(PricebookEntry pbeRecord : productRecord.PricebookEntries){               
                if(pbeRecord.Pricebook2.IsStandard){
                    if(leadProductStdPbeMap.containsKey(productRecord.Id)){
                        leadProductStdPbeMap.get(productRecord.Id).add(pbeRecord.CurrencyIsoCode);
                    }else{
                        leadProductStdPbeMap.put(productRecord.Id,new Set<String>{pbeRecord.CurrencyIsoCode});
                    }
                }else{
                   if(leadProductCustPbeMap.containsKey(productRecord.Id)){
                        leadProductCustPbeMap.get(productRecord.Id).add(pbeRecord.Pricebook2.Name);
                    }else{
                        leadProductCustPbeMap.put(productRecord.Id,new Set<String>{pbeRecord.Pricebook2.Name});
                    } 
                    
                    if(leadProductCustPbeCurrMap.containsKey(productRecord.Id)){
                        Map<String,Set<String>> curMap = leadProductCustPbeCurrMap.get(productRecord.Id);
                        if(curMap.containskey(pbeRecord.Pricebook2.Name)){
                            curMap.get(pbeRecord.Pricebook2.Name).add(pbeRecord.CurrencyIsoCode); 
                        }else{
                            curMap.put(pbeRecord.Pricebook2.Name,new Set<String>{pbeRecord.CurrencyIsoCode}); 
                        }                                               
                        leadProductCustPbeCurrMap.get(productRecord.Id).putAll(curMap);
                    }else{                       
                        leadProductCustPbeCurrMap.put(productRecord.Id,new Map<String,Set<String>>{pbeRecord.Pricebook2.Name =>new Set<String>{pbeRecord.CurrencyIsoCode}});       
                    } 
                }
            }            
        }
        //System.debug('#leadProductIdSet:'+JSON.serialize(leadProductIdSet));
        System.debug('#leadProductCustPbeCurrMap:'+JSON.serialize(leadProductCustPbeCurrMap));
       // System.debug('#leadProductStdPbeMap:'+JSON.serialize(leadProductStdPbeMap));  
       // System.debug('#leadProductCustPbeMap:'+JSON.serialize(leadProductCustPbeMap));     
        List<SBQQ__ProductOption__c> productOptionList = [Select Id,Name,SBQQ__OptionalSKU__c,SBQQ__ProductName__c,SBQQ__ProductCode__c, 
                                                          SBQQ__ConfiguredSKU__r.Name,SBQQ__ConfiguredSKU__r.SAP_Material_Ref__c,
                                                          SBQQ__ConfiguredSKU__r.isActive,Price_Relevant__c,SBQQ__Bundled__c,SBQQ__Selected__c
                                                          From 
                                                          SBQQ__ProductOption__c
                                                          Where SBQQ__ConfiguredSKU__c IN: leadProductIdSet
                                                          AND Price_Relevant__c = FALSE
                                                          ];
        Map<String,Set<String>> leadProductWithVariantMap = new Map<String,Set<String>>(); 
        Set<String> variantIds = new Set<String>();
        for(SBQQ__ProductOption__c option : productOptionList){
            variantIds.add(option.SBQQ__OptionalSKU__c);
            if(leadProductWithVariantMap.containsKey(option.SBQQ__ConfiguredSKU__c)){
                leadProductWithVariantMap.get(option.SBQQ__ConfiguredSKU__c).add(option.SBQQ__OptionalSKU__c);
            }else{
                leadProductWithVariantMap.put(option.SBQQ__ConfiguredSKU__c,new Set<String>{option.SBQQ__OptionalSKU__c});
            }
        }
        // System.debug('#leadProductWithVariantMap:'+JSON.serialize(leadProductWithVariantMap));  
          
        List<Product2> variantProductList = [Select Id, Name, SAP_Material_Ref__c,ProductCode,
                                          (Select Id, Name, Pricebook2Id,Pricebook2.Name,Pricebook2.IsStandard, Product2Id,Product2.Name,
                                           ProductCode , CurrencyIsoCode,UnitPrice, IsActive, UseStandardPrice,Valid_From__c,Valid_To__c 
                                           From PricebookEntries)
                                          From Product2  
                                          WHERE Id IN: variantIds];
        //System.debug('#variantProductList:'+JSON.serialize(variantProductList));   
        Map<String,Set<String>> variantProductStdPbeMap = new Map<String,Set<String>>();
        Map<String,Set<String>> variantProductCustPbeMap = new Map<String,Set<String>>();
        Map<String,Map<String,Set<String>>> variantProductCustPbeCurMap = new Map<String,Map<String,Set<String>>>();
        
        for(Product2 productRecord : variantProductList){
            for(PricebookEntry pbeRecord : productRecord.PricebookEntries){               
                if(pbeRecord.Pricebook2.IsStandard){
                    if(variantProductStdPbeMap.containsKey(productRecord.Id)){
                        variantProductStdPbeMap.get(productRecord.Id).add(pbeRecord.CurrencyIsoCode);
                    }else{
                        variantProductStdPbeMap.put(productRecord.Id,new Set<String>{pbeRecord.CurrencyIsoCode});
                    }
                }else{
                   if(variantProductCustPbeMap.containsKey(productRecord.Id)){
                        variantProductCustPbeMap.get(productRecord.Id).add(pbeRecord.Pricebook2.Name);
                    }else{
                        variantProductCustPbeMap.put(productRecord.Id,new Set<String>{pbeRecord.Pricebook2.Name});
                    } 
                    
                    if(variantProductCustPbeCurMap.containsKey(productRecord.Id)){
                        Map<String,Set<String>> curMap = variantProductCustPbeCurMap.get(productRecord.Id);
                        if(curMap.containskey(pbeRecord.Pricebook2.Name)){
                            curMap.get(pbeRecord.Pricebook2.Name).add(pbeRecord.CurrencyIsoCode); 
                        }else{
                            curMap.put(pbeRecord.Pricebook2.Name,new Set<String>{pbeRecord.CurrencyIsoCode}); 
                        }                                               
                        variantProductCustPbeCurMap.get(productRecord.Id).putAll(curMap);
                    }else{                       
                        variantProductCustPbeCurMap.put(productRecord.Id,new Map<String,Set<String>>{pbeRecord.Pricebook2.Name =>new Set<String>{pbeRecord.CurrencyIsoCode}});
                   		
                    } 
                }
            }            
        }
        //System.debug('#variantProductCustPbeMap:'+JSON.serialize(variantProductCustPbeMap));  
        System.debug('#variantProductCustPbeCurMap:'+JSON.serialize(variantProductCustPbeCurMap));   
        List<PricebookEntry> stdPriceBookEntryList = new List<PricebookEntry>();
        List<PricebookEntry> custmPriceBookEntryList = new List<PricebookEntry>();
        
        if(!leadProductWithVariantMap.isEmpty()){
            for(String leadProductId : leadProductWithVariantMap.keySet()){
                Set<String> productVariants = leadProductWithVariantMap.get(leadProductId);                 
                Set<String> prductStdCurrencyCodes = leadProductStdPbeMap.get(leadProductId);
                Set<String> prductCustmPriceBooks = leadProductCustPbeMap.get(leadProductId);
                Map<String,Set<String>> productPbeCurMap =   leadProductCustPbeCurrMap.get(leadProductId);
                System.debug('#productPbeCurMap:'+JSON.serialize(productPbeCurMap));
               // System.debug('#productVariants:'+JSON.serialize(productVariants));  
                System.debug('#prductStdCurrencyCodes:'+JSON.serialize(prductStdCurrencyCodes));  
                System.debug('#prductCustmPriceBooks:'+JSON.serialize(prductCustmPriceBooks));  
                for(String variantId : productVariants){
                    Set<String> variantStdCurrencyCodes = variantProductStdPbeMap.get(variantId);
                    Set<String> variantCustmPriceBooks = variantProductCustPbeMap.get(variantId);
                    Map<String,Set<String>> variantCustPbCurrMap = variantProductCustPbeCurMap.get(variantId);
                    System.debug('#variantStdCurrencyCodes:'+JSON.serialize(variantStdCurrencyCodes));  
                    System.debug('#variantCustmPriceBooks:'+JSON.serialize(variantCustmPriceBooks));      
                    System.debug('#variantCustPbCurrMap:'+JSON.serialize(variantCustPbCurrMap));  
              
                    // Check Standard book entry for currency exist or not if not then add new currency entry for the product
                    for(String currencyCode : prductStdCurrencyCodes){
                        if(variantStdCurrencyCodes!=null && !variantStdCurrencyCodes.contains(currencyCode)){
                            PricebookEntry standardPriceBookEntry = new PricebookEntry();
                            standardPriceBookEntry.Pricebook2Id = standardPriceBook.Id;
                            standardPriceBookEntry.Product2Id = Id.valueOf(variantId);
                            standardPriceBookEntry.CurrencyIsoCode = currencyCode;
                            standardPriceBookEntry.UnitPrice = 0;
                            standardPriceBookEntry.UseStandardPrice = false;
                            standardPriceBookEntry.IsActive = true;
                            stdPriceBookEntryList.add(standardPriceBookEntry);
                        }else if(variantStdCurrencyCodes.isEmpty() || variantStdCurrencyCodes==null){
                            PricebookEntry standardPriceBookEntry = new PricebookEntry();
                            standardPriceBookEntry.Pricebook2Id = standardPriceBook.Id;
                            standardPriceBookEntry.Product2Id = Id.valueOf(variantId);
                            standardPriceBookEntry.CurrencyIsoCode = currencyCode;
                            standardPriceBookEntry.UnitPrice = 0;
                            standardPriceBookEntry.UseStandardPrice = false;
                            standardPriceBookEntry.IsActive = true;
                            stdPriceBookEntryList.add(standardPriceBookEntry);
                        }
                    }
                    
                    for(String pbName : productPbeCurMap.keySet()){  
                        
                        if(!variantCustPbCurrMap.isEmpty() || variantCustPbCurrMap != null){
                            Set<String> variantCurCodeSet = variantCustPbCurrMap.get(pbName);
                            for(String curCode : productPbeCurMap.get(pbName)){
                                if(!variantCurCodeSet.contains(curCode)){
                                    Pricebook2 custmPriceBook = customPriceBookMap.get(pbName);
                                    PricebookEntry customPriceBookEntry = new PricebookEntry();
                                    customPriceBookEntry.Pricebook2Id = custmPriceBook.Id;
                                    customPriceBookEntry.Product2Id = Id.valueOf(variantId);
                                    customPriceBookEntry.CurrencyIsoCode = curCode;
                                    customPriceBookEntry.UnitPrice = 0;
                                    customPriceBookEntry.UseStandardPrice = false;
                                    customPriceBookEntry.IsActive = true;
                                    custmPriceBookEntryList.add(customPriceBookEntry);
                                }
                            }
                        }else{
                            // if Currency code entry not exist in Custom Pricebook
                            for(String curCode : productPbeCurMap.get(pbName)){
                                Pricebook2 custmPriceBook = customPriceBookMap.get(pbName);
                                PricebookEntry customPriceBookEntry = new PricebookEntry();
                                customPriceBookEntry.Pricebook2Id = custmPriceBook.Id;
                                customPriceBookEntry.Product2Id = Id.valueOf(variantId);
                                customPriceBookEntry.CurrencyIsoCode = curCode;
                                customPriceBookEntry.UnitPrice = 0;
                                customPriceBookEntry.UseStandardPrice = false;
                                customPriceBookEntry.IsActive = true;
                                custmPriceBookEntryList.add(customPriceBookEntry);
                            }                            
                        }
                    }
                    /*
                    for(String pbName : prductCustmPriceBooks){                        
                        if(variantCustmPriceBooks!=null && !variantCustmPriceBooks.contains(pbName)){                           
                            Pricebook2 custmPriceBook = customPriceBookMap.get(pbName);
                            PricebookEntry customPriceBookEntry = new PricebookEntry();
                            customPriceBookEntry.Pricebook2Id = custmPriceBook.Id;
                            customPriceBookEntry.Product2Id = Id.valueOf(variantId);
                            customPriceBookEntry.CurrencyIsoCode = custmPriceBook.CurrencyIsoCode;
                            customPriceBookEntry.UnitPrice = 0;
                            customPriceBookEntry.UseStandardPrice = false;
                            customPriceBookEntry.IsActive = true;
                            custmPriceBookEntryList.add(customPriceBookEntry);
                        }else{
                            Pricebook2 custmPriceBook = customPriceBookMap.get(pbName);
                            PricebookEntry customPriceBookEntry = new PricebookEntry();
                            customPriceBookEntry.Pricebook2Id = custmPriceBook.Id;
                            customPriceBookEntry.Product2Id = Id.valueOf(variantId);
                            customPriceBookEntry.CurrencyIsoCode = custmPriceBook.CurrencyIsoCode;
                            customPriceBookEntry.UnitPrice = 0;
                            customPriceBookEntry.UseStandardPrice = false;
                            customPriceBookEntry.IsActive = true;
                            custmPriceBookEntryList.add(customPriceBookEntry);
                        }
                    }*/
                    
                }
            }
        }
        System.debug('#stdPriceBookEntryList 111:'+JSON.serialize(stdPriceBookEntryList));
        if(!stdPriceBookEntryList.isEmpty()){
            insert stdPriceBookEntryList;
        }
        System.debug('#custmPriceBookEntryList 222:'+JSON.serialize(custmPriceBookEntryList));
         if(!custmPriceBookEntryList.isEmpty()){
            insert custmPriceBookEntryList;
        }
    }
    
   
    
    /* Below code not in use

public static Map<String,Map<String,List<PricebookEntry>>> getExistingProductPriceBookEntryMap(Set<String> productSAPMaterialCode){
Map<String,Map<String,List<PricebookEntry>>> existingProductPriceBookMap = new Map<String,Map<String,List<PricebookEntry>>>();
List<Product2> productList = [Select Id, Name, SAP_Material_Ref__c,ProductCode,
(Select Id, Name, Pricebook2Id,Pricebook2.Name,Pricebook2.IsStandard, Product2Id,Product2.Name,ProductCode , CurrencyIsoCode,
UnitPrice, IsActive, UseStandardPrice,Valid_From__c,Valid_To__c 
From PricebookEntries)
From Product2 
WHERE SAP_Material_Ref__c IN: productSAPMaterialCode];

for(Product2 productRecord : productList){            
Map<String,List<PricebookEntry>> priceBookEntryMap = new Map<String,List<PricebookEntry>>();            
for(PricebookEntry priceBookEntryRecord : productRecord.PricebookEntries){
if(!priceBookEntryRecord.Pricebook2.IsStandard){
if(!priceBookEntryMap.isEmpty() && priceBookEntryMap.containsKey(priceBookEntryRecord.CurrencyIsoCode)){
priceBookEntryMap.get(priceBookEntryRecord.CurrencyIsoCode).add(priceBookEntryRecord);
}else if(!priceBookEntryMap.containsKey(priceBookEntryRecord.CurrencyIsoCode)){
priceBookEntryMap.put(priceBookEntryRecord.CurrencyIsoCode, new List<PricebookEntry>{priceBookEntryRecord});
}
}                          
}  
System.debug('#PriceBookEntry:'+JSON.serialize(priceBookEntryMap));
if(!priceBookEntryMap.isEmpty()){
existingProductPriceBookMap.put(productRecord.SAP_Material_Ref__c,priceBookEntryMap);
}
}
System.debug('#existingProductPriceBookMap:'+JSON.serialize(existingProductPriceBookMap));
return existingProductPriceBookMap;
}

public static Map<String,PricebookEntry> getProductSTDPriceBookEntryMap(Set<String> productIds){
Map<String,PricebookEntry> productPriceBookEntryMap = new Map<String,PricebookEntry>();
List<PricebookEntry> productSTDPriceBookEntryList = new  List<PricebookEntry>();

productSTDPriceBookEntryList = [SELECT Id, Name, Pricebook2Id,Pricebook2.Name, Product2Id,Product2.Name,Product2.SAP_Material_Ref__c,
ProductCode , CurrencyIsoCode, UnitPrice, IsActive, UseStandardPrice,Pricebook2.IsStandard
From PricebookEntry 
WHERE IsActive = TRUE AND Product2Id IN:productIds
AND Pricebook2.IsStandard = TRUE];

for(PricebookEntry pbeRecord : productSTDPriceBookEntryList){
productPriceBookEntryMap.put(pbeRecord.Product2Id,pbeRecord);
}
return productPriceBookEntryMap;
}

public static Map<String,List<PricebookEntry>> getProductCustomPriceBookEntryMap(Set<String> productIds){
Map<String,List<PricebookEntry>> pbEntryMap = new Map<String,List<PricebookEntry>>();
List<PricebookEntry> priceBookEntryList = new  List<PricebookEntry>();        
priceBookEntryList = [SELECT Id, Name, Pricebook2Id,Pricebook2.Name, Product2Id,Product2.Name,Product2.SAP_Material_Ref__c,
ProductCode , CurrencyIsoCode, UnitPrice, IsActive, UseStandardPrice,
Pricebook2.IsStandard
From PricebookEntry 
WHERE IsActive = TRUE AND Product2Id IN:productIds
AND Pricebook2.IsStandard = FALSE];


for(PricebookEntry pbEntryRecord : priceBookEntryList){
if(!pbEntryMap.isEmpty() && !pbEntryMap.containsKey(pbEntryRecord.CurrencyIsoCode)){
pbEntryMap.get(pbEntryRecord.Product2.SAP_Material_Ref__c).add(pbEntryRecord);
}else if(!pbEntryMap.containsKey(pbEntryRecord.CurrencyIsoCode)){
pbEntryMap.put(pbEntryRecord.Product2.SAP_Material_Ref__c, new List<PricebookEntry>{pbEntryRecord});
}
}        
return pbEntryMap;
}

public static void getProductPriceMasterDetails(){
List<Product2> productList =[SELECT Id, Name, SAP_Material_Ref__c,ProductCode,                             
(Select Id,SBQQ__OptionalSKU__c,SBQQ__ProductName__c,SBQQ__ProductCode__c From SBQQ__Options__r),
(Select Name,IsActive,CurrencyIsoCode,UnitPrice,PriceBook2.Name,Valid_From__c,Valid_To__c 
from PricebookEntries)
FROM Product2
WHERE Id = '01t6D00000BBPcHQAX'];

System.debug('#ProductList:'+JSON.serialize(productList));

Set<String> leadProductIdsSet = new Set<String>();
Set<String> variantProductIdsSet = new Set<String>();
Map<String,SBQQ__ProductOption__c> productVariantMap = new Map<String,SBQQ__ProductOption__c>();

for(Product2 leadProduct : productList){
leadProductIdsSet.add(leadProduct.Id);
for(SBQQ__ProductOption__c option : leadProduct.SBQQ__Options__r){
productVariantMap.put(option.Id,option);
variantProductIdsSet.add(option.SBQQ__OptionalSKU__c);
}
}
System.debug('#leadProductIdsSet:'+JSON.serialize(leadProductIdsSet));
System.debug('#productVariantMap:'+JSON.serialize(productVariantMap));
System.debug('#variantProductIdsSet:'+JSON.serialize(variantProductIdsSet));


Map<String,Product2> variantProductMap = new Map<String,Product2>([SELECT Id, Name, SAP_Material_Ref__c,ProductCode,
(Select Name,IsActive,CurrencyIsoCode,UnitPrice,PriceBook2.Name,
Valid_From__c,Valid_To__c from PricebookEntries)
FROM Product2
WHERE Id IN: variantProductIdsSet]);

System.debug('#variantProductMap:'+JSON.serialize(variantProductMap));

ProductPriceMasterDTO productPriceMasterDTO = new ProductPriceMasterDTO();	
List<ProductPriceMasterDTO.ProductPrice> productPriceMasterList = new List<ProductPriceMasterDTO.ProductPrice>();
for(Product2 leadProduct : productList){             
ProductPriceMasterDTO.ProductPrice productPriceMaster = new ProductPriceMasterDTO.ProductPrice();
productPriceMaster.conditionNo = '';
productPriceMaster.pricingConditionType = 'PR00';     
productPriceMaster.salesOrg = '100'; 
productPriceMaster.sapMaterialCode = String.isNotBlank(leadProduct.SAP_Material_Ref__c)? leadProduct.SAP_Material_Ref__c : '';
productPriceMaster.priceListCode = '';
productPriceMaster.priceListDescription = '';
productPriceMaster.priceListItems = new List<ProductPriceMasterDTO.PriceListItem>();            
for(PriceBookEntry price : leadProduct.PricebookEntries){
ProductPriceMasterDTO.PriceListItem pricebookMaster =new ProductPriceMasterDTO.PriceListItem();
pricebookMaster.conditionAmount = String.valueOf(price.UnitPrice);
pricebookMaster.conditionCurrency = price.CurrencyIsoCode;
pricebookMaster.conditionNo = '';
pricebookMaster.characteristicValue = '';
pricebookMaster.priceListCode = price.PriceBook2.Name;
pricebookMaster.validFrom = price.Valid_From__c!=null? String.valueOf(price.Valid_From__c) : '';
pricebookMaster.validTo = price.Valid_To__c!=null? String.valueOf(price.Valid_To__c) : '';
pricebookMaster.priceListDescription = '';
productPriceMaster.priceListItems.add(pricebookMaster);
} 
System.debug('#productPriceMaster:'+JSON.serialize(productPriceMaster));
productPriceMasterList.add(productPriceMaster);
System.debug('#productPriceMasterList:'+JSON.serialize(productPriceMasterList));
}
productPriceMasterDTO.productPriceList = productPriceMasterList;
System.debug('#productPriceMasterDTO:'+JSON.serialize(productPriceMasterDTO));
}
*/
}