public class InsertOppo {
    public static void insertOppos(){
    Opportunity oppos = new Opportunity();
    Account acc = [Select Id,Name from Account WHERE name = 'AAAA'];
    oppos.Name = 'opps';
    oppos.CloseDate = System.today();
    oppos.StageName = 'Closed won';
    oppos.AccountId = acc.Id; 
    
    INSERT oppos;
    }
}