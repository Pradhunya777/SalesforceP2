/********************************
*Name				: ProductDTOServiceHandler
*Description		: To create and update product from SAP to salesforce
*TestMethod			:
*Used In			: ProductDTOService
*CreateDate			: 15-Nov-2021
*LastModifiedDate	: 25-Nov-2021
-------------------------------------------------------
#ModificationDate	: Details
15-11-2011	Created methods to insert and update product from SAP to salesforce
********************************/
public class ProductDTOServiceHandler {
    /*
* Name : createProduct
* Parameter:Product pushed from SAP
* Description: To create or update product in Salesforce 
* CreatedDate: 15-Nov-2021
* LastModifiedDate:16-Nov-2021
*/
    public static Response createProduct(ProductDTO productDTO){   
        Response response;      
        List<Product2> productList = [Select Id,Name,ProductCode,SAP_Material_Ref__c,Product_Group__c,Product_Group_Number__c,
                                      Material_Type__c,Description,Family,CurrencyIsoCode,QuantityUnitOfMeasure,IsActive
                                      From Product2 
                                      Where SAP_Material_Ref__c =: productDTO.sapMaterialRef];
        Product2 product = new Product2();
        if(!productList.isEmpty()){
            product = productList[0];
        }
                
        upsertProductDetails(product,productDTO); //Bind FG Product details
        
        upsert product; // Create or update FG product.        
       
        createStandardPriceBook(new Set<Id>{product.Id});  //Create Standard PriceBooks for Product If not created.
                
        upsertProductFeature(product,productDTO); //Create/update product feature/characterstics/Attributes
               
        upsertProductOption(product, productDTO);  //Create/Update product option/characterstics/Attributes value
        
        response = new Response(productDTO.sapMaterialRef,'true','Success');      
        return response;
    }
    /*
* Name : bindProductDetails
* Parameter: Map of sapMaterialRef with its product data, Existing productset, list of existing product
* Description: To bind add new product in list and update the existing product information
* CreatedDate: 15-Nov-2021
* LastModifiedDate:16-Nov-2021
*/
    public static void upsertProductDetails(Product2 product,ProductDTO productDTO){      
        Map<String,Integer>productFamilyMap = new Map<String,Integer>{
            'Tapeline' => 1,'Cheese Winder' => 2,'Loom' => 3,'Conversion Line' => 4,'Lamicoat' => 5,'Lofil' => 6,
                'Printing' => 7,'Twister' => 8,'Auxiliary' => 9
                };

		product.IsFG__c = true;
        product.SAP_Material_Ref__c = productDTO.sapMaterialRef;
        product.Name = String.isNotBlank(productDTO.name)? productDTO.name : productDTO.sapMaterialRef;
        //product.ProductCode = String.isNotBlank(productDTO.productCode)? productDTO.productCode : '';
        product.Product_Group__c = String.isNotBlank(productDTO.productGroup)? productDTO.productGroup : '';        
        if(String.isNotBlank(productDTO.productGroupNumber)){
            product.Product_Group_Number__c = Decimal.valueOf(productDTO.productGroupNumber);
        }        
        product.Material_Type__c = String.isNotBlank(productDTO.materialType) ? productDTO.materialType : '';
        product.Description = String.isNotBlank(productDTO.description) ? productDTO.description : '';
        product.Family = String.isNotBlank(productDTO.family) ? productDTO.family : '';
        if(String.isNotBlank(productDTO.family) && productFamilyMap.containsKey(productDTO.family)){
            product.SBQQ__SortOrder__c =  Decimal.valueOf(productFamilyMap.get(productDTO.family));
        }
        product.CurrencyIsoCode = String.isNotBlank(productDTO.currencyIsoCode) ? productDTO.currencyIsoCode : '';
        product.QuantityUnitOfMeasure = String.isNotBlank(productDTO.currencyIsoCode) ? productDTO.quantityUnitOfMeasure : 'EA';
        product.IsActive = productDTO.isActive == 'true'? true : false;    
        
        if(String.isNotBlank(productDTO.netWeight)){
            product.Net_Weight__c = Decimal.valueOf(productDTO.netWeight);
        }
        if(String.isNotBlank(productDTO.weightUnit)){
            product.Net_Weight__c = Decimal.valueOf(productDTO.netWeight);
        }
        if(String.isNotBlank(productDTO.weightUnit)){
            product.Weight_Unit__c = Integer.valueOf(productDTO.weightUnit);
        }
        if(String.isNotBlank(productDTO.tod)){
            product.TOD__c = productDTO.tod;
        }
        if(String.isNotBlank(productDTO.division)){
            product.Division__c = productDTO.division;
        }
        
        
    }  
    /*
* Name : bindProductFeature
* Parameter: Map of sapMaterialRef with its product data, Existing productset, list of existing product
* Description: To bind add new product in list and update the existing product information
* CreatedDate: 15-Nov-2021
* LastModifiedDate:16-Nov-2021
*/
    public static List<SBQQ__ProductFeature__c> upsertProductFeature(Product2 product,ProductDTO productDTO ){
        List<SBQQ__ProductFeature__c> exstingProductFeatureList = new List<SBQQ__ProductFeature__c>();
        Set<String> productAttributeNameSet = new Set<String>();
        Set<String> newProductAttributeNameSet = new Set<String>();
        Set<String> existingProductAttributeNameSet = new Set<String>();
        Map<String,String> attributesInternalCharNumMap = new Map<String,String>();
        
        for(productDTO.ProductAttribute productAttribute:  productDTO.attributes){
            if(String.isNotBlank(productAttribute.charDescription)){
                productAttributeNameSet.add(productAttribute.charDescription);  
                if(String.isNotBlank(productAttribute.internalCharNumber)){
                    attributesInternalCharNumMap.put(productAttribute.charDescription,productAttribute.internalCharNumber);
                }                
            }       
        }      
        //System.debug('#productAttributeNameSet 1:'+JSON.serialize(productAttributeNameSet));
        
        exstingProductFeatureList = getProductFeature(product.Id);
        //System.debug('#exstingProductFeatureList 1:'+JSON.serialize(exstingProductFeatureList));
        
        for(SBQQ__ProductFeature__c feature : exstingProductFeatureList){
            if(String.isNotBlank(feature.Name)){
                existingProductAttributeNameSet.add(feature.Name);
            }
        }
        //System.debug('#existingProductAttributeNameSet 1:'+JSON.serialize(existingProductAttributeNameSet));
        
        for(String featureName : productAttributeNameSet){
            if(String.isNotBlank(featureName)){         
                if(!existingProductAttributeNameSet.isEmpty()){
                    if(!existingProductAttributeNameSet.contains(featureName)){
                        newProductAttributeNameSet.add(featureName);
                    }
                }else if(existingProductAttributeNameSet.isEmpty()){
                    newProductAttributeNameSet.add(featureName);
                }
            }
        }   
       // System.debug('#newProductAttributeNameSet 1:'+JSON.serialize(newProductAttributeNameSet));
        for(String newFeatureName : newProductAttributeNameSet){
            SBQQ__ProductFeature__c feature = new SBQQ__ProductFeature__c();
            feature.Name = newFeatureName;
            feature.SBQQ__ConfiguredSKU__c = product.Id;
            feature.SBQQ__MaxOptionCount__c = 1;
            feature.SBQQ__MinOptionCount__c = 1;
            feature.SBQQ__OptionSelectionMethod__c = 'click';
            feature.SBQQ__Number__c = 1;
            if(!attributesInternalCharNumMap.isEmpty() && attributesInternalCharNumMap.containsKey(newFeatureName)){
                feature.Internal_Char_Number__c = attributesInternalCharNumMap.get(newFeatureName);
            }
            exstingProductFeatureList.add(feature);
        }
      //  System.debug('#newFeatureList:'+JSON.serialize(exstingProductFeatureList));        
        if(exstingProductFeatureList!=null && exstingProductFeatureList.size()>0){
            upsert exstingProductFeatureList;           
        }
       // System.debug('#ProductFeatureList:'+JSON.serialize(exstingProductFeatureList)); 
        return exstingProductFeatureList;
    }
    
