@isTest
public class ToolsAssignmentTriggerTest {
    @TestSetup
    public static void setupMethod(){
        Tools__c toolRec= createTools();
        insert toolRec;
    }
    @isTest
    public static void Test1(){
        Test.startTest();
        
        Tools__c tool=[Select Id , Name 
                      From Tools__c 
                      Where Name='Demo' LIMIT 1];
       
        if(tool!=Null){
            List<Tools_Assignment__c> toolAss= createToolsAssignment(tool.Id);
            insert toolAss;
            System.assert(toolAss.size()>0);
        }
        List<Tools_Assignment__c> toolAssignmentList=[Select Id, Status__c,Returned__c
                                  FROM Tools_Assignment__c 
                                  WHERE Tools__c =: tool.Id];
        for(Tools_Assignment__c toolAss:toolAssignmentList){
            toolAss.Status__c='Requested';
        }
        Update toolAssignmentList;
        
        Delete toolAssignmentList;
        Test.stopTest();
    }
    public static Tools__c createTools(){
        Tools__c toolRec= new Tools__c();
        toolRec.Name='Demo';
        
        return toolRec;
    }
    public static List<Tools_Assignment__c> createToolsAssignment(Id toolsId){
        List<Tools_Assignment__c> toolAssList = new List<Tools_Assignment__c>();
        for(Integer i=0;i<=3;i++){
            Tools_Assignment__c testRec= new Tools_Assignment__c();
            testRec.Tools__c=toolsId;
            testRec.Status__c='Approved';
            testRec.Returned__c= false;
            toolAssList.add(testRec);
        }
        for(Integer i=0;i<=3;i++){
            Tools_Assignment__c testRec1= new Tools_Assignment__c();
            testRec1.Tools__c=toolsId;
            testRec1.Status__c='New';
            testRec1.Returned__c= true;
            toolAssList.add(testRec1);
        }
        return toolAssList;
}
}