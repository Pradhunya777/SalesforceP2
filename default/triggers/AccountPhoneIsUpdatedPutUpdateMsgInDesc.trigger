trigger AccountPhoneIsUpdatedPutUpdateMsgInDesc on Account (before update) {
    
    //***Before Update
    //Q.) If account phone is updated the put update message in description 
    
    AccountPhoneIsUpdatedPutUpdateMsgInDesc.UpdatePhoneDesc(Trigger.new, Trigger.oldMap);

}