    /*
* Name : bindProductOption
* Parameter: Map of sapMaterialRef with its product data, Existing productset, list of existing product
* Description: To bind add new product in list and update the existing product information
* CreatedDate: 15-Nov-2021
* LastModifiedDate:15-Nov-2021
*/
    public static List<SBQQ__ProductOption__c> upsertProductOption(Product2 product,ProductDTO productDTO){
        List<SBQQ__ProductOption__c> productOptionList;
        Map<String,SBQQ__ProductFeature__c> existingProductFeaturesMap = new Map<String,SBQQ__ProductFeature__c>();
		Map<String, Map<String,SBQQ__ProductOption__c>> existingProductVariantMap = new Map<String, Map<String,SBQQ__ProductOption__c>>();
		
        List<SBQQ__ProductOption__c> existingProductOptions = getProductOption(product.Id);
        for(SBQQ__ProductOption__c productOption : existingProductOptions){
            Map<String,SBQQ__ProductOption__c> variantMap = new Map<String,SBQQ__ProductOption__c>();       
			if(!existingProductVariantMap.isEmpty() && existingProductVariantMap.containsKey(productOption.Internal_Char_Number__c)){
				variantMap.put(productOption.SBQQ__ProductName__c.toUpperCase(),productOption);
                existingProductVariantMap.get(productOption.Internal_Char_Number__c).putAll(variantMap);	
			}else{
				existingProductVariantMap.put(productOption.Internal_Char_Number__c,new Map<String,SBQQ__ProductOption__c>{productOption.SBQQ__ProductName__c => productOption});
			}
        }       
      //  System.debug('#existingProductVariantMap:'+ JSON.serialize(existingProductVariantMap));
        List<SBQQ__ProductFeature__c> existingProductFeatures = getProductFeature(product.Id);       
        for(SBQQ__ProductFeature__c feature : existingProductFeatures){
            if(String.isNotBlank(feature.Name)){
                existingProductFeaturesMap.put(feature.Name,feature);
            }
        }
        Set<String> internalCharValuesSet = new Set<String>();
        Map<String,List<ProductDTO.ProductAttributeValues>> productAttributeMap = new Map<String,List<ProductDTO.ProductAttributeValues>>();
        Map<String,ProductDTO.ProductAttributeValues> productAttributeValuesMap = new Map<String,ProductDTO.ProductAttributeValues>();  
        Map<String,Map<String,ProductDTO.ProductAttributeValues>> internalCharAttributeValuesMap = new Map<String,Map<String,ProductDTO.ProductAttributeValues>>();
		Map<String,List<ProductDTO.ProductAttributeValues>> internalCharAttributeMap = new Map<String,List<ProductDTO.ProductAttributeValues>>();
		
        for(productDTO.ProductAttribute productAttribute:  productDTO.attributes){ 
      //      System.debug('#productAttribute.internalCharNumber:'+productAttribute.internalCharNumber);
			 internalCharValuesSet.add(productAttribute.internalCharNumber);
			 if(String.isNotBlank(productAttribute.internalCharNumber)){
                if(productAttribute.attributeValues!=null || !productAttribute.attributeValues.isEmpty()){
                    internalCharAttributeMap.put(productAttribute.internalCharNumber,productAttribute.attributeValues);
                }               
                for(ProductDTO.ProductAttributeValues productAttributeValue: ProductAttribute.attributeValues){
       //             System.debug('#productAttributeValue:'+JSON.serialize(productAttributeValue));
                    if(String.isNotBlank(productAttribute.internalCharNumber)){                       
						Map<String,ProductDTO.ProductAttributeValues> interCharMap = new Map<String,ProductDTO.ProductAttributeValues>();
						if(!internalCharAttributeValuesMap.isEmpty() && internalCharAttributeValuesMap.containsKey(productAttribute.internalCharNumber)){
							interCharMap.put(productAttributeValue.characteristicValue,productAttributeValue);
							internalCharAttributeValuesMap.get(productAttribute.internalCharNumber).putAll(interCharMap);
						}else{
							internalCharAttributeValuesMap.put(productAttribute.internalCharNumber,new Map<String,ProductDTO.ProductAttributeValues> {productAttributeValue.characteristicValue => productAttributeValue});
						}
		//				System.debug('#1 internalCharAttributeValuesMap:'+JSON.serialize(internalCharAttributeValuesMap));                        
                    }                
                }
            }
        }       
    //    System.debug('#internalCharValuesSet:'+JSON.serialize(internalCharValuesSet));
    //    System.debug('#internalCharAttributeValuesMap:'+JSON.serialize(internalCharAttributeValuesMap));
        List<Product2> productForOptionList = getProductsBySAPMaterialRefNumber(productDTO.sapMaterialRef);        
        List<Product2> newProductList = createProductsForOptions(productDTO,productForOptionList,internalCharAttributeValuesMap,internalCharValuesSet);   
   //     System.debug('#Missing Products:'+ JSON.serialize(newProductList));
        if(newProductList!=null && newProductList.size()>0){           
            upsert newProductList;           
            Set<Id> productIdSet = new Set<Id>(new Map<Id, Product2>(newProductList).keySet());
            //Create Standard PriceBooks for variants
            createStandardPriceBook(productIdSet);
        }        
        newProductList = getProductsBySAPMaterialRefNumber(productDTO.sapMaterialRef);
        productOptionList = createProductOptions(product,productDTO,newProductList,existingProductFeaturesMap,existingProductVariantMap,internalCharAttributeMap);      
	//	System.debug('#ProductOptionList:'+ JSON.serialize(productOptionList));       
        upsert productOptionList;       
        return productOptionList;
    }
    
