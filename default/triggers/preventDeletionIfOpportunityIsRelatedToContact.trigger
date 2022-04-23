trigger preventDeletionIfOpportunityIsRelatedToContact on Contact (before delete) {
    if(Trigger.isBefore){
        if(Trigger.isDelete){
            preventDeletionIfOppoRelatedToConHelper.preventDeletionIfOpportunityIsRelatedToContact(Trigger.new, Trigger.oldMap);
        }
    }
}