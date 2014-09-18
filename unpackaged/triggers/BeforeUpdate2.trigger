trigger BeforeUpdate2 on TblDevAssumptions__c bulk (before insert,before update) {

	
	for (TblDevAssumptions__c t : Trigger.new) {
            //if (t.desc__c == null) {
             //   t.addError('Desc cannot be null');
          //  } 
		
			
        }
	
	

}