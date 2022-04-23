public class studentExtension {
    
    public List<Student__c> sList{get;set;}
    
    public StudentExtension(ApexPages.StandardController s){
        
        sList = [SELECT Id,Name from Student__C];
        
    }
     /*public void save(){
        System.debug('I am From Student');
    }*/

}