    //Created : 19-Jan-2022
    public static List<Product2> createProductsForOptions(ProductDTO productDTO,List<Product2> productForOptionList,
                                                          Map<String,Map<String,ProductDTO.ProductAttributeValues>> internalCharAttributeValuesMap,
                                                          Set<String> internalCharValuesSet)
    {
        System.debug('createProductForOption'); 
        List<Product2> newProductList = new List<Product2>();
		Map<String,Map<String,Product2>> existingInternalCharProductMap= new Map<String,Map<String,Product2>>();
        for(Product2 productRecord : productForOptionList){            
			if(String.isNotBlank(productRecord.Internal_Char_Number__c)){
				Map<String,Product2> productMap = new Map<String,Product2>();
				if(!existingInternalCharProductMap.isEmpty() && existingInternalCharProductMap.containsKey(productRecord.Internal_Char_Number__c)){
					productMap.put(productRecord.Name,productRecord);
					existingInternalCharProductMap.get(productRecord.Internal_Char_Number__c).putAll(productMap);
				}else{					
				existingInternalCharProductMap.put(productRecord.Internal_Char_Number__c,new Map<String,Product2>{productRecord.Name => productRecord});
				}
			}
        }      
        //System.debug('#existingInternalCharProductMap 1:'+JSON.serialize(existingInternalCharProductMap));
        if(productForOptionList.isEmpty()){
           // System.debug('productForOptionList is empty'); 
            for(productDTO.ProductAttribute productAttribute:  productDTO.attributes){
                for(ProductDTO.ProductAttributeValues productAttributeValue: ProductAttribute.attributeValues){
                  //  System.debug('#1'+ productAttributeValue.characteristicValue); 
                    Product2 productValue = new Product2();
                    productValue.Name = productAttributeValue.characteristicValue;
                    productValue.ProductCode = productDTO.sapMaterialRef;                   
                    productValue.Description = productAttributeValue.charDescription;                    
                    productValue.CurrencyIsoCode = productDTO.currencyIsoCode;
                    productValue.IsActive = productAttributeValue.isActive == 'true'? true: false;
                    productValue.Internal_Char_Number__c = productAttribute.internalCharNumber;
                    newProductList.add(productValue);
                }
            }
           // System.debug('#newProductList 1:'+JSON.serialize(newProductList)); 
        }else if(!productForOptionList.isEmpty()){
           // System.debug('productOption not is empty'); 
            for(string internalCharNumber : internalCharValuesSet){
                Map<String,ProductDTO.ProductAttributeValues> productAttributeValueMap = internalCharAttributeValuesMap.get(internalCharNumber);
            //    System.debug('#productAttributeValueMap:'+ JSON.serialize(productAttributeValueMap));
                if(!existingInternalCharProductMap.isEmpty() && !existingInternalCharProductMap.containsKey(internalCharNumber)){  
					Map<String,Product2> existingProductMap = existingInternalCharProductMap.get(internalCharNumber);
					for(ProductDTO.ProductAttributeValues attributeValue : productAttributeValueMap.values()){
						if(!existingProductMap.isEmpty() && !existingProductMap.containsKey(attributeValue.characteristicValue)){  
					//	    System.debug('#2'+ attributeValue.characteristicValue);                    
							Product2 productValue = new Product2();
							productValue.Name = attributeValue.characteristicValue;
							productValue.ProductCode = productDTO.sapMaterialRef;                   
							productValue.Description = attributeValue.charDescription;                    
							productValue.CurrencyIsoCode = productDTO.currencyIsoCode;
							productValue.IsActive = attributeValue.isActive == 'true'? true: false; 
							productValue.Internal_Char_Number__c = internalCharNumber;								
							newProductList.add(productValue);                   
						}/*else if(!existingProductMap.isEmpty() && existingProductMap.containsKey(attributeValue.characteristicValue)){
					//	    System.debug('#3:'+ attributeValue.characteristicValue );
							Product2 productValue = existingProductMap.get(attributeValue.characteristicValue);
							productValue.Name = attributeValue.characteristicValue;
							productValue.ProductCode = productDTO.sapMaterialRef;            
							productValue.Description = attributeValue.charDescription;                    
							productValue.CurrencyIsoCode = productDTO.currencyIsoCode;
							productValue.IsActive = attributeValue.isActive == 'true'? true: false;
							newProductList.add(productValue);                    
						}*/
					}         
                }else if(!existingInternalCharProductMap.isEmpty() && existingInternalCharProductMap.containsKey(internalCharNumber)){
					Map<String,Product2> existingProductMap = existingInternalCharProductMap.get(internalCharNumber);
					for(ProductDTO.ProductAttributeValues attributeValue : productAttributeValueMap.values()){
						if(!existingProductMap.isEmpty() && !existingProductMap.containsKey(attributeValue.characteristicValue)){  
						 //   System.debug('#4'+ attributeValue.characteristicValue);                    
							Product2 productValue = new Product2();
							productValue.Name = attributeValue.characteristicValue;
							productValue.ProductCode = productDTO.sapMaterialRef;                   
							productValue.Description = attributeValue.charDescription;                    
							productValue.CurrencyIsoCode = productDTO.currencyIsoCode;
							productValue.IsActive = attributeValue.isActive == 'true'? true: false; 
							productValue.Internal_Char_Number__c = internalCharNumber;								
							newProductList.add(productValue);                   
						}
					}
				}
            }          
        }
        return newProductList;
    }
    
