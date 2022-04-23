public class Spoonacular {    
   private static final string SPOONACULAR_API = 'https://api.spoonacular.com';
   private static final string APIKEY = '1814e27ba94542f288ca95dc300d0464';
    
   public static void getRandomRecipe(){   
    Http http = new Http();
	HttpRequest request = new HttpRequest();
	request.setEndpoint(SPOONACULAR_API+'/recipes/random?apiKey='+APIKEY);
	request.setMethod('GET');
	HttpResponse response = http.send(request);  
	// If the request is successful, parse the JSON response.
	System.debug('Response code '+response.getStatusCode());
	if(response.getStatusCode() == 200) {
        System.debug('Response'+response.getBody());
    }
   }
    
    public static void getRecipeInformation(String receipeId){   
    Http http = new Http();
	HttpRequest request = new HttpRequest();
	request.setEndpoint(SPOONACULAR_API+'/recipes/'+receipeId+'/information?apiKey='+APIKEY);
	request.setMethod('GET');
	HttpResponse response = http.send(request);  
	// If the request is successful, parse the JSON response.
	System.debug('Response code '+response.getStatusCode());
	if(response.getStatusCode() == 200) {
        System.debug('Response'+response.getBody());
    }
   }
    
    public static void getRecipeByIngredients(String ingredients){   
    Http http = new Http();
	HttpRequest request = new HttpRequest();
	request.setEndpoint(SPOONACULAR_API+'/recipes/findByIngredients?apiKey='+APIKEY+'&ingredients='+Ingredients);
	request.setMethod('GET');
	HttpResponse response = http.send(request);  
	// If the request is successful, parse the JSON response.
	System.debug('Response code '+response.getStatusCode());
	if(response.getStatusCode() == 200) {
        System.debug('Response'+response.getBody());
    }
   }
}