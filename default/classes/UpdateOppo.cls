public class UpdateOppo {
    public static void main(){
        
        //***Update
        //***Update Opportunitiees
        //It will Update all (closedates of opportunities from last 90 days) Today + 90 Days. 
        
        List<Opportunity>opList=[select name,amount,closedate from opportunity where createddate=last_90_days];
        
        Date d = System.Today() + 90;
		
        for(Opportunity o : opList){
            o.CloseDate = d;
        }
        Update opList;
        
    }

}