trigger BeforeEventListenerOnCase on Case (before insert, before update) {

    if(Trigger.isInsert){
        for(Case oCase : Trigger.new){
            //Update Case status from New to Documents pending
            oCase.status = CaseStatus__c.getInstance('Documents pending').Name ;
        }
    }

}