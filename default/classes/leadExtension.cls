public class leadExtension {
     
    public List<lead> lList{get;set;}
        
        public leadExtension(ApexPages.StandardController s){
            lList = [Select Name,Status FROM lead ORDER  BY Name];
        } 
    
    //Save method for checking two same thods in difeerent extensions which one will be called
    
   /* public void save(){
        System.debug('I am From Lead');
    }*/
    
    
    //for custom controller use controller name as a parameter
    
    public leadExtension(accConOppController cc){
            lList = [Select Name,Status FROM lead ORDER  BY Name];
        } 
    
   
    public leadExtension(MyAccountController MAC){
		lList = [Select Name,Status FROM lead ORDER  BY Name];
    }

}