trigger UpdateApprover on Reserves__c (before update) {

 for(Reserves__c r: trigger.new)
 {
system.debug('111111'+r);
system.debug('22222'+r.Assigned_Adjuster__c);
 User u= [select id from User where ContactId=: r.Assigned_Adjuster__c];
  r.Approver__c=u.id;
 }

}