trigger ROTrigger on Opportunity (after insert, after delete, after undelete) {
     RO.Roooo(Trigger.new,Trigger.old); 
}