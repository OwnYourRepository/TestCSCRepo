trigger AddPolNumber on Claim__c (before insert) {

  if (Trigger.isInsert) 
  {
    if (Trigger.isBefore)
    {
    for(Claim__c c: trigger.new)
   {
   System.debug('SKJ inside AddPolNumber Trigger on Claim::');
   //Incident__c ee=[select Policy__c,Case__c from Incident__c where Id=: c.Event_Number__c ]; == Commented by Sudhir
   Case oCase = [select Policy__c, Id from Case where Id=: c.Case__c ] ;
   system.debug('oCase ::'+ oCase );
   //c.Policy_Name__c=   ee.Policy__c;
   //c.Case__c=ee.Case__c;
   c.Policy_Name__c=   oCase.Policy__c ;
   c.Case__c = oCase.Id ;
   system.debug('Updated Claim before Insert::' + c);
  
   
   }
    
    } 
  }

}