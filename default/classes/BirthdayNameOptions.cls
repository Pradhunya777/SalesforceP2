//this is a schedular class of BatchWishes that i write saperate we can write this execute method in that class also

global class BirthdayNameOptions implements Schedulable {
    global void execute(SchedulableContext sc){
        BatchWishes bth = new BatchWishes();
        Database.executeBatch(bth); 
    }
}
/*  1) To schedule this class at 12am everyday then we have to paste this code in anonymous window  

	BatchWishes bno = new BatchWishes();
	String cronExp = '0 0 0 * * ? *';
	System.schedule('BatchWishes', cronExp, bno);


   2) To schedule this class at 2.20pm everyday then we have to paste this code in anonymous window  

	BatchWishes bno = new BatchWishes();
	String cronExp = '0 20 14 * * ? *';
	System.schedule('BatchWishes', cronExp, bno);


*/