  //Date: 19-Jan-2022
  public static List<SBQQ__ProductOption__c> createProductOptions(Product2 product,ProductDTO productDTO,List<Product2> newProductList,
                                                                   Map<String,SBQQ__ProductFeature__c> existingProductFeaturesMap,                                                                   
																   Map<String, Map<String,SBQQ__ProductOption__c>> existingProductVariantMap,
                                                                   Map<String,List<ProductDTO.ProductAttributeValues>> internalCharAttributeMap
                                                                   )
    {       
        System.debug('#createProductOption:');  
    //    System.debug('#existingProductVariantMap'+JSON.serialize(existingProductVariantMap));
    //    System.debug('#internalCharAttributeMap'+JSON.serialize(internalCharAttributeMap));       
    //    System.debug('#newProductList'+JSON.serialize(newProductList));
        
        List<SBQQ__ProductOption__c> productOptionList = new List<SBQQ__ProductOption__c>();        
        Map<String,Map<String,Product2>> existingInternalCharProductMap= new Map<String,Map<String,Product2>>();
        for(Product2 productRecord : newProductList){
            if(String.isNotBlank(productRecord.Internal_Char_Number__c)){
                Map<String,Product2> internalProductMap = new Map<String,Product2>();
                if(!existingInternalCharProductMap.isEmpty() && existingInternalCharProductMap.containsKey(productRecord.Internal_Char_Number__c)){
                    internalProductMap.put(productRecord.Name, productRecord);
                    existingInternalCharProductMap.get(productRecord.Internal_Char_Number__c).putAll(internalProductMap);
                }else{					
                    existingInternalCharProductMap.put(productRecord.Internal_Char_Number__c,new Map<String,Product2>{productRecord.Name => productRecord});
                }
            }
        }    
   //     System.debug('#existingInternalCharProductMap'+JSON.serialize(existingInternalCharProductMap));
        
        for(productDTO.ProductAttribute productAttribute:  productDTO.attributes){
            if(String.isNotBlank(productAttribute.charDescription)){
                SBQQ__ProductFeature__c productFeature = existingProductFeaturesMap.get(productAttribute.charDescription);
                List<ProductDTO.ProductAttributeValues> productAttributeValuesList = internalCharAttributeMap.get(productAttribute.internalCharNumber);
                Map<String,Product2> productMap = existingInternalCharProductMap.get(productAttribute.internalCharNumber);
                Map<String,SBQQ__ProductOption__c> existingProductOptionsMap = existingProductVariantMap.get(productAttribute.internalCharNumber);
                for(ProductDTO.ProductAttributeValues productAttributeValue : productAttributeValuesList){
                    if(String.isNotBlank(productAttributeValue.characteristicValue)){                        
                        Product2 optionalProduct = productMap.get(productAttributeValue.characteristicValue);
                        if(!existingProductOptionsMap.isEmpty() && existingProductOptionsMap.containsKey(productAttributeValue.characteristicValue)){
     //                       System.debug('#1:'+ productAttributeValue.characteristicValue );
                            SBQQ__ProductOption__c productOption = existingProductOptionsMap.get(productAttributeValue.characteristicValue);
      //                      System.debug('#productOption 1:'+JSON.serialize(productOption));                                                    
                            productOption.SBQQ__ConfiguredSKU__c = product.Id;
                            productOption.SBQQ__Feature__c = productFeature.Id;
                            productOption.SBQQ__OptionalSKU__c = optionalProduct.Id;
                            productOption.SBQQ__Quantity__c = 1;
                            productOption.SBQQ__Type__c = 'Component';
                            productOption.SBQQ__Number__c = 1;
                            if(productAttributeValue.defaultValue =='true'){
                                productOption.SBQQ__Selected__c = true;
                            }else{
                                productOption.SBQQ__Selected__c = false;
                            }
                            if(productAttributeValue.priceRelevant == 'true'){
                                productOption.Price_Relevant__c = true;
                                productOption.SBQQ__Bundled__c = false;
                            }else{
                                productOption.Price_Relevant__c = false;
                                productOption.SBQQ__Bundled__c = true;
                            }  
                            productOptionList.add(productOption);
                        }else if(existingProductOptionsMap.isEmpty() || (!existingProductOptionsMap.isEmpty() && !existingProductOptionsMap.containsKey(productAttributeValue.characteristicValue))){
       //                     System.debug('#2:'+ productAttributeValue.characteristicValue );
                            SBQQ__ProductOption__c productOption = new SBQQ__ProductOption__c();
                            productOption.SBQQ__ConfiguredSKU__c = product.Id;
                            productOption.SBQQ__Feature__c = productFeature.Id;
                            productOption.SBQQ__OptionalSKU__c = optionalProduct.Id;
                            productOption.SBQQ__Quantity__c = 1;
                            productOption.SBQQ__Type__c = 'Component';
                            productOption.SBQQ__Number__c = 1;                           
                            if(productAttributeValue.defaultValue =='true'){
                                productOption.SBQQ__Selected__c = true;
                            }else{
                                productOption.SBQQ__Selected__c = false;
                            }
                            if(productAttributeValue.priceRelevant == 'true'){
                                productOption.Price_Relevant__c = true;
                                productOption.SBQQ__Bundled__c = false;
                            }else{
                                productOption.Price_Relevant__c = false;
                                productOption.SBQQ__Bundled__c = true;
                            }  
                            productOptionList.add(productOption);
                        }
                    }
                }
            }
        }
        return productOptionList;
	}
    
    
    
