trigger NewCaseCommentUpdate on Case (before update) {

List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

  if(Trigger.isBefore){
  if(Trigger.isUpdate){
    try{
   for(case c: trigger.new)
   {system.debug('--------------'+c.Send_Mail__c);
   if(c.Send_Mail__c==True)
   {
    Case cc=[select ownerid from case where id=:c.id];
  User u= [select email from user where id=: cc.ownerid];
    Messaging.SingleEmailMessage sendEmail = new Messaging.SingleEmailMessage();
            sendEmail.setTemplateID('00XC0000001TXvY');                    
            sendEmail.setTargetObjectId(c.contactId);
            sendEmail.setOrgWideEmailAddressId('0D2C0000000TOPI');
            sendEmail.setWhatId(c.id);
            String[] CCEmails = new String[]{u.Email};
            sendEmail.setCCAddresses(CCEmails);
            sendEmail.setSaveAsActivity(false);
            emails.add(sendEmail);
            system.debug('---222222-----'+sendEmail);
   }
   c.Send_Mail__c=False;
   }
     } catch(Exception e) {
             system.debug('Exception---->'+e.getmessage());   
        }   
  }
  }
if (emails != NULL && emails.size() > 0)
{
system.debug('---222222-----'+emails);
   Messaging.sendEmail(emails);
}
}