public  class quickContactController {
    @AuraEnabled
    public static Contact createContact(Contact con, Id AccountId) {
        //we are passing two parameters that we getting from javascript controller 1st ia whole contact
        //and 2nd is account id.
        con.AccountId = AccountId;
        insert con;
        return con;
    }
}