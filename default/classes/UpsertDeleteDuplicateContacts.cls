public class UpsertDeleteDuplicateContacts {
    public static void main(){
        
        //***Program to delete duplicate contacts***//
        
        List<Contact> cList5 = [Select name from contact];
        
        Map<String, Id> mMap = new Map<String, Id>();
        //In map key cannot duplicate, Value can be duplicate.
        //If the name is duplicate the record will not create in these mMap Because key is unique.
        
        for(Contact c : cList5){
            mMap.put(c.Name, c.ID);
        }
        
        List<Contact> uniqueList = new List<Contact>();
        //uniqueList Stores the unique values that are available in mMap
        
        List<Contact> delList = new List<Contact>();
        //delList stores the Duplicate values that are not stored in mMap
        
        Set<String> s1 = mMap.KeySet();
        //We get all the keys in S1 Set.
        
        Set<ID> uniqueSet = new Set<ID>();
        //In uniqueSet we want to insert record id's. record id's of unique records.
        
        for(String s : s1){
            uniqueSet.add(mMap.get(s));
        }
         //Getting the values with the help of mMap.get(s) these returns the value from map 
         //& it is get added into uniqueSet.add.
         
        for(Contact c : cList5){			//It checks whether the unique set contains that id
            if((uniqueSet.Contains(C.Id)))  //Or not if contains, that perticular id in that case
                uniqueList.add(c);			//Added into in uniqueList that we created& the id's
            else							//Which are not there will get added into delList;
                delList.add(c);
        }
        Delete delList;
        
        
        
    }

}