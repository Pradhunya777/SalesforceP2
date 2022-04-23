public class CurrencyConvertedClass {
    public static Decimal convertCurrencyToINR(Decimal eur){
        Decimal inr = 0.0;
        
        Http h = new Http();
        HTTPRequest req = new HTTPRequest();
        
        req.setEndpoint('https://api.exchangeratesapi.io/latest?access_key=d2de2caf1f733200ea846d5e0f721232');
        req.setMethod('GET');
        
        HTTPResponse res = h.send(req);   
        
        Map<String, object> jsonBody = (map<String, object>)json.deserializeUntyped(res.getBody());
        Map<String, object> mMap = (map<String, object>)jsonBody.get('rates');
        
        Decimal conversionRate = (Decimal)mMap.get('INR');
        inr = eur * conversionRate;
        return inr;
    } 

}