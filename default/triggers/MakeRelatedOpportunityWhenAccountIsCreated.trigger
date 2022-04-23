trigger MakeRelatedOpportunityWhenAccountIsCreated on Account (After insert) {
    CreateRelatedOppoWhenAccountIsCreated.createRelatedOppo(trigger.new);
}