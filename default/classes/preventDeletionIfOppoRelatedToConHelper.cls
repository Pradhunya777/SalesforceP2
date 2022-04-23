public class preventDeletionIfOppoRelatedToConHelper {
     public static void preventDeletionIfOpportunityIsRelatedToContact
        									(List<Contact> newList, Map<Id, Contact> oldMap){     
                                                
       for(Contact a : [select ID, (select ID from Opportunities) from Contact where ID in: oldMap.keySet()]){
      				 System.debug(a.Opportunities.size()); //resulting in right number of opportunities associated
           if(a.Opportunities.size() > 0) {
          				 a.addError('cannot delete');
           }else if(a.Opportunities.size() <= 0)
               delete a;
   			 }
                                                
         
      }

}