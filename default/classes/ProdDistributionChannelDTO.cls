public class ProdDistributionChannelDTO {
    
	public string sapMaterialCode{get;set;}
    
    public List<DistributionChannel> distributionChannels{get;set;}
    
    public class DistributionChannel{
        public string sapMaterialCode {get;set;}
        public string salesOrg {get;set;}
        public string distribustionChannel {get;set;}
        public string division {get;set;}
        public string longDescription {get;set;}
        public string deliveryUnit {get;set;}
        public string maximumOrderQuanity{get;set;}	//MOQ
        public string materialGroup1 {get;set;}
        public string materialGroup2 {get;set;}
        public string materialGroup3 {get;set;}
        public string materialGroup4 {get;set;}
        public string materialGroup5 {get;set;}
    }
}