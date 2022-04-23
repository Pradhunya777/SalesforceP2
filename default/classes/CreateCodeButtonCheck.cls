public with sharing class CreateCodeButtonCheck {
    @AuraEnabled
    public static String debugStatusMessage() {
        String msg = 'Original value';
        return ('Hello from the server, ' + msg);
    }
  
}