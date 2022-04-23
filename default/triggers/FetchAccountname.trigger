trigger FetchAccountname on Opportunity (After insert) {
FetchAccName.fetchaccount(Trigger.new);
}