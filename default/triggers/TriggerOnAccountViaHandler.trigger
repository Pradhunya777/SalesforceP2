trigger TriggerOnAccountViaHandler on Account (before insert) {
    
    //***Before Insert
    //Q.) If Account Industry is not Null & having value as 'Media' then populate rating as 'HOT'.
    
    BeforeInsertClassOnAccount.beforeInsert(Trigger.new); 

}