public class ProductPlantMasterDTO {
	
    public string sapMaterialCode {get;set;}
   
    public List<PlantDetail> plantDetails{get;set;}
   
    public class PlantDetail{
        public string sapMaterialCode {get;set;}
        public string plantCode {get;set;}
        public string plantName {get;set;}
        public string hsnCode {get;set;}
        public string commodityCode {get;set;}        
    }
}