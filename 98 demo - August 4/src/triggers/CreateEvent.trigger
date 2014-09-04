trigger CreateEvent on Case (after insert,before insert) 
{
   
   
   if(Trigger.isBefore)
   {
   
  
      for(case c: trigger.new)
      {
     try{
      
   Account aa=[select email__c from Account where Id=:c.AccountId];
       system.debug('!!!!!'+aa.email__c );
           c.Created_By_ID__c = UserInfo.getUserId() ;
        
         c.Account_Email__c=aa.email__c;
          } catch(Exception e) {
                system.debug('Exception---->'+e.getmessage());
        }   
        
        
        
      /*  Account aa=[select email__c from Account where Id=:c.AccountId];
       system.debug('!!!!!'+aa.email__c );
           c.Created_By_ID__c = UserInfo.getUserId() ;
        
         c.Account_Email__c=aa.email__c;  */
      }
   }
   /*
   if (Trigger.isAfter)
   { 
   list<Incident__c> theEvents = new list<Incident__c>();
   
   for(case c: trigger.new)
   {
      Incident__c e = new Incident__c();
        e.event_type__c = c.event_type__c;
        e.name = c.event__c;
        e.city__c = c.city__c;
        e.country__c = c.country__c;
        e.date_time_of_event__c = c.date_time_of_event__c;
        e.state__c = c.state__c;
        e.event_description__c = c.Event_Description__c; 
        e.zipcode__c = c.zip__c;
        e.case__c = c.id;
       e.Department__c=c.Department__c;
       e.Department_Head_Advised__c=c.Department_Head_Advised__c;
       e.Primary_Location__c= c.Primary_Location__c;
       e.Event_on_premise__c=c.Event_on_premise__c;
        e.Date_Reported__c =c.Date_Time_Reported__c;
        e.Number_of_Fatalities__c   = c.Number_of_Fatalities__c;
        e.Event_Indicator__c    =  c.Event_Indicator__c;
        e.Event_Status__c   = c.Event_Status__c;
        e.Event_Category__c =c.Event_Category__c;
        e.Injury_From__c    = c.Injury_From__c;
        e.Injury_to__c  =    c.Injury_to__c;
        e.Cause_Code__c = c.Cause_Code__c;
        e.Location_Address_1__c = c.Location_Address_1__c;
        e.Location_Address_2__c = c.Location_Address_2__c;
        e.Location_Type__c  =c.Location_Type__c;
        e.Location_Description__c   = c.Location_Description__c;
     //   e.Reporter_Home_Phone__c  =c.ContactPhone;
     //   e.ContactEmail  =   c.ContactEmail;
        e.Follow_up_date__c = c.Follow_up_date__c;
        e.Date_Physician_Advised__c = c.Date_Physician_Advised__c;
        e.Treatment_Given__c    =c.Treatment_Given__c;
        e.Release_Signed__c = c.Release_Signed__c;
        e.Actions__c    =c.Actions__c;
        e.Physician_Notes__c    = c.Physician_Notes__c;
        e.Outcome__c    = c.Outcome__c;
        e.Intervention_requested_required__c    =    c.Intervention_requested_required__c;
        e.Policy__c=c.Policy__c;
        e.Carrier_Notified_Date__c=c.Carrier_Notified_Date__c;
        
         Contact cc=[select State__c, Country__c from Contact where Id=:c.ContactId];
        
         e.State__c=cc.State__c;
         e.Country__c=cc.Country__c;
        
        
        
        theEvents.add(e);
   }
    insert theEvents;
   }
   */

}