trigger MakeRelatedContactWhenAccountIsCreated on Account (After insert) {
    CreateRelatedConWhenAccountIsCreated.createRelatedContactWhenAccountIsCreated(trigger.new);
}