public class SpannicularHttpCall {
    public static void spannicularCallout(){
        Http http = new Http();  
		HttpRequest request = new HttpRequest();
		request.setEndpoint('https://api.spoonacular.com/recipes/complexSearch?apiKey=e1d5f0b00aa84c04aeb30f6881cf6100');
		request.setMethod('GET');

		HttpResponse response = http.send(request);
		System.debug('Response Code '+response.getStatusCode());
		if(response.getStatusCode() == 200){
 		   System.debug('Response '+response.getBody());
		}
    }
    public static void spannicularCalloutWithParameter(String id){
        Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setEndpoint('https://api.spoonacular.com/recipes/'+id+'/information?apiKey=e1d5f0b00aa84c04aeb30f6881cf6100');
		request.setMethod('GET');

		HttpResponse response = http.send(request);
		System.debug('Response Code '+response.getStatusCode());
		if(response.getStatusCode() == 200){
 		   System.debug('Response '+response.getBody());
		}
    }

}