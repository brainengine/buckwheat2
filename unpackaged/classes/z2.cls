global class z2 implements Database.batchable<Account>{ 
	global Iterable<Account> start(Database.batchableContext info){ 
		List<Account> records = new List<Account>();
		return records;
	}     
	global void execute(Database.batchableContext info, List<Account> scope){ 
		List<Account> recordsToUpdate = new List<Account>(); 
		for(Account a : scope){ 
           
			recordsToUpdate.add(a); 
		} 
		update recordsToUpdate; 
	}     
	global void finish(Database.batchableContext info){     
	} 
}