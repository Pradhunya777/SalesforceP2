public class CalculateAgeOfContactPersonHelper {
    public static void calculateAge(List<Contact> conList){
        for(contact con : conList){
            date present_date = System.today();
            Integer present_day = present_date.day();
            Integer present_month = present_date.month();
            Integer present_year = present_date.year();
            
            date birth_date = con.Date_Of_Birth__c;
            Integer birth_day = birth_date.day();
            Integer birth_month = birth_date.month();
            Integer birth_year = birth_date.year();
            
            Integer[] month = new List<Integer> {31,28,31,30,31,30,31,31,30,31,30,31};
                
                if(birth_day > present_day){
                    present_day = present_day + month[birth_month -1];
                    present_month = present_month-1;
                }
            	
          	   if(birth_month > Present_month){
                	present_year = present_year-1;
                	present_month = present_month + 12;
          	   }
            
            integer final_day = present_day - birth_day;
            integer final_month = present_month - birth_month;
            integer final_year = present_year - birth_year;
             
           con.Current_Age__c = 'Days: '+final_day+' Months: '+final_month+' Years: '+final_year;
            
            if(con.Date_Of_Birth__c > System.today()){
                con.Date_Of_Birth__c.addError('Birth day date cant be greater than todays date');
            }
        }
        
    }
 
}