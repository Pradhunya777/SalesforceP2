trigger PhoneUpdatePopulateOnOppo on Account (After Update) {
    
    //***After Update
    //Q.) If Account phone is updated then populate that on all related opportunities
    
    PhoneUpdatePopulateOnOppo.UpdateRelatedPhone(Trigger.new, Trigger.oldMap);

}