@isTest
public class ExceptionUtilityTest {
       
	@isTest
    public static void testExceptionLogCreated(){
         Lead lead = new Lead(LastName='Test Lead',
                            Company='');
        try{
            INSERT lead;
        }catch(Exception e){
            ExceptionUtility.addExceptionLog(new ExceptionUtility.LogUitlity(null
                                                                             ,'ExceptionUtilityTest'
                                                                             ,'testExceptionLogCreated'
                                                                             ,e.getStackTraceString()
                                                                             ,e.getMessage()
                                                                             , e.getTypeName()
                                                                             ,e.getLineNumber()));
            ExceptionUtility.commiLog();
        }
        
        Exception_Log__c logs = [SELECT Exception_Type__c, Notify_Admin__c, Source__c, MethodName__c
                                 FROM Exception_Log__c
                                 LIMIT 1];
        
        System.assertEquals('System.DmlException', logs.Exception_Type__c);
        System.assertEquals(true, logs.Notify_Admin__c);
        System.assertEquals('ExceptionUtilityTest', logs.Source__c);
        System.assertEquals('testExceptionLogCreated', logs.MethodName__c);
        
    }
    
    @isTest
    public static void testExceptionLogCreatedBluk(){
        Lead lead = new Lead(LastName='Test Lead',
                            Company='');
        List<ExceptionUtility.LogUitlity> exceptionLog = new List<ExceptionUtility.LogUitlity>();
        
        try{
            INSERT lead;
        }catch(Exception e){
            for(Integer i = 0; i<2; i++){
                exceptionLog.add(new ExceptionUtility.LogUitlity(null
                                                                 ,'ExceptionUtilityTest'
                                                                 ,'testExceptionLogCreatedBluk'
                                                                 ,e.getStackTraceString()
                                                                 ,e.getMessage()
                                                                 ,e.getTypeName()
                                                                 ,e.getLineNumber()));
            }
            
            ExceptionUtility.addExceptionLog(exceptionLog);
            ExceptionUtility.commiLog();
        }
        
        Exception_Log__c logs = [SELECT Exception_Type__c, Notify_Admin__c, Source__c, MethodName__c
                                 FROM Exception_Log__c
                                 LIMIT 1];
        
        System.assertEquals('System.DmlException', logs.Exception_Type__c);
        System.assertEquals(true, logs.Notify_Admin__c);
        System.assertEquals('ExceptionUtilityTest', logs.Source__c);
        System.assertEquals('testExceptionLogCreatedBluk', logs.MethodName__c);
    }
    
}