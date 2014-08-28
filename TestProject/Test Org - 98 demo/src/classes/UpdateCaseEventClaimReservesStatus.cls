public class UpdateCaseEventClaimReservesStatus{

    public list<Claim__c> listClaim ;
    public boolean bFinalPaymentDone;
    public list<Claim__c> listClaimToUpdate ;
    public list<Claim__c> listClaim2 ;
    public list<Reserves__c> listReserves ;
    public list<Case> listCase ;
    public list<Incident__c> listEvent ;
    public list<Case> listCase2 ;

    
    public UpdateCaseEventClaimReservesStatus(){
        listClaim = new list<Claim__c>();
        listClaimToUpdate = new list<Claim__c>();
        listClaim2 = new list<Claim__c>();
        listReserves = new list<Reserves__c>();
        listCase = new list<Case>();
        listEvent = new list<Incident__c>();
        listCase2 = new list<case>();

    }
    
    
    public void updateRelatedObjectsStatus(map<Id, Claim__c> mapClaim){
        system.debug('Inside class:mapClaim:: ' + mapClaim);
        /*
        for(Claim__c c : mapClaim.values()){
            system.debug('Claim :: ' + c);
                for(Reserves__c r : c.Reserves__r){
                   system.debug('Reserves :: ' + r);
                    for(Fund__c f : r.Funds__r){
                        system.debug('Fund__c :: ' + f);
                        if(f.Final_Payment__c == true)
                            bFinalPaymentDone = True;
                        else
                            bFinalPaymentDone = False;
                            break;
                    }
                If (bFinalPaymentDone == False)
                    break;
              
                }
            */
        list<Claim__c> listClaim2Reserves = [select Id, Claim_Status__c, (select Id, Status__c from Reserves__r) from Claim__c where Id IN: mapClaim.keySet()];
        map<Id, Reserves__c> mapReserve2Funds = new map<Id, Reserves__c>([select Id, Status__c, Claim__c, (select Id, Final_Payment__c from Funds__r) from Reserves__c where Claim__c IN: mapClaim.values()]) ;
        
            for(Claim__c c : listClaim2Reserves){
                for(Reserves__c r : c.Reserves__r){
                    system.debug('Reserves :: ' + r);
                    if(mapReserve2Funds.containsKey(r.Id)){
                        for(Fund__c f: mapReserve2Funds.get(r.Id).Funds__r){
                            system.debug('Fund :: ' + f);
                            if(f.Final_Payment__c == true)
                                bFinalPaymentDone = True;
                            else
                                bFinalPaymentDone = False;
                                break;
                        }
                    }
                    If (bFinalPaymentDone == False)
                        break;
                  
                 }
            
            
                system.debug('bFinalPaymentDone inside Claim loop::' + bFinalPaymentDone);
                If(bFinalPaymentDone  == True)
                    listClaimToUpdate.add(c);
            }
            
        system.debug('listClaimToUpdate::' + listClaimToUpdate);
            
         if(!listClaimToUpdate.isEmpty())  {
         //Update related Reserves, Claims, Event and Case //Event is not being used now
         
            For(Claim__c c : listClaimToUpdate){
                c.Claim_Status__c = 'Closed';
                listClaim2.add(c);
                
                for(Reserves__c r : c.Reserves__r){
                    r.Status__c = 'Closed';
                    r.RecordTypeId = KeyValueListStore__c.getInstance('Closed Reserves RecordTypeId').Value__c;
                    listReserves.add(r);
                }
            }
            system.debug('listReserves to update:: ' + listReserves);
            update listReserves;
            system.debug('listClaim2 to update:: ' + listClaim2);
            update listClaim2;
         
            /*   
            For(Incident__c e : [Select Id, Case__r.Id ,RecordTypeId, Event_Status__c from Incident__c where Id IN
                                            (select Event_Number__c from Claim__c where Id IN: listClaimToUpdate)]){
                e.Event_Status__c = 'Closed';
                e.RecordTypeId = KeyValueListStore__c.getInstance('Closed Event RecordTypeId').Value__c;
                listEvent.add(e);
                system.debug('e.Case__c-->' + e.Case__r.Id);
                listCase.add(new Case(Id=e.Case__r.Id));
           
            }                
            */
            
            For(Claim__c c : [Select Id, Case__r.Id from Claim__c where Id IN: listClaimToUpdate]){
                system.debug('SKJ Claim to update related case::' + c) ;
                Case oCase = new Case(Id = c.Case__r.Id);
                oCase.status = 'Closed';
                oCase.RecordTypeId = KeyValueListStore__c.getInstance('Closed Case RecordTypeId').Value__c;
                listCase2.add(oCase);
                system.debug('oCase:: ' + oCase);
            }
            system.debug('listCase2 to update:: ' + listCase2);
            update listCase2;
            /*
            For(Case c : listCase){
                c.status = 'Closed';
                c.RecordTypeId = KeyValueListStore__c.getInstance('Closed Case RecordTypeId').Value__c;
                listCase2.add(c);
            }
            system.debug('listCase2 to update:: ' + listCase2);
            update listCase2;
            */
        }    
    
    }
}