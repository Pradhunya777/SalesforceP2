public class StudentSearchController {
    @AuraEnabled
    public static List<Student__c> searchStudent(){
        List<Student__c> studentList = new List<Student__c>([Select id,Full_Name__c,Email__c,
                                            Phone__C,Total_Fees__c from Student__c]);
        return studentList;
    } 
    
}