    /*
* Name : getProductsByAttrubeValuesSet
* Parameter: Product Id
* Description: To get all the feature list of Product
* CreatedDate: 16-Nov-2021
* LastModifiedDate:16-Nov-2021
*/
    public static List<Product2> getProductsByAttrubeValuesSet(Set<String> attributeValuesSet ){
        List<Product2> productList =[Select Id,Name,ProductCode,SAP_Material_Ref__c,Product_Group__c,Product_Group_Number__c,
                                     Material_Type__c,Description,Family,CurrencyIsoCode,QuantityUnitOfMeasure,IsActive
                                     From Product2 
                                     WHERE Name IN:attributeValuesSet];
        return productList;
    } 
    
    public static List<Product2> getProductsBySAPMaterialRefNumber(String sapMaterialRef ){
        List<Product2> productList =[Select Id,Name,ProductCode,SAP_Material_Ref__c,Internal_Char_Number__c,Product_Group__c,Product_Group_Number__c,
                                     Material_Type__c,Description,Family,CurrencyIsoCode,QuantityUnitOfMeasure,IsActive
                                     From Product2 
                                     WHERE ProductCode =: sapMaterialRef];
        return productList;
    } 
    
    /*
* Name : getProductFeature
* Parameter: Product Id
* Description: To get all the feature list of Product
* CreatedDate: 16-Nov-2021
* LastModifiedDate:16-Nov-2021
*/
    public static List<SBQQ__ProductFeature__c> getProductFeature(String productId){
        List<SBQQ__ProductFeature__c> productFeatureList = new List<SBQQ__ProductFeature__c>([Select Id,Name,SBQQ__ConfiguredSKU__c,SBQQ__ConfiguredSKU__r.SAP_Material_Ref__c,
                                                                                              SBQQ__MinOptionCount__c,SBQQ__MaxOptionCount__c,SBQQ__OptionSelectionMethod__c,
                                                                                              SBQQ__Number__c,Internal_Char_Number__c
                                                                                              From SBQQ__ProductFeature__c
                                                                                              WHERE SBQQ__ConfiguredSKU__c =: productId 
                                                                                              ORDER BY SBQQ__Number__c]);
        return productFeatureList;
    }
    
