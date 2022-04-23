public class StudentTriggerHelperClass {
    
    
    
    public static void CheckStudentActiveOrInactive(List<Student__c> oldList){
        
        //***Before Delete
    //Show the message when user wants to delete active student record
    //Msg = Record cannet be deleted if active is true. 
    
        for(Student__c std : oldList){
            if(std.Active__c == true){
                std.addError('Active Student cannot be removed ');
            }           
    	}
    }
    
    public static void UndeleteAndCheckActiveCheckboxAutomatically(List<Student__c> newList){
        
   //***After Undelete
   //Undelete Student record & set Active as true
   //i.e = if we undelete any record from recyclr bin tehn check the chekbox automaticallyt on that field
        
        List<Student__c> studentsToBeUpdated = new List<Student__c>();
        for(Student__c std : newList){
            Student__c s = new Student__c();
            s.Id = std.Id;
            s.Active__c = true;
            studentsToBeUpdated.add(s);
        }
        if(!studentsToBeUpdated.isEmpty()){
            update studentsToBeUpdated;
        }
    }

}