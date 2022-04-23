public class DeleteRecycleBin {
    public static void main(){
        
        List<Account> accList =  [Select ID from Account where isDeleted = true All Rows];
        Database.emptyRecycleBin(accList);
        
        
    }

}