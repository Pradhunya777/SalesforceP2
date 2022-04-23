public class AuthenticationTest{
    /*End point Url to web service callout*/
    private final static String ENP_POINT_URL = 'https://oauthasservices-ldb39be14.ae1.hana.ondemand.com/oauth2/api/v1/token?grant_type=client_credentials';
    private final static String CONSUMER_KEY = '3cb683bc-1d57-3bca-b044-aa03e316e4cc';
    private final static String CONSUMER_SECRET = 'SFDC@1234';
    
    /*To generate Access token Method*/
    public static OAuth getAccessToken(){
        try{
            HttpRequest req = new HttpRequest();
            req.setEndpoint(ENP_POINT_URL);
            req.setMethod('GET');          
            Blob headerValue = Blob.valueOf(CONSUMER_KEY + ':' + CONSUMER_SECRET);
         	String authorizationHeader = 'Basic ' +EncodingUtil.base64Encode(headerValue);
          	req.setHeader('Authorization', authorizationHeader);
            req.setBody('grant_type=client_credentials'+'&client_id='+CONSUMER_KEY +'&client_secret='+CONSUMER_SECRET);
		
            System.debug('REQUESTBODY'+req.getBody());
            req.setTimeout(60000);
            Http http = new Http();
            HttpResponse res = http.send(req);
            System.debug('RESPONSE:'+res);
            System.debug('Body ' + res.getBody());
			System.debug('Status ' + res.getStatus());
			System.debug('Status code ' + res.getStatusCode());

            OAuth objAuthenticationInfo = (OAuth)JSON.deserialize(res.getbody(), OAuth.class);
            return objAuthenticationInfo;
        }catch(CallOutException ce){
            throw ce;
        }
       // return null;
    }
    
    /*To get Access token property*/
    public static OAuth authenticationDetail{
        get{
            if(authenticationDetail == null){
                authenticationDetail = getAccessToken();
            }
            return authenticationDetail;
        }set;
    }
        
    /*To get aouthentication detail Wrapper*/
    public class OAuth{
        public String id{get;set;}
        public String issued_at{get;set;}
        public String instance_url{get;set;}
        public String signature{get;set;}
        public String access_token{get;set;}    
    }   
}