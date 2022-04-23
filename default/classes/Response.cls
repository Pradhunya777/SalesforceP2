global class Response {
    global String isSuccess {get;set;}
    global string sapMaterialRef{get;set;}
    global String message{get;set;}
    global List<String> errors{get;set;}
    
    global Response(String sapMaterialRef,String isSuccess,String message){
        this.sapMaterialRef = sapMaterialRef;
        this.isSuccess = isSuccess;
        this.message = message;
    }
    global Response(String sapMaterialRef,String isSuccess,String message,List<String> errors){
        this.sapMaterialRef = sapMaterialRef;
        this.isSuccess = isSuccess;
        this.message = message;
        this.errors = errors;
    }    
}