trigger finalOppo on Opportunity (before insert) {
    
    List<Account> accLisst = new List<Account>();
    
   List<Opportunity> newOpportunities = [SELECT Id,Name,Account.Name FROM Opportunity];
    for(Opportunity oppoList : newOpportunities){
        DateTime D = date.Today(); 
                        String month =d.format('MMM'); 
                        Integer day = D.day();
                        Integer year = D.year(); 
        
        oppoList.Name = ('-'+month+'-'+year+'-'+oppoList.Name);
    }

}