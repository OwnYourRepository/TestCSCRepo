trigger TriggerAfterEventListenerOnFund on Fund__c (after update, after insert){

    map<Id, Claim__c> mapClaim = new map<Id, Claim__c>(); 
    set<Id> setClaim = new set<Id>() ;
    list<Fund__c> listFund= new list<Fund__c>() ;
    
    if(Trigger.isUpdate){
        listFund = [Select Id, Final_Payment__c, Reserves__r.Claim__c from Fund__c where Id IN: Trigger.New] ;
        system.debug('listFund :: ' +listFund );
        for(Fund__c f : listFund){
            system.debug('Fund ::' + f);
            if(f.Final_Payment__c != Trigger.oldMap.get(f.Id).Final_Payment__c && f.Final_Payment__c == True){
                system.debug('Fund ::' + f);
                system.debug('f.Reserves__r.Claim__c  --' +f.Reserves__r.Claim__c);
                Claim__c c = new Claim__c(Id = f.Reserves__r.Claim__c);
                system.debug('Claim:: ' + c);
                mapClaim.put(c.Id, c);
                system.debug('mapClaim from Trigger.new:: '+ mapClaim);
            }
        }
    }

    /*   */
    if(!mapClaim.isEmpty()){
        system.debug('Inside Trigger: mapClaim:: '+ mapClaim);
        UpdateCaseEventClaimReservesStatus oUpdateCaseEventClaimReservesStatus = new UpdateCaseEventClaimReservesStatus();
        oUpdateCaseEventClaimReservesStatus.updateRelatedObjectsStatus(mapClaim);
    }
    
}