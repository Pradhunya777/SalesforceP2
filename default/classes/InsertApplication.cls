public class InsertApplication {
    public void InsertValue() {
        Application__c Application = new Application__C();
        Application.Name = 'Leave';
        Application.AIMS_Prime__c = 'Record inserted via ApexClass';
        insert  Application;
        System.debug('Successfully inserted!!....'+System.now());        
    }
}