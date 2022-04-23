public class TransactionAndRollBack {
    public static void main(){
        
        savepoint sp1 = Database.setSavepoint();//savepoint saves the stste of the database
        
        try
        {
            Opportunity o = [Select name,Account.id,amount,
                             ownerID from opportunity where name like 'Sell whe%' Limit 1];
            
            Decimal commision =  o.Amount * 0.20;            
            o.Amount = o.Amount + commision;             
            update o;		//1st database operation
            
            Commision__c c = new Commision__c();
           
            c.commision_Amount__c = commision;
            c.agent__c = o.OwnerId;
            
            insert c;			//2nd database operation
            
            Account acc2 = [select name from account where id = :o.AccountId];
            acc2.Discount_percent__c=20;
            update acc2;		//3rd database operation 
            
        }catch(Exception e ){
            System.debug('Exception occured ');
            Database.rollback(sp1);
        }  
        
        
    }

}