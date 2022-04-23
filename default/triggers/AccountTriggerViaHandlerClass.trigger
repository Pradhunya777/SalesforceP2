trigger AccountTriggerViaHandlerClass on Account (before insert) {
    AccountTriggerHandler.beforeInsert(Trigger.new);

}