    /*
* Name : getProductOption
* Parameter: Product Id
* Description: To get all the product option list of Product
* CreatedDate: 16-Nov-2021
* LastModifiedDate:16-Nov-2021
*/
    public static List<SBQQ__ProductOption__c> getProductOption(String productId){
        List<SBQQ__ProductOption__c> productOptionsList = new List<SBQQ__ProductOption__c>([Select Id,Name,SBQQ__ConfiguredSKU__c,SBQQ__ConfiguredSKU__r.SAP_Material_Ref__c,
                                                                                            SBQQ__OptionalSKU__c,Internal_Char_Number__c,
                                                                                            SBQQ__Feature__c,SBQQ__Feature__r.Name,SBQQ__Quantity__c,SBQQ__QuantityEditable__c,
                                                                                            SBQQ__Selected__c,SBQQ__Bundled__c,Price_Relevant__c,SBQQ__Type__c,SBQQ__Number__c,
                                                                                            SBQQ__ProductName__c,SBQQ__ProductCode__c
                                                                                            From 
                                                                                            SBQQ__ProductOption__c
                                                                                            WHERE SBQQ__ConfiguredSKU__c =: productId
                                                                                            ORDER BY SBQQ__Number__c
                                                                                           ]);
        return productOptionsList;
    }
    
