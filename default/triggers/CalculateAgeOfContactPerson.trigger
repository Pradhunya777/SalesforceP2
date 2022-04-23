trigger CalculateAgeOfContactPerson on Contact (before insert, before update) {
   CalculateAgeOfContactPersonHelper.calculateAge(Trigger.new); 
}