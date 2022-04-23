public class InsertOpposInbulk {
    public static void insertOppos(){
        
    List<Opportunity> oppoList = new List<Opportunity>();
  //  List<Opportunity> oppsList=[SELECT Name,Id,AccountId FROM Opportunity];
    for(integer i=35; i<40;i++){
        
   		Account acc = [SELECT Id,Name from Account where Name='CheckTrigger'];
 		Opportunity oppos = new Opportunity(Name='Test Oppo'+i,StageName = 'Closed Won',CloseDate=System.today(),AccountId=acc.Id);
 		oppoList.add(oppos);
   	 } 
    INSERT oppoList;
	}
}