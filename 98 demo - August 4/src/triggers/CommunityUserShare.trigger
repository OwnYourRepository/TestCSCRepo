trigger CommunityUserShare on Policy__c (after Insert) {

 if (Trigger.isInsert) 
  {
    if (Trigger.isAfter)
    {
            List<Policy__Share> customerShares  = new List<Policy__Share>();
            Policy__Share customerShare;
        
    for(Policy__c c: trigger.new)
   {
 //  Contact c=[select InsuredContact__c from Policy__c where id=: c.id];  ==comment by Sudhir 2, 3, 4, 5
   User u=[select id from User where ContactId =:c.InsuredContact__c];
   
            customerShare = new Policy__Share();
            customerShare.ParentId = c.id;
            customerShare.UserOrGroupId = u.id;
            customerShare.AccessLevel = 'read';
            customerShares.add(customerShare);
            }

            insert customerShares;
}
}
}