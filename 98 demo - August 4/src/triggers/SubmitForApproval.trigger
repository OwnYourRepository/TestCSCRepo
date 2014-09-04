trigger SubmitForApproval on Claim__c (after insert , after update) 
{


  if (Trigger.isInsert) 
  {
         List<User> usr = [select Profile.Name , Id , UserRole.Name from user where Profile.Name = 'Partner Communitys User'];
         List<Claim__share> claimList = new List<Claim__share>();
         List<Claim__share> claimListCust = new List<Claim__share>();

             
         for (Integer i = 0; i < Trigger.new.size(); i++) 
         {
           submitForApproval(Trigger.new[i]);
           /*if(Trigger.new[i].Amount_of_Total_Loss__c >= 10000)
           {
             submitForApproval(Trigger.new[i]);
           }*/

//************************

          /* if(Trigger.new[i].Created_For_Customer__c != null || Trigger.new[i].Created_For_Customer__c != '')
           {
              Id identity = Id.valueOf(Trigger.new[i].Created_For_Customer__c);
              system.debug(' Entered ****************************** ' );
              Claim__share shareClaim = new Claim__share();
              shareClaim.UserOrGroupId = identity;
              //shareClaim.UserOrGroupId = '00590000002OY9D';
              shareClaim.ParentId = Trigger.new[i].Id;
              shareClaim.AccessLevel = 'Read';
              shareClaim.RowCause = 'Manual'; 
              claimListCust.add(shareClaim);
            } */
   
//************************
                   
           if(Trigger.new[i].Created_By_Profile__C == 'Partner Communitys User')
           {
              //List<Id> ulist = new List<Id>();
              for(User u : usr)
              {
                system.debug(' ~~~~~~~~~~ ' + u.UserRole.Name  + '           ' +  Trigger.new[i].Created_By_Role__C + '   ' + u.Id );
                if(u.UserRole.Name == Trigger.new[i].Created_By_Role__C && u.Id != Trigger.new[i].OwnerId )
                {
                                
                  system.debug(' Entered ****************************** ' );
                  Claim__share shareClaim = new Claim__share();
                  shareClaim.UserOrGroupId = u.Id;
                  shareClaim.ParentId = Trigger.new[i].Id;
                  shareClaim.AccessLevel = 'Read';
                  shareClaim.RowCause = 'Manual'; 
                  claimList.add(shareClaim);
               }
            }
          }  
        }
      insert claimListCust;
      insert claimList;
  }
          
  
   if (Trigger.isUpdate) 
   {
       for (Integer i = 0; i < Trigger.new.size(); i++) 
       {
 
         //if (Trigger.new[i].Amount_of_Total_Loss__c >= 10000 && Trigger.old[i].Amount_of_Total_Loss__c < 10000 )
         if (Trigger.new[i].Amount_of_Total_Loss__c != Trigger.old[i].Amount_of_Total_Loss__c)  
         { 
            submitForApproval(Trigger.new[i]);
         }
       }
   }
  
        public void submitForApproval(Claim__c cl)
        {
        try{
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval');
        req1.setObjectId(cl.id);
        Approval.ProcessResult result = Approval.process(req1);
        }Catch(Exception e)
        {}
        } 




}