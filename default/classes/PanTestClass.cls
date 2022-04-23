public class PanTestClass {
    public static void getAccessToken(){
        try{
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://staging.eko.in:25004/ekoapi/v1/pan/verify');
            req.setMethod('POST');      
           // req.setHeader('Authorization', authorizationHeader);
           
        }catch(CallOutException e){
            throw e;
        }
        
    }
}