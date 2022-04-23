/*
    * Name : ProductDTO
    * Description: To bind details for product which are pulled from SAP to salesforce
    * TestMethod:
    * CreateDate: 12-Nov-2021
 -------------------------------------------------------
#ModificationDate	: Details

*/
global class ProductDTO{
    
    public ProductDTO() {}
    
    public string name;
    public string productCode;     
    public string sapMaterialRef; // Primary Key or External Identifier
    public string description;
    public string materialType;
    public string family;
    public string productGroup;
    public string productGroupNumber;
    public string quantityUnitOfMeasure;
    public string currencyIsoCode;
    public string isActive;
    public string netWeight;
    public string weightUnit;
    public string tod;
    public string programming;
    public string division;
    public List<ProductAttribute> attributes;
    
    public class ProductAttribute {
        public string charDescription; // Primary Key or External Identifier
        public string sapMaterialRef;
        public string internalCharNumber;
        public List<ProductAttributeValues> attributeValues;
    }
    public class ProductAttributeValues{
        public string characteristicValue;   // Primary Key or External Identifier 
        public string charDescription;
        public string description;
        public string defaultValue;
        public string priceRelevant;       
        public string currencyIsoCode;       
        public string isActive; 
    }    
}