    /*
* Name : createStandardPriceBook
* Parameter: List of Product which do not have standard price book entry
* Description: To bind add new product in list and update the existing product information
* CreatedDate: 15-Nov-2021
* LastModifiedDate:15-Nov-2021
*/
    public static void createStandardPriceBook(Set<Id> productIdSet){      
        //System.debug('Product Ids as Set<Id>: ' + productIdSet);
        Set<String> currencySet = new Set<String>{'INR','USD','EUR'};            
        Pricebook2 standardPriceBook = [SELECT Id FROM Pricebook2 WHERE isStandard = true LIMIT 1];
        List<PricebookEntry> pricebookEntryList = [SELECT Id, Name, Pricebook2Id,Pricebook2.Name,Pricebook2.IsStandard, Product2Id,Product2.Name, 
                                                   CurrencyIsoCode,IsActive, UnitPrice, ProductCode, UseStandardPrice
                                                   FROM PricebookEntry 
                                                   WHERE Product2Id IN:productIdSet 
                                                   AND Pricebook2.IsStandard = TRUE
                                                   ORDER BY Product2Id,Product2.Name,CurrencyIsoCode
                                                  ];
        Map<String,Set<String>> productPBEntryMap = new Map<String,Set<String>>();
        Set<String> pricebookEntrySet = new Set<String>();
        if(pricebookEntryList.size()>0 && pricebookEntryList!=null){
            for(PricebookEntry pricebook : pricebookEntryList){                
                if(productPBEntryMap.containsKey(pricebook.Product2Id)){
                    Set<String> productCurrencySet = productPBEntryMap.get(pricebook.Product2Id);
                    if(!productCurrencySet.contains(pricebook.CurrencyIsoCode)){
                        productPBEntryMap.get(pricebook.Product2Id).add(pricebook.CurrencyIsoCode);
                    }
                }else{
                    productPBEntryMap.put(pricebook.Product2Id,new Set<String>{pricebook.CurrencyIsoCode});
                }
            }
        }  
        
        List<PricebookEntry> newPricebookEntryList = new List<PricebookEntry>();
        for(String productId : productIdSet){
            if(!productPBEntryMap.isEmpty()){
                if(productPBEntryMap.containsKey(productId)){
                    Set<String> productCurrencySet = productPBEntryMap.get(productId);
                    for(String currencyCode: currencySet){
                        if(!productCurrencySet.contains(currencyCode)){
                            PricebookEntry standardPriceBookEntry = new PricebookEntry();
                            standardPriceBookEntry.Pricebook2Id = standardPriceBook.Id;
                            standardPriceBookEntry.Product2Id = Id.valueOf(productId);
                            standardPriceBookEntry.CurrencyIsoCode = currencyCode;
                            standardPriceBookEntry.UnitPrice = 0;
                            standardPriceBookEntry.UseStandardPrice = false;
                            standardPriceBookEntry.IsActive = true;
                            newPricebookEntryList.add(standardPriceBookEntry);
                        }
                    }
                }
            }else{
                for(String currencyCode: currencySet){                   
                    PricebookEntry standardPriceBookEntry = new PricebookEntry();
                    standardPriceBookEntry.Pricebook2Id = standardPriceBook.Id;
                    standardPriceBookEntry.Product2Id = Id.valueOf(productId);
                    standardPriceBookEntry.CurrencyIsoCode = currencyCode;
                    standardPriceBookEntry.UnitPrice = 0;
                    standardPriceBookEntry.UseStandardPrice = false;
                    standardPriceBookEntry.IsActive = true;
                    newPricebookEntryList.add(standardPriceBookEntry);                    
                }
            }
        }      
        if(newPricebookEntryList.size()>0){
             upsert newPricebookEntryList;
        }       
    }
}