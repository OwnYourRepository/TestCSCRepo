trigger AfterEventListenerOnAttachment on Attachment (after insert, after update) {
    
    list<Case> listCase = new list<Case>() ;
    set<Id> setParentIdOnAttachment = new set<Id>() ;
    Boolean bHasAllSupportingDocs ;
    list<Case> listCaseToUpdate = new list<Case>() ;
    list<String> listSupportingDoc = new list<String>() ;
    list<Case> listCaseWithAllDocs = new list<Case>() ;
    list<Case> listCaseWithoutAllDocs = new list<Case>() ;
    
    for(Attachment a : Trigger.new){
            system.debug('SKJ Attachment:: ' + a) ;
        setParentIdOnAttachment.add(a.ParentId) ;
            system.debug('SKJ setParentIdOnAttachment:: ' + setParentIdOnAttachment) ;
    }
    
    listCase = [ select Id, CaseNumber, Status, Policy__r.Policy_Name__r.Supporting_Documents__c  from Case 
                 where Id IN: setParentIdOnAttachment] ;
        System.debug('SKJ listCaseOnAttachment:: ' + listCase);
    
    for(Case oCase : listCase){
        
        String sSupportingDoc = oCase.Policy__r.Policy_Name__r.Supporting_Documents__c ;
                system.debug('SKJ sSupportingDoc ::' + sSupportingDoc ) ;
        if(sSupportingDoc != null){    
            listSupportingDoc = sSupportingDoc.split(';');
            system.debug('SKJ listSupportingDoc ::' + listSupportingDoc) ; 
        } 
            
        AggregateResult[] listAttachmentCount = [select ParentId, Count(Name) from Attachment where Id IN: Trigger.new Group By ParentId] ;  
            system.debug('SKJ listAttachmentCount::' + listAttachmentCount) ;
        for(AggregateResult ar : listAttachmentCount){
            if(ar.get('expr0') == listSupportingDoc.size()){
                bHasAllSupportingDocs = true ;
                system.debug('SKJ bHasAllSupportingDocs:: ' + bHasAllSupportingDocs) ;
                system.debug('SKJ for Case:: ' + oCase) ;
                listCaseWithAllDocs.add(oCase) ;
            } else{
                listCaseWithoutAllDocs.add(oCase) ;
            }    
        }    
    }
    
    if(bHasAllSupportingDocs == True){
        for(Case c : listCaseWithAllDocs){
            c.status = 'Adjuster to be appointed' ;
            listCaseToUpdate.add(c);
        }
        update listCaseToUpdate ;
    } else {
        for(Case c : listCaseWithoutAllDocs){
            c.status = 'Documents pending' ;
            listCaseToUpdate.add(c);
        }
        update listCaseToUpdate ;
    }
    
              
    /*
    for(Case oCase : listCase){
        list<String> listSupportingDoc = new list<String>() ;
        String sSupportingDoc = oCase.Policy__r.Policy_Name__r.Supporting_Documents__c ;
            system.debug('SKJ sSupportingDoc ::' + sSupportingDoc ) ;
        if(sSupportingDoc != null){    
            listSupportingDoc = sSupportingDoc.split(';');
            system.debug('SKJ listSupportingDoc ::' + listSupportingDoc) ; 
        }             
        for(String sDoc : listSupportingDoc){
            
            for(Attachment a : oCase.Attachments){
                if(a.Name.contains(sDoc)){
                   break ; 
                } else{
                    bHasAllSupportingDocs = false ;
                }
            }
            if(bHasAllSupportingDocs == false){
                break ;
            }
            system.debug('SKJ bHasAllSupportingDocs:: ' + bHasAllSupportingDocs) ;
        }
        
        system.debug('SKJ bHasAllSupportingDocs:: ' + bHasAllSupportingDocs) ;
        if(bHasAllSupportingDocs != false){
            bHasAllSupportingDocs = true ;
        }
        
        system.debug('SKJ bHasAllSupportingDocs:: ' + bHasAllSupportingDocs) ;
        if(bHasAllSupportingDocs == true){
            listCaseToUpdate.add(oCase);

        }    
    }
    
    system.debug('SKJ listCaseToUpdate::' + listCaseToUpdate) ;
    
    for(Case c : listCaseToUpdate){
        //
    }
    */
}