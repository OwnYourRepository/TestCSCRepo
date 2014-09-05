trigger AddPolNumber on Claim__c (before insert) {
 // testing Jenkins CI -- Test
 //commented on Sep 5
  //comment#2 on Sep 5
  if (Trigger.isInsert) 
  {
    if (Trigger.isBefore)
    {
    for(Claim__c c: trigger.new)
   {
   System.debug('SKJ inside AddPolNumber Trigger on Claim::');
   //Incident__c ee=[select Policy__c,Case__c from Incident__c where Id=: c.Event_Number__c ]; == Commented by Sudhir --> Sep 4, 2014
   Case oCase = [select Policy__c, Id from Case where Id=: c.Case__c ] ;
   system.debug('oCase ::'+ oCase );
   //c.Policy_Name__c=   ee.Policy__c; --> Sep 4, 2014
   //c.Case__c=ee.Case__c;  --> Sep 4, 2014
   c.Policy_Name__c=   oCase.Policy__c ;
   c.Case__c = oCase.Id ;
   system.debug('Updated Claim before Insert::' + c);
  
   
   }
    
    } 
  }

}