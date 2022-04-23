public class ExceptionUtility {
	static List<Exception_Log__c> logs = new List<Exception_Log__c>();
    
    public static void addExceptionLog(List<LogUitlity> exceptionLog){
        if(exceptionLog != null && !exceptionLog.isEmpty()){
            for(LogUitlity log : exceptionLog){
                addExceptionLog(log);
            }
        }
    } 
    
    public static void addExceptionLog(LogUitlity exceptionLog){
        if(exceptionLog != null){
            Exception_Log__c debugLog = new Exception_Log__c();
            debugLog.Name = exceptionLog.className +' '+ exceptionLog.exceptionType;
            debugLog.Related_To_Record_Id__c = exceptionLog.recordId;
            debugLog.StackTrace__c = exceptionLog.stackTrace;
            debugLog.Source__c = exceptionLog.className;
            debugLog.MethodName__c = exceptionLog.methodName;
            debugLog.Exception_Type__c = exceptionLog.exceptionType;
            debugLog.Line_Number__c = exceptionLog.lineNumber;
            debugLog.Log_In_User__c = UserInfo.getUserId();
            debugLog.Message__c = exceptionLog.message;
            debugLog.Notify_Admin__c = true;
            logs.add(debugLog);
        }
    }
    
    public static void commiLog(){
            if( logs != null){
                insert logs;
                //DataBase.SaveResult[] result = Database.insert(logs);
                //if()
            }
    }
    
    public class LogUitlity{
        String recordId;
        String className;
        String methodName;
        String stackTrace;
        String message;
        String exceptionType;
        Integer lineNumber;
        
        public LogUitlity(String recordId, String className, String methodName, String stackTrace, String message, String exceptionType, Integer lineNumber){
            this.recordId = recordId;
            this.className = className;
            this.methodName = methodName;
            this.stackTrace = stackTrace;
            this.message = message;
            this.exceptionType = exceptionType;
            this.lineNumber = lineNumber;  
           
        }       
    }

}