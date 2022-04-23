public class Insertopps {
    public static void insertOppos(){
        
    List<Opportunity> oppoList = new List<Opportunity>();
    for(integer i=1; i<6;i++){
        
   		//Account acc = [SELECT Id,Name from Account where Name='CheckTrigger'];
 		Opportunity oppos = new Opportunity(Name='Test Opps'+i,StageName = 'Closed Won',
                                            CloseDate=System.today());//,AccountId=acc.Id);
 		oppoList.add(oppos);
   	 } 
    INSERT oppoList;
	}
}