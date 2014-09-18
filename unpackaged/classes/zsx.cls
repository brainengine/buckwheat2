global class zsx implements Database.batchable<Account__c>{ 
	global Iterable<Account__c> start(Database.batchableContext info){ 
		List<Account__c> records = new List<Account__c>();
		return records;
	}     
	global void execute(Database.batchableContext info, List<Account__c> scope){ 
		List<Account__c> recordsToUpdate = new List<Account__c>(); 
		for(Account__c a : scope){ 
           
			recordsToUpdate.add(a); 
		} 
		update recordsToUpdate; 
	}     
	global void finish(Database.batchableContext info){     
	} 
}