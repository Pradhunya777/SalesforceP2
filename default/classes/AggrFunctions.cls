public class AggrFunctions {
    public  void main(){
        
        //****Sum
        AggregateResult ar1 = [select sum(Amount),max(Amount),min(Amount) from opportunity];
        System.debug('Result is'+ar1); 
        
        //****Max
        AggregateResult ar2 = [select max(Amount) from opportunity];
        System.debug('Result is'+ar2);  
        
        //***Min
        AggregateResult ar3 = [select min(Amount) from opportunity];
        System.debug('Result is'+ar3); 
        
        //***Count
        integer i = [select count() from opportunity];
        System.debug(i); //it gives integer result
        
       //***Count
        AggregateResult ar4 = [select count(ID) from opportunity];
        System.debug('Result is '+ar4); //it gives Aggregate result 
         
        //***
        AggregateResult ar5 = [select count(Amount) from opportunity];
        System.debug('Result is '+ar5);
        
        //***Avg
        AggregateResult ar6 = [select Avg(Amount) from opportunity];
        System.debug('Result is '+ar6);
        
        //***Count_Distinct
        AggregateResult ar7 = [select Count_Distinct(Amount) from opportunity];
        System.debug('Result is '+ar7);
    }

}