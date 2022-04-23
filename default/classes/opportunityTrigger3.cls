public class opportunityTrigger3 {

    public  static void oppoNameViaFormula(List<Opportunity> oList) {
		
		for(opportunity opp : oList){
			account acc = new account();
			opp.name =acc.Name+' Oct-2021 '+ opp.name;			//acc.name+ ' Oct-2021 'opp.Name;
		}

	}
}