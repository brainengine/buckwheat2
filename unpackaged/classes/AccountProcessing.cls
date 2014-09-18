public class AccountProcessing{
	//
	//comment
	//
	//
	public static void DetermineLocation(Account[] accounts) {
      for (Account a :accounts){
         
		  Legal_Documents__c doc = [Select Id, Name, Account_Type__c from Legal_Documents__c where Account_Type__c =: a.Type];
		  // oo
		  a.Site = doc.Name;
		  
      }
	 
	  	CloudtunesController con = new CloudtunesController();
	  
	  	AccountManagementService accnt = new AccountManagementService();
		accnt.createAccountPerson('Bob', 'Johnson', 'bjohnson@acme.com');
		accnt.firstName = 'Sam Jones';
	